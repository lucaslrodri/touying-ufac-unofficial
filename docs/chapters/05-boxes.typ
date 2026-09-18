#import "../template.typ": *
#show: chapter

= Boxes and quotes <boxes>

== Emphasis boxes

#reference("components", "emph-box")

```example
#emph-box[A definition, in the primary color.]

#emph-box(color: colors.tertiary, title: [Problem])[
  The gradient *vanishes* and ~stalls~.

  -> the arrow is red too
]
```

== The box shorthand

A paragraph whose lines start with `>` is a box in the primary color; a first line `> == Title` gives the title.

```example
> A box without title, with *bold* and $x^2$.

> == Definition
> A box with a title.
> The second line flows on.
```

#emph-box(color: colors.secondary, title: [Limits of the shorthand])[
  Only inline content fits: lists and code blocks need `#emph-box`, and `>` before a block equation is an `eq-box`.
  A loose `>` at the start of a paragraph is read as a box: write `$a > b$`, or escape it (@escapes).
]

== Equation boxes

#reference("components", "eq-box")

#emph-box(color: colors.secondary, title: [Why the dollar signs inside])[
  A content block inside an equation is markup, not math: `#eq-box[x = 2]` would be the upright text "x=2", and an
  underscore or an asterisk in it would not even parse. `eq-box` refuses such a body with a hint. `> $x$`, with an
  inline equation, is an ordinary box: the shorthand takes a block equation.
]

== Quotations

#reference("components", "quote-box")

```example
"All models are wrong"
"but some are useful"

A sentence with a "quotation" inside.

#quote(attribution: [George Box])[
  All models are wrong.
]
```
