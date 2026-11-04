// Body of the `elements/logo` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== The UFAC logo (`#_ufac-logo-image`)
#demo[
```typst
Blue and yellow, as in the footer
(`0.64em` high): #_ufac-logo-image()

#_ufac-logo-image(height: 1.6em)

#let blue = box.with(
  fill: colors.primary, inset: .5em)
#blue(_ufac-logo-image(height: 1.6em,
  color: white))
#blue(_ufac-logo-image(height: 1.6em,
  color: white, shield: white))

White lettering (the cover); all white.
```
]
