#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  title: [Neural Networks],
  short-title: [NN101],
  subtitle: [Training and evaluation],
  short-subtitle: [Units III and IV],
  author: [Prof. Author Name],
))
// --- example ---
== Ogata 4.6 <exercise-ogata>

Find the transfer function of the system.

#answer
$G(s) = 1 / (s^2 + 2s + 1)$.

== XOR network <example>

Can a single neuron learn XOR?

#pause
#solution
No: two hidden neurons are enough.

#exercise-slide(title: [Haykin 4.2], color: colors.primary, icon: "terminal")[
  The function form, with another color and icon.
]

#example-slide(title: [Perceptron], icon: none)[
  Without icon: `icon: none`.
]

== Review

Solve @exercise-ogata before the next class.
