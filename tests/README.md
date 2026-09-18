# Regression tests (Tytanic)

Visual test suite of the theme, run with [Tytanic](https://typst-community.github.io/tytanic/) (`tt`, installed with
`brew install tytanic`; validated version: 0.4.1). The project root is the repository root (Tytanic finds it through
`typst.toml`, which also holds the `[tool.tytanic]` settings). The tests import the package by its published name
(`@preview/touying-ufac:0.1.0`), like the template and the example do, so that name must resolve to this working copy:
run `sh scripts/link.sh` once (it symlinks the repository into Typst's local package directory, under `preview`).

```sh
tt run --use-system-fonts                        # compiles everything and compares with tests/*/*/ref/*.png
tt run --use-system-fonts sections/              # one group only (accepts test-set expressions: `tt list -e 'name(~elements)'`)
tt update --use-system-fonts sections/exercises  # rewrites the references after an intentional change
tt new --use-system-fonts new/my-case            # creates tests/new/my-case/test.typ from tests/template.typ (= the starting deck), plus its ref
tt list                                          # lists the tests; `tt status` shows the summary
tt util clean                                    # removes out/ and diff/
typst compile tests/tests.typ                    # the full catalogue (same bodies); also `typst compile tests.typ` from tests/
```

`--use-system-fonts` is mandatory: the theme uses New Computer Modern Sans, which is not bundled with Typst (tytanic
0.4.1 does not accept that option in the manifest). Without the flag every test fails with a substituted font. Where
the fonts are not installed, and in the CI (`.github/workflows/tests.yml`, see [CONTRIBUTING.md](../CONTRIBUTING.md)),
`sh scripts/fonts.sh` downloads them into `fonts/` and the flag becomes `--font-path fonts`.

## Structure: one body, two uses

- `<group>/<case>/body.typ`: the markup of the case (slides), starting with `#import "../../common.typ": *` (no `#show`).
- `<group>/<case>/test.typ`: 3 lines, preamble + `#show: setup` + `#include "body.typ"`. This is what Tytanic compiles.
- `tests.typ` (this folder): catalogue that includes **all** the `body.typ` files in the order of the parts (cover, Style guide,
  Elements, New elements, Sections, edge cases and the section-slide variants last). The catalogue and the suite cannot
  diverge: they are the same body. Every path in the suite is **relative** (`../../common.typ`, `../../logo.svg`), so the
  Typst root does not matter: Tytanic uses the repository root, the `typst` CLI the folder of the file, tinymist the workspace
  folder; absolute `/tests/…` paths broke in the editor whenever the workspace was another folder. To check nothing was left out:
  `diff <(grep -o '"\./[^"]*body.typ"' tests/tests.typ | tr -d '"' | sed 's|^\./|tests/|' | sort) <(find tests -name body.typ | sort)`
  (only `config/*` and `unit/*` may show up: they are not part of the catalogue).
- `common.typ`: imports the package, defines `setup` (theme with `lang: "en"` + fixed `config-info`; the default
  language, pt-br, is covered by `config/lang-default`) and the `demo` helper (code on the left, the same text evaluated
  on the right).
- `template.typ`: model for `tt new`, a **relative symlink** to `../template/main.typ` (the package's starting deck).
  Tytanic compiles the template *in place* to render the initial reference and then copies it verbatim into
  `tests/<group>/<case>/test.typ`, so the template cannot contain relative paths (`../../common.typ` resolves from `tests/`
  in one step and from `tests/<group>/<case>/` in the other; `#include "../template/main.typ"` breaks after the copy). The
  starting deck only has package imports, so it works in both places, and the symlink keeps it equal to the real template.
  For a new case: `tt new`, replace the copied deck by the 3-line `test.typ` (preamble + `#show: setup` + `#include
  "body.typ"`), write the markup in `body.typ`, `tt update` the reference and add the matching `#include` to `tests.typ`.
- `placeholder.typ` and `logo.svg`: test assets (provisional figure helper and a yellow square used as a real image).
- `deck/`: the two decks shipped with the package, `template/main.typ` and `example/main.typ`, included as they are
  (`#include "../../../template/main.typ"`) and compared pixel by pixel; Tytanic's own `@template` only compiles.
- `config/`: theme parameters (names, `part-name`, footers, `counter-prefix`, including `counter-prefix: none`), `aspect-ratio: "4-3"` and `lang`
  (`lang-default`, `lang-en`, `lang-es`, sharing `config/lang-body.typ`); they have
  their own preamble, so they are not part of the catalogue. `unit/api`: compile only, assertions about the API
  (`assert`, `assert-panic`, `catch`). `unit/docstrings`: compile only; it feeds every module of `src/` to
  [tidy](https://typst.app/universe/package/tidy), private definitions included, so every `///` doc-comment must be
  valid markup and every doc-comment test (`#test(..)`) must pass.
- `docs/manual`: compile only; it includes `docs/manual.typ`, so a broken chapter, live example or doc-comment fails
  the suite. It needs the slide pictures in `docs/examples/out/` (`sh docs/build.sh` renders them; they are committed).
- `ref/N.png`: one image per page, at 96 ppi (`[tool.tytanic.default]` in `typst.toml`); `max-delta = 1`,
  `max-deviations = 0`. `out/` and `diff/` are temporary (tytanic creates their `.gitignore`).

When a test fails, compare `out/N.png` with `ref/N.png` and look at `diff/N.png`; if the change is intentional,
`tt update --use-system-fonts <test>`.

## VS Code

The suite can be driven from the **Testing** view (beaker icon) with the
[Command Line Test Adapter](https://marketplace.visualstudio.com/items?itemName=jvcdk-at-github.vscode-commandline-test-adapter)
extension (`code --install-extension jvcdk-at-github.vscode-commandline-test-adapter`; validated version: 1.3.0). There is
no Tytanic extension and `tt run` has no JSON output, so the adapter builds the tree from `tt list --json` and decides
pass/fail by the exit code of one `tt run` per test (0 = passed, 1 = failed). Open the **repository root** as the
workspace: the configuration is versioned in [.vscode/](../.vscode) (`settings.json`, `tt-discover.sh`, `tasks.json`; every
other file of that folder is git-ignored).

What you get: one node per group (`guide`, `elements`, `new`, `sections`, `config`, `unit`) with one leaf per test, plus
`@template`; run one test, a group or everything; a leaf points to its `test.typ`; a failure shows the last 20 lines of the
`tt` output (`Page 1 had different dimensions`, a compile error with file:line, …). Leaves run in parallel, which is safe
(each test writes only its own `out/` and `diff/`); the whole suite takes about 1.5 s. Discovery runs again when a
`test.typ` or `typst.toml` changes.

Caveats, verified against the extension's source:

- `cpuCount` must be a JSON **string** (`"4"`). With a number the extension throws *after* the run was created, the run never
  ends and the Testing view spins forever, with nothing in its log (`Developer: Reload Window` clears it).
- The discovery output is a bare JSON array; a group node has `command: ""` (it is skipped and its children are queued).
- Commands are spawned without a shell, so the script emits the absolute path of `tt`; it needs `jq` (bundled with macOS 15+)
  and the executable bit (`chmod +x .vscode/tt-discover.sh`).

Without the extension, `.vscode/tasks.json` still gives `Tasks: Run Test Task` (whole suite in a terminal; Typst compile
errors go to the Problems panel with file:line links, thanks to `--diagnostic-format short`; image mismatches only appear in
the terminal) and `tt: update references` (asks for a test id).
