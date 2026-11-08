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

== Inside a box and a callout
#cols[
  #emph-box[
    - in a box

    #pause

    - veiled
  ]
][
  #tip[
    - in a callout

    #pause

    - veiled
  ]
]

== Inside a block with a `set` rule
#[
  #set text(size: .9em)
  - first item

  #pause

  - second item, veiled
]
