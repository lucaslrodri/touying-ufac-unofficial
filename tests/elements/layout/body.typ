// Body of the `elements/layout` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Layout: `#grid`, `#side-by-side`, `#v`
#[
#set text(size: .85em)
`#grid(columns: (1fr, 1fr), align: horizon, gutter: 1.2em)` is the most common layout of the real slides; `#side-by-side` (Touying) and `#cols` (theme, see New elements) are shortcuts:
#grid(columns: (1fr, 1fr), align: horizon, gutter: 1.2em,
  emph-box(color: colors.quaternary, title: [Advantages])[
    - simple
    - fast
  ],
  [Text next to the box, vertically centered by `align: horizon`, with *black bold* outside the box.])
#v(.6em)
#side-by-side[Column A (`#side-by-side`, no divider)][Column B][Column C]
]
