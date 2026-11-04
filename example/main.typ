// Example deck of the touying-ufac-unofficial theme: the elements of the syntax at a glance (details: package README).
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *

#show: ufac-theme.with(
  aspect-ratio: "16-9",
  lang: "en",                         // "pt-br" (default), "en" or "es": text language and pill/section names
  // exercise-name: [Exercise], example-name: [Example], part-name: [Part],   // override the localized names
  config-info(
    subject: [Subject name],
    subject-code: [CODE or Department],
    unit-title: [Title of the teaching unit],
    unit: [Teaching unit I],
    author: [Prof. Dr. Your Name],
    counter-prefix: [1.],
  ),
)

#title-slide()

= Name of the first section
// Content right after `=` goes to the right of the section slide, at the page margin from the edge (usually an image):
// #image("figure.png")

== Slide title
=== Subtitle (repeated after `---`)

Text with *bold*, _italic_, ~~blue emphasis~~, ==yellow highlight== and ~underline~.

-> Item with an arrow
-> Another item

- Item
  - Sub-item
    - Sub-sub-item

> == Definition
> Box with a title (same as `#emph-box(title: [Definition])[...]`).

---

> Box without title

"A quotation in a box."


$
x^2 - 3x + 2 = 0
$

Equation box:

> $
x = {2, 1}
$

---

"A list of quotation boxes"
"Another item"
"Another item \
with 2 lines"
"Another item"
"Another item"


#cols(divider: true)[
  Column with blue divider
][
  Column 2
]

#v(3em)

#cols[Col without divider][Column 2]

== Boxes with an icon

#emph-box(color: colors.quaternary, icon: "tip", title: [Tip])[
  An icon before the title: the name of any `#icon` (`"tip"`, `"warning"`, …) or any content.
]

#emph-box(color: colors.tertiary, icon: "warning", title: [Caution])[
  The icon is centered on the capitals of the title, and the badge keeps the same height.
]

== Callouts
// a caution (a mistake to avoid), a tip (a shortcut), a remark (to recall what was seen) or a note (something
// secondary): the color, the icon and the title in the language of the deck;
// `style: "badge"` gives the look of the boxes above
#caution[A caution: `x * y` with two lists is an error.]
#tip[A tip: the up arrow recalls the last command.]
#remark[As seen before: a *function* is a named block of code.]
#note[A note: something secondary.]

== An exercise <exercise-a>

Statement. (Also `#exercise-slide(title: [Title])[...]`.)

== An example <example>

Citing the @exercise-a.

// closing slide: the blue page of the cover with the footer in white; `#ending-slide()` alone says "Thank you!"; the
// contact of `config-info(contact:)`, when there is one, goes in the body: `#info("contact")`
#ending-slide[Thank you!][Questions and suggestions][`your.name@example.com`]
