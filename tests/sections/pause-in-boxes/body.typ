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

== A `#pause` between the lines of a `>` box
> First line of the box.
#pause
> Second line of the box.

After the box: only this waits for the second step.

== Quotations separated by blank lines
"First quotation."

#pause

"Second quotation, revealed on the second step."

== `#item-by-item`
#item-by-item[
  - first item
  - second item
]
