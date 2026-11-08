// Body of the `sections/pause-numbering` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Numbered items split by a `#pause`
+ first
#pause
+ second, still 2. under the veil
#pause
+ third

== Numbered items split in an example <example>
+ first step
#pause
+ second step, still 2. under the veil, in the color of the example

== Numbered items split inside a box
#emph-box[
  + first
  #pause
  + second, still 2. under the veil
]

== Numbered items split in a callout
#tip[
  + first
  #pause
  + second, still 2. under the veil
]

== Numbered items split in the last column
#cols[
  The first column, visible.
][
  + first
  #pause
  + second, still 2. under the veil
]

== Numbered items split inside an item
- outer item
  + first
  #pause
  + second, still 2. under the veil

== A `#meanwhile` after a split
+ first
#pause
+ second, veiled on the first step
#meanwhile
+ third, shown on the first step, still 3.

#set enum(start: 3)
== A numbered list after `#set enum(start: 3)` outside the slide
+ three
+ four

== Numbered items split after a `set` rule
#set enum(numbering: "a)", start: 1)
+ first
#pause
+ second, still b) under the veil
