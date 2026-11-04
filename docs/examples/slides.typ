#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  title: [Ocean Science],
  short-title: [OCE110],
  subtitle: [Tides and waves],
  short-subtitle: [Unit III],
  author: [Prof. Author Name],
))
// --- example ---
#slide(composer: (1fr, 2fr))[
  Left body
][
  Right body, twice as wide.
]

==
A `==` heading without text: a slide without a title, with the footer.
