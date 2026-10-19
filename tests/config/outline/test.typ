/// Synopsis: `#outline()` on the slide after the cover: the parts of the deck, numbers in small pills, titles in bold blue (a code chip in a title takes its blue, as in a slide title), links and the number that the footer of each section slide shows (2, 6 and 8: the cover does not count, and a `---` continuation is a slide of its own).
#import "../../common.typ": *
#show: setup

#title-slide()

== Contents
#outline()

= First part
#placeholder()

== One
Text.

---

A `---` continuation: the footer counts it.

== Two
Text.

= Second part, with `code`
#placeholder()

== Three
Text.

= Third part
#placeholder()

== Four
Text.
