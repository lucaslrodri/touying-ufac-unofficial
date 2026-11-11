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
  [`#arrow-list(color:)[- ..]`], [`-> item`], [consecutive `->` lines = one list; blank line before; `#arrows(color:)[..]` colors the `->` lines inside],
  [`#alert[..]`], [`~~text~~`], [`~` is Typst's non-breaking space; plain text only inside],
  [`#underline[..]`], [`~text~`], [start/space/opening bracket before, space/punctuation/end after (`Fig.~1 and Tab.~2` stay spaces)],
  [`#highlight[..]`], [`==text==`], [plain text, never at the start of the line],
  [`#primary` (blue, also in a box), `#secondary`, `#tertiary`, `#quaternary`], [(no shorthand)], [colored emphases, named after the color],
  [`#question-slide(title:, color:)[..]`], [`== Title <question>`], [numbered red pill],
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

  `\> box` and `\> 3 items` (followed by a word or a number):

  \> box stays text

  \> 3 items stays text

  `-\> item` (the backslash goes on the `>`):

  -\> item stays text
][
  `\~\~x\~\~` and `\~x\~`: \~\~x\~\~ and \~x\~ stay literal (each tilde escaped); ~~alert~~ and ~underline~ are still shorthands.

  `\"quote\"` (straight quotes):

  \"quote\" stays text

  Limits: `\> == T`, `\> *x*` and `\-> item` do not escape (the escaped `>` must be followed by a word or a number).

  In math the sign is never a shorthand, at the start of a paragraph too:

  $a > b$ stays text

  $>$ *x* stays text
]
]
