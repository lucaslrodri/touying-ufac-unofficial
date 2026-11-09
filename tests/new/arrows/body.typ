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

== `#arrow-list`, the function form of `->`
#cols(divider: true)[
  -> the shorthand, with *bold*
  -> another item with $x -> y$
][
  #arrow-list[
    - the function, with *bold*
    - another item with $x -> y$
  ]
]
#emph-box(color: colors.quaternary)[
  #arrow-list[
    - green arrow, as `->` in the box
    - `#arrow-list(color: ..)` gives another one:
  ]
  #arrow-list(color: colors.tertiary)[- red arrow]
]

== `#arrow-list` with a `#pause`
#arrow-list[
  - first, on every step
  #pause
  - second, from the second step
]

== `#arrow-list` at the start of a callout
#cols[
  #tip[-> the shorthand
  -> on the line under the title]
][
  #tip[#arrow-list[
    - the function
    - under the title, as `->`
  ]]
][
  #tip[- a `-` list
  - under the title too]
]
