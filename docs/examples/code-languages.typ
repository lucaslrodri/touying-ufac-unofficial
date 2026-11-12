#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#import "@preview/codly-languages:0.1.10": codly-languages
#show: ufac-theme.with(
  lang: "en",
  code-languages: codly-languages + (
    spice: (name: "SPICE", icon: none),
  ),
  config-info(
    subject: [Ocean Science],
    subject-code: [OCE110],
    unit-title: [Tides and waves],
    unit: [Unit III],
    author: [Prof. Author Name],
  ),
)

// --- example ---
== More languages

```julia
tide(t) = 1.2 * cos(2π * t / 12.4)
```

```spice
R1 in out 1k
```

```python
print("the pill of the theme")
```
