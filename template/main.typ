// Starting deck for the touying-ufac-unofficial theme. Syntax: package README; the elements at a glance:
// example/main.typ; a whole lecture: example/lecture.typ, both at
// https://github.com/lucaslrodri/touying-ufac-unofficial/tree/v0.3.0/example
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *

#show: ufac-theme.with(
  aspect-ratio: "16-9",
  lang: "en",   // "pt-br" (default), "en" or "es"
  config-info(
    subject: [Subject name],                  // or Touying's `title:`
    subject-code: [CODE or Department],       // or `short-title:`
    unit-title: [Title of the teaching unit], // or `subtitle:`
    unit: [Teaching unit I],                  // or `short-subtitle:`
    author: [Prof. Dr. Your Name],
    counter-prefix: [1.],   // "Exercise 1.N"; none gives "Exercise N"
  ),
)

#title-slide()

== Slide title
=== Subtitle

Text.
