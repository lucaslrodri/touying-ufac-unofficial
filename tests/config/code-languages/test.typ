/// Synopsis: `ufac-theme(code-languages:)` without codly: a new language with an icon given as content, `python` renamed with its icon kept, `matlab` renamed without `icon:` (no icon), and a `text` entry, which is ignored: the output keeps its pill, "Output" in the language of the deck.
#import "../../common.typ": *
#show: ufac-theme.with(
  lang: "en",
  test-info,
  code-languages: (
    rust: (name: "Rust", icon: text(weight: "bold", fill: rgb("#CE422B"))[R]),
    python: (name: "Python 3", icon: "python"),
    matlab: (name: "MATLAB"),
    text: (name: "Log", icon: "tip"),
  ),
)

== Languages of the deck

```rust
fn main() { println!("{}", 375.0); }
```

```python
print(375.0)
```

```matlab
disp(375.0)
```

```text
375.0
```
