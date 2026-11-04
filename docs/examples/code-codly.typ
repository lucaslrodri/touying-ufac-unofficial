#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#import "@preview/codly:2.0.0" as codly
#show: ufac-theme.with(lang: "en", codly: codly, config-info(
  title: [Training and evaluation], subtitle: [Units III and IV], author: [Prof. Author Name],
  subject: [Neural Networks], subject-code: [PPGEE016],
))

== Code blocks through codly 2

#codly.new(
  ```python
  def step(w, grad, lr=0.1):
      return w - lr * grad
  ```,
  file: "train.py",
  highlights: ((line: 2, start: 12, end: 24, tag: [update]),),
)

```text
w = 0.25
```
