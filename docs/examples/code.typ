#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  title: [Training and evaluation], subtitle: [Units III and IV], author: [Prof. Author Name],
  subject: [Neural Networks], subject-code: [PPGEE016],
))
// --- example ---
== Code blocks

```python
def step(w, grad, lr=0.1):
    return w - lr * grad
```

#local(display-name: true, highlights: ((line: 2, fill: colors.secondary-lighter),))[
  ```python
  for epoch in range(10):
      w = step(w, grad(w))
  ```
]

#local(number-format: none)[
  ```bash
  typst compile slides.typ
  ```
]
