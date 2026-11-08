// error: Unsupported mark
// A `#pause` inside a box with a badge: the box is a `layout`, which Touying's marks do not go through.
#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en")

== Pause in a badge box
#emph-box(title: [Title])[Visible. #pause Covered.]
