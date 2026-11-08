// Body of the `sections/pause-glued` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== A `#pause` between list items
- first item, gjpqy
#pause
- second item, veiled whole
- third item

== A `#pause` between numbered items
+ first, gjpqy
#pause
+ second, veiled whole

== A paragraph, a `#pause`, a list
Visible paragraph, gjpqy.
#pause
- covered item, veiled whole
- another

== A `#pause` before a `>` box
Visible paragraph.

#pause
> == Box
> Covered box body, badge included.

== A `#pause` before a box with a title
Visible paragraph.

#pause
#emph-box(title: [Title])[Covered body, badge included.]

== A `#pause` right after the title
#pause
- covered item one
- covered item two

== A `#pause` before a table
Visible.
#pause
#table(columns: 2, [A], [B], [C], [D])

== `#uncover` with its body on the next lines
Visible paragraph.

#uncover(2)[
  - covered item one
  - covered item two
]

== `#uncover` around a box with a title
Visible.

#uncover(2)[
  #emph-box(title: [Box])[Covered body.]
]

== A numbered list that no `#pause` splits
#set enum(start: 3)
+ keeps `set enum(start: 3)`: three
+ four
