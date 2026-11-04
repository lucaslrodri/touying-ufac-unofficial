// Body of the `sections/explicit-slides` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *
== Explicit slides: `#slide`, `#empty-slide`
`#slide[..]` creates a theme slide without a new `==` (header = current title); `#slide(composer: (1fr, 2fr))[..][..]` splits it into columns; `#empty-slide[..]` is Touying's own, without header nor footer (the theme's is gone in 0.3.0).

#slide[
  Explicit slide with the same header.
]

#slide(composer: (1fr, 2fr))[
  1fr column via `#slide(composer:)`.
][
  2fr column. The header still shows "Explicit slides".
]

#empty-slide[
  #align(center + horizon)[`#empty-slide[..]` of Touying: no header, no footer.]
]

== A label of 0.2.0 <empty-slide>
`<empty-slide>` was a slide of the theme in 0.2.0; it is now an ordinary label, so this is an ordinary slide, with its header and its footer.
