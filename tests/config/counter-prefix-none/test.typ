/// Synopsis: `counter-prefix: none` in `config-info`: pills and references numbered "Question 1", "Example 1", "Question 2" (no "1." prefix); on the last page, Typst's own outline (`std.outline`) of the `==` headings, whose lines are the PDF bookmarks of the slides: "Q1 — First question", "E1 — An example", "Q2 — Second", the other slides by their title alone.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  title: [Course],
  short-title: [COD123],
  subtitle: [Title],
  short-subtitle: [Subtitle],
  author: [Author],
  counter-prefix: none,
))

== First question <question-a>
Pill "Question 1" and the title, without the "1." prefix; cited as @question-a.

== An example <example-b>
Pill "Example 1" and the title; cited as @example-b.

#question-slide(title: [Second])[Pill "Question 2" and the title.]

== The bookmarks
#std.outline(title: none, target: heading.where(level: 2))
