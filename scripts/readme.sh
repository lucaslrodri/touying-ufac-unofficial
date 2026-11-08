#!/bin/sh
# Keeps README.md and its pictures in step with the decks. It renders the pages of the template and of the example
# decks and joins them into the pictures of the README (docs/readme/sheet.typ -> docs/readme/<picture>.png):
#   template.png                   the pages of template/main.typ, under its code
#   flavors.png                    the covers of the decks of each flavor (lecture, coursework, tcc), at the top
#   cover-style-<style>.png        the cover of the template with each cover style, in "Choose a cover style"
#   element-<element>.png          one slide for each row of "Elements", from the example decks or, for what they do
#                                  not show, from docs/readme/gallery.typ
#   deck-<deck>.png                the cover and one page of each deck, in "Examples"
# and rewrites what README.md has between `<!-- <block>:begin ... -->` and `<!-- <block>:end -->`:
#   template                       the source of template/main.typ, then its picture
#   examples                       the source of each deck of "Examples", in a closed <details>
# thumbnail.png is the cover of the template, which Typst Universe wants as the template is initialized.
#
# The pictures are referenced by their raw.githubusercontent.com URL, not by a relative path: docs/ is not published,
# so on Typst Universe a relative path would be broken. The URL is the one of the tag `v<version>` (`repository` and
# `version` of typst.toml), as typst/packages recommends, so the README of a version keeps the pictures of that
# version: on GitHub they show once the tag is pushed.
#
# The elements and the decks are pages of the example decks and of docs/readme/gallery.typ, taken by their number: each
# deck must have the number of pages below, or the script stops, so that a deck that grows never shifts a picture to another slide unnoticed. When
# a deck changes on purpose, check the pages taken from it and update the number.
#
# `sh scripts/readme.sh --check` writes nothing: it fails when README.md is out of date and only warns when a picture
# is, since the pixels depend on the release of the installed fonts. scripts/local.sh runs it before every commit.
set -eu
# The decks import `@preview/touying-ufac-unofficial:<version>`: the script runs itself through scripts/with-preview.sh,
# which links that name to this working copy while it runs.
[ -n "${TOUYING_UFAC_PREVIEW:-}" ] || exec sh "$(dirname "$0")/with-preview.sh" sh "$0" "$@"
cd "$(dirname "$0")/.."

out=docs/readme
tmp=$out/.tmp   # inside the project, where sheet.typ can read the pages
ppi=72          # two slides of 842pt side by side: 1768 px
thumbnail_ppi=144   # 1684 px: Typst Universe asks for 1080 px or more on the longer edge
examples="lecture coursework tcc"   # the decks of "Examples", one for each flavor, in this order

fail() {
  echo "error: $*" >&2
  exit 1
}

check=false
[ "${1:-}" = "--check" ] && check=true

repository=$(sed -n 's/^repository *= *"https:\/\/github\.com\/\(.*\)"/\1/p' typst.toml | head -n 1)
[ -n "$repository" ] || fail "typst.toml has no GitHub \`repository\`"
version=$(sed -n 's/^version *= *"\(.*\)"/\1/p' typst.toml | head -n 1)
url="https://raw.githubusercontent.com/$repository/v$version/$out"

fonts=""
[ -d fonts ] && fonts="--font-path fonts"

rm -rf "$tmp"
mkdir -p "$tmp"
trap 'rm -rf "$tmp"' EXIT
cp README.md "$tmp/README.md"
pictures=""

# render <deck> <name>: the pages of the deck as $tmp/<name>-<page>.svg
render() {
  typst compile $fonts "$1" "$tmp/$2-{p}.svg"
}
pages() {
  ls "$tmp/$1"-*.svg | wc -l | tr -d ' '
}
# expect <name> <pages>: the deck has the pages that the pictures below take from it
expect() {
  [ "$(pages "$1")" = "$2" ] || fail "$1 has $(pages "$1") pages, not $2: check the pages that scripts/readme.sh takes from it"
}
# sheet <picture> <columns> <margin> <page>...: the pages side by side, in $tmp/<picture>.png
sheet() {
  picture=$1 columns=$2 margin=$3
  shift 3
  typst compile --root . $fonts --ppi "$ppi" --input files="$(echo "$@" | tr ' ' ',')" --input columns="$columns" \
    --input margin="$margin" --input dir=.tmp "$out/sheet.typ" "$tmp/$picture.png"
  pictures="$pictures $picture"
}
# fenced <file>: the source of a deck in a fence of four backticks (a deck may hold a code block of three, which would
# close a fence of three and turn the rest of the README into code)
fenced() {
  grep -q '^````' "$1" && fail "$1 has a line starting with four backticks, the fence of README.md"
  echo '````typst'
  awk 1 "$1"
  echo '````'
}

