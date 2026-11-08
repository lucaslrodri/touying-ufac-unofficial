#!/bin/sh
# Runs a command with `@preview/touying-ufac-unofficial:<version>` linked to this working copy:
#
#   sh scripts/with-preview.sh tt run --use-system-fonts
#   sh scripts/with-preview.sh typst compile example/lecture.typ
#
# The template and the example decks import the package by that name, as Typst Universe requires of the template (a
# deck created from it must compile untouched), and so do the tests that include them (`deck/`, Tytanic's `@template`).
# gotpm links the name to this working copy in a package folder of the run (TYPST_PACKAGE_PATH, which typst, tt and
# gotpm read), deleted at the end, never in the system's: there it would take the place of the version published on
# Typst Universe in every deck of the machine. The version is the one of typst.toml, so a new version needs no step of
# its own. The other scripts that compile those files run themselves through this one.
set -eu
root=$(cd "$(dirname "$0")/.." && pwd)

if [ $# -eq 0 ]; then
  echo "usage: sh scripts/with-preview.sh <command> [arguments]" >&2
  exit 2
fi
command -v gotpm > /dev/null || {
  echo "error: gotpm is not installed (CONTRIBUTING.md, Setup)" >&2
  exit 1
}

TYPST_PACKAGE_PATH=$(mktemp -d)
export TYPST_PACKAGE_PATH
trap 'rm -rf "$TYPST_PACKAGE_PATH"' EXIT
(cd "$root" && gotpm install -e -n preview > /dev/null)
# for the scripts that run themselves through this one: the name is linked already
export TOUYING_UFAC_PREVIEW=1
"$@"
