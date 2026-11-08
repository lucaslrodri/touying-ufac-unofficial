// Body of the `sections/pause-in-boxes` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== A `#pause` inside a box without a title
#emph-box(color: colors.quaternary)[
  Visible line of the box.

  #pause

  Covered line, under a veil on the box.
]

== A `#pause` inside a quote box and a column
#cols[
  #quote-box[Visible quotation. #pause Covered rest of it.]
][
  Second column, shown at the second step.

  #pause

  Shown at the third step.
]
