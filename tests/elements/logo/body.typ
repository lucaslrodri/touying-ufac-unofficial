// Body of the `elements/logo` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== The UFAC logo (`#info("logo")` and `ufac-logo`)
#demo[
```typst
As in the footer: #info("logo")

#box(fill: colors.primary, inset: .5em,
  info("logo", height: 1.6em, white: true))

Outside a deck, as in a handout:
#image(bytes(ufac-logo), height: 1.6em)
```
]
