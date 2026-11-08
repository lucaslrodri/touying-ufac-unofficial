#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#show: ufac-theme.with(
  aspect-ratio: "16-9",
  lang: "en",
  config-info(
    subject: [Ocean Science],
    subject-code: [OCE110],
    unit-title: [Tides and waves],
    unit: [Unit III],
    author: [Prof. Author Name],
    counter-prefix: [3.],   // "Exercise 3.1"
  ),
)

#title-slide()
