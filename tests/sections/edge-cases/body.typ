// Body of the `sections/edge-cases` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *
== Syntax edge cases
#[
#set text(size: .8em)
- `a -> b` in the middle of the line and `$a -> b$`: a -> b, $a -> b$ (do not become a list)
- `a > b` in the middle of the sentence: a > b and $a > b$ (only `>` at the start of the paragraph becomes a box)
- Quotes in the middle: a sentence with a "quotation" inside (does not become a `quote-box`)
- `x == y` in normal text is not a highlight (the regex requires a closed `==…==`): x == y
- `> $x$` (inline equation on the `>` line) becomes a plain box, not an equation box: the equation reaches `show par` already realized, without a body. Use `> $ … $` (a block equation) or `$ #eq-box[$x$] $`:

> $x^2$

-1 is negative at the start of the line (stays text, not a list)

Previous text without a blank line
-> glued to the text above, stays text (the `->` list must open the paragraph)

A paragraph with — an em dash and plain text is safe; an em dash next to markup (`Text — *bold*`) would break the slide, unless inside `#[ ]`: #[Text — *bold* protected].
]
