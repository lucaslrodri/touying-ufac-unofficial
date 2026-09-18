// Body of the `new/arrows` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Arrows: `#arrows` and `->`
#[
#set text(size: .85em)
#demo[
```typst
-> default blue arrow with *bold*
-> another item with $x -> y$

#arrows(color: colors.quaternary)[
-> `#arrows(color: colors.quaternary)`
-> another item
]
```
]
#cols(divider: true)[
  #arrows(color: colors.secondary)[
  -> secondary
  ]
  #arrows(color: colors.tertiary)[
  -> tertiary
  ]
][
  #arrows(color: colors.neutral-darkest)[
  -> neutral-darkest
  ]
  In `emph-box` the arrow takes the box color:
  #emph-box(color: colors.quaternary)[
  -> green arrow
  ]
]
]