# the template: its code and its pages, under "Start"; the cover with each cover style
render template/main.typ template
n=$(pages template)
sheet template 2 28 $(seq 1 "$n" | sed 's/^/template-/')
{
  fenced template/main.typ
  echo
  echo "![The $n pages of template/main.typ]($url/template.png)"
} > "$tmp/template.md"
for style in bubbles gradient plain; do
  awk -v s="$style" '{ print } /^#show: ufac-theme\.with\(/ { print "  cover-style: \"" s "\"," }' template/main.typ \
    > "$tmp/cover-$style.typ"
  typst compile --root . $fonts --pages 1 "$tmp/cover-$style.typ" "$tmp/cover-$style-{p}.svg"
  sheet "cover-style-$style" 1 4 "cover-$style-1"
done

# the example decks: their pages, taken by number
render docs/readme/gallery.typ gallery && expect gallery 5
for deck in $examples; do render "example/$deck.typ" "$deck"; done
expect lecture 13 && expect coursework 4 && expect tcc 8
sheet flavors 3 28 lecture-1 coursework-1 tcc-1
for element in slide:lecture-4 emphasis:gallery-4 section:gallery-5 exercise:lecture-10 boxes:gallery-1 \
  callouts:gallery-2 code:lecture-12 table:gallery-3 ending:lecture-13; do
  sheet "element-${element%%:*}" 1 4 "${element#*:}"
done
sheet deck-lecture 2 4 lecture-1 lecture-9
sheet deck-coursework 2 4 coursework-1 coursework-3
sheet deck-tcc 2 4 tcc-1 tcc-3
first=true
for deck in $examples; do
  $first || echo
  first=false
  echo '<details>'
  echo "<summary>Show the code of example/$deck.typ</summary>"
  echo
  fenced "example/$deck.typ"
  echo
  echo '</details>'
done > "$tmp/examples.md"

for block in template examples; do
  for marker in "^<!-- $block:begin" "^<!-- $block:end -->\$"; do
    [ "$(grep -c -- "$marker" README.md)" = 1 ] || fail "README.md must have exactly one line matching '$marker'"
  done
  awk -v block="$block" -v file="$tmp/$block.md" '
    index($0, "<!-- " block ":begin") == 1 { print; while ((getline line < file) > 0) print line; skip = 1; next }
    $0 == "<!-- " block ":end -->" { skip = 0 }
    !skip { print }
  ' "$tmp/README.md" > "$tmp/README.new"
  mv "$tmp/README.new" "$tmp/README.md"
done

typst compile $fonts -f png --pages 1 --ppi "$thumbnail_ppi" template/main.typ "$tmp/thumbnail.png"

if $check; then
  for picture in $pictures; do
    cmp -s "$tmp/$picture.png" "$out/$picture.png" || echo "warning: $out/$picture.png is out of date" >&2
  done
  cmp -s "$tmp/thumbnail.png" thumbnail.png || echo "warning: thumbnail.png is out of date" >&2
  cmp -s "$tmp/README.md" README.md || fail "README.md is out of date with the decks: run \`sh scripts/readme.sh\`"
  exit 0
fi

# only what changed is written, so an up-to-date README keeps its timestamp
for picture in $pictures; do
  cmp -s "$tmp/$picture.png" "$out/$picture.png" || { mv -f "$tmp/$picture.png" "$out/$picture.png" && echo "$out/$picture.png"; }
done
cmp -s "$tmp/thumbnail.png" thumbnail.png || { mv -f "$tmp/thumbnail.png" thumbnail.png && echo "thumbnail.png"; }
cmp -s "$tmp/README.md" README.md || { cp "$tmp/README.md" README.md && echo "README.md"; }
