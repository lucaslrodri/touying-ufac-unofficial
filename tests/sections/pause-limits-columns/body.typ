// Body of the `sections/pause-limits-columns` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

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

== Way out: `#uncover("2-")` around the next column
#cols[
  - first item
  #pause
  - second item
  #pause
  - third item
][
  #uncover("2-")[
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

== Way out: `#uncover("2-")` around the next columns
#cols[
  - first item
  #pause
  - second item
][
  #uncover("2-")[
    -> an arrow list,
    -> veiled whole
  ]
][
  #uncover("2-")[
    - a list,
    - veiled whole
  ]
]
