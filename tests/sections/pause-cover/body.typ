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

== Covered inside a callout
#tip[Visible `chip` and ==high==. #pause Covered `chip`, ==highlight==, #icon("note") and ~under~.]

== Covered in a question <question>
Visible `chip` and ==high==.

#pause

Covered `chip`, ==highlight==, #icon("note") and ~under~ in the box of a question.

== Covered boxes with a badge, tags, logos and framed equations
Visible #tag[tag] and #eq-box[$x = 2$].

#pause

#emph-box(title: [Box title])[Body of a box with a title.]

#emph-box(title: [With an icon], icon: "tip")[Body of a box with an icon.]

Covered #tag[tag], #tag(size: 1em)[big tag], #eq-box[$x = 2$] and #info("logo", height: 2em) in running text.
