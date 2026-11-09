#!/bin/sh
# Releases a version of the package with one command:
#
#   sh scripts/release.sh patch              # or minor, major, or the version itself, as 0.2.0
#   sh scripts/release.sh 0.2.0              # the version typst.toml already has, when it has no tag yet
#   sh scripts/release.sh --dry-run patch    # shows what it would do, and changes nothing
#
# While a version is developed, typst.toml keeps the version published last, and every change an author can see goes
# into the changelog, under the heading "Próxima versão" (in Portuguese) or "Unreleased" (in English). A release takes
# several steps around gotpm, which only changes the version of typst.toml (`gotpm bump`) and pushes the package to
# the fork of typst/packages (`gotpm publish`, in release.yml). This script does them all, in this order, and stops at
# the first failure:
#
#  1. it checks that the working copy can be released: on the development branch, clean, not behind origin, with a
#     changelog for the version, the tag still free, gh logged in and the fonts downloaded;
#  2. it changes the version of typst.toml (`gotpm bump`) and, in every tracked text file, the imports of the package
#     (`<name>:<version>`) and the links to the tag of the version (`/v<version>/`, `` `v<version>` ``), but not in
#     the versions of the changelog already released, whose links stay on the tags of their own versions;
#  3. it turns the heading "Próxima versão" / "Unreleased" into the version, with the date when `dated`;
#  4. it builds what is committed (the manuals, the pictures, the thumbnail), runs the checks of the CI and the gate of
#     gotpm (`sh scripts/package.sh --check`);
#  5. it shows the changes and asks before it commits, tags and pushes: the tag starts release.yml, which runs the
#     tests, publishes with gotpm to the fork of typst/packages and creates the GitHub release;
#  6. it waits for release.yml and opens in the browser the pull request to typst/packages, with its title and its
#     body (the checklist of an update and the changelog of the version) filled in. Its button creates it.
#
# A version is also released by the number typst.toml already has, as it is, when it has no tag yet: typst.toml was
# changed by hand, or the release of the version is redone after a failure (see "New version" in CONTRIBUTING). Step 2
# then changes nothing, the changelog may already have the heading of the version (kept as it is), and a commit is made
# only when step 3 or the build changes something.
#
# The same script releases abntly and touying-ufac-unofficial: only the block below differs between them.
set -eu
cd "$(dirname "$0")/.."

# --- What differs between the packages -------------------------------------------------------------------------------
# the branch where the versions are developed; when it is not main, main is fast-forwarded to it by the release
dev_branch=develop
# the files that hold the changelog, each with one section "Próxima versão" or "Unreleased"
changelogs="CHANGELOG.md"
# the changelog in English, whose section of the version goes into the pull request
pr_changelog=CHANGELOG.md
# whether the heading of a version carries its date: "0.1.2 (8 de novembro de 2026)", "0.1.2 (8 November 2026)"
dated=false
# what is built from the sources and committed
build() {
  sh docs/build.sh
  sh scripts/examples.sh
  sh scripts/readme.sh
}
# what the CI checks (tests.yml)
check() {
  sh scripts/local.sh
}
# ---------------------------------------------------------------------------------------------------------------------

fail() {
  echo "error: $*" >&2
  exit 1
}

step() {
  printf '\n==> %s\n' "$*"
}

dry_run=false
if [ "${1:-}" = "--dry-run" ]; then
  dry_run=true
  shift
fi
if [ $# -ne 1 ]; then
  echo "usage: sh scripts/release.sh [--dry-run] patch|minor|major|<version>" >&2
  exit 2
fi
increment=$1

# A problem stops a release; a dry run only reports it.
problem() {
  if $dry_run; then
    echo "warning: $*" >&2
  else
    fail "$*"
  fi
}

field() {
  sed -n "s/^$1 *= *\"\(.*\)\"/\1/p" typst.toml | head -n 1
}
name=$(field name)
prev=$(field version)
description=$(field description)
repository=$(field repository | sed 's|^https://github\.com/||')

case $increment in
  major | minor | patch | [0-9]*.[0-9]*.[0-9]*) ;;
  *) fail "unknown increment $increment: patch, minor, major or a version, as 0.2.0" ;;
esac
# the version of typst.toml, asked for by its number, is released as it is
if [ "$increment" = "$prev" ]; then
  as_is=true
  next=$prev
else
  as_is=false
  next=$(gotpm bump -n "$increment") || fail "gotpm bump -n $increment failed"
  # gotpm takes any version, also an older one
  awk -v a="$next" -v b="$prev" 'BEGIN {
    split(a, x, "."); split(b, y, ".")
    for (i = 1; i <= 3; i++) { if (x[i] + 0 > y[i] + 0) exit 0; if (x[i] + 0 < y[i] + 0) exit 1 }
    exit 1
  }' || fail "the new version ($next) must come after $prev"
