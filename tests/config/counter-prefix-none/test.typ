/// Synopsis: `counter-prefix: none` in `config-info`: pills and references numbered "Exercise 1", "Example 1", "Exercise 2" (no "1." prefix).
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  title: [Title], subtitle: [Subtitle], author: [Author], subject: [Course], subject-code: [COD123],
  counter-prefix: none,
))

== First exercise <exercise-a>
Pill "Exercise 1 (First exercise)", without the "1." prefix; cited as @exercise-a.

== An example <example-b>
Pill "Example 1 (An example)"; cited as @example-b.

#exercise-slide(title: [Second])[Pill "Exercise 2 (Second)".]
