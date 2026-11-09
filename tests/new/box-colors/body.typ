// Body of the `new/box-colors` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== The color of the box: `emph-box`
#let sample = [
  === Subtitle
  *Bold*, ~~alert~~, ==highlight==, `code` and #link("https://www.ufac.br")[a link] #icon("tip")
  - an item
  -> an arrow
]
#cols(columns: (1fr,) * 3)[
  #emph-box(sample)
][
  #emph-box(color: colors.tertiary, sample)
][
  #emph-box(color: colors.quaternary, title: [With a title], sample)
]

== The color of the box: callouts
#cols[
  #callout("caution")[=== Subtitle
    *Bold* and `code` in red.]
  #callout("tip")[=== Subtitle
    *Bold* and `code` in green.]
][
  #callout("remark")[=== Subtitle
    *Bold* and `code` in blue.]
  #callout("note", style: "badge")[=== Subtitle
    *Bold* and `code` in gray.]
]

== Boxes inside boxes <example>
=== The subtitle of the example, in green
*Bold* in green. Each box inside it keeps its color, and its subtitles follow it:
#cols[
  #emph-box(title: [Definition])[
    ==== In blue
    *Bold* in blue.
  ]
][
  #callout("caution")[==== In red
    *Bold* in red.]
]

== Boxes inside boxes <exercise>
=== The subtitle of the exercise, in red
#emph-box(color: colors.quaternary)[
  ==== In green, inside a green box
  #callout("remark")[==== In blue, inside a callout inside the box]
]

== Light cells of a table
#table(columns: 3, table.header([Plain], [Light tone], [Another]),
  [*bold* and `code`],
  table.cell(fill: colors.quaternary-lighter)[*bold* and `code`],
  table.cell(fill: colors.tertiary-lightest)[*bold* and `code`],
)
