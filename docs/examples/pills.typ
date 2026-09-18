#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  title: [Training and evaluation], subtitle: [Units III and IV], author: [Prof. Author Name],
  subject: [Neural Networks], subject-code: [PPGEE016],
))
// --- example ---
== Header with `raw` and *bold*

=== Pill: *bold*, ~~alert~~, `raw`, #icon("check")

#emph-box(title: [Title: *bold*, ~~alert~~ and `raw`])[
  In the body: *bold*, `raw` and #icon("check").
]
