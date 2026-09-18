// Body of the `elements/icons` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Icons (`#icon`)
#[
#set text(size: .8em)
#demo[
```typst
#icon("link") Link, #icon("light-bulb", color: colors.secondary) idea,
#icon("alert", color: colors.tertiary) warning and
#icon("check-circle", color: colors.quaternary) right.

Size (`size:`): #icon("star", size: .8em) #icon("star")
#icon("star", size: 1.5em) #icon("star", size: 2em) on the text line.

-> #icon("book") list item with an icon

#emph-box(color: colors.quaternary, title: [#icon("info") Tip])[
  Without `color:` the icon follows the context:
  #icon("check") green here, white in the title.
]
```
]
]

---

=== #icon("apps") Sample of the names (Octicons, 320 icons in `icons.typ`)
#[
#set text(size: .8em)
#let names = (
  "link", "light-bulb", "alert", "info", "question", "check-circle", "x-circle", "stop",
  "book", "mortar-board", "pencil", "beaker", "telescope", "graph", "table", "code",
  "terminal", "cpu", "database", "gear", "tools", "bug", "zap", "rocket",
  "star", "heart", "trophy", "flame", "clock", "calendar", "mail", "globe",
  "search", "comment", "people", "megaphone", "download", "upload", "play", "sync",
)
#grid(columns: (1fr,) * 8, row-gutter: .7em, align: center + top,
  ..names.map(n => [#icon(n, size: 1.4em)\ #text(size: .55em, fill: colors.neutral-dark, n)]))
An unknown name is a compile error: `unknown icon` (checked in `tests/unit/api`).
]

== Icon in the `==` title #icon("star") and in a box header
#emph-box(title: [#icon("alert") Warning])[#icon("zap") Blue icon in the body, white in the title; in the slide header, blue.]
