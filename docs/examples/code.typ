#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  subject: [Ocean Science],
  subject-code: [OCE110],
  unit-title: [Tides and waves],
  unit: [Unit III],
  author: [Prof. Author Name],
))
// --- example ---
== Code blocks

```python
def scale(grams, people, n=4):
    return grams * people / n
```

```text
375.0
```

```bash
typst compile slides.typ
```
