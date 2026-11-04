// Starting deck for the touying-ufac-unofficial theme. Syntax: package README; every element: example/main.typ.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *

#show: ufac-theme.with(
  aspect-ratio: "16-9",
  lang: "en",   // "pt-br" (default), "en" or "es"
  config-info(
    title: [Subject name],                    // or `subject:`
    short-title: [CODE or Department],        // or `subject-code:`
    subtitle: [Title of the teaching unit],
    short-subtitle: [Teaching unit I],
    author: [Prof. Dr. Your Name],
    counter-prefix: [1.],   // "Exercise 1.N"; none gives "Exercise N"
  ),
)

#title-slide()

== Slide title
=== Subtitle

Text.
