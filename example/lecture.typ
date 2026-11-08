// Example deck of the touying-ufac-unofficial theme: a lecture of a course, with the aliases of a course (`subject`,
// `subject-code`, `unit`, `unit-title`, `semester`) and the prefix of its unit (`counter-prefix`), a slide revealed step by step, exercises and examples with their
// solutions, callouts and the closing slide.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *

#show: ufac-theme.with(
  lang: "en",
  config-info(
    flavor: "lecture",
    subject: [Introductory Astronomy],
    subject-code: [AST101],
    unit: [Unit II],
    unit-title: [The solar system],
    semester: [2026.2],
    author: [Prof. Dr. Your Name],
    counter-prefix: [2.],   // the second unit: "Exercise 2.1"
  ),
)

#title-slide()

== Contents
#outline()

= The planets

== Orbits
=== Kepler's laws
-> The planets move on ellipses, with the Sun at a focus
-> A planet sweeps equal areas in equal times
-> The square of the period grows with the cube of the orbit

> == Definition
> An astronomical unit (au) is the mean distance from the Earth to the Sun, about $1.5 times 10^8$ km.

#tip[In years and astronomical units, Kepler's third law is just $T^2 = a^3$.]

// Touying's animations: a `#pause` in a paragraph of its own between two lines, then `#uncover(3)` around a box,
// which shows on the third step
== One step at a time
-> The orbit of a planet is an ellipse

#pause

-> The Sun sits at one of its foci

#uncover(3)[
  #emph-box(title: [Kepler's first law])[The planets move on ellipses, with the Sun at one focus.]
]

== The period of Mars <example>
Mars orbits the Sun at $a = 1.52$ au. How long is its year?

#pause
#solution
From $T^2 = a^3$:

$ T = sqrt(1.52^3) approx 1.87 "years" $

== Jupiter and Saturn <exercise>
Find the period of:

+ Jupiter, at $5.2$ au
+ Saturn, at $9.5$ au
+ an asteroid at $2.8$ au

#answer
About $11.9$, $29.3$ and $4.7$ years.

= On the computer

== The periods in Python
```python
planets = {"Mercury": 0.39, "Earth": 1.00, "Mars": 1.52}

for name, a in planets.items():
    print(name, round(a ** 1.5, 2))
```
```text
Mercury 0.24
Earth 1.0
Mars 1.87
```

#tip[`a ** 1.5` is the same as `sqrt(a ** 3)`.]

#ending-slide[Thank you!][Next lecture: the Moon][Read chapter 3 of the book.]
