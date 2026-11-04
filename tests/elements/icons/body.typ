// Body of the `elements/icons` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Icons of the theme (`#icon`)
#[
#set text(size: .8em)
#demo[
```typst
#icon("tip") A role, #icon("warning", color: colors.tertiary)
a coloured one and the 0.2.0 names of the shipped Octicons:
#icon("alert") #icon("light-bulb") #icon("pencil") #icon("beaker").

Size (`size:`): #icon("info", size: .8em) #icon("info")
#icon("info", size: 1.5em) #icon("info", size: 2em) on the line.

-> #icon("note") list item with an icon

#emph-box(color: colors.quaternary, title: [#icon("tip") Tip])[
  Without `color:` the icon follows the context:
  #icon("example") green here, white in the title.
]
```
]
]
An unknown name is a compile error that says how to get the icon (checked in `tests/unit/api`).

---

=== Every icon the theme ships (`theme-icons`)
#[
#set text(size: .8em)
#grid(columns: (1fr,) * 8, row-gutter: .7em, align: center + top,
  ..theme-icons.keys().map(n => [#icon(n, size: 1.4em)\ #text(size: .55em, fill: colors.neutral-dark, n)]))
]
The logos of `python`, `bash` and `matlab` keep their colours; the other icons, the Typst logo included, take the colour of the context.

== Icons of a collection the deck provides (`provide-icons`)
#provide-icons(octicons)
#[
#set text(size: .8em)
#demo[
```typst
#icon("octicon:rocket-16") A collection given with
`provide-icons`, by `"collection:name"`:
#icon("octicon:star-16", color: colors.secondary)
#icon("octicon:check-circle-16", color: colors.quaternary)
#icon("octicon:mark-github-16", size: 1.5em)
```
]
]
#[
#set text(size: .8em)
#let names = (
  "link", "question", "check-circle", "x-circle", "stop", "book", "mortar-board", "telescope",
  "graph", "table", "code", "cpu", "database", "gear", "tools", "bug",
  "zap", "rocket", "star", "heart", "trophy", "flame", "clock", "calendar",
  "globe", "search", "comment", "people", "megaphone", "download", "play", "sync",
)
#grid(columns: (1fr,) * 8, row-gutter: .7em, align: center + top,
  ..names.map(n => [#icon("octicon:" + n + "-16", size: 1.4em)\ #text(size: .55em, fill: colors.neutral-dark, n)]))
]

== Icon in the `==` title #icon("octicon:star-16") and in a box header
#emph-box(title: [#icon("warning") Warning])[#icon("octicon:zap-16") Blue icon in the body, white in the title; in the slide header, blue.]
