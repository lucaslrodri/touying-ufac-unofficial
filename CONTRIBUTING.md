# Development

The repository root is the package: `typst.toml`, `src/`, `assets/`, `template/`. The rest is development only and is
not published: the example deck in `example/`, `tests/` ([Tytanic](https://typst-community.github.io/tytanic/) suite, see
[tests/README.md](tests/README.md)), the sources of the manual in `docs/`, `scripts/`, `.githooks/`, `.github/` and
`.vscode/`.

Besides the dependencies of the README, development needs [Tytanic](https://typst-community.github.io/tytanic/) 0.4.1
(`tt`, the test suite) and [tidy](https://typst.app/universe/package/tidy) 0.4.3 (manual and doc-comment tests; fetched
automatically).

The package was developed on macOS. The scripts are POSIX `sh` and also run on the Linux runners of the CI, but nothing
was tried on Windows, where they would need WSL or Git Bash and probably adjustments (`scripts/link.sh` only knows
Typst's package directory of macOS and Linux). Paths such as `~/Library/...` below are the macOS ones.

## Setup

```sh
sh scripts/link.sh                    # links @preview/touying-ufac-unofficial:<version> here (`--remove` undoes it)
sh scripts/fonts.sh                   # only if New Computer Modern (Sans and Math) is not installed: downloads it into fonts/
git config core.hooksPath .githooks   # runs scripts/local.sh before every commit
```

The template, the example, the tests and the README import the package as
`@preview/touying-ufac-unofficial:<version>`, which Typst Universe requires from a template (a fresh deck must compile untouched). `scripts/link.sh` symlinks the
repository into Typst's local package directory under the `preview` namespace, where Typst looks before downloading,
so that name resolves to the working copy in `tt`, in `typst compile` and in the editor. It does not touch the `local`
namespace. It is run by hand, once per clone and again when the version changes; in VS Code it is the task
**typst: link the package** (Cmd+Shift+P > *Tasks: Run Task*).

```sh
tt run --use-system-fonts       # test suite, with the installed fonts
tt run --font-path fonts        # the same, as the CI runs it: fonts/ plus the fonts embedded in Tytanic
sh docs/build.sh                # docs/manual.pdf
sh scripts/package.sh           # dist/preview/touying-ufac-unofficial/<version>/: the files that go to Typst Universe
sh scripts/readme.sh            # README.md (Basic usage, Example), docs/readme/*.png and thumbnail.png from the decks
sh scripts/local.sh             # what tests.yml checks, in seconds: test suite, the two decks, packaging, README
```

`scripts/local.sh` is the pre-commit hook (`.githooks/pre-commit`): a failure aborts the commit, and
`git commit --no-verify` skips it. It uses `fonts/` as the CI does when that folder exists, else the installed fonts,
and it checks the working copy, not only what is staged. It does not link the package: when the link is missing or
points elsewhere it stops and asks for `scripts/link.sh`. Git does not version its configuration, so the `git config`
line above is needed once in every clone.

### README

The sections *Basic usage* and *Example* of the README are generated: `scripts/readme.sh` (VS Code task
**readme: update from the decks**) copies `template/main.typ` and `example/main.typ` between the
`<!-- template:begin -->`/`<!-- example:begin -->` markers and renders each deck into one picture,
`docs/readme/<deck>.png` (the layout is `docs/readme/sheet.typ`); it also renders `thumbnail.png`, the cover of the
template, which Typst Universe wants as the template is initialized. Edit the decks, never those blocks;
`scripts/local.sh` refuses a commit whose README does not match the decks (`sh scripts/readme.sh --check`) and warns
when a picture is out of date.

`docs/` and `example/` are not published, so the README reaches the pictures, the manual and the example deck by their
GitHub URL, never by a relative path, which would be broken on Typst Universe. The URL is the one of the tag `v<version>` (built from `repository` and
`version` of `typst.toml`), as `typst/packages` recommends: the README of a version keeps the manual and the pictures
of that version. On GitHub they therefore show only once the tag is pushed. `scripts/package.sh` refuses a README with a
link into the repository that is not at the tag of the version.

## Workflows

| Workflow | Trigger | What it does |
| --- | --- | --- |
| [tests.yml](.github/workflows/tests.yml) | push to `main`, pull request, manual | Tytanic suite (Tytanic 0.4.1 = Typst 0.15); compiles the two decks with the `compiler` version of `typst.toml` |
| [release.yml](.github/workflows/release.yml) | tag `v*` | tests, manual, package, checks, GitHub release, branch on the fork of `typst/packages` |

Tytanic is installed by the official [setup-tytanic](https://github.com/typst-community/setup-tytanic) action and Typst
by [setup-typst](https://github.com/typst-community/setup-typst). A failed test run uploads `ref/`, `out/` and `diff/`
as the artifact `tytanic-results`.

### Running them locally with act

[act](https://github.com/nektos/act) runs the workflows in Docker (`brew install act`, Docker running). `.actrc` sets the
runner image. The first run is slow: it downloads the image and clones the actions.

```sh
act push -W .github/workflows/tests.yml                                  # both test jobs
act push -W .github/workflows/tests.yml -j tytanic                       # one job
act push -W .github/workflows/release.yml -e .github/act/release.json    # dry run of a release
```

`.github/act/release.json` is the event of a tag push; edit its `ref` to the tag being rehearsed (it must be
`v<version of typst.toml>`, the workflow checks it). Under act the steps that leave the machine are skipped
(`if: ${{ !env.ACT }}`): the package check in Docker, the artifact uploads (act 0.2.89 does not support
`upload-artifact` v6+), the GitHub release and the push to the fork. Everything else runs, up to the commit in a clone
of `typst/packages`, whose file list is printed; `sh scripts/package.sh` gives the same files in `dist/`.

The package linter of `typst/packages` can be run by hand on the packaged files (it works offline, from the package
cache, so compile the template once before):

```sh
sh scripts/package.sh
docker run --rm -v "$PWD/dist/preview/touying-ufac-unofficial/0.1.0:/data" \
  -v "$HOME/Library/Caches/typst/packages:/.cache/typst/packages:ro" ghcr.io/typst/package-check check
```

## Releasing

One-time setup:

1. Fork [typst/packages](https://github.com/typst/packages). If the fork is not `<owner>/packages`, set the repository
   variable `REGISTRY_FORK` (Settings > Secrets and variables > Actions > Variables) to `owner/name`.
2. Create a fine-grained personal access token restricted to the fork, with **Contents: read and write**, and save it as
   the repository secret `REGISTRY_TOKEN`. If the push is refused for lack of the `workflow` scope, sync the `main`
   branch of the fork with upstream (the branch is created from the current upstream `main`, which may carry workflow
   files that the fork does not have yet).

For every version:

1. Set `version` in `typst.toml` and update every `@preview/touying-ufac-unofficial:<version>` (template, example,
   tests, README, manual): `grep -rn "touying-ufac-unofficial:" --include='*.typ' --include='*.md' .`. The links of
   the README to the manual, the license and the example deck carry the tag (`blob/v<version>/`) too. `scripts/package.sh` refuses to
   package a mismatch. Run `sh scripts/link.sh` again (the link carries the version) and `sh scripts/readme.sh` (the
   README carries the decks and the tag).
2. `tt run --use-system-fonts`, `sh docs/build.sh`, commit, and rehearse with act if the workflows changed.
3. `git tag v<version> && git push origin main v<version>`.
4. When the workflow finishes, open the link of its summary: a pull request to `typst/packages` named
   `touying-ufac-unofficial:<version>`, with the checklist of its template filled in. After the merge the version is on
   [Typst Universe](https://typst.app/universe/) within minutes. Published versions are immutable: a fix is a new version.
