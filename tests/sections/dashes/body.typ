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

Quotation marks — "next" word

A parenthesis — (next)

A function — #text(fill: red)[next]

At the end of a line —
next

At the end of a paragraph —

The last paragraph.

== In an arrow list
// two pages; the items after the break lose their arrows: the second page writes "-> Second item" as plain text
-> First item — *bold* on the next page
-> Second item

== In a box
> A box — *bold* on the next page

== In a quotation
// two pages, and the quotation loses its box: plain text in quotation marks
"A quotation — *bold* on the next page."

== Dashes that keep the slide whole
A root -- when it exists -- is unique; -- _italic_, -- #text(fill: red)[a function], and a typed — before a word.
An en dash at the end of a line --
and the next line.

-> An en dash -- *bold*, -- $x$, -- `x`, -- #link("https://typst.app")[link], -- "quotation" and at the end --
-> A typed em dash — before a plain word, and *bold* — after markup

> A box with an en dash -- *bold*

"A quotation with an en dash -- *bold*."

// the em dash breaks only the text at the top level of the slide: inside a list item or a box it stays
- A list item — *bold*

#tip[A tip — *bold*]
