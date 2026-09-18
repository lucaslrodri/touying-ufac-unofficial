// Body of the `elements/highlight` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Highlight (`highlight`): 5 colors
#[
#set text(size: .8em)
#table(columns: (auto, 1fr), [Syntax], [Result],
  [`==text==` or `#highlight[..]` (secondary-lighter)], [Text with the ==default highlight== in yellow and #highlight[with *bold* inside]],
  [`#highlight(fill: colors.primary-lighter)[..]`], [Text with #highlight(fill: colors.primary-lighter)[blue highlight]],
  [`#highlight(fill: colors.tertiary-lighter)[..]`], [Text with #highlight(fill: colors.tertiary-lighter)[red highlight]],
  [`#highlight(fill: colors.quaternary-lighter)[..]`], [Text with #highlight(fill: colors.quaternary-lighter)[green highlight]],
  [`#highlight(fill: colors.neutral-lighter)[..]`], [Text with #highlight(fill: colors.neutral-lighter)[gray highlight]],
)
#v(.3em)
Combined with bold: #highlight(fill: colors.quaternary-lighter)[#quaternary[correct]], #highlight(fill: colors.tertiary-lighter)[#tertiary[wrong]], #highlight(fill: colors.primary-lighter)[~~important~~].
`==x==` only takes plain text and cannot open the line (it would become a heading); `x == y` in prose is not a highlight: x == y; in `raw` it stays literal: `==x==`. Inside `emph-box`, `==highlight==` uses `color.lighten(80%)`; an explicit `fill:` wins:
#emph-box(color: colors.primary)[Blue box with ==light-blue highlight== and #highlight(fill: colors.quaternary-lighter)[explicit green fill].]
]
