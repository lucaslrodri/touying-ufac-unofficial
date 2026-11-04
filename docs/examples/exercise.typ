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
== Tide table <exercise-tides>

High tide was at 6:10. When is the next one?

#answer
About 12 h 25 min later, at 18:35.

== Wave speed <example>

Is a long wave faster than a short one in deep water?

#pause
#solution
Yes: the speed grows with the square root of the wavelength.

#exercise-slide(title: [Field trip], color: colors.primary, icon: "terminal")[
  The function form, with another color and icon.
]

#example-slide(title: [Lighthouse], icon: none)[
  Without icon: `icon: none`.
]

== Review

Solve @exercise-tides before the next class.
