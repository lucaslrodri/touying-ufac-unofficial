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

== Way out: the `#pause` in a paragraph of its own
Visible line.

#pause

Covered line, veiled.
#rect(width: 4em, height: 1.5em, fill: colors.primary)

== Limit: a `#pause` in a column, and the next column
#cols[
  - first item
  #pause
  - second item
][
  #tip[A callout in the next column, veiled in bands.]
  #rect(width: 4em, height: 1.5em, fill: colors.primary)
  #image("../../logo.svg", height: 1.5em)
]

== Way out: `#uncover` around the next column
#cols[
  - first item
  #pause
  - second item
][
  #uncover(2)[
    #tip[A callout in the next column, veiled whole.]
    #rect(width: 4em, height: 1.5em, fill: colors.primary)
    #image("../../logo.svg", height: 1.5em)
  ]
]

== Limit: a `#pause` in a column, and a list alone in the next ones
#cols[
  - first item
  #pause
  - second item
][
  -> an arrow list alone,
  -> as text on the first step
][
  - a list alone,
  - its markers not veiled
]

== Way out: `#uncover` around the next columns
#cols[
  - first item
  #pause
  - second item
][
  #uncover(2)[
    -> an arrow list,
    -> veiled whole
  ]
][
  #uncover(2)[
    - a list,
    - veiled whole
  ]
]

== Limit: `#uncover` around an item right after another
- first item
#uncover(2)[- second item, shown on the first step]

== Way out: a `#pause` between the items
- first item
#pause
- second item, veiled

== Limit: a list right inside `#align(center)`
#align(center)[
  - first item
  #pause
  - second item, its marker in the middle on the first step
]

== Way out: the list centered as a block, with its text on the left
#align(center, block(align(left)[
  - first item
  #pause
  - second item, its marker in place
]))

== Way out: the first number written
3. three, written
#pause
+ four

#set enum(start: 3)
== Limit: a split list after `#set enum(start: 3)` (last: the rule reaches the slides after it)
+ first, numbered 1.
#pause
+ second, numbered 2.
