/// Synopsis: `footer-left` and `footer-right` given as arrays: the items joined by the dot of the footer, the empty ones (`[ ]`, `none`, `""`, `[]`) left out with no dot beside them; `footer-right`, a function that returns an array with nothing left, gives an unbroken rule. On a slide, in the box of an exercise and, in white, on the closing slide.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", test-info,
  footer-left: ([OCE110], [ ], none, [Ocean Science], "", [2026]),
  footer-right: self => ([], [ ], none),
)

== A slide
The left text joins three items, one dot between each two; the right one has none, and the rule runs on to the number.

== An exercise <exercise>
The same footer closes the box of the exercise.

#ending-slide()
