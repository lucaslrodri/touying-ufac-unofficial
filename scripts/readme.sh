#!/bin/sh
# Keeps README.md and thumbnail.png in step with the two decks. For template/main.typ and example/main.typ it renders
# the pages, joins them into one picture (docs/readme/sheet.typ -> docs/readme/<deck>.png) and rewrites what README.md
# has between `<!-- <deck>:begin ... -->` and `<!-- <deck>:end -->`: the source of the deck, then the picture.
# thumbnail.png is the cover of the template, which Typst Universe wants as the template is initialized.
#
# The picture is referenced by its raw.githubusercontent.com URL, not by a relative path: docs/ is not published, so on
# Typst Universe a relative path would be broken. The URL is the one of the tag `v<version>` (`repository` and
# `version` of typst.toml), as typst/packages recommends, so the README of a version keeps the pictures of that
# version: on GitHub they show once the tag is pushed.
#
# `sh scripts/readme.sh --check` writes nothing: it fails when README.md is out of date and only warns when a picture
# is, since the pixels depend on the release of the installed fonts. scripts/local.sh runs it before every commit.
set -eu
cd "$(dirname "$0")/.."

decks="template example"
out=docs/readme
tmp=$out/.tmp   # inside the project, where sheet.typ can read the pages
ppi=72          # two slides of 842pt side by side: 1768 px
thumbnail_ppi=144   # 1684 px: Typst Universe asks for 1080 px or more on the longer edge

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

for deck in $decks; do
  typst compile $fonts "$deck/main.typ" "$tmp/$deck-{p}.svg"
  pages=$(ls "$tmp/$deck"-*.svg | wc -l | tr -d ' ')
  typst compile --root . $fonts --ppi "$ppi" --input deck="$deck" --input pages="$pages" --input dir=.tmp \
    "$out/sheet.typ" "$tmp/$deck.png"

  {
    echo '```typst'
    awk 1 "$deck/main.typ"
    echo '```'
    echo
    echo "![The $pages pages of $deck/main.typ]($url/$deck.png)"
  } > "$tmp/$deck.md"

  for marker in "^<!-- $deck:begin" "^<!-- $deck:end -->\$"; do
    [ "$(grep -c -- "$marker" README.md)" = 1 ] || fail "README.md must have exactly one line matching '$marker'"
  done
  awk -v deck="$deck" -v block="$tmp/$deck.md" '
    index($0, "<!-- " deck ":begin") == 1 { print; while ((getline line < block) > 0) print line; skip = 1; next }
    $0 == "<!-- " deck ":end -->" { skip = 0 }
    !skip { print }
  ' "$tmp/README.md" > "$tmp/README.new"
  mv "$tmp/README.new" "$tmp/README.md"
done

typst compile $fonts -f png --pages 1 --ppi "$thumbnail_ppi" template/main.typ "$tmp/thumbnail.png"

if $check; then
  for deck in $decks; do
    cmp -s "$tmp/$deck.png" "$out/$deck.png" || echo "warning: $out/$deck.png is out of date" >&2
  done
  cmp -s "$tmp/thumbnail.png" thumbnail.png || echo "warning: thumbnail.png is out of date" >&2
  cmp -s "$tmp/README.md" README.md || fail "README.md is out of date with the decks: run \`sh scripts/readme.sh\`"
  exit 0
fi

# only what changed is written, so an up-to-date README keeps its timestamp
for deck in $decks; do
  cmp -s "$tmp/$deck.png" "$out/$deck.png" || { mv -f "$tmp/$deck.png" "$out/$deck.png" && echo "$out/$deck.png"; }
done
cmp -s "$tmp/thumbnail.png" thumbnail.png || { mv -f "$tmp/thumbnail.png" thumbnail.png && echo "thumbnail.png"; }
cmp -s "$tmp/README.md" README.md || { cp "$tmp/README.md" README.md && echo "README.md"; }
