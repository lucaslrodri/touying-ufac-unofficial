#import "../template.typ": *
#show: chapter

= Colors and logo <colors>

Five families of seven tones. The light tones serve as fills of highlights and boxes, the dark ones as text on white.

#let families = ("primary", "secondary", "tertiary", "quaternary", "neutral")
#let tones = ("darkest", "darker", "dark", "", "light", "lighter", "lightest")
#let key(family, tone) = if tone == "" { family } else { family + "-" + tone }
#let swatch(c) = {
  let ink = if c.luma().components().first() > 60% { black } else { white }
  block(width: 100%, height: 2.4em, fill: c, radius: .25em, stroke: .5pt + luma(210),
    align(center + horizon, text(size: .7em, fill: ink, upper(c.to-hex()))))
}

#grid(
  columns: (auto,) + (1fr,) * 7, gutter: .35em, align: center + horizon,
  [], ..tones.map(t => text(size: .8em, if t == "" { [base] } else { raw("-" + t) })),
  ..families.map(f => (align(left, raw(f)), ..tones.map(t => swatch(colors.at(key(f, t)))))).flatten(),
)

The tones are derived from the base in RGB: `darken(75%)`, `darken(55%)`, `darken(30%)`, the base, `lighten(30%)`,
`lighten(60%)` and `lighten(85%)`. The neutral family follows Touying's default instead, from black to white.

```example
#highlight(fill: colors.tertiary-lighter)[red fill]
and #text(fill: colors.primary-dark)[dark blue text].
```

#reference("constants", "colors", "ufac-logo")
