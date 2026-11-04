// Example deck of the touying-ufac-unofficial theme: a paper for a course (`kind: "coursework"`), in English, with the
// students and the teacher in groups on the cover (the style "stack") and `#info` inside the slides.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *

#show: ufac-theme.with(
  lang: "en",
  config-info(
    kind: "coursework",
    subject: [Power Electronics],
    subject-code: [CCET310],
    unit-title: [A buck converter for a solar charger],
    author: [_Students_ \ First Student, Second Student \ _Teacher_ \ Prof. Dr. Teacher Name],
    year: 2026,
  ),
)

#title-slide()

== The converter
#cols(columns: (3fr, 2fr))[
  -> Input: the panel, from 12 to 20 V
  -> Output: 5 V for a phone
  -> Switching at 100 kHz

  The duty cycle is #eq-box[$D = V_o / V_i$].
][
  #emph-box(title: [Course])[
    #info("subject") (#info("subject-code")), #info("year").
  ]
]

== The inductor <example>
Find $L$ for a ripple of 20% at 100 kHz, with $V_i = 20$ V and $I_o = 2$ A.

#solution
$ L = (V_i - V_o) D / (Delta I f) = (15 dot 0.25) / (0.4 dot 10^5) approx 94 mu"H" $

#callout("warning")[Pick the next standard value, 100 µH.]

#ending-slide()
