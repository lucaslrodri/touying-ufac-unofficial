#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#import "@preview/iconify:0.5.3"
#show: ufac-theme.with(lang: "en", config-info(
  subject: [Ocean Science],
  subject-code: [OCE110],
  unit-title: [Tides and waves],
  unit: [Unit III],
  author: [Prof. Author Name],
))
#let ic = iconify.icon.with(height: 1em)

== Field trip
// https://api.iconify.design/ph.json?icons=boat-bold,sun-bold,waves-bold
#iconify.provide-icons(json("ph.json"))
#emph-box(icon: ic("ph:boat-bold"), title: [On the boat])[
  Bring a hat #ic("ph:sun-bold", y: -0.2em) and water.
]
#tip(icon: ic("ph:waves-bold"))[The tide turns at 14:20.]

#exercise-slide(title: [Wave height], icon: ic("ph:waves-bold"))[
  Measure the height of ten waves.
]
