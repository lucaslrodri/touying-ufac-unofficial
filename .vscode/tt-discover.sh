#!/bin/sh
# Discovery command for the "Command Line Test Adapter" VS Code extension
# (jvcdk-at-github.vscode-commandline-test-adapter). Prints the Tytanic tests
# of this repository as the JSON array the extension expects: one group per test
# directory (guide, elements, ...) with one leaf per test, plus @template. Every leaf runs tt through
# scripts/with-preview.sh, which links @preview/touying-ufac-unofficial:<version> (imported by the deck tests) to this
# working copy while it runs.
set -eu
export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"
cd "$(dirname "$0")/.."
TT=$(command -v tt)
tt list --json | jq --arg tt "$TT" '
  def run($id): {command: "sh", args: ["scripts/with-preview.sh", $tt, "run", "--use-system-fonts", "--color=never", $id], children: []};
  map(.test)
  | (map(select(.id | startswith("@")))
       | map({label: .id, file: (.path + "/main.typ"), line: 1} + run(.id))) as $special
  | (map(select(.id | startswith("@") | not))
       | group_by(.id | split("/")[0])
       | map({
           label: (.[0].id | split("/")[0]),
           command: "",
           args: [],
           children: map({
             label: (.id | split("/")[1:] | join("/")),
             file: (.path + "/test.typ"),
             line: 1
           } + run(.id))
         })) as $groups
  | $groups + $special
'
