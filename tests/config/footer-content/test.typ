/// Synopsis: `footer-left` and `footer-right` given as content, not as a function of `self`: the same texts on a slide, in the box of an exercise (in its color) and, in white, on the closing slide. The left text holds a code chip, an icon and a link, which take the color of the footer as its text does.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", test-info, footer-left: [Ocean Science • `code` • #icon("tip") • #link("https://example.com")[link] • 2026], footer-right: [First Author & Second Author])

== A slide
The footer with fixed texts, in place of the titles and the authors.

== An exercise <exercise>
The same footer closes the box of the exercise.

#ending-slide()
