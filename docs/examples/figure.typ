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
== The beach at noon
#cols[
  The tide is low: the
  beach is at its widest.
][
  #figure(
    image("figure.svg",
      height: 60%),
    caption: [The beach at
      low tide, at noon.],
  )
]
