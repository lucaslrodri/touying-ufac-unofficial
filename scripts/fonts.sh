#!/bin/sh
# Downloads the New Computer Modern family (the theme uses its Sans and Math cuts; Sans is not bundled with Typst) from
# CTAN into fonts/, which is git-ignored. For the CI and for machines where the fonts are not installed:
# `tt run --font-path fonts` or `typst compile --font-path fonts ...`. The reference images of the test suite match
# the releases 8.0.1 and 8.1.1 of the fonts.
set -eu
cd "$(dirname "$0")/.."

# The two cuts the theme uses. Typst embeds a New Computer Modern Math, not necessarily in the release of the reference
# images, so Math comes from fonts/ too: when either file is missing, the family is downloaded again.
missing=""
for font in NewCMSans10-Regular.otf NewCMMath-Regular.otf; do
  [ -f "fonts/$font" ] || missing="$missing $font"
done
if [ -z "$missing" ]; then
  echo "fonts/ is already populated"
  exit 0
fi
echo "missing in fonts/:$missing"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fsSL --retry 3 -o "$tmp/newcm.zip" https://mirrors.ctan.org/fonts/newcomputermodern.zip
mkdir -p fonts
unzip -q -j -o "$tmp/newcm.zip" '*.otf' -d fonts
echo "fonts/: $(ls fonts | wc -l | tr -d ' ') files"
