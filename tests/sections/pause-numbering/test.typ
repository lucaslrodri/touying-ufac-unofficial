/// Synopsis: numbered items (`+`) that a `#pause` splits keep their numbers under the veil (2., not 1.): on a slide, in the box of an example, inside an `emph-box`, a callout, the last column and an item of a list, and after a `set enum(numbering: ..)` rule of the slide; after a `#meanwhile`, the item shown on the first step keeps its number (3.); a numbered list after a `#set enum(start: 3)` written outside the slide counts from 3 (the theme writes the numbers only of the lists that a mark splits). The rules reach the slides after them, so they come last, and the last one gives `start: 1` again, so that its split list does not depend on how a split list reads the `start` of a rule (a limit, in `sections/pause-limits-lists`).
#import "../../common.typ": *
#show: setup
#include "body.typ"
