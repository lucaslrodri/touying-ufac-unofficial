// error: @exercise-tides is now @question-tides in 0.4.0, with the label <question-tides>
// A citation of a question of 0.3.0, left behind when its label became `<question-tides>`, is checked when the deck is
// laid out: it names the new citation instead of Typst's "label does not exist".
#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en")

== Tide table <question-tides>
High tide was at 6:10.

== Review
Solve @exercise-tides before the next class.
