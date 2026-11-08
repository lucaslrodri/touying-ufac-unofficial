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

== Arrow lines with a pause that reach the next page
-> Arrow line 1, visible
-> Arrow line 2, visible

#pause

-> Arrow line 3, covered
-> Arrow line 4, covered
-> Arrow line 5, covered
-> Arrow line 6, covered
-> Arrow line 7, covered
-> Arrow line 8, covered
-> Arrow line 9, covered
-> Arrow line 10, covered
-> Arrow line 11, covered
-> Arrow line 12, covered
-> Arrow line 13, covered
-> Arrow line 14, covered
-> Arrow line 15, covered
-> Arrow line 16, covered
-> Arrow line 17, covered
-> Arrow line 18, covered
-> Arrow line 19, covered
-> Arrow line 20, covered
