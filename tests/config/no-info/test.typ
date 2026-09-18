/// Synopsis: a deck without any `config-info` (no author, subject or title) must compile: cover, slide and footer.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.1.0": *

#show: ufac-theme.with(lang: "en")

#title-slide()

== Slide without deck information

The footer has only the logo and the slide number; the cover is empty.

== Second slide <exercise>

The exercise pill still works.
