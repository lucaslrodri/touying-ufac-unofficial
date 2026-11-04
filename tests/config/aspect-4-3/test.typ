/// Synopsis: `aspect-ratio: "4-3"` (cover, section slide, header, footer, columns, the box of an exercise and the closing slide on 4:3 paper), in the default language (Portuguese) with English text. The figure of the section is a tall image without a size: its frame, 66% of the height, depends on the height of the page.
#import "../../common.typ": *
#show: ufac-theme.with(aspect-ratio: "4-3", test-info)

#title-slide()

= Section in 4:3
#image(format: "svg", bytes("<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 200'><rect x='2' y='2'"
  + " width='96' height='196' fill='#E6EDF6' stroke='#0C4DA2' stroke-width='4'/><circle cx='50' cy='100' r='38'"
  + " fill='none' stroke='#BE1E2D' stroke-width='6'/></svg>"))

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
