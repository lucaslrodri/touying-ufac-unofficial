// Body of the `elements/enum` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Numbered lists (`+`)
#[
#set text(size: .9em)
#cols(divider: true)[
  Default: `1.`, `a)` and `i.`, blue and *bold*:
  + first level
    + second level
      + third level
      + another item
    + another item
  + another item

  Explicit numbers and `#enum(start: 3)`:
  1. one
  2. two
  #enum(start: 3)[three][four]
][
  `#set enum(numbering: "a)")`: `a)`, `i.` and `1.`, also blue:
  #[
  #set enum(numbering: "a)")
  + first level
    + second level
      + third level
  ]

  `#enum(numbering: "a)")[..][..]`:
  #enum(numbering: "a)")[alpha][beta]

  Mixing `+` and `-`:
  + step one
    - detail
    - another detail
  + step two
]
]
