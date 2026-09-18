// Body of the `sections/explicit-slides` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *
== Explicit slides: `#slide`, `#empty-slide`
`#slide[..]` creates a theme slide without a new `==` (header = current title); `#slide(composer: (1fr, 2fr))[..][..]` splits it into columns; `#empty-slide[..]` has no header but keeps the footer.

#slide[
  Explicit slide with the same header.
]

#slide(composer: (1fr, 2fr))[
  1fr column via `#slide(composer:)`.
][
  2fr column. The header still shows "Explicit slides".
]

#empty-slide[
  #align(center + horizon)[`#empty-slide[..]`: no header, with footer.]
]
