#!/bin/sh
# The error messages that Typst raises only when it lays out the deck, out of reach of `catch` in tests/unit/api: every
# file of tests/errors/ must fail to compile, with the text of its first line (`// error: <text>`) in the message.
# Run by scripts/local.sh and by the CI, on the minimum Typst version.
set -eu
cd "$(dirname "$0")/.."

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

status=0
count=0
for f in tests/errors/*.typ; do
  count=$((count + 1))
  want=$(sed -n '1s|^// error: ||p' "$f")
  if [ -z "$want" ]; then
    echo "error: $f has no '// error: <text>' first line" >&2
    status=1
  elif out=$(typst compile "$f" "$tmp/out.pdf" 2>&1); then
    echo "error: $f compiled; expected an error with: $want" >&2
    status=1
  elif ! printf '%s\n' "$out" | grep -qF -- "$want"; then
    echo "error: $f failed with another message; expected: $want" >&2
    printf '%s\n' "$out" >&2
    status=1
  fi
done

[ "$status" -eq 0 ] && echo "error messages: $count checked"
exit "$status"
