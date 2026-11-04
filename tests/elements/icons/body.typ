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
The logos of `python` and `matlab` keep their colours; the other icons, the Typst logo included, take the colour of the context.

== Icons of the iconify package, used directly
#iconify.provide-icons(octicons)
#[
#set text(size: .8em)
#demo[
```typst
#let ic = iconify.icon.with(height: 1em)
#ic("octicon:rocket-16") It takes the colour of the text:
#text(fill: colors.secondary, ic("octicon:star-16"))
#text(fill: colors.quaternary, ic("octicon:zap-16"))
#ic("octicon:mark-github-16", height: 1.5em)
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
  ..names.map(n => [#iconify.icon("octicon:" + n + "-16", height: 1.4em)\ #text(size: .55em, fill: colors.neutral-dark, n)]))
]

== Icons of iconify in the boxes and callouts
#cols[
  #emph-box(icon: iconify.icon("octicon:rocket-16", height: 1em), title: [Launch])[
    `emph-box(icon: iconify.icon(..))`: white on the badge.
  ]
  #callout("note", style: "badge", icon: iconify.icon("octicon:book-16", height: 1em))[The badge style.]
][
  #callout("tip", icon: iconify.icon("octicon:rocket-16", height: 1em))[In a callout, the icon takes its colour.]
  #warning(icon: iconify.icon("octicon:flame-16", height: 1em))[The shorthands take it too.]
]

== Icon in the `==` title #icon("tip") and in a box header
#emph-box(title: [#icon("warning") Warning])[#icon("info") Blue icon in the body, white in the title; in the slide header, blue.]
