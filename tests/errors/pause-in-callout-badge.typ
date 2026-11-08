// error: Unsupported mark
// A `#pause` inside a callout with `style: "badge"` stops: the badge style is an `emph-box` with a title. The callout in the default style takes it.
#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en")

== Pause in a callout with a badge
#tip(style: "badge")[
  - first item
  #pause
  - second item
]
