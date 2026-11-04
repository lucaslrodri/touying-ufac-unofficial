#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  title: [Neural Networks],
  short-title: [PPGEE016],
  subtitle: [Training and evaluation],
  short-subtitle: [Units III and IV],
  author: [Prof. Author Name],
))
// --- example ---
== Header with `raw` and *bold*

=== Pill: *bold*, ~~alert~~, `raw`, #icon("tip")

#emph-box(title: [Title: *bold*, ~~alert~~ and `raw`])[
  In the body: *bold*, `raw` and #icon("tip").
]
