#import "../template.typ": *
#show: chapter

= Quick start <quick-start>

A deck imports Touying and the theme, applies `ufac-theme` and usually starts with the cover:

```typ
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac:0.1.0": *
```

#slide-example("cover")

`typst init @preview/touying-ufac:0.1.0` creates a deck from the package template, and `example/main.typ` shows the
elements of the syntax in a short deck. From here on, every example shows the source on the left and the result on
the right: a real slide when the feature belongs to the slide (headers, pills, continuations), otherwise the content
alone, laid out by the same rules as in a deck.

== The information of the deck

`config-info` is Touying's; the theme reads these fields:

#table(
  columns: (auto, 1fr),
  table.header([Field], [Where it appears]),
  [`subject`], [first line of the cover (large, white) and left side of the footer],
  [`subtitle`], [second line of the cover, in yellow],
  [`title`], [third line of the cover, in white],
  [`author`], [top right of the cover and right side of the footer],
  [`subject-code`], [before the subject in the footer: "CODE · SUBJECT"],
  [`counter-prefix`], [prefix of the exercise and example numbers: `[1.]` gives "Exercise 1.N", `none` gives "Exercise N"],
)

== The theme and the cover

#reference("ufac", "ufac-theme", "title-slide")

== Language

The theme speaks Portuguese by default (`lang: "pt-br"`): Exercício, Exemplo, Parte. `lang: "en"` or `"es"` switches
the text language and those three names, and each name can still be overridden.

#slide-example("lang", pages: (1, 2))

== Dependencies <dependencies>

#let sources = ("lib.typ", "ufac.typ", "components.typ", "utils.typ").map(f => read("../../src/" + f)).join()
#let found = sources.matches(regex("@preview/([a-z0-9-]+):([0-9.]+)")).map(m => m.captures).dedup().sorted()
#let roles = (
  touying: [the slide engine; the deck imports it too, with the same version],
  codly: [code blocks; its functions are re-exported by the theme],
  linguify: [localized names (Exercise, Example, Part)],
)

The versions below are read from the sources of the package, so this table cannot go stale. All of them are the
latest releases at the time of writing and are fetched automatically by Typst.

#table(
  columns: (auto, auto, 1fr),
  table.header([Package], [Version], [Role]),
  ..found.map(((name, version)) => (
    link("https://typst.app/universe/package/" + name, raw(name)), raw(version), roles.at(name, default: []),
  )).flatten(),
)

#let tidy-version = read("../template.typ").match(regex("@preview/tidy:([0-9.]+)")).captures.first()

Besides the packages, the theme needs *Typst #package.compiler or later* and the font *New Computer Modern Sans*
installed on the system (it is not bundled with Typst, unlike *New Computer Modern Math*, used for the equations). Building this manual also takes
#link("https://typst.app/universe/package/tidy")[tidy] #tidy-version, and the test suite runs on
#link("https://typst-community.github.io/tytanic/")[Tytanic] 0.4.1.
