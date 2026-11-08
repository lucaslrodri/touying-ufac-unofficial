// Body of the `sections/pause-overflow` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Covered content that reaches the next page
Before.

#pause

#tip[A tip with ~~alert~~ and ~underline~ and *bold*.]

#emph-box(color: colors.tertiary, title: [Box])[A box with ~~alert~~ and ~underline~.]

#table(columns: 2, table.header([A], [~~B~~]), [~sub~], [~~alert~~])

"A quotation with ~~alert~~ and ~underline~."

Text with #alert[alert] and #underline[underline] and #highlight[highlight] and `code`.
