// Example deck of the touying-ufac-unofficial theme: a paper for a course (`kind: "coursework"`), with the students and
// the teacher in groups on the cover (the style "stack") and `#info` inside the slides.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *

#show: ufac-theme.with(
  lang: "en",
  config-info(
    kind: "coursework",
    subject: [Applied Statistics],
    subject-code: [STA210],
    unit-title: [How long does it take to get to class?],
    author: [_Students_ \ First Student, Second Student \ _Teacher_ \ Prof. Dr. Teacher Name],
    year: 2026,
  ),
)

#title-slide()

== The survey
#cols(columns: (3fr, 2fr))[
  -> 40 students answered a short form
  -> Each one gave the time from home to class
  -> On foot, by bike, by bus or by car

  The mean is #eq-box[$overline(x) = 1/n sum_i x_i$].
][
  #emph-box(title: [Course])[
    #info("subject") (#info("subject-code")), #info("year").
  ]
]

== The spread <example>
Five students took 10, 15, 20, 25 and 30 minutes. Find the mean and the standard deviation.

#solution
$ overline(x) = 20 "min", quad s = sqrt((100 + 25 + 0 + 25 + 100) / 4) approx 7.9 "min" $

#callout("warning")[The sample standard deviation divides by $n - 1$, not by $n$.]

#ending-slide()
