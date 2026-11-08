#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#show: ufac-theme.with(
  lang: "en",
  config-info(
    flavor: "tcc",
    title: [A low-cost weather station
      for schools],
    course: [Bachelor's in Physics],
    author: [
      _Student_ \ Student Name \
      _Advisor_ \ Prof. Dr. Advisor Name
    ],
    year: 2026,
  ),
)

#title-slide()
