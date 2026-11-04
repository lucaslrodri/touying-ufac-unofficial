#!/bin/sh
# Compiles every example deck (example/*.typ) to docs/decks/<name>.pdf, the PDFs that README.md links to, so that a
# reader can see the result of each deck without compiling it. docs/ is not published, so README.md reaches them by
# their GitHub URL at the tag of the version. Run it again when a deck or the theme changes; the PDFs are committed.
set -eu
cd "$(dirname "$0")/.."

fonts=""
[ -d fonts ] && fonts="--font-path fonts"
mkdir -p docs/decks
for deck in example/*.typ; do
  name=$(basename "$deck" .typ)
  typst compile --root . $fonts "$deck" "docs/decks/$name.pdf"
  echo "docs/decks/$name.pdf"
done
