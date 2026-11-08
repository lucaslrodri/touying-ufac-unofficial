// Body of the `sections/cover` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *
#title-slide()

== First slide after the cover
The slide counter skips the cover (`freeze-slide-counter`): this is slide 1.

#title-slide[
  #image("../../logo.svg", height: 1.7em)
  #provide-icons(octicons)
  Content below the titles: *bold* and #icon("octicon:rocket-16") white, #alert[alert] yellow
]

// a body that shows nothing: the same cover as the first one, titles in the same place
#title-slide[#provide-icons(octicons)]
