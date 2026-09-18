#!/bin/sh
# Runs on this machine, without Docker, what .github/workflows/tests.yml runs on the CI (act, in CONTRIBUTING.md, runs
# the workflows themselves): the Tytanic suite, the two decks and the packaging into a temporary folder, which checks
# the list of published files and the version of every import; then that README.md is in step with the decks
# (scripts/readme.sh). The package must be linked already: scripts/link.sh is run by hand, once per version.
#
# Called by .githooks/pre-commit on every commit, once `git config core.hooksPath .githooks` is set; a failure aborts
# the commit and `git commit --no-verify` skips the checks. It checks the working copy, not the index.
set -eu
cd "$(dirname "$0")/.."

fail() {
  echo "error: $*" >&2
  exit 1
}

command -v tt > /dev/null || fail "tt (Tytanic) is not installed"
command -v typst > /dev/null || fail "typst is not installed"

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

sh scripts/link.sh --check
tt run $tt_fonts --no-fail-fast
for deck in template example; do
  typst compile $typst_fonts "$deck/main.typ" "$tmp/$deck.pdf"
done
sh scripts/package.sh "$tmp/dist" > /dev/null
sh scripts/readme.sh --check

echo "local checks passed"
