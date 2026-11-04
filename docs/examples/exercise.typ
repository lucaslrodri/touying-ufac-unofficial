#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  title: [Neural Networks],
  short-title: [PPGEE016],
  subtitle: [Training and evaluation],
  short-subtitle: [Units III and IV],
  author: [Prof. Author Name],
))
// --- example ---
== Ogata 4.6 <exercise-ogata>

Find the transfer function of the system.

== XOR network <example>

Two hidden neurons are enough.

#exercise-slide(title: [Haykin 4.2], color: colors.primary, icon: "terminal")[
  The function form, with another color and icon.
]

#example-slide(title: [Perceptron], icon: none)[
  Without icon: `icon: none`.
]

== Review

Solve @exercise-ogata before the next class.
