#!/bin/sh
# Runs on this machine, without Docker, what .github/workflows/tests.yml runs on the CI (act, in CONTRIBUTING.md, runs
# the workflows themselves): the Tytanic suite, the two decks and the packaging into a temporary folder, which checks
# the list of published files and the version of every import, and that gotpm would publish the same files (the
# offline part of `package.sh --check`); the templates of the skills (skills/); the error messages raised at layout
# (scripts/errors.sh); then that README.md is in step with the decks (scripts/readme.sh).
#
# The template, the example decks and the tests that include them import `@preview/touying-ufac-unofficial:<version>`:
# the script runs itself through scripts/with-preview.sh, which links that name to this working copy with gotpm while
# it runs, never in the system's package folder.
#
# Called by .githooks/pre-commit on every commit, once `git config core.hooksPath .githooks` is set; a failure aborts
# the commit and `git commit --no-verify` skips the checks. It checks the working copy, not the index.
set -eu
[ -n "${TOUYING_UFAC_PREVIEW:-}" ] || exec sh "$(dirname "$0")/with-preview.sh" sh "$0" "$@"
cd "$(dirname "$0")/.."

fail() {
  echo "error: $*" >&2
  exit 1
}

command -v tt > /dev/null || fail "tt (Tytanic) is not installed"
command -v typst > /dev/null || fail "typst is not installed"
command -v gotpm > /dev/null || fail "gotpm is not installed"

# As the CI (only fonts/ and the embedded fonts) when scripts/fonts.sh has downloaded fonts/, else the installed fonts.
if [ -d fonts ]; then
  tt_fonts="--font-path fonts"
  typst_fonts="--font-path fonts --ignore-system-fonts"
else
  tt_fonts="--use-system-fonts"
  typst_fonts=""
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

tt run $tt_fonts --no-fail-fast
for deck in template example; do
  typst compile $typst_fonts "$deck/main.typ" "$tmp/$deck.pdf"
done
out=$(sh scripts/package.sh "$tmp/dist")
# gotpm publishes what the `exclude` of typst.toml and .gitignore leave: the same files as package.sh
gotpm install --install-dir "$tmp/gotpm" > /dev/null
find "$tmp/gotpm" -name .DS_Store -delete
diff -rq "$out" "$tmp/gotpm" >&2 || fail "gotpm would publish other files than scripts/package.sh: align the \`exclude\` of typst.toml"
# the templates of the skills that compile on their own (the deck of skills/lectures needs the comum.typ of a course)
for f in skills/academic/templates/deck.typ skills/academic/templates/circuitos-zap.typ \
  skills/lectures/templates/circuitos-zap.typ; do
  typst compile $typst_fonts "$f" "$tmp/skill.pdf" || fail "$f does not compile"
done
sh scripts/errors.sh
sh scripts/readme.sh --check

echo "local checks passed"
