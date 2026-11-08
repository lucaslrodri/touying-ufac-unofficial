// Body of the `sections/dashes` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== A `---` in a sentence
// three pages: "A root", "when it exists", "is unique."
A root --- when it exists --- is unique.

== A typed em dash before markup
// each `—` below goes on to a new page: the page shows the text before it, and the next one starts with what follows
Italic — _next_

Math — $x$

Code — `x`

A link — #link("https://typst.app")[next]

A quotation — "next"

A call — #strong[next]

At the end of a paragraph —

The last paragraph.

== In an arrow list
-> First item — *bold* on the next page
-> Second item

== In a box
> A box — *bold* on the next page

== Dashes that keep the slide whole
-> An en dash -- *bold*, -- $x$, -- `x`, -- #link("https://typst.app")[link], -- "quotation" and at the end --
-> A typed em dash — before a plain word, and *bold* — after markup

> A box with an en dash -- *bold*

"A quotation with an en dash -- *bold*."
