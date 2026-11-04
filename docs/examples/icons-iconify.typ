#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  subject: [Ocean Science],
  subject-code: [OCE110],
  unit-title: [Tides and waves],
  unit: [Unit III],
  author: [Prof. Author Name],
))
// --- example ---
== Field trip
// https://api.iconify.design/ph.json?icons=boat-bold,sun-bold,waves-bold
#provide-icons(json("ph.json"))
#emph-box(icon: "ph:boat-bold", title: [On the boat])[
  Bring a hat #icon("ph:sun-bold") and water.
]
#tip(icon: "ph:waves-bold")[The tide turns at 14:20.]

#exercise-slide(title: [Wave height], icon: "ph:waves-bold")[
  Measure the height of ten waves.
]
