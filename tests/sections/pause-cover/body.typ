// Body of the `sections/pause-cover` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *
== Covered theme elements
Visible line with *bold*, #alert[alert], `chip` and ==highlight==.

#pause

Covered running text: *bold*, _italic_, #alert[alert], `chip`, ==highlight==, ~underline~, ~~alert~~ and $x^2$.

- list item
  - sub-item

-> arrow item

=== Subtitle declared after the pause

> == Box title
> Box body with *bold* text.

"A covered quotation."

== Covered block that overflows the page
The covered list below does not fit on this page. A block that breaks across pages cannot be veiled by one rectangle, so it is hidden (same space) until it is revealed.

#pause

#for i in range(1, 16) [- Covered item #i]

== Covered `#quote`
Typst's `#quote` without `block: true`, which the theme shows as a quote box, is veiled after `#pause` too.

#pause

#quote(attribution: [Author])[A covered quotation, written as `#quote`.]

== Covered shorthands in running text
A paragraph covered from the middle #pause keeps ~underline~, ~~alert~~ and Fig.~1 as revealed, on a line of the same length.