fi

# The heading of the changelog of the next version, at any level.
unreleased='^#+ (Próxima versão|Unreleased)[[:blank:]]*$'
# The heading of the section of the version: the one above, or, for a version released as it is, also the version
# itself, with or without its date.
version_heading=$unreleased
names='"Próxima versão" or "Unreleased"'
if $as_is; then
  version_heading="$unreleased|^#+ $(echo "$next" | sed 's/\./\\./g')([[:blank:]].*)?\$"
  names="\"Próxima versão\", \"Unreleased\" or \"$next\""
fi

# section FILE PATTERN: the body of the section whose heading matches PATTERN, up to the next heading of the same or
# of a higher level, without the blank lines around it.
section() {
  PATTERN=$2 awk '
    function level(s) { match(s, /^#+/); return RLENGTH }
    /^[ \t]*```/ { fence = !fence }
    inside && !fence && /^#+ / && level($0) <= depth { exit }
    inside { lines[++n] = $0; next }
    !fence && $0 ~ ENVIRON["PATTERN"] { inside = 1; depth = level($0) }
    END {
      first = 1; while (first <= n && lines[first] ~ /^[ \t]*$/) first++
      last = n; while (last >= first && lines[last] ~ /^[ \t]*$/) last--
      for (i = first; i <= last; i++) print lines[i]
    }' "$1"
}

# replace FILE SKIP: FILE with the version changed, on stdout. With SKIP=1 (a changelog), the versions already released
# (the sections after the one of the next version, up to a heading of a higher level) stay as they are: their links
# point to the tags of their own versions. The section of the next version is changed like the rest: a link written
# while it was developed points to the tag of the version before.
replace() {
  OLD_IMPORT="$name:$prev" NEW_IMPORT="$name:$next" OLD_TAG="v$prev" NEW_TAG="v$next" PATTERN=$version_heading SKIP=$2 awk '
    function level(s) { match(s, /^#+/); return RLENGTH }
    # every FROM in S becomes TO; with BOUNDED, not when a digit follows (pkg:1.0.1 is not in pkg:1.0.10)
    function swap(s, from, to, bounded,   out, i, rest) {
      out = ""
      while ((i = index(s, from)) > 0) {
        rest = substr(s, i + length(from))
        if (bounded && rest ~ /^[0-9]/) out = out substr(s, 1, i - 1 + length(from))
        else out = out substr(s, 1, i - 1) to
        s = rest
      }
      return out s
    }
    /^[ \t]*```/ { fence = !fence }
    ENVIRON["SKIP"] == "1" && !fence && /^#+ / {
      if ($0 ~ ENVIRON["PATTERN"]) { changelog = 1; depth = level($0) }  # the next version: changed like the rest
      else if (changelog && level($0) < depth) changelog = history = 0  # past the changelog
      else if (changelog && level($0) == depth) history = 1             # a version already released
    }
    !history {
      $0 = swap($0, ENVIRON["OLD_IMPORT"], ENVIRON["NEW_IMPORT"], 1)
      $0 = swap($0, "/" ENVIRON["OLD_TAG"] "/", "/" ENVIRON["NEW_TAG"] "/", 0)
      $0 = swap($0, "`" ENVIRON["OLD_TAG"] "`", "`" ENVIRON["NEW_TAG"] "`", 0)
    }
    { print }' "$1"
}

# tagged TAG: whether TAG exists, here or on origin
tagged() {
  git rev-parse -q --verify "refs/tags/$1" > /dev/null ||
    git ls-remote --exit-code --tags origin "refs/tags/$1" > /dev/null 2>&1
}

is_changelog() {
  case " $changelogs " in
    *" $1 "*) return 0 ;;
  esac
  return 1
}

# heading LINE: the heading of the version that takes the place of LINE ("Próxima versão" or "Unreleased")
day=$(date +%d | sed 's/^0//')
month=$(date +%m | sed 's/^0//')
year=$(date +%Y)
pt_month=$(echo "janeiro fevereiro março abril maio junho julho agosto setembro outubro novembro dezembro" | cut -d ' ' -f "$month")
en_month=$(echo "January February March April May June July August September October November December" | cut -d ' ' -f "$month")
heading() {
  hashes=${1%% *}
  if ! $dated; then
    echo "$hashes $next"
  elif echo "$1" | grep -q Unreleased; then
    echo "$hashes $next ($day $en_month $year)"
  else
    echo "$hashes $next ($day de $pt_month de $year)"
  fi
}

