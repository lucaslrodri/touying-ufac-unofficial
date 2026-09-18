// Body of the `guide/colors` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Colors: 5 families × 7 tones
#[
#set text(size: .62em)
#let swatch(name, tone) = {
  let c = if tone == "base" { colors.at(name) } else { colors.at(name + "-" + tone) }
  let dark-text = tone in ("light", "lighter", "lightest") or (name == "secondary" and tone == "base")
  box(fill: c, width: 100%, height: 2.4em, radius: 4pt, stroke: if tone == "base" { 1pt + black } else { .5pt + colors.neutral-lighter },
    align(center + horizon, text(fill: if dark-text { black } else { white }, size: .8em, upper(c.to-hex()))))
}
#grid(columns: (auto, ..range(7).map(_ => 1fr)), column-gutter: .5em, row-gutter: .6em, align: (left + horizon, ..range(7).map(_ => center + horizon)),
  [], ..("darkest", "darker", "dark", "*base*", "light", "lighter", "lightest").map(t => text(size: .9em, fill: colors.neutral-dark, eval(t, mode: "markup"))),
  ..for name in ("primary", "secondary", "tertiary", "quaternary", "neutral") {
    (text(weight: "bold", name),) + ("darkest", "darker", "dark", "base", "light", "lighter", "lightest").map(t => swatch(name, t))
  })
#v(.4em)
Every key lives in `colors` and in `self.colors` (`config-colors`): `colors.primary-lighter`, `colors.quaternary-dark`, ...
Derived in RGB: `darken(75% / 55% / 30%)` and `lighten(30% / 60% / 85%)`; `neutral` in thirds of `#808080`.
]

== Colors: role of each family
#[
#set text(size: .8em)
#let sw(c) = box(fill: c, width: 1.4em, height: .9em, radius: 2pt, baseline: .1em)
#table(columns: (auto, auto, 1fr), [Family], [Base], [Where it appears],
  [`primary`], [#sw(colors.primary) `#0C4DA2`], [`=`/`==` titles, `===`/`====` pills, `->` arrows, `#alert`, enum numbers, tables, `>` box and 2nd quote],
  [`secondary`], [#sw(colors.secondary) `#FFBF14`], [`-` markers, `#secondary`, `==x==` highlight (`-lighter`), 1st `"quote"`],
  [`tertiary`], [#sw(colors.tertiary) `#BE1E2D`], [`#tertiary`, exercise pill, problem boxes, 4th `"quote"`],
  [`quaternary`], [#sw(colors.quaternary) `#09B081`], [`#quaternary`, example pill, advantage boxes, 3rd `"quote"`],
  [`neutral`], [#sw(colors.neutral) `#808080`], [`-darkest` = bold, italic and terms; `-lightest` = background; `-dark` = captions and secondary labels],
)
]
