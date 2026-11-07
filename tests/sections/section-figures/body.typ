// Body of the `sections/section-figures` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
// The frame of the figure of a section slide, 12em × 66%: an image without a size fills it, one with a size shrinks to
// it. Each image has a border (cut, if it is cropped) and a circle (an ellipse, if it is stretched).
#import "../../common.typ": *
#let shape(w, h) = image(format: "svg", bytes("<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 " + str(w) + " "
  + str(h) + "'><rect x='2' y='2' width='" + str(w - 4) + "' height='" + str(h - 4) + "' fill='#E6EDF6' stroke='#0C4DA2'"
  + " stroke-width='4'/><circle cx='" + str(w / 2) + "' cy='" + str(h / 2) + "' r='" + str(calc.min(w, h) / 2 - 12)
  + "' fill='none' stroke='#BE1E2D' stroke-width='6'/></svg>"))
#let sized(w, h, ..size) = image(..size, shape(w, h).source, format: "svg")

= A wide image without a size: 12em wide
#shape(300, 100)

= A tall image without a size: 66% of the height
#shape(100, 200)

= A square with only its height (5em)
#sized(100, 100, height: 5em)

= A wide image with only its height (6em): at most 12em wide
#sized(300, 100, height: 6em)

= A tall image with only its width (8em): at most 66% high
#sized(100, 300, width: 8em)

= Both sizes (10em × 10em): contained, not stretched
#sized(300, 100, width: 10em, height: 10em)

= A large width (15cm): scaled down whole to the frame
#sized(300, 200, width: 15cm)

= A small image with a size (3em) keeps it
#sized(100, 100, width: 3em)

= An image inside a figure, with a caption: in the frame
#figure(shape(300, 100), caption: [A caption under the figure.])

= A tall image inside a figure: the caption under it
#figure(shape(100, 220), caption: [The caption, under the image.])

= An image inside `align` and `link`: in the frame
#align(center, link("https://example.com", shape(100, 200)))

= A width relative to the room (`100%`, `50%`): against the frame
#sized(300, 100, width: 100%)

#sized(300, 100, width: 50%)

= A height relative to the room (`80%`): against the frame
#sized(100, 300, height: 80%)

= An icon in the title #icon("tip") stays inline
#shape(200, 100)

= The icons of the content keep their size
A line with #icon("tip") an icon.
#block(width: 11em)[
  A line with #icon("warning") an icon.
  #tip[A callout keeps its icon.]
  #emph-box(icon: "info", title: [Box])[A badge with an icon.]
]

= A long caption wraps at the frame
#figure(shape(300, 100), caption: [A caption much longer than the image wraps at the width of the frame, and the title keeps its column.])
