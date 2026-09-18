// Body of the `elements/figures` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Figures
#[
#set text(size: .8em)
#cols[
  `#figure(image(..), caption: [..])`, caption without "Figure N:":
  #figure(placeholder(width: 100%, height: 6em, label: [figure]), caption: [Figure caption, body only])
][
  Typical layout `#grid(columns: (1fr, 1fr), align: horizon, gutter: 1.2em)` with box + figure:
  #grid(columns: (1fr, 1fr), align: horizon, gutter: 1.2em,
    emph-box(color: colors.primary)[Definition next to the figure.],
    placeholder(width: 100%, height: 5em, stroke: none, label: [figure]))
][
  `#image("../../logo.svg", width: 70%)` (real image; the file is a yellow test square):
  #image("../../logo.svg", width: 70%)
]
]
