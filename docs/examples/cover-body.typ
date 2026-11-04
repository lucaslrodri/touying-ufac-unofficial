#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(
  aspect-ratio: "16-9",
  lang: "en",
  config-info(
    title: [Neural Networks],
    short-title: [NN101],
    subtitle: [Training and evaluation],
    short-subtitle: [Units III and IV],
    author: [Prof. Author Name],
  ),
)
// --- example ---
#title-slide[
  #icon("code", size: 1.6em) \
  *Intelligent Systems Lab*
]
