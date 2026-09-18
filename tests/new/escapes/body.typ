// Body of the `new/escapes` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Function and equivalent shorthand
#[
#set text(size: .64em)
#table(columns: (0.5fr, 0.5fr, 1fr),
  table.header([Function], [Shorthand], [Notes]),
  [`#emph-box[..]`], [`> text`], [lines starting with `> `; inline content only; color always `primary`],
  [`#emph-box(title: [T])[..]`], [`> == T` + `> text`], [the 1st line `> == T` is the title],
  [`$ #eq-box[$…$] $`], [`> $ … $`], [equation box (the `key-eq`), inside the equation; inline `> $x$` does not count (Edge cases)],
  [`#quote-box(color:)[..]`], [`"text"` (whole line)], [several lines → several boxes, alternating colors],
  [`#arrows(color:)[..]` / `#list(marker:)`], [`-> item`], [consecutive `->` lines = one list; blank line before],
  [`#alert[..]`], [`~~text~~`], [`~` is Typst's non-breaking space; plain text only inside],
  [`#underline[..]`], [`~text~`], [start/space/opening bracket before, space/punctuation/end after (`Fig.~1 and Tab.~2` stay spaces)],
  [`#highlight[..]`], [`==text==`], [plain text, never at the start of the line],
  [`#primary` (= `#alert`), `#secondary`, `#tertiary`, `#quaternary`], [(no shorthand)], [colored emphases, named after the color],
  [`#exercise-slide(title:, color:)[..]`], [`== Title <exercise>`], [numbered red pill],
  [`#example-slide(title:, color:)[..]`], [`== Title <example>`], [numbered green pill],
  [`#pagebreak()`], [`---` (alone on a line)], [slide continuation, `===` pill repeated],
  [`#cols(divider:)[..][..]`], [(no shorthand)], [columns with or without divider],
  [(escape)], [`\==x==`, `\> …`, `-\> …`, `\~x\~`, `\"…\"`], [backslash on the sign (next slide); inside `raw` no shorthand applies],
)
]

---

== Backslash escapes
#[
#set text(size: .8em)
No shorthand applies inside `raw`: `==x==`, `> a`, `-> b`, `~~c~~`, `~d~`. For a literal case in the text, a backslash on the sign:
#cols(divider: true)[
  `\==x==` and `=\=x==`: \==x== and =\=x== stay literal; ==z== is still a highlight, also in *\==bold==*.

  `\> box` (followed by a word):

  \> box stays text

  `-\> item` (the backslash goes on the `>`):

  -\> item stays text
][
  `\~\~x\~\~` and `\~x\~`: \~\~x\~\~ and \~x\~ stay literal (each tilde escaped); ~~alert~~ and ~underline~ are still shorthands.

  `\"quote\"` (straight quotes):

  \"quote\" stays text

  Limits: `\> == T`, `\> *x*` and `\-> item` do not escape (the escaped `>` must be followed by a word).
]
]
