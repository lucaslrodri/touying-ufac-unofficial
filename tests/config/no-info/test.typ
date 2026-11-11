/// Synopsis: a deck without any `config-info` (no author, subject or title) must compile: cover, slide and footer.
#import "@preview/touying:0.7.4": *
#import "../../../src/lib.typ": *

#show: ufac-theme.with(lang: "en")

#title-slide()

== Slide without deck information

The footer has only the logo and the slide number; the cover is empty.

== Second slide <question>

The question pill still works.
