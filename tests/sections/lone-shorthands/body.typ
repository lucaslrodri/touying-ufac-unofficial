// Body of the `sections/lone-shorthands` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Only an arrow list
-> the shorthand alone on a slide
-> is rewritten too

== Only a box
> A box alone on a slide.

== Only quotations
"A quotation alone on a slide."
"And another one."

== An arrow list with a pause
-> first
#pause
-> second

#slide(composer: (1fr, 1fr))[
  -> in a column
  -> of `slide(composer:)`
][
  > and a box
]
