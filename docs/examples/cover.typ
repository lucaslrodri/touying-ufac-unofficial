#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#show: ufac-theme.with(
  aspect-ratio: "16-9",
  lang: "en",
  config-info(
    title: [Neural Networks],
    short-title: [PPGEE016],
    subtitle: [Training and evaluation],
    short-subtitle: [Units III and IV],
    author: [Prof. Author Name],
    counter-prefix: [1.],
  ),
)

#title-slide()
