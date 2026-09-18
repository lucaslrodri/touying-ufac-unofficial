// Body of the `new/emph-box` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Emphasis box: `#emph-box` and `> `
#[
#set text(size: .8em)
#demo[
```typst
#emph-box(color: colors.quaternary, title: [Advantages])[
  Body with *bold* and ==highlight== in the box color.

  - marker in the color
    - level 2
]
#emph-box(color: colors.tertiary)[No title, border only.]
```
]
#demo[
```typst
> == Title (always primary)
> Body with *bold*, ==highlight== and $x^2$.
> The second line flows in the same paragraph.

> No title, border only.
```
]
]

== Emphasis box: colors and content
#[
#set text(size: .8em)
#cols[
  #emph-box(color: colors.primary, title: [primary])[Definition; *bold*, ==highlight==, `raw`.

  -> arrow in the color]
][
  #emph-box(color: colors.secondary, title: [secondary])[Remark; *bold*, ==highlight==, `raw`.

  -> arrow in the color]
][
  #emph-box(color: colors.tertiary, title: [tertiary])[Problem; *bold*, ==highlight==, `raw`.

  -> arrow in the color]
]
#cols[
  #emph-box(color: colors.quaternary, title: [quaternary])[Advantage; *bold*, ==highlight==, `raw`.

  -> arrow in the color]
][
  #emph-box(color: colors.neutral-dark, title: [neutral-dark])[Neutral; *bold*, ==highlight==, `raw`.

  -> arrow in the color]
][
  #emph-box(color: colors.quaternary)[
    Overriding inside the box:
    #arrows(color: colors.primary)[
    -> `#arrows(color: colors.primary)`
    ]
    #highlight(fill: colors.tertiary-lighter)[`#highlight(fill:)`] and #alert[`#alert`] keep their color.
  ]
]
]
