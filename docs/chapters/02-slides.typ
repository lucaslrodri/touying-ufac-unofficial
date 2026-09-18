#import "../template.typ": *
#show: chapter

= Slides and headings <slides>

Headings drive the deck: no function call is needed for the ordinary slides.

#table(
  columns: (auto, 1fr),
  table.header([Markup], [Effect]),
  [`= Title`], [section slide "Part N: Title"; what follows the heading goes to the right],
  [`== Title`], [new slide with a blue header, fitted to the width],
  [`== Title <exercise>`], [exercise slide: red pill "Exercise 1.N (Title)", numbered automatically],
  [`== Title <example>`], [example slide: green pill "Example 1.N (Title)", with its own counter],
  [`=== Subtitle`], [blue pill; no new slide; repeated at the top of every continuation page],
  [`==== Subtitle`], [the same pill, not repeated],
  [`---`], [alone on a line: next page of the same slide (same header, same number)],
)

== Sections

The content right after a `=` heading, typically an image, sits on the right, flush with the page edge.
`#pad(right: 1.8em)[#image(..)]` restores the page margin.

#slide-example("section")

== Slides and continuations

#slide-example("heading", pages: (1, 2))

#emph-box(color: colors.tertiary, title: [Caution])[
  Touying breaks the page at _any_ top-level em dash, so an em dash next to inline markup, as in
  `Text — *bold*`, also starts a new page. Use an en dash or wrap the paragraph in `#[ ]`.
]

== Exercises and examples

A label on the `==` heading turns the header into a numbered pill. Any suffix gives the same slide and makes the
label unique, so the slide can be cited: `@exercise-ogata` becomes "Exercise 1.N", bold, in the color of the kind and
linked to the slide. `#exercise-slide` and `#example-slide` are the function forms, with a `color` option; they
cannot be cited.

#slide-example("exercise", pages: (1, 2, 3, 4))

#reference("ufac", "exercise-slide", "example-slide")

== Subtitles

A `===` subtitle is repeated on the pages that continue the slide, unless the continuation starts with another
`===`. That holds for `---`, for `#pagebreak()` and for content that overflows by itself.

#slide-example("subtitle", pages: (1, 2))

#slide-example("overflow", pages: (1, 2))

Only a top-level `===` is repeated; inside `#[ ]`, a column or a box the pill stays in the flow.
`config-common(breakable: false)` makes Touying warn about overflow instead.

== Slide functions

`#slide` is the slide that every `==` opens; calling it gives access to Touying's arguments, such as `composer`.
`#empty-slide` drops the header and keeps the footer. `#title-slide()` is the cover, shown in @quick-start.

#slide-example("slides", pages: (1, 2))

#reference("ufac", "slide", "empty-slide", "new-section-slide")
