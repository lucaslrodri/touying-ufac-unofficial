// Body of the `sections/pause-blank-lines` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Between list items
- first item

#pause

- second item, veiled whole

== Between numbered items
+ first

#pause

+ second, veiled whole, still 2.

== In an exercise <exercise>
- first item

#pause

- second item, veiled in the color of the exercise

== Inside a box
#emph-box[
  - in a box

  #pause

  - veiled in the color of the box
]

== Inside a callout
#tip[
  - in a callout

  #pause

  - veiled in the color of the callout
]

== Inside a column
#cols[
  The first column, visible.
][
  - in the last column

  #pause

  - veiled
]

== Centered
#align(center)[
  - centered

  #pause

  - veiled
]

== Inside a block with a `set` rule
#[
  #set text(size: .9em)
  - first item

  #pause

  - second item, veiled
]

== Two marks in a row
- first item

#pause

#pause

- third step only

== Inside an item
- outer item
  - inner, first

  #pause

  - inner, veiled

== A box with a label keeps it
#show <labelled-box>: set text(fill: red)
#block[
  - first item, in red

  #pause

  - second item, in red, veiled
] <labelled-box>

== After a `set` rule of the slide (last: the rule reaches the slides after it)
#set text(size: .9em)
- first item

#pause

- second item, veiled
