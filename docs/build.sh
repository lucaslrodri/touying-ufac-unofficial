#!/bin/sh
# Builds the manual: every deck in docs/examples/ becomes docs/examples/out/<name>-<page>.svg (the pictures of the
# slide examples), then docs/manual.pdf. Run from anywhere: `sh docs/build.sh`. Needs typst >= 0.14 and the fonts
# New Computer Modern Sans/Math.
#
# The pictures are rendered into a temporary folder and swapped in only when every deck compiled: an editor preview
# that compiles the manual meanwhile never finds a picture missing, and a broken deck leaves out/ untouched.
set -e
cd "$(dirname "$0")/.."

out=docs/examples/out
tmp=docs/examples/.out.tmp
rm -rf "$tmp"
mkdir -p "$tmp" "$out"
trap 'rm -rf "$tmp"' EXIT

for deck in docs/examples/*.typ; do
  name=$(basename "$deck" .typ)
  typst compile --root . "$deck" "$tmp/$name-{p}.svg"
done

# new pictures first (a rename replaces the old file in one step), then the leftovers of decks that lost pages
(cd "$tmp" && ls *.svg) > "$tmp/.new"
for picture in "$tmp"/*.svg; do
  mv -f "$picture" "$out/"
done
for picture in "$out"/*.svg; do
  grep -qxF "$(basename "$picture")" "$tmp/.new" || rm -f "$picture"
done

typst compile --root . docs/manual.typ docs/manual.pdf
echo "docs/manual.pdf"
