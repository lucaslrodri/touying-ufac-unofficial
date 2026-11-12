/// Synopsis: code blocks through codly 2 (`ufac-theme(codly: codly)`): the same look as without codly, the console in the gray box of the output too, plus codly's file name, highlights, range and diff; `code-languages` adds a language.
#import "@preview/touying:0.7.4": *
#import "../../../src/lib.typ": *
#import "@preview/codly:2.0.0" as codly
#import "../../common.typ": test-info
#show: ufac-theme.with(lang: "en", codly: codly, code-languages: (zig: (name: "Zig", icon: none)), test-info)

== Code through codly 2
The same look as without codly: the box, the numbers, the language pill and the output in gray.
```python
def mean(values):
    return sum(values) / len(values)
```
#cols[
  ```text
  8.333333333333334
  ```
][
  ```console
  $ python mean.py
  ```
]
A language added with `code-languages` (no icon):
```zig
pub fn main() void {}
```

== codly's own features
#codly.new(
  ```python
  def mean(values):
      total = sum(values)
      return total / len(values)
  ```,
  file: "mean.py",
  highlights: (
    (line: 2, start: 13, end: 25, tag: [sum]),
    (line: 3, start: 12, end: 31, fill: colors.quaternary),
  ),
)
#codly.new(raw("-return total / 2\n+return total / len(values)", lang: "diff-py", block: true))
#[
  #show: codly.set_(range: (2, 3))
  ```python
  import math
  x = math.sqrt(2)
  y = x + 1
  print(y)
  ```
]