# body CHANGES: the body of the pull request to typst/packages, an update, with the changes of the file CHANGES
body() {
  cat <<EOF
I am submitting
- [ ] a new package
- [x] an update for a package

Description: version $next of \`$name\`. $description What changed:

$(cat "$1")

Release notes: https://github.com/$repository/releases/tag/v$next

The template compiles untouched after \`typst init\`, and \`package-check\` reports no issues.

- [x] ensured that my package is licensed such that users can use and distribute the contents of its template directory without restriction, after modifying them through normal use.
EOF
}

tmp=$(mktemp -d)
changed=false
committed=false
finish() {
  status=$?
  rm -rf "$tmp"
  if [ "$status" -ne 0 ] && $changed && ! $committed; then
    echo "note: the release stopped, and its changes are in the working tree: \`git restore . && git clean -fd\` undoes them" >&2
  fi
}
trap finish EXIT
trap 'exit 130' INT TERM

# 1. ------------------------------------------------------------------------------------------------------------------
if $as_is; then
  step "$name $next, the version of typst.toml"
else
  step "$name $prev -> $next"
fi
branch=$(git rev-parse --abbrev-ref HEAD)
[ "$branch" = "$dev_branch" ] || problem "a release is made on $dev_branch, not on $branch"
[ -z "$(git status --porcelain)" ] || problem "the working tree is not clean: commit or stash the changes first"
git fetch -q origin || problem "git fetch origin failed"
if git rev-parse -q --verify "origin/$dev_branch" > /dev/null; then
  [ "$(git rev-list --count "HEAD..origin/$dev_branch")" -eq 0 ] ||
    problem "$dev_branch is behind origin/$dev_branch: pull first"
fi
if [ "$dev_branch" != main ]; then
  git merge-base --is-ancestor origin/main HEAD ||
    problem "origin/main is not in $dev_branch, so main cannot be fast-forwarded to it"
fi
if tagged "v$next"; then problem "the tag v$next already exists"; fi
if ! $as_is && ! tagged "v$prev"; then
  problem "typst.toml has $prev, which has no tag v$prev, so it was never released: release it as it is, with \`sh scripts/release.sh $prev\`"
fi
gh auth status > /dev/null 2>&1 || problem "gh is not logged in: run \`gh auth login\`"
[ -d fonts ] || problem "fonts/ is missing: run \`sh scripts/fonts.sh\`"
for f in $changelogs; do
  count=$(grep -cE "$version_heading" "$f" || true)
  if [ "$count" -ne 1 ]; then
    problem "$f needs one section $names with the changes of the version (it has $count)"
  elif [ -z "$(section "$f" "$version_heading")" ]; then
    problem "the section of the version in $f is empty"
  elif $dated && grep -E "$version_heading" "$f" | grep -vE "$unreleased" | grep -qv '('; then
    problem "the heading of $next in $f has no date: write it as \"Próxima versão\" / \"Unreleased\", and the release dates it"
  fi
done
# the changelog of the version for the pull request, with its links already on the new tag
replace "$pr_changelog" 1 > "$tmp/pr-changelog"
section "$tmp/pr-changelog" "$version_heading" > "$tmp/changes.md"
pr_heading=$next

# 2. ------------------------------------------------------------------------------------------------------------------
step "The version in typst.toml, the imports and the links"
if ! $dry_run; then changed=true; fi
files=
if $as_is; then
  echo "  typst.toml has $next already: the imports and the links stay as they are (the gate checks them)"
else
  if ! $dry_run; then gotpm bump "$increment" > /dev/null; fi
  echo "  typst.toml: version = \"$next\""
  # the pictures and the PDFs are built again below; this script is left out, as the same file serves every version
  files=$(git grep -lIF -e "$name:$prev" -e "/v$prev/" -e "\`v$prev\`" -- . \
    ':(exclude)*.pdf' ':(exclude)*.svg' ':(exclude)*.png' ':(exclude)scripts/release.sh' || true)
fi
while IFS= read -r f; do
  [ -n "$f" ] || continue
  skip=0
  if is_changelog "$f"; then skip=1; fi
  replace "$f" "$skip" > "$tmp/file"
  lines=$(diff "$f" "$tmp/file" | grep -c '^>' || true)
  [ "$lines" -gt 0 ] || continue
  echo "  $f: $lines line(s)"
  if ! $dry_run; then cat "$tmp/file" > "$f"; fi
done << EOF
$files
EOF

# 3. ------------------------------------------------------------------------------------------------------------------
step "The changelog"
for f in $changelogs; do
  old=$(grep -E "$version_heading" "$f" | head -n 1 || true)
  [ -n "$old" ] || continue
  if ! echo "$old" | grep -qE "$unreleased"; then
    echo "  $f: $old (as it is)"
    if [ "$f" = "$pr_changelog" ]; then pr_heading=${old#* }; fi
    continue
  fi
  new=$(heading "$old")
  echo "  $f: $old -> $new"
  if [ "$f" = "$pr_changelog" ]; then pr_heading=${new#* }; fi
  if ! $dry_run; then
    OLD=$old NEW=$new awk '!done && $0 == ENVIRON["OLD"] { print ENVIRON["NEW"]; done = 1; next } { print }' \
      "$f" > "$tmp/file"
    cat "$tmp/file" > "$f"
  fi
done

if $dry_run; then
  step "The body of the pull request $name:$next"
  body "$tmp/changes.md"
  printf '\n(dry run: nothing was changed)\n'
  exit 0
fi

# 4. ------------------------------------------------------------------------------------------------------------------
step "Building"
build
step "Checking (as the CI)"
check
step "The gate of gotpm publish (scripts/package.sh --check)"
RELEASE_TAG="v$next" sh scripts/package.sh --check

# 5. ------------------------------------------------------------------------------------------------------------------
step "The release"
if [ "$dev_branch" = main ]; then
  refs="main v$next"
else
  refs="$dev_branch $dev_branch:main v$next"
fi
if [ -n "$(git status --porcelain)" ]; then
  commit=true
  git status --short
  git diff --stat | tail -n 1
  question="Commit \"Release $next\", tag v$next and push ($refs)?"
else
  # a version released as it is, with nothing built again
  commit=false
  echo "Nothing changed: the tag goes on $(git log -1 --format='%h %s' | cut -c 1-100)"
  question="Tag v$next and push ($refs)?"
fi
printf '\nChangelog of %s:\n\n' "$next"
cat "$tmp/changes.md"
printf '\n%s [y/N] ' "$question"
read -r answer || answer=
case $answer in
  y | Y | yes | s | S | sim) ;;
  *)
    echo "Stopped before the commit: the changes are in the working tree (\`git restore . && git clean -fd\` undoes them)."
    exit 0
    ;;
esac
if $commit; then
  git add -A
  git commit -q -m "Release $next"
fi
git tag "v$next"
committed=true
# shellcheck disable=SC2086 # $refs is a list of refs
git push --atomic origin $refs ||
  fail "the push failed: the commit and the tag v$next are only here; push them with \`git push --atomic origin $refs\`"
if [ "$dev_branch" != main ]; then
  git fetch -q . "$dev_branch:main"
fi
# the @local of the new version, for the editor and the works of this machine
gotpm install -e -f > /dev/null 2>&1 || echo "note: \`gotpm install -e\` failed; @local/$name:$next is not installed" >&2

# 6. ------------------------------------------------------------------------------------------------------------------
step "Waiting for release.yml (tests, gotpm publish, GitHub release)"
# The run of this tag's commit: a release redone (see CONTRIBUTING) leaves the run of the old tag under the same name.
sha=$(git rev-parse "v$next^{commit}")
run=
tries=0
while [ -z "$run" ]; do
  [ "$tries" -lt 30 ] || fail "release.yml did not start for v$next: https://github.com/$repository/actions"
  sleep 3
  tries=$((tries + 1))
  run=$(gh run list -R "$repository" --workflow release.yml --branch "v$next" --commit "$sha" --event push --limit 1 \
    --json databaseId --jq '.[0].databaseId // empty' 2> /dev/null || true)
done
gh run watch "$run" -R "$repository" --exit-status --compact ||
  fail "release.yml failed: https://github.com/$repository/actions/runs/$run (to redo the version, see \"New version\" in CONTRIBUTING)"

step "The pull request $name:$next to typst/packages"
fork=$(gh variable get REGISTRY_FORK -R "$repository" 2> /dev/null || echo "${repository%%/*}/packages")
existing=$(gh pr list -R typst/packages --head "$name-$next" --state open --json url --jq '.[0].url // empty' \
  2> /dev/null || true)
if [ -n "$existing" ]; then
  echo "It is already open, and the push of gotpm has updated it: $existing"
  exit 0
fi
body "$tmp/changes.md" > "$tmp/body.md"
# The browser gets the body in the address: a long changelog becomes a link to it, and the whole body goes to the
# clipboard.
if [ "$(wc -c < "$tmp/body.md")" -gt 4000 ]; then
  anchor=$(printf '%s' "$pr_heading" | tr 'A-Z' 'a-z' | sed 's/[^a-z0-9 -]//g; s/ /-/g')
  echo "The changes are in the changelog: https://github.com/$repository/blob/v$next/$pr_changelog#$anchor" \
    > "$tmp/short.md"
  if command -v pbcopy > /dev/null 2>&1; then
    pbcopy < "$tmp/body.md"
    echo "note: the changelog is long, so the form links to it; the whole body is in the clipboard, to paste instead"
  fi
  body "$tmp/short.md" > "$tmp/body.md"
fi
gh pr create -R typst/packages --base main --head "${fork%%/*}:$name-$next" --title "$name:$next" \
  --body-file "$tmp/body.md" --web
printf '\nThe form is open in the browser: check it and press "Create pull request". After the merge, %s:%s is on\nTypst Universe within minutes.\n' "$name" "$next"
