// Body of the `sections/cover` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *
#title-slide()

== First slide after the cover
The slide counter skips the cover (`freeze-slide-counter`): this is slide 1.

#title-slide[
  #image("../../logo.svg", height: 1.7em)
  Content below the titles: *bold* and #icon("rocket") white, #alert[alert] yellow
]
