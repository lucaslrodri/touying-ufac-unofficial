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
#slide(composer: (1fr, 2fr))[
  Left body
][
  Right body, twice as wide.
]

#empty-slide[
  #align(center + horizon)[No header, footer kept.]
]
