/// Synopsis: `footer-right` given as a function of `self` that paints its text with `self.colors.primary`: blue on a slide, and in the box of a yellow exercise the dark tone of the text of the footer (`secondary-dark`), not the yellow of the rules, which are the border of the box; on the closing slide, white.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", test-info, footer-right: self => text(fill: self.colors.primary)[*In the primary color*])

== A slide
The right text of the footer is in the primary color that the function gets.

#exercise-slide(title: [A yellow exercise], color: colors.secondary)[The function gets the color of the text of the footer.]

#ending-slide()
