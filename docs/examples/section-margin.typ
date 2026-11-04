#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#show: ufac-theme.with(
  lang: "en",
  section-margin: false,   // flush with the edge
  config-info(
    title: [Networks],
    author: [Author Name],
  ),
)

= Multilayer networks
#image("network.svg")
