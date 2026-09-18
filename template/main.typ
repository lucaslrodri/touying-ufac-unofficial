// Starting deck for the touying-ufac theme. Syntax: package README; every element in action: example/main.typ.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac:0.1.0": *

#show: ufac-theme.with(
  aspect-ratio: "16-9",
  lang: "en",   // "pt-br" (default), "en" or "es"
  config-info(
    title: [Title of the teaching unit],
    subtitle: [Teaching unit I],
    author: [Prof. Dr. Your Name],
    subject: [Subject name],
    subject-code: [CODE or Departament],
    counter-prefix: [1.],   // "Exercise 1.N"; none gives "Exercise N"
  ),
)

#title-slide()

== Slide title
=== Subtitle

Text.
