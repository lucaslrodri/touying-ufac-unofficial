// Body of the `elements/quotes` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *
== Quotations (`#quote`)
`#quote(attribution: [..])[..]` becomes a `quote-box` with the attribution on the right (0.85em); `#quote[..]` without attribution:
#quote(attribution: [Author, year])[A quotation with attribution, to show the side bar and the source aligned to the right.]
#quote[Quotation without attribution, same yellow bar.]
Quotes inside a sentence, like "this one", do not become a box; the `"whole line"` form is under New elements.
