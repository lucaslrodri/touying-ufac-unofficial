#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  title: [Neural Networks],
  short-title: [PPGEE016],
  subtitle: [Training and evaluation],
  short-subtitle: [Units III and IV],
  author: [Prof. Author Name],
))
// --- example ---
== Code blocks

```python
def step(w, grad, lr=0.1):
    return w - lr * grad
```

```text
w = 0.25
```

```bash
typst compile slides.typ
```
