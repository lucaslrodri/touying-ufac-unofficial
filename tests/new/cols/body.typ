// Body of the `new/cols` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Columns: `#cols`
#[
#set text(size: .8em)
#demo(columns: (1fr, 1.4fr))[
```typst
#cols(divider: true)[
  -> shorthand in a column
][
  > box in a column
][
  "quote in a column"
]
#cols(columns: (1fr, 2fr), gutter: 2em)[
  *1fr*
][
  *2fr* with `gutter: 2em`, no divider
]
```
]
]
