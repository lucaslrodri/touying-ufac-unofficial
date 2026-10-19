// Body of the `elements/tables` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Tables
#[
#set text(size: .8em)
#cols[
  Blue header with white text and formulas; blue rules; `inset: 0.5em`; `align:` per column:
  #table(columns: (auto, 1fr, 1fr), align: (left, center, center),
    [Function], [$f(x)$], [$f'(x)$],
    [Quadratic], [$x^2$], [$2x$],
    [Exponential], [$e^x$], [$e^x$],
    [Sine], [$sin x$], [$cos x$],
  )
][
  `#figure(table(..), caption: [..])`: caption with the body only, no "Table 1:":
  #figure(table(columns: 3, [Year], [Value], [Change], [2024], [1.20], [3 %], [2025], [1.35], [12 %]), caption: [Yearly series (table)])
  `table.header(..)` is row 0 as well:
  #table(columns: 2, table.header([A], [B]), [1], [2])
]
]

== Tables: code chips
Code chips follow the background, as in pills and boxes: inverted in the header, in the family's tones in a filled cell:
#table(columns: 3,
  [], [`mean(N, 2)` →], [*Bold*],
  [Plain cell], [`x(1)`], [*bold*],
  table.cell(fill: colors.secondary-lighter)[`mean(N)` ↓], table.cell(fill: colors.secondary-lighter)[*bold*],
  table.cell(fill: colors.quaternary-lightest)[`ok`],
)
