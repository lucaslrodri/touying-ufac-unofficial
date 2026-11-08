#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#show: ufac-theme.with(
  lang: "en",
  cover-style: "gradient",
  config-info(
    flavor: "dissertation",
    title: [Rainfall and river levels in
      the western Amazon],
    course: [Graduate Program in
      Geography],
    author: [
      _Student_ \ Student Name \
      _Advisor_ \ Prof. Dr. Advisor Name
    ],
    year: 2026,
  ),
)

#title-slide()
