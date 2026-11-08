// error: Unsupported mark
// A `#pause` inside an `emph-box` with a title (its badge): the box is a `layout`, which Touying's marks do not go through.
#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en")

== Pause in a box with a title
#emph-box(title: [Title])[Visible. #pause Covered.]
