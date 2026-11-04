#!/bin/sh
# Report of the test suite, tests/report.pdf: for every test, its name, its synopsis (the `/// Synopsis:` lines of its
# test.typ), its code (body.typ, or test.typ) and, beside it, its reference pages (ref/*.png), in the format of a
# catalogue. Typst cannot list a folder, so this script writes the list of the tests (tests/.report.json: the id,
# whether it has a body.typ and how many reference pages) and compiles tests/report.typ. Both outputs are git-ignored:
# run it again after `tt update`.
set -eu
cd "$(dirname "$0")/.."

fonts=""
[ -d fonts ] && fonts="--font-path fonts"

{
  printf '['
  sep=''
  for test in $(find tests -name test.typ | sort); do
    dir=$(dirname "$test")
    body=false
    [ -f "$dir/body.typ" ] && body=true
    pages=0
    [ -d "$dir/ref" ] && pages=$(ls "$dir/ref" | grep -c '\.png$' || true)
    printf '%s\n  {"id": "%s", "body": %s, "pages": %s}' "$sep" "${dir#tests/}" "$body" "$pages"
    sep=','
  done
  printf '\n]\n'
} > tests/.report.json

typst compile --root . $fonts tests/report.typ tests/report.pdf
echo "tests/report.pdf"
