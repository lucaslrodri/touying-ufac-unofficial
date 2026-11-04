#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  subject: [Ocean Science],
  subject-code: [OCE110],
  unit-title: [Tides and waves],
  unit: [Unit III],
  author: [Prof. Author Name],
))
// --- example ---
== Header with `raw` and *bold*

=== *bold*, ~~alert~~, `raw`, #icon("tip")

#emph-box(
  title: [*bold*, ~~alert~~, `raw`],
)[
  In the body: *bold*, `raw`
  and #icon("tip").
]
