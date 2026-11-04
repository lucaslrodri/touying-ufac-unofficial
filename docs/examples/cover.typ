#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#show: ufac-theme.with(
  aspect-ratio: "16-9",
  lang: "en",
  config-info(
    title: [Ocean Science],
    short-title: [OCE110],
    subtitle: [Tides and waves],
    short-subtitle: [Unit III],
    author: [Prof. Author Name],
    counter-prefix: [1.],
  ),
)

#title-slide()
