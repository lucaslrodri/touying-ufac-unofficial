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

The next one comes about 12 h 25 min later:

$ 6"h"10 + 12"h"25 = 18"h"35 $

== Wave speed <example>

Is a long wave faster than a short one in deep water?

#pause
#solution
Yes: the speed grows with the square root of the wavelength.

#exercise-slide(title: [Field trip], color: colors.primary, icon: "terminal")[
  The function form, with another color and icon: how long between two high tides?

  #answer
  About 12 h 25 min.
]

#example-slide(title: [Lighthouse], icon: none)[
  Without icon: `icon: none`.
]

== Review

Solve @exercise-tides before the next class.
