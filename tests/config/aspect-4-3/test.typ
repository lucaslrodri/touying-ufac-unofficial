/// Synopsis: `aspect-ratio: "4-3"` (cover, section slide, header, footer, columns, the box of an exercise and the closing slide on 4:3 paper), in the default language (Portuguese) with English text.
#import "../../common.typ": *
#show: ufac-theme.with(aspect-ratio: "4-3", test-info)

#title-slide()

= Section in 4:3
#placeholder()

== Slide in 4:3
=== Subtitle
#cols(divider: true)[
  > box in a column
][
  -> arrow in a column
]
"Quotation in 4:3"

== An exercise in 4:3 <exercise>
The box of the item on the 4:3 page.

#answer
The answer.

#ending-slide()
