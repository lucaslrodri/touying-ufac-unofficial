#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#show: ufac-theme.with(
  lang: "en",
  background: "gradient",   // "circles" (default), "gradient", "plain"
  config-info(
    kind: "tcc",
    title: [Implant detection in radiographs],
    course: [Electrical Engineering],
    author: [_Student_ \ First Author \ _Advisor_ \ Prof. Dr. Advisor Name],
    year: 2026,
  ),
)

#title-slide()
