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

== A long code block
=== The listing goes on to the next pages
The block of the theme splits across pages, as any long content, and no line runs into the footer: 18 lines on each full page under the repeated pill. The language pill stays on its first part.

```python
x1 = 1 * 2  # line 1
x2 = 2 * 2  # line 2
x3 = 3 * 2  # line 3
x4 = 4 * 2  # line 4
x5 = 5 * 2  # line 5
x6 = 6 * 2  # line 6
x7 = 7 * 2  # line 7
x8 = 8 * 2  # line 8
x9 = 9 * 2  # line 9
x10 = 10 * 2  # line 10
x11 = 11 * 2  # line 11
x12 = 12 * 2  # line 12
x13 = 13 * 2  # line 13
x14 = 14 * 2  # line 14
x15 = 15 * 2  # line 15
x16 = 16 * 2  # line 16
x17 = 17 * 2  # line 17
x18 = 18 * 2  # line 18
x19 = 19 * 2  # line 19
x20 = 20 * 2  # line 20
x21 = 21 * 2  # line 21
x22 = 22 * 2  # line 22
x23 = 23 * 2  # line 23
x24 = 24 * 2  # line 24
x25 = 25 * 2  # line 25
x26 = 26 * 2  # line 26
x27 = 27 * 2  # line 27
x28 = 28 * 2  # line 28
x29 = 29 * 2  # line 29
x30 = 30 * 2  # line 30
x31 = 31 * 2  # line 31
x32 = 32 * 2  # line 32
x33 = 33 * 2  # line 33
x34 = 34 * 2  # line 34
x35 = 35 * 2  # line 35
x36 = 36 * 2  # line 36
x37 = 37 * 2  # line 37
x38 = 38 * 2  # line 38
x39 = 39 * 2  # line 39
x40 = 40 * 2  # line 40
```

#for i in range(1, 30) [- Item #i of a long list under the repeated pill]
