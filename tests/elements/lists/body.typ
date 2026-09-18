// Body of the `elements/lists` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Bulleted list (`-`)
#[
#set text(size: .8em)
#cols(divider: true)[
  - level 1: filled yellow square
    - level 2: rotated hollow square
      - level 3: hollow circle (smaller)
      - another level-3 item
    - another level-2 item
  - another level-1 item

  Inside `emph-box` the marker takes the box color:
  #emph-box(color: colors.tertiary, title: [Problems])[
    - level 1
      - level 2
        - level 3
  ]
][
  `#list[..][..]`:
  #list[one][two]

  Item with two paragraphs (indented continuation):
  - first paragraph of the item

    second paragraph of the item
  - next item

  A "loose" list (blank line between items):

  - item A

  - item B
]
]
