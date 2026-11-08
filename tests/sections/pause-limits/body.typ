// Body of the `sections/pause-limits` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Limit: a `#pause` between the lines of a `>` box
> First line of the box.
#pause
> Second line of the box.

After the box: only this waits for the second step.

== Limit: quotations on consecutive lines
"First quotation."
#pause
"Second quotation."

== Way out: quotations separated by blank lines
"First quotation."

#pause

"Second quotation, revealed on the second step."

== Limit: `#item-by-item`
#item-by-item[
  - first item
  - second item
]

== Limit: numbered items split inside a box
#emph-box[
  + first
  #pause
  + second, 1. under the veil
]

== Way out: the numbers written
#emph-box[
  1. first
  #pause
  2. second, 2. under the veil
]
