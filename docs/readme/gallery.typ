// Slides of the README pictures that no example deck has: scripts/readme.sh renders this deck and makes of its pages
// the pictures of "Elements": page 1 element-boxes.png, 2 element-callouts.png, 3 element-table.png, 4
// element-emphasis.png, 5 element-section.png. It is not an example, and it is not published; the other rows come
// from the decks of example/. The test of the minimum version of Typst (.github/workflows/tests.yml) compiles it too.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *

#show: ufac-theme.with(
  aspect-ratio: "16-9",
  lang: "en",
  config-info(
    subject: [Subject name],
    subject-code: [CODE or Department],
    unit-title: [Title of the teaching unit],
    unit: [Teaching unit I],
    author: [Prof. Dr. Your Name],
  ),
)

== Boxes

> Box without title

"A quotation in a box."

> $ x = {2, 1} $

== Callouts

#caution[`x * y` with two lists is an error.]
#tip[The up arrow recalls the last command.]
#remark[A *function* is a named block of code.]
#note[Two versions of the program differ here.]
#cols[
  #example[`len([1, 2, 3])` is 3.]
][
  #examples[Types: `int`, `str`.]
]

== A table

#table(
  columns: 3,
  table.header([Fish], [Depth (m)], [$T$ (°C)]),
  [Cod], [200], [4],
  [Tuna], [50], table.cell(fill: colors.secondary-lighter)[*18*],
)

== Emphasis

-> *bold* and _italic_
-> an ~~alert~~, in the blue of the slide
-> a ==highlight==
-> an ~underline~

= A section
#image("figure.svg")
