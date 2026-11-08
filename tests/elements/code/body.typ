// Body of the `elements/code` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Code: inline `raw` and blocks
Inline in the text: `x = 1`, `#emph-box[...]`, `typst compile slides.typ`, in a gray chip at 0.85em. Blocks at 0.75em in the box of the theme: a light fill, a bar on the left, square corners, the line numbers and the language in a pill; long lines wrap:

```python
def mean(values, digits=2):
    total = 0
    for v in values:
        total += v                      # running total; a long line to show how a line of code wraps in the box
    return round(total / len(values), digits)
```
#cols[
  The output of a program (`text`): the gray box, without numbers:
  ```text
  item 1: value 0.693
  item 2: value 0.512 ==no highlight==
  ```
][
  The other languages of the theme (`bash`, `matlab`):
  ```bash
  typst compile slides.typ
  ```
  ```matlab
  x = linspace(0, 1, 5);
  ```
]

---

=== Inline code in every context: pill with `code` (dark fill, light text)
In running text the chip is gray: `x = 1`, and the shorthands are off inside it: `==x==`, `> a`, `-> b`, `~~c~~`, `~d~`. In boxes, light tones of the container color (fill `-lightest`, a light border, text `-dark`):
#cols[#emph-box(color: colors.primary)[`primary`]][#emph-box(color: colors.secondary)[`secondary`]][#emph-box(color: colors.tertiary)[`tertiary`]][#emph-box(color: colors.quaternary)[`quaternary`]][#emph-box(color: colors.neutral-dark)[`neutral`]]
In the `==` header (next slide) and in the `=` title the chip uses the `primary` tones.

== Code blocks in a box, and unknown languages
#cols[
  A block inside a colored box keeps its look:
  #emph-box(color: colors.tertiary, title: [Box])[
    ```python
    y = x + 1
    ```
  ]
  The shell, in `bash` or `sh` ("Shell"), has a colored terminal:
  ```sh
  ls *.typ
  ```
][
  A language the theme does not know: no pill.
  ```rust
  fn main() { println!("hi"); }
  ```
  A block without a language:
  ```
  plain block
  ```
]

== Title `==` with `raw` in the header: chip in the `primary` tones
```typst
// The shorthands are off in a raw block: ==x==, > a, -> b, ~~c~~, ~d~, "quote"
#let x = 1
```

== A first line as wide as the block
The first line leaves the width of the pill free and wraps before it, in code and in the output of a program:
```python
total = sum(value * weight for value, weight in zip(values, weights)) / sum(weights)
print(total)
```
```text
the first line of a long output of a program, as wide as the box, wraps before the pill
the second line has the whole width of the box, as the others
```
