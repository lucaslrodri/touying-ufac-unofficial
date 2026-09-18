#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  title: [Training and evaluation], subtitle: [Units III and IV], author: [Prof. Author Name],
  subject: [Neural Networks], subject-code: [PPGEE016],
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
