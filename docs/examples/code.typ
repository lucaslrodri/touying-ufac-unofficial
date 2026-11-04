#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  title: [Ocean Science],
  short-title: [OCE110],
  subtitle: [Tides and waves],
  short-subtitle: [Unit III],
  author: [Prof. Author Name],
))
// --- example ---
== Code blocks

```python
def scale(grams, people, serves=4):
    return grams * people / serves
```

```text
375.0
```

```bash
typst compile slides.typ
```
