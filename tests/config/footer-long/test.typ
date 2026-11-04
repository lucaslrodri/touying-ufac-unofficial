/// Synopsis: a footer with long texts (a long `short-title` and `title`, four authors): each text stays on one line, cut with "…" when the two do not fit, on a slide, in the box of an exercise and, in white, on the closing slide; a short left text leaves the room to the authors.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  kind: "tcc",
  title: [A low-cost weather station for the public schools of the western Amazon, built with open hardware],
  author: [First Author, Second Author, Third Author and Fourth Author],
))

== A long footer
The left text, the tag of the work and the title, is cut with "…"; the authors take the room the left text leaves, at least a third of it.

== In an exercise <exercise>
The same footer closes the box of the exercise, on one line.

#ending-slide()
