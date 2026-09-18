// Body of the `elements/code` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Code: inline `raw` and blocks (codly)
Inline in the text: `x = 1`, `#emph-box[...]`, `typst compile slides.typ`, in a gray chip at 0.85em. Blocks at 0.75em, numbered by codly, without a language header; long lines wrap with `smart-indent`:

```python
def mean(values, digits=2):
    total = 0
    for v in values:
        total += v                      # running total; long line to show the wrap with codly's smart-indent
    return round(total / len(values), digits)
```
#cols[
  Output (`text`), without numbers via `#local(number-format: none)`:
  #local(number-format: none)[
  ```text
  item 1: value 0.693
  item 2: value 0.512 ==no highlight==
  ```
  ]
][
  Highlight and language name: `#local(display-name: true, highlights: (..))`:
  #local(display-name: true, highlights: ((line: 2, fill: colors.secondary-lighter),))[
  ```python
  x = mean(values)
  y = round(x, 1)
  ```
  ]
]

---

=== Inline code in every context: pill with `code` (dark fill, light text)
In running text the chip is gray: `x = 1`, and the shorthands are off inside it: `==x==`, `> a`, `-> b`, `~~c~~`, `~d~`. In boxes, light tones of the container color (fill `-lightest`, border `-lighter`, text `-dark`):
#cols[#emph-box(color: colors.primary)[`primary`]][#emph-box(color: colors.secondary)[`secondary`]][#emph-box(color: colors.tertiary)[`tertiary`]][#emph-box(color: colors.quaternary)[`quaternary`]][#emph-box(color: colors.neutral-dark)[`neutral`]]
In the `==` header (next slide) and in the `=` title the chip uses the `primary` tones.
#cols[
  `#local(range: (2, 3))` shows only a slice:
  #local(range: (2, 3))[
  ```python
  import math
  x = math.sqrt(2)
  y = x + 1
  print(y)
  ```
  ]
][
  Another configured language (`bash`) and `#no-codly[..]` (plain Typst raw):
  ```bash
  typst compile slides.typ
  ```
  #no-codly[
  ```typst
  #let x = 1
  ```
  ]
]

== Title `==` with `raw` in the header: chip in the `primary` tones
```typst
// The shorthands are off in a raw block: ==x==, > a, -> b, ~~c~~, ~d~, "quote"
```
