/// Synopsis: a short left text and many authors (an array): the authors take the room the left text leaves and are cut with "…" at the end of a word, which may fall inside a name ("SEVENTH…"), on a slide and in the box of an exercise.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  title: [Tides],
  short-title: [OCE110],
  author: ("First Author", "Second Author", "Third Author", "Fourth Author", "Fifth Author", "Sixth Author",
    "Seventh Author", "Eighth Author", "Ninth Author"),
))

== Many authors
The left text is short, so the authors take almost all the footer, cut with "…".

== In an exercise <exercise>
The same footer in the box of an exercise.
