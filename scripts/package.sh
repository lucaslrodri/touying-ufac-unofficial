#!/bin/sh
# Assembles the files that are published on Typst Universe into <target>/preview/<name>/<version>/ (default target:
# dist/), the layout of `packages/` in https://github.com/typst/packages, so <target> also works as a package path:
# `typst init --package-path dist @preview/touying-ufac:<version> deck`.
#
# Only the list below is published. The rest of the repository (tests, manual sources, scripts, CI) stays out of
# typst/packages, as its guidelines ask (docs/tips.md, "What to commit? What to exclude?"); `docs/manual.pdf` and
# `example/` are linked from the README, so they are committed there, and `exclude` in typst.toml keeps the manual
# out of the archive that the compiler downloads.
set -eu
cd "$(dirname "$0")/.."

files="typst.toml LICENSE README.md thumbnail.png src template example docs/manual.pdf"

name=$(sed -n 's/^name *= *"\(.*\)"/\1/p' typst.toml | head -n 1)
version=$(sed -n 's/^version *= *"\(.*\)"/\1/p' typst.toml | head -n 1)
target=${1:-dist}
out="$target/preview/$name/$version"

fail() {
  echo "error: $*" >&2
  exit 1
}

# A release tag (`v<version>`), when given by the CI, must match the manifest.
if [ -n "${RELEASE_TAG:-}" ] && [ "$RELEASE_TAG" != "v$version" ]; then
  fail "tag $RELEASE_TAG does not match the version of typst.toml ($version)"
fi

rm -rf "$out"
mkdir -p "$out"
for f in $files; do
  [ -e "$f" ] || fail "$f is missing"
  mkdir -p "$out/$(dirname "$f")"
  cp -R "$f" "$out/$f"
done
find "$out" -name .DS_Store -delete

# Every import of the package itself must use the published name and this version: a deck created from the template
# has to compile untouched, and the README is what people copy from.
if grep -rn "@local/" "$out" --include='*.typ' --include='*.md' >&2; then
  fail "the files above import from @local; published files must use @preview/$name:$version"
fi
stale=$(grep -rnoE "@preview/$name:[0-9]+\.[0-9]+\.[0-9]+" "$out" --include='*.typ' --include='*.md' \
  | grep -v ":@preview/$name:$version\$" || true)
if [ -n "$stale" ]; then
  echo "$stale" >&2
  fail "the references above do not point to version $version"
fi

echo "$out"
