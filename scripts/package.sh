#!/bin/sh
# Assembles the files that are published on Typst Universe into <target>/preview/<name>/<version>/ (default target:
# dist/), the layout of `packages/` in https://github.com/typst/packages, so <target> also works as a package path:
# `typst init --package-path dist @preview/touying-ufac-unofficial:<version> deck`.
#
# Only the list below is published. The rest of the repository (tests, manual, scripts, CI) stays out of
# typst/packages, as its guidelines ask (docs/tips.md, "What to commit? What to exclude?"): the README reaches the
# manual, its pictures and the example deck (example/) by their GitHub URL, at the tag of the version. gotpm publishes
# the same files: it leaves out the `exclude` of typst.toml and what .gitignore ignores (`--check` compares the two).
#
# `sh scripts/package.sh --check [target]` is the gate of `gotpm publish` (its pre-publish hook, in typst.toml): besides
# the checks below, it compares these files with the ones gotpm publishes, creates a deck from the published files
# only and compiles it, refuses a version already on Typst Universe and runs the checker of the pull requests of
# typst/packages (with Docker; skipped, with a note, on a machine without it, but required on the CI).
set -eu
cd "$(dirname "$0")/.."

files="typst.toml LICENSE LICENSE-MIT-0 README.md thumbnail.png src assets template"

name=$(sed -n 's/^name *= *"\(.*\)"/\1/p' typst.toml | head -n 1)
version=$(sed -n 's/^version *= *"\(.*\)"/\1/p' typst.toml | head -n 1)
check=false
if [ "${1:-}" = "--check" ]; then
  check=true
  shift
fi
target=${1:-dist}
out="$target/preview/$name/$version"

fail() {
  echo "error: $*" >&2
  exit 1
}

# A release tag (`v<version>`), when given by the CI, must match the manifest.
if [ -n "${RELEASE_TAG:-}" ] && [ "$RELEASE_TAG" != "v$version" ]; then
  fail "tag $RELEASE_TAG does not match the version of typst.toml ($version)"
fi

rm -rf "$out"
mkdir -p "$out"
for f in $files; do
  [ -e "$f" ] || fail "$f is missing"
  mkdir -p "$out/$(dirname "$f")"
  cp -R "$f" "$out/$f"
done
find "$out" -name .DS_Store -delete

# Every import of the package itself must use the published name and this version: a deck created from the template
# has to compile untouched, and the README is what people copy from.
if grep -rn "@local/" "$out" --include='*.typ' --include='*.md' >&2; then
  fail "the files above import from @local; published files must use @preview/$name:$version"
fi
stale=$(grep -rnoE "@preview/$name:[0-9]+\.[0-9]+\.[0-9]+" "$out" --include='*.typ' --include='*.md' \
  | grep -v ":@preview/$name:$version\$" || true)
if [ -n "$stale" ]; then
  echo "$stale" >&2
  fail "the references above do not point to version $version"
fi

# The README reaches the manual, the license and its pictures in the repository, at the tag of this version
# (scripts/readme.sh writes the pictures). The badges read typst.toml of main through an encoded URL: not matched here.
repository=$(sed -n 's/^repository *= *"https:\/\/github\.com\/\(.*\)"/\1/p' typst.toml | head -n 1)
stale=$(grep -noE "(github\.com/$repository/(blob|raw|tree)|raw\.githubusercontent\.com/$repository)/[^/]+/" "$out/README.md" \
  | grep -v "/v$version/\$" || true)
if [ -n "$stale" ]; then
  echo "$stale" >&2
  fail "the links above must point to the tag v$version"
fi

if $check; then
  work=$(mktemp -d)
  trap 'rm -rf "$work"' EXIT

  # gotpm publishes the files that `exclude` and .gitignore leave: they must be the list above
  if command -v gotpm > /dev/null; then
    gotpm install --install-dir "$work/gotpm" > /dev/null
    find "$work/gotpm" -name .DS_Store -delete
    diff -rq "$out" "$work/gotpm" >&2 ||
      fail "gotpm would publish other files: align the \`exclude\` of typst.toml with this script"
  else
    echo "note: gotpm is not installed; its files were not compared" >&2
  fi

  # what a user does: create a deck from the published files only, and compile it untouched
  fonts=""
  [ -d fonts ] && fonts="--font-path fonts --ignore-system-fonts"
  typst init --package-path "$target" "@preview/$name:$version" "$work/deck" > /dev/null 2>&1 ||
    fail "typst init does not create a deck from the published template"
  typst compile --package-path "$target" $fonts "$work/deck/main.typ" "$work/deck.pdf" ||
    fail "a deck created from the published template does not compile"

  # versions on Typst Universe are immutable: a fix is a new version
  if curl -fsI "https://packages.typst.org/preview/$name-$version.tar.gz" > /dev/null 2>&1; then
    fail "$name:$version is already on Typst Universe"
  fi

  # the checker of the pull requests of typst/packages, offline, from the package cache the compilation above filled
  if docker info > /dev/null 2>&1; then
    case $out in /*) data=$out ;; *) data=$PWD/$out ;; esac
    cache=$(typst info -f yaml | sed -n 's/^ *package-cache-path: *//p')
    docker run --rm -v "$data:/data" -v "$cache:/.cache/typst/packages:ro" ghcr.io/typst/package-check check ||
      fail "the checker of typst/packages refused the package"
  elif [ -n "${CI:-}" ] && [ -z "${ACT:-}" ]; then
    fail "the CI needs Docker for the checker of typst/packages"
  else
    echo "note: Docker is not running; the checker of typst/packages was skipped" >&2
  fi
fi

echo "$out"
