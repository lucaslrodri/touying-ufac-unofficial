/// Synopsis: the dashes on a slide (manual, "Slides and continuations"). Touying takes `---` for a page break also in a sentence (slide 1, three pages), and a typed `—` breaks the page too when it is not followed by a plain word: before italic, math, code, a link, a quotation or a `#` call, and at the end of a paragraph (slide 2, one page for each), and in an arrow list and a `>` box (slides 3 and 4, two pages each). The en dash `--` is safe in all those places, and so is a `—` before a plain word or after markup (slide 5, one page).
#import "../../common.typ": *
#show: setup
#include "body.typ"
