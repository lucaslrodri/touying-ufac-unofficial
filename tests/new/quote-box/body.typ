// Body of the `new/quote-box` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Quotation: `#quote-box` and `"whole line"`
#[
#set text(size: .85em)
#demo[
```typst
#quote-box[Quotation with the default yellow bar.]
#quote-box(color: colors.primary)[With an explicit `color:`.]
```
]
#demo[
```typst
"A quotation on its own: whole line between quotes."
```
]
]

---

=== Several quoted lines: one box per line, alternating colors
#[
#set text(size: .85em)
#demo[
```typst
"Item 1 (secondary)"
"Item 2 (primary)"
"Item 3 (quaternary)"
"Item 4 (tertiary)"
```
]
]
