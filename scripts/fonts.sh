#!/bin/sh
# Downloads the New Computer Modern family (the theme uses its Sans and Math cuts; Sans is not bundled with Typst) from
# CTAN into fonts/, which is git-ignored. For the CI and for machines where the fonts are not installed:
# `tt run --font-path fonts` or `typst compile --font-path fonts ...`. The reference images of the test suite match
# the releases 8.0.1 and 8.1.1 of the fonts.
set -eu
cd "$(dirname "$0")/.."

if ls fonts/NewCMSans10-Regular.otf fonts/NewCMMath-Regular.otf > /dev/null 2>&1; then
  echo "fonts/ is already populated"
  exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fsSL --retry 3 -o "$tmp/newcm.zip" https://mirrors.ctan.org/fonts/newcomputermodern.zip
mkdir -p fonts
unzip -q -j -o "$tmp/newcm.zip" '*.otf' -d fonts
echo "fonts/: $(ls fonts | wc -l | tr -d ' ') files"
