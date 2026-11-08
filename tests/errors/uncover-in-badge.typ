// error: Unsupported mark
// An `#uncover` inside an `emph-box` with a title stops as a `#pause` does: every animation of Touying, not only `#pause`.
#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en")

== Uncover in a box with a title
#emph-box(title: [Title])[Visible. #uncover("2-")[Covered.]]
