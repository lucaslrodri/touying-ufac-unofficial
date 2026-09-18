#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#show: ufac-theme.with(
  aspect-ratio: "16-9",
  lang: "en",
  config-info(
    subject: [Neural Networks],
    subtitle: [Units III and IV],
    title: [Training and evaluation],
    author: [Prof. Author Name],
    subject-code: [PPGEE016],
    counter-prefix: [1.],
  ),
)

#title-slide()
