// Body of the `guide/typography` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Typography
#[
#set text(size: .85em)
#let lbl(t) = text(size: .7em, fill: colors.neutral-dark, t)
#grid(columns: (auto, 1fr), column-gutter: 1.2em, row-gutter: 1.2em, align: (right + horizon, left + horizon),
  lbl[body 1em], [Body 22pt, weight 500, New Computer Modern Sans; `leading: 0.55em`, `spacing: 0.9em`.],
  lbl[0.8em], text(size: .8em)[Body reduced to 0.8em, the most common override in dense slides.],
  lbl[`==` 1.2em], text(size: 1.2em, weight: "bold", fill: colors.primary)[Slide header, blue bold],
  lbl[`=` 2em], text(size: 2em, weight: "bold", fill: colors.primary)[Part N: Section],
  lbl[pill], [#_pill[Subtitle `===` / `====`] #_pill(color: colors.tertiary)[Exercise 1.1 (Title)] #_pill(color: colors.quaternary)[Example 1.1]],
  lbl[math], [$f(x) = a x^2 + b x + c, quad integral_0^1 f(x) dif x = a/3 + b/2 + c$ in New Computer Modern Math],
  lbl[term], [/ Term: description in `terms` (term in black bold)],
  lbl[raw], [Inline code `x = 1` in a gray chip (0.85em); 0.75em block with codly (line numbers, gray fill, thin border).],
  lbl[footer], text(size: .4em, fill: colors.primary, upper[Code - course · author · slide no. (0.6em)]),
)
]

== Paragraphs, breaks and per-slide size
Paragraphs are separated by a blank line; `\` breaks the line \ without a new paragraph; `#v(.6em)` adds vertical space:
#v(.6em)
A loose `#set text(size:)` applies to *the whole rest of the file* (header and footer included). Per slide, wrap it in `#[ ]`:
#[
#set text(size: .7em)
This paragraph is at 0.7em inside `#[ … ]`. #lorem(25)
]
This paragraph is back to 1em, and the next slide must look normal (no leaking `set`).
