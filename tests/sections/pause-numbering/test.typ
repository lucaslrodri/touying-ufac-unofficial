/// Synopsis: numbered items (`+`) that a `#pause` splits keep their numbers under the veil (2., not 1.): on a slide, in the box of an example, inside an `emph-box`, a callout, the last column and an item of a list, and after a `set enum(numbering: ..)` rule of the slide; a numbered list after a `#set enum(start: 3)` written outside the slide counts from 3 (the theme writes the numbers only of the lists that a mark splits). The rules reach the slides after them, so they come last.
#import "../../common.typ": *
#show: setup
#include "body.typ"
