#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#import "@preview/codly:2.0.0" as codly
#show: ufac-theme.with(lang: "en", codly: codly, config-info(
  subject: [Ocean Science],
  subject-code: [OCE110],
  unit-title: [Tides and waves],
  unit: [Unit III],
  author: [Prof. Author Name],
))

== Code blocks through codly 2

#codly.new(
  ```python
  def scale(grams, people, serves=4):
      return grams * people / serves
  ```,
  file: "recipe.py",
  highlights: ((line: 2, start: 12, end: 26, tag: [per person]),),
)

```text
375.0
```
