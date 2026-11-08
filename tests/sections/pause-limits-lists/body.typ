// Body of the `sections/pause-limits-lists` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Limit: `#uncover` around an item after another, glued or after a blank line
- first item
#uncover(2)[- second item, shown on the first step]

- third item

#uncover(2)[- fourth item, shown on the first step]

== Way out: a `#pause` between the items
- first item
#pause
- second item, veiled

== Limit: a list right inside `#align(center)`
#align(center)[
  - first item
  #pause
  - second item, its marker in the middle on the first step
]

== Limit: a list right inside `#align(right)`
#align(right)[
  - first item
  #pause
  - second item, its marker on the right on the first step
]

== Way out: the list centered as a block, with its text on the left
#align(center, block(align(left)[
  - first item
  #pause
  - second item, its marker in place
]))

== Way out: the list on the right as a block, with its text on the left
#align(right, block(align(left)[
  - first item
  #pause
  - second item, its marker in place
]))

== Way out: the first number written
3. three, written
#pause
+ four

#set enum(start: 3)
== Limit: a split list after `#set enum(start: 3)` (last: the rule reaches the slides after it)
+ first, numbered 1.
#pause
+ second, numbered 2.
