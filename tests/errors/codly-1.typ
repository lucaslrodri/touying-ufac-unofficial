// error: codly is the module of codly 2
// codly 1, which 0.2.0 imported, is refused with the import of codly 2.
#import "@preview/codly:1.3.0" as codly
#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en", codly: codly)

== Code
```python
x = 1
```
