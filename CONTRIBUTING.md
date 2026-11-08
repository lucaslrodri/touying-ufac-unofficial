# Development

This file describes the development environment of the theme: the tools, the folders, the tests, the build scripts and the release. To use the theme, see the [README](README.md) and the [manual](docs/manual.pdf).

## Tools

| Tool | What for |
| ---- | -------- |
| [Typst](https://typst.app/) ≥ 0.15 | compiling the decks, the manual and the README pictures (the package itself works from the `compiler` of `typst.toml`) |
| [Tytanic](https://typst-community.github.io/tytanic/) 0.4.1 (`tt`) | the test suite ([tests/README.md](tests/README.md)) |
| [gotpm](https://github.com/npikall/gotpm) 0.8.0 | installing the package into Typst's package directory, and publishing it |
| [tinymist](https://github.com/Myriad-Dreamin/tinymist) CLI (optional) | `scripts/lock.sh`, for the editor |
| [act](https://github.com/nektos/act) and Docker (optional) | running the GitHub workflows on this machine, and the checker of typst/packages |

[tidy](https://typst.app/universe/package/tidy) 0.4.3 (the manual and the tests of the doc-comments) is fetched by Typst. gotpm runs on macOS, Linux and Windows (`brew install npikall/tap/gotpm`, or the installer in its README). The scripts are POSIX `sh`: they run on macOS and on the Linux runners of the CI; on Windows they need WSL or Git Bash, and nothing was tried there.

## Setup

```sh
git clone https://github.com/lucaslrodri/touying-ufac-unofficial
cd touying-ufac-unofficial
gotpm install -e                      # @local/touying-ufac-unofficial:<version>, a link to this copy (editable)
sh scripts/fonts.sh                   # only if New Computer Modern (Sans and Math) is not installed: downloads it into fonts/
git config core.hooksPath .githooks   # runs scripts/local.sh before every commit
sh scripts/lock.sh                    # tinymist.lock: the editor opens the body of a test through its test.typ
```

During development the package is installed under `@local`, never under `@preview` in the system's package directory: a `@preview/touying-ufac-unofficial:<version>` installed there would take the place of the version published on Typst Universe in every deck of the machine. With `gotpm install -e`, `#import "@local/touying-ufac-unofficial:<version>": *` resolves to the working copy in `typst compile` and in the editor. `gotpm font` cannot install the font of the theme: it only fetches the families of Google Fonts, which does not have New Computer Modern.

The template and the example decks import the package by its published name, `@preview/touying-ufac-unofficial:0.3.0`, as an author does (Typst Universe requires it of the template: a deck created from it must compile untouched). `scripts/with-preview.sh <command>` links that name to the working copy only while the command runs, in a temporary package directory, the one of `TYPST_PACKAGE_PATH`, which `typst`, `tt` and gotpm read; the scripts that compile those decks (`local.sh`, `examples.sh`, `readme.sh`) run themselves through it. A new version needs no step of its own. The tests import the theme by the path of its entrypoint, `src/lib.typ`, so the editor opens them as they are; only the tests that include the template and the example decks (`deck/`, Tytanic's `@template`) need the published name.

`scripts/lock.sh` writes `tinymist.lock` (ignored by git) for the editor. With `tinymist.projectResolution: "lockDatabase"`, set in `.vscode/settings.json`, tinymist compiles a file that a test includes (its `body.typ`) inside that test, where the theme is applied; alone, a body with `@exercise-…` references fails. The routes go to tinymist's cache, so the lock is written once per clone and again when a test is added. The manual is a single file, `docs/manual.typ`, so every file of `docs/` opens by itself.

### Local installation with gotpm

gotpm installs the package into Typst's package directory, with the same commands on macOS, Linux and Windows:

```sh
gotpm install -e                                                   # @local/touying-ufac-unofficial:<version>, a link to this copy (editable)
gotpm install                                                      # the same, a copy with only the published files
gotpm install -r github.com/lucaslrodri/touying-ufac-unofficial    # the highest v<version> tag on GitHub, without this copy (-t HEAD: main)
```

The development version of the next release is the `develop` branch. Clone it (`git clone -b develop https://github.com/lucaslrodri/touying-ufac-unofficial`) and run `gotpm install` in the new folder: it installs as `@local/touying-ufac-unofficial:<version>`, the `version` of its `typst.toml` (`-f` replaces an older installation of the same version).

The copy holds what goes to Typst Universe: the `exclude` of `typst.toml` and what `.gitignore` ignores are left out, as in `scripts/package.sh`. `-f` replaces an installation of the same version (of a link, only the link is deleted), `gotpm list` shows what is installed and `gotpm uninstall touying-ufac-unofficial -V <version>` removes it. Then `#import "@local/touying-ufac-unofficial:<version>": *` works before the version reaches Typst Universe. Two cautions:

- the template imports `@preview/touying-ufac-unofficial:<version>`, and gotpm does not rewrite that import. A deck created with `typst init @local/touying-ufac-unofficial:<version>` compiles with the version on Typst Universe; to use the local copy, change `@preview` to `@local` in it;
- on Windows, `-e` (a symbolic link) needs Developer Mode or an administrator terminal; without them, use `gotpm install`, which copies.

## Folders

| Folder | Contents |
| ------ | -------- |
| [`src/`](src/) | the theme; `src/lib.typ` is the entrypoint |
| [`assets/`](assets/) | the UFAC logo, the icons the theme ships and the syntax theme of the code blocks |
| [`template/`](template/) | the starting deck of `typst init` |
| [`example/`](example/) | the example deck of the README and one deck for each kind of work |
| [`docs/`](docs/) | the manual (`manual.typ`, `template.typ`, `build.sh`, the decks of its examples in `examples/`), the PDFs of the example decks (`decks/`) and the pictures of the README (`readme/`) |
| [`tests/`](tests/) | the Tytanic suite ([tests/README.md](tests/README.md)) |
| [`scripts/`](scripts/) | the scripts for linking, building and checking |
| [`skills/`](skills/) | a skill for AI agents that writes decks with the theme, in Portuguese, in two modes: lectures and academic works ([skills/README.md](skills/README.md)) |

Only `typst.toml`, `LICENSE`, `LICENSE-MIT-0`, `README.md`, `thumbnail.png`, `src/`, `assets/` and `template/` go to Typst Universe: the `exclude` of `typst.toml` and `scripts/package.sh` leave out the rest, and `sh scripts/package.sh --check` refuses a difference between the two.

## Tests

```sh
sh scripts/local.sh                                        # everything tests.yml checks, in seconds
sh scripts/with-preview.sh tt run --use-system-fonts       # only the Tytanic suite, with the installed fonts
sh scripts/with-preview.sh tt run --font-path fonts        # the same, as the CI runs it: fonts/ plus the fonts embedded in Tytanic
sh scripts/with-preview.sh tt update --use-system-fonts sections/exercises   # writes the references of a case again
sh scripts/errors.sh                                       # tests/errors/*.typ must fail to compile, each with the message of its first line
sh scripts/report.sh                                       # tests/report.pdf: every test with its synopsis, its code and its reference pages (git-ignored)
```

Run directly, `tt` needs the name `@preview/touying-ufac-unofficial:<version>` in the tests that include the decks: `scripts/with-preview.sh` gives it, or, for a whole terminal session, `export TYPST_PACKAGE_PATH=$(mktemp -d) && gotpm install -e -n preview`. In VS Code, the tasks of `.vscode/tasks.json` and the Testing view run `tt` through the script.

`scripts/local.sh` runs the suite, compiles the template and the example deck, assembles the package and checks that gotpm would publish the same files, compiles the templates of the skill (`skills/touying-ufac/templates/`), checks the error messages and checks that the README is in step with the decks; it needs gotpm. It is the pre-commit hook (`.githooks/pre-commit`): a failure aborts the commit, and `git commit --no-verify` skips it. It uses `fonts/` as the CI does when that folder exists, else the installed fonts, and it checks the working copy, not only what is staged. Git does not version its configuration, so the `git config` line above is needed once in every clone.

## Building

| Script | What it builds |
| ------ | -------------- |
| `sh docs/build.sh` | the pictures of the examples of the manual and `docs/manual.pdf` |
| `sh scripts/readme.sh` | the sections *Basic usage* and *Example* of the README, `docs/readme/*.png` and `thumbnail.png`, from the decks |
| `sh scripts/examples.sh` | `docs/decks/*.pdf`: the PDF of every example deck (`example/*.typ`), linked from the README |
| `sh scripts/icons.sh` | `assets/icons/*.json`: the icons the theme ships, from the Iconify API (only when the list changes) |
| `sh scripts/package.sh` | the files published on Typst Universe, in `dist/preview/touying-ufac-unofficial/<version>/` |

The manual, the PDFs of the example decks, the pictures of the README and `thumbnail.png` are committed: after changing the theme, run `sh docs/build.sh`, `sh scripts/examples.sh` and `sh scripts/readme.sh`.

### README

The sections *Basic usage* and *Example* of the README are generated: `scripts/readme.sh` (VS Code task **readme: update from the decks**) copies `template/main.typ` and `example/main.typ` between the `<!-- template:begin -->`/`<!-- example:begin -->` markers and renders each deck into one picture, `docs/readme/<deck>.png` (the layout is `docs/readme/sheet.typ`); it also renders `thumbnail.png`, the cover of the template, which Typst Universe wants as the template is initialized. Edit the decks, never those blocks; `scripts/local.sh` refuses a commit whose README does not match the decks (`sh scripts/readme.sh --check`) and warns when a picture is out of date.

`docs/` and `example/` are not published, so the README reaches the pictures, the manual and the example decks by their GitHub URL, never by a relative path, which would be broken on Typst Universe. The URL is the one of the tag `v<version>` (built from `repository` and `version` of `typst.toml`), as `typst/packages` recommends: the README of a version keeps the manual and the pictures of that version. On GitHub they therefore show only once the tag is pushed. `scripts/package.sh` refuses a README with a link into the repository that is not at the tag of the version.

## Workflows

| Workflow | Trigger | What it does |
| --- | --- | --- |
| [tests.yml](.github/workflows/tests.yml) | push to `main`, pull request, manual | the Tytanic suite (Tytanic 0.4.1 = Typst 0.15); the template and the example deck with the `compiler` version of `typst.toml`, and the error messages |
| [release.yml](.github/workflows/release.yml) | tag `v*` | the tests, the manual, the package, `gotpm publish` to the fork of `typst/packages`, the GitHub release |

Tytanic is installed by the official [setup-tytanic](https://github.com/typst-community/setup-tytanic) action, Typst by [setup-typst](https://github.com/typst-community/setup-typst) and gotpm by its installer, at a pinned version. A failed test run uploads `ref/`, `out/` and `diff/` as the artifact `tytanic-results`.

### Running them locally with act

[act](https://github.com/nektos/act) runs the workflows in Docker (`brew install act`, Docker running). `.actrc` sets the runner image. The first run is slow: it downloads the image and clones the actions.

```sh
act push -W .github/workflows/tests.yml                                  # both test jobs
act push -W .github/workflows/tests.yml -j tytanic                       # one job
act push -W .github/workflows/release.yml -e .github/act/release.json    # dry run of a release
```

`.github/act/release.json` is the event of a tag push; edit its `ref` to the tag being rehearsed (it must be `v<version of typst.toml>`, the gate checks it). Under act, `gotpm publish` runs with `--local`: it commits the package to its clone of the fork and does not push. The steps that leave the machine are skipped (`if: ${{ !env.ACT }}`): the artifact uploads (act 0.2.89 does not support `upload-artifact` v6+) and the GitHub release; the checker of typst/packages is skipped too, as the container cannot share its folders with Docker.

## New version

All of the publishing goes through gotpm: `gotpm bump` changes the version, and `gotpm publish` takes the package to Typst Universe. For a new version:

1. `gotpm bump patch` (or `minor`, `major`, or the version, as `gotpm bump 0.4.0`) changes the version of `typst.toml`, and only it;
2. rename the section `### Unreleased` of the changelog in the README to `### <version>`, and change the version in the imports (`@preview/touying-ufac-unofficial:<version>`) of the template, the example decks, the manual and the README, and in the links of the README (`blob/v<version>/`, `raw.githubusercontent.com/…/v<version>/`): `git grep -n "touying-ufac-unofficial:<previous version>\|v<previous version>"` shows the places;
3. run `gotpm install -e` (the `@local` of the new version), `sh docs/build.sh`, `sh scripts/examples.sh` and `sh scripts/readme.sh`;
4. commit, then create and push the tag: `git tag v<version> && git push origin main v<version>`. The tag makes the links and the pictures of the README work and starts [`release.yml`](.github/workflows/release.yml), which runs the tests, publishes through `gotpm publish` (below) and creates the GitHub release, with the zip of the package and the manual;
5. open the pull request `touying-ufac-unofficial:<version>` in typst/packages from the link in the summary of the workflow, with the checklist of its template filled in (`gotpm publish` suggests another title, `release: touying-ufac-unofficial <version>`; typst/packages asks for `touying-ufac-unofficial:<version>`). After the merge, the version is on [Typst Universe](https://typst.app/universe/) within minutes. Published versions are immutable: a fix is a new version.

While the pull request is not merged, the version can be redone: delete the release and the tag (`gh release delete v<version> --cleanup-tag` and `git tag -d v<version>`), fix, commit and create the tag again. `gotpm publish` adds a commit to the branch already on the fork, and the pull request updates by itself; with no change in the package, it fails, since there is nothing to publish.

## Publishing

`gotpm publish` does, in this order:

1. it runs the gate of `typst.toml` (`[tool.gotpm] pre-publish-hook`), `sh scripts/package.sh --check`, and stops when it fails. The gate assembles the published files in `dist/` and checks:
   - the tag (`RELEASE_TAG`, on the CI) against the version of `typst.toml`;
   - the imports of the package and the links of the README at the right version;
   - the files against the ones gotpm publishes (the `exclude` of `typst.toml`);
   - a deck created by `typst init` from the published files only, which has to compile;
   - the version not yet on Typst Universe;
   - the checker of the pull requests of typst/packages (`ghcr.io/typst/package-check`), through Docker. Without Docker, the checker is skipped with a note; on the CI, it is required;
2. it clones the fork of typst/packages (the `fork.url` of gotpm's configuration) and creates the branch `touying-ufac-unofficial-<version>` from the `main` of the fork;
3. it copies the package into `packages/preview/touying-ufac-unofficial/<version>/`, with the same rules as the installation: the `exclude` of `typst.toml` and what `.gitignore` ignores are left out;
4. it commits and pushes the branch to the fork. The pull request is left to the author.

The fork and the token are set up once:

1. a fork of [typst/packages](https://github.com/typst/packages). If the fork is not called `<owner>/packages`, set the repository variable `REGISTRY_FORK` (Settings > Secrets and variables > Actions > Variables) to `owner/name`;
2. a fine-grained personal access token restricted to the fork, with **Contents: read and write**, saved as the repository secret `REGISTRY_TOKEN`. `release.yml` hands it to the git of `gotpm publish`. If the push is refused for lack of the `workflow` scope, sync the `main` branch of the fork with upstream.

To publish from this machine, without the CI, set up the fork once and run gotpm at the root of the clean working copy, at the tag of the version:

```sh
gotpm config set fork.url https://github.com/<owner>/packages
gotpm publish --local -m "touying-ufac-unofficial:<version>"   # rehearsal: the commit in the clone of the fork, no push
gotpm publish -m "touying-ufac-unofficial:<version>"           # the push, with the git credentials of this machine
```

The clone of the fork stays in gotpm's data directory (`gotpm locate` shows the directories). `gotpm publish` copies the working copy, not the tag: publish from a clean tree, at the tag. The GitHub release, in that case, is made by hand: `sh scripts/package.sh dist` and `gh release create v<version> --verify-tag --generate-notes` with the zip and the manual.
