// Body of the `sections/pause-limits-boxes` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
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
