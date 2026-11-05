// Body of the `sections/overflow` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *
== Automatic overflow (no `---`)
=== Subtitle repeated on every overflow page
The content below is longer than one page and there is no `---`: Touying lets it flow onto the next pages and the
`===` pill is repeated at the top of each of them (repeating grid header).

#for i in range(1, 19) [- Item #i of the first subtitle]

=== Second subtitle, also overflowing
A new `===` starts a new block: the previous pill stops being repeated and this one takes over on its own overflow pages.

#for i in range(1, 15) [- Item #i of the second subtitle]

---

Continuation after `---` that overflows as well: the pill "Second subtitle, also overflowing" comes from `_current-subtitle()` and is repeated on both pages.

#for i in range(1, 17) [- Item #i of the continuation]

== Overflow with `#pause`
=== Subtitle kept on the subpages and on the overflow page
First step, before the pause.

#pause

Second step: with the pause the list below is revealed and the slide overflows; the pill is repeated on the overflow page of the second subpage.

#for i in range(1, 15) [- Item #i after the pause]

== A callout that does not fit
The style `"bar"` does not split: a callout that does not fit what is left of the page goes whole to the next one,
with the `==` header repeated. #lorem(40)

#tip[
  The whole callout on the next page:
  #for i in range(1, 8) [- Step #i of the tip]
]

== A callout with the badge goes on
With `style: "badge"` the callout continues on the next page, as an `emph-box`. #lorem(30)

#tip(style: "badge")[
  The callout split between two pages:
  #for i in range(1, 11) [- Step #i of the tip]
]
