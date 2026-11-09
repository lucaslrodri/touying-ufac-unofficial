// Body of the `new/light-colors` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== A yellow box
#emph-box(color: colors.secondary, title: [A badge with ~~alert~~ and ==highlight==])[
  === A subtitle with ~~alert~~, ==highlight==, `raw` and #icon("tip")
  The body: *bold*, ~~alert~~, ==highlight==, `raw` and #link("https://example.com")[a link].

  -> an arrow
]
#callout("tip", style: "badge", color: colors.secondary)[A yellow callout with a badge, *bold* and ~~alert~~.]

#exercise-slide(title: [A yellow exercise], color: colors.secondary)[
  The numbers and the markers in the dark yellow, as the bold:
  + *first* item
    + nested item
  + second item
  - a bullet
]

== A yellow box with lists and a bar callout
#cols[
  #emph-box(color: colors.secondary)[
    - a bullet with *bold*
    -> an arrow
    + a number
  ]
][
  #tip(color: colors.secondary)[
    A yellow callout in the bar style, with *bold* and ~~alert~~:
    - a bullet
    + a number
  ]
]

== Other light colors
#cols[
  #emph-box(color: colors.primary-lighter, title: [Primary lighter])[
    - *bold* and ~~alert~~ in `primary-dark`
  ]
][
  #note(color: colors.quaternary-light)[A light green callout, *bold* and ~~alert~~ in `quaternary-dark`.]
]
#emph-box(color: rgb("#eeeeee"), title: [Out of the palette])[*Bold* and ~~alert~~ in the color darkened by 40%.]

#exercise-slide(title: [A yellow exercise that goes on], color: colors.secondary)[
  === A subtitle with ~~alert~~
  The pill is dark yellow and the alert in it dark blue.

  #answer
  The dashed rule and the word in the dark yellow.

  ---

  The pill is repeated on the continuation.
]

#example-slide(title: [A light green example], color: colors.quaternary-light)[
  *Bold*, ~~alert~~ and the markers in `quaternary-dark`:
  + a number
  - a bullet

  #solution
  The solution in the dark tone too.
]

#exercise-slide(title: [A #secondary[yellow] word in a yellow badge], color: colors.secondary)[
  === A #quaternary[green] word in the dark yellow pill
  Tags: #tag[#secondary[yellow] and #tertiary[red] in yellow] and #tag(color: colors.quaternary-light)[#quaternary[green] in light green].

  #emph-box(color: colors.secondary, title: [#secondary[Yellow] in a yellow badge])[The words that do not read on the light pill take the blue of an alert there.]

  #table(columns: 2, table.header([Cell], [Body]), [A light cell:], table.cell(fill: colors.secondary-lighter)[#secondary[yellow] and #tertiary[red]])
]
