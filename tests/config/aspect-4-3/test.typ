/// Synopsis: `aspect-ratio: "4-3"` (cover, section slide, header, footer and columns on 4:3 paper).
#import "../../common.typ": *
#show: ufac-theme.with(aspect-ratio: "4-3", info)

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
