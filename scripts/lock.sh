#!/bin/sh
# Writes tinymist.lock (ignored by git) for the editor. With `tinymist.projectResolution: "lockDatabase"`
# (.vscode/settings.json), tinymist compiles a file that another one includes inside the document recorded here,
# instead of alone. The body of a test (`body.typ`, `config/lang-body.typ`) only works under the theme that its
# `test.typ` applies (alone, its `@exercise-…` references fail), so every test with a body is recorded and the editor
# opens a body through its own test. The other tests are left out: deck/ and docs/ include the decks and the manual,
# which open by themselves, and unit/ only compiles inside Tytanic.
#
# The routes (the files that each test includes) go to tinymist's cache (~/Library/Caches/tinymist/projects), so the
# lock is written on every machine: run it once per clone and again when a test is added. It needs the tinymist CLI
# (`brew install tinymist`).
set -eu
cd "$(dirname "$0")/.."

fail() {
  echo "error: $*" >&2
  exit 1
}

command -v tinymist > /dev/null || fail "tinymist is not installed"

rm -f tinymist.lock
# `--when never`: the documents are recorded for the routes only, the editor never exports them. The CLI still writes
# the PDF (next to the test, where an export from the editor would go; `-` became a file named `-.pdf`), so it is
# removed at once.
for test in $(grep -l 'body.typ"' tests/*/*/test.typ); do
  tinymist compile --save-lock --when never --root . "$test" "${test%.typ}.pdf"
  rm -f "${test%.typ}.pdf"
done
echo "tinymist.lock: $(grep -c '^\[\[document\]\]' tinymist.lock) tests"
