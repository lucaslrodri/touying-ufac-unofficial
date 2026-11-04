#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(
  aspect-ratio: "16-9",
  lang: "en",
  config-info(
    subject: [Ocean Science],
    subject-code: [OCE110],
    unit-title: [Tides and waves],
    unit: [Unit III],
    author: [Prof. Author Name],
  ),
)
// --- example ---
#title-slide[
  Slides and exercises:
  #link("https://example.com/ocean")[
    `example.com/ocean`] \
  Questions: *`author@example.com`*
]
