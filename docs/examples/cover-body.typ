#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(
  aspect-ratio: "16-9",
  lang: "en",
  config-info(
    title: [Ocean Science],
    short-title: [OCE110],
    subtitle: [Tides and waves],
    short-subtitle: [Unit III],
    author: [Prof. Author Name],
  ),
)
// --- example ---
#title-slide[
  Slides and exercises: #link("https://example.com/ocean")[`example.com/ocean`] \
  Questions: *`author@example.com`*
]
