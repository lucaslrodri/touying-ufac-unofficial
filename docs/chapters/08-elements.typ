#import "../template.typ": *
#import "../../src/icons.typ" as icons
#show: chapter

= Tables, figures, math, code and icons <elements>

== Tables

The header row is blue with white text, and formulas in it turn white too.

```example
#table(
  columns: 3,
  table.header([Model], [Layers], [$eta$]),
  [MLP], [3], [0.1],
  [CNN], [8], [0.01],
)
```

== Figures and math

A figure caption shows its body only, without "Figure N". Math uses New Computer Modern Math, and block equations
sit closer to the text than Typst's default. For a framed key equation, see `eq-box` in @boxes.

```example
#figure(
  rect(width: 60%, height: 3em, fill: colors.primary-lightest),
  caption: [The caption, without a number.],
)

The update rule is
$ bold(w) <- bold(w) - eta nabla E(bold(w)) $
```

== Code

Inline `raw` is the chip of @inline. Code blocks go through codly: a gray box, gray line numbers, no zebra, never
split across pages. The theme re-exports codly, and its `local` wraps codly's for per-block settings;
`#codly-range(..)` and `#no-codly[..]` work as usual. The languages with a label are `python`, `typst`, `bash` and
`text` (labelled "saída").

#slide-example("code")

#reference("components", "local")

#reference("constants", "code-languages")

== Icons

#reference("components", "icon")

```example
#emph-box(color: colors.tertiary)[
  #icon("alert") takes the box color.
]
```

The 320 names, from #link("https://primer.style/octicons/")[Octicons]:

#{
  set text(size: 6.5pt)
  set par(justify: false)
  grid(
    columns: (1fr,) * 5, row-gutter: .75em, column-gutter: .5em,
    ..icons.data.keys().sorted().map(name => [#icon(name, size: 1.5em) #h(.3em) #name]),
  )
}
