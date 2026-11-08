/// Synopsis: a footer with two long texts (the tag of the work and a long `title`, four authors in one content): each stays on one line, cut with "…" at the end of a word, the authors keeping a third of the room, on a slide, in the box of an exercise and, in white, on the closing slide. A short left text is in `config/footer-long-authors`.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  flavor: "tcc",
  title: [A low-cost weather station for the public schools of the western Amazon, built with open hardware],
  author: [First Author, Second Author, Third Author and Fourth Author],
))

== A long footer
The left text, the tag of the work and the title, is cut with "…"; the authors take the room the left text leaves, at least a third of it.

== In an exercise <exercise>
The same footer closes the box of the exercise, on one line.

#ending-slide()
