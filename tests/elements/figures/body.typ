// Body of the `elements/figures` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Figures
#[
#set text(size: .8em)
#cols[
  `#figure(image(..), caption: [..])`, caption without "Figure N:", at 0.6 of the text:
  #figure(placeholder(width: 100%, height: 6em, label: [figure]), caption: [Figure caption, body only])
][
  Typical layout `#grid(columns: (1fr, 1fr), align: horizon, gutter: 1.2em)` with box + figure:
  #grid(columns: (1fr, 1fr), align: horizon, gutter: 1.2em,
    emph-box(color: colors.primary)[Definition next to the figure.],
    placeholder(width: 100%, height: 5em, stroke: none, label: [figure]))
][
  `#image("../../logo.svg", width: 70%)` (real image; the file is a yellow test square):
  #image("../../logo.svg", width: 70%)
]
]

== Captions at the size of the slide
The text of the slide is 22pt and a caption 0.6 of it; a long one wraps under its figure. In the middle, the deck gives another size with `show figure.caption: set text(size: 16pt)`; on the right, the caption is on top:
#cols[
  #figure(placeholder(width: 100%, height: 3em, label: [figure]), caption: [A long caption with *bold*, a `chip` and $x^2$, which wraps under the figure.]) <fig-wave>
][
  #show figure.caption: set text(size: 16pt)
  #figure(placeholder(width: 100%, height: 3em, label: [figure]), caption: [At 16pt, the size of the deck.])
][
  #set figure.caption(position: top)
  #figure(placeholder(width: 100%, height: 3em, label: [figure]), caption: [Above the figure: `position: top`.])
]
A reference to a figure says "Figure N", a number its caption does not show: @fig-wave.
