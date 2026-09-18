#import "../template.typ": *
#show: chapter

= Inline formatting and shorthands <inline>

Most emphases have two forms: a function and a *shorthand*, a short piece of markup that the theme rewrites into the
same function. The shorthands take plain text only (no markup inside) and none of them applies inside `raw`.

#table(
  columns: (auto, auto, 1fr),
  table.header([Function], [Shorthand], [Result]),
  [`#strong[text]`], [`*text*`], [black bold],
  [`#emph[text]`], [`_text_`], [black italic],
  [`#alert[text]`, `#primary[text]`], [`~~text~~`], [blue bold],
  [`#highlight[text]`], [`==text==`], [light-yellow background],
  [`#underline[text]`], [`~text~`], [strong yellow underline],
  [`#secondary`, `#tertiary`, `#quaternary`], [], [bold in yellow, red, green],
  [`#emph-box[..]`], [`> text`], [box, @boxes],
  [`$ #eq-box[$..$] $`], [`> $ .. $`], [equation box, @boxes],
  [`#quote-box[..]`], [`"text"`], [quotation, @boxes],
  [`#arrows[..]`], [`-> item`], [arrow list, @lists],
)

== Bold, italic and alert

```example
Black *bold* and _italic_.

Blue #alert[alert], the same as
~~this shorthand~~.
```


== Highlight and underline

The `==text==` shorthand cannot open a line (there it is a heading) and its text neither starts nor ends with a
space; `#highlight` has no such limits and takes another fill, such as the `-lighter` tones of the palette.

````example
A ==highlighted== word and a
#highlight(fill: colors.quaternary-lighter)[green one].

A ~strong underline~ and
#underline[the function form]; `Fig.~1` keeps
its non-breaking space.
````

== Code chips

Inline `raw` is a gray chip. Inside a title or a box it follows the color of the container, and inside a pill it
is inverted.

````example
Call `fit(x, y)` first.

#emph-box(color: colors.tertiary)[
  Never call `predict` before `fit`.
]
````

== Colors by context

Bold text, alerts, highlights, underlines, arrows, chips and icons read the color of what contains them: the box
color inside an `emph-box`, white or yellow inside a pill, where the pill color would hide them.

#slide-example("pills")

== Colored emphases

Bold text named after the color families of @colors. A typical use is a label that opens a sentence.

#reference("components", "primary", "secondary", "tertiary", "quaternary")

== Escapes <escapes>

A backslash on the sign keeps a shorthand literal. An escaped `>` is only recognized when a word follows it.

````example
\==not highlighted== and \~not underlined\~

\> not a box

-\> not a list

\"not a quotation\"
````
