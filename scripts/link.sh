#!/bin/sh
# Makes `@preview/touying-ufac-unofficial:<version>` resolve to this working copy: symlinks the repository into Typst's
# local package directory, under the `preview` namespace (Typst looks there before the download cache, so the link also
# wins over the published release of the same version). The decks, the tests and the README import the package by that
# name, as Typst Universe requires from a template, so the link is needed by `tt run`, `typst compile template/main.typ`
# and the editor preview. Used by the CI workflows too, and by the VS Code task "typst: link the package".
# `sh scripts/link.sh --remove` deletes the link; `--check` only tells whether it points to this working copy.
set -eu
cd "$(dirname "$0")/.."

name=$(sed -n 's/^name *= *"\(.*\)"/\1/p' typst.toml | head -n 1)
version=$(sed -n 's/^version *= *"\(.*\)"/\1/p' typst.toml | head -n 1)

if [ -n "${TYPST_PACKAGE_PATH:-}" ]; then
  packages=$TYPST_PACKAGE_PATH
else
  case "$(uname -s)" in
    Darwin) packages="$HOME/Library/Application Support/typst/packages" ;;
    *) packages="${XDG_DATA_HOME:-$HOME/.local/share}/typst/packages" ;;
  esac
fi
link="$packages/preview/$name/$version"

if [ "${1:-}" = "--remove" ]; then
  [ -L "$link" ] && rm "$link" && echo "removed $link"
  exit 0
fi

if [ "${1:-}" = "--check" ]; then
  [ "$(cd "$link" 2> /dev/null && pwd -P)" = "$(pwd -P)" ] && exit 0
  echo "error: $link does not point to this working copy: run \`sh scripts/link.sh\`" >&2
  exit 1
fi

if [ -e "$link" ] && [ ! -L "$link" ]; then
  echo "error: $link exists and is not a symlink; remove it first" >&2
  exit 1
fi
mkdir -p "$(dirname "$link")"
ln -sfn "$PWD" "$link"
echo "$link -> $PWD"
