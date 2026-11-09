/// Synopsis: `footer-left` and `footer-right` given as content, not as a function of `self`: the same texts on a slide, in the box of an exercise (in its color) and, in white, on the closing slide. The left text holds a code chip, an icon and a link, which take the color of the footer as its text does; the code keeps its letters as written, also inside bold, a link and a `#text(fill:)`, which keeps its style (a red capital R before the chip), while the rest of the footer is in capitals.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", test-info, footer-left: [Ocean Science • `my_Var.Len()` • *bold `b_Var`* • #icon("tip") • #link("https://example.com")[link `l_Var`] • #text(fill: red)[r `r_Var`] • 2026], footer-right: [First Author & Second Author])

== A slide
The footer with fixed texts, in place of the titles and the authors.

== An exercise <exercise>
The same footer closes the box of the exercise.

#ending-slide()
