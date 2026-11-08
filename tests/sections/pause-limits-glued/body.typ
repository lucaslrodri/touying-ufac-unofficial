// Body of the `sections/pause-limits-glued` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Limit: `#item-by-item`
#item-by-item[
  - first item
  - second item
]

== Limit: a `#speaker-note` glued to the items
- first item
#pause
- second item, shown on the first step
#speaker-note[A note.]

== Way out: the note after a blank line
- first item
#pause
- second item, veiled

#speaker-note[A note.]

== Limit: a covered line glued to a visible one, then a shape
Visible line.
#pause
Covered line, shown on the first step.
#rect(width: 4em, height: 1.5em, fill: colors.primary)

== Limit: a covered line glued to a visible one, then an image
Visible line.
#pause
Covered line, shown on the first step.
#image("../../logo.svg", height: 1.5em)

== Way out: the `#pause` in a paragraph of its own
Visible line.

#pause

Covered line, veiled.
#rect(width: 4em, height: 1.5em, fill: colors.primary)
#image("../../logo.svg", height: 1.5em)

== Limit: a `#pause` and an `#uncover` in one paragraph
First. #pause Second. #uncover(3)[Third.] Fourth.

== Way out: one paragraph each
First.

#pause

Second.

#uncover(3)[Third.]

Fourth.
