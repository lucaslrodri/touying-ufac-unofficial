// touying-ufac-unofficial manual (PDF), in one file: every `=` heading is a chapter. Build with `sh docs/build.sh`,
// which also renders the slide examples. The chapters teach, from the first deck to the details; the reference of
// every definition, generated from the doc-comments of the package, comes at the end.
#import "template.typ": *

#show: project.with(
  title: package.name,
  subtitle: package.description,
  authors: ("Lucas Lima Rodrigues",),
  abstract: [
    A #link("https://touying-typ.github.io/")[Touying] theme for the slides of the
    #link("https://www.ufac.br/")[Federal University of Acre]: lectures, courses, the work of students, final papers
    and theses. Slides are written with headings and a few Markdown-like shorthands for boxes, quotations, arrow lists
    and emphases. This manual is set with the rules of the theme itself.
  ],
  url: package.repository,
  date: datetime.today().display("[month repr:long] [day], [year]"),
  version: package.version,
)
// the look of the chapters: the theme rules and the example blocks (`chapter` in template.typ)
#show: chapter

= Getting started <start>

== Install the font

The theme uses the font *New Computer Modern Sans*, which is not bundled with Typst. Without it, Typst falls back to
another font and the slides do not look like the ones in this manual. It belongs to the
#link("https://ctan.org/pkg/newcomputermodern")[New Computer Modern] family: download the archive from CTAN and take
the `NewCMSans10-*.otf` files of its `otf` folder. Install them on the system, or keep them in a folder and compile
with `typst watch --font-path <folder> main.typ`. In the #link("https://typst.app/")[Typst web app], upload the
`.otf` files to the project.

== A first deck <first-deck>

`typst init @preview/touying-ufac-unofficial:0.3.0` creates a deck from the template of the package; in the new folder,
`typst watch main.typ` compiles it on every change. A deck imports
Touying and the theme, applies `ufac-theme` with the information of the deck, and starts with the cover:

```typ
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *
```

#slide-example("cover", columns: (1fr, 1fr))

From here on, most examples show the source on the left and the result on the right: a real slide when the feature
belongs to the slide (headers, pills, continuations), otherwise the content alone, laid out by the same rules as in a
deck. The repository has complete decks to start from: a lecture, an extension course, a final paper and the work of
students for a course
(#link("https://github.com/lucaslrodri/touying-ufac-unofficial/tree/v0.3.0/example")[`example/`]).

Before `#title-slide`, put only imports, `#let` bindings and `set`/`show` rules: anything that makes content, even
content that is not seen, such as `#provide-icons(..)` (@icons), opens an extra page, with the footer, before the cover.

== Dependencies <dependencies>

// every `@preview/name:version` in the sources (the imports of touying and iconify, and the hint that names codly) and
// in the examples of the integrations; touying first, then what the theme imports, then the optional
#let found = {
  let files = ("lib.typ", "ufac.typ", "components.typ", "utils.typ", "icons.typ", "code.typ", "info.typ")
    .map(f => read("../src/" + f)) + ("code-codly.typ", "icons-iconify.typ").map(f => read("examples/" + f))
  let order = ("touying", "iconify", "codly")
  files.join().matches(regex("@preview/([a-z0-9-]+):([0-9.]+)")).map(m => m.captures).dedup()
    .sorted(key: p => order.position(n => n == p.first()))
}
#let roles = (
  touying: [the slide engine; the deck imports it too, with the same version],
  iconify: [the icons of a collection the deck gives to `provide-icons`; the theme's own icons ship with the theme],
  codly: [optional: the code blocks through codly (requires Typst 0.15)],
)

The theme needs *Typst #package.compiler or later*. Typst fetches the packages by itself:

#table(
  columns: (auto, auto, 1fr),
  table.header([Package], [Version], [Role]),
  ..found.map(((name, version)) => (
    link("https://typst.app/universe/package/" + name, raw(name)), raw(version), roles.at(name, default: []),
  )).flatten(),
)

touying 0.8 requires Typst 0.15; this version of the theme stays on touying 0.7.4, which also works with Typst 0.14.
codly is imported by the deck that wants it (@codly).

Before a version reaches Typst Universe, its development version, the `develop` branch of the repository, can be
installed as a local package and imported as `@local/touying-ufac-unofficial:0.3.0` instead of `@preview`: clone the branch
(`git clone -b develop https://github.com/lucaslrodri/touying-ufac-unofficial`) and, in the new folder, install it with
#link("https://github.com/npikall/gotpm")[gotpm] (`gotpm install`); see
#link("https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/CONTRIBUTING.md#local-installation-with-gotpm")[Local installation with gotpm] in the contributing guide.

= The information of the deck <information>

== The fields

The cover, the footer and the metadata of the PDF come from Touying's `config-info`, given to `ufac-theme`. The theme
reads these fields:

#table(
  columns: (auto, auto, 1fr),
  table.header([Field], [Default], [What it is and where it appears]),
  [`title`], [`[]`], [the name of the course or of the work: large on the cover, and in the footer],
  [`short-title`], [`none`], [its code or a shorter name: the tag of the cover, and before the title in the footer],
  [`subtitle`], [`[]`], [the topic of the lecture: on the cover],
  [`short-subtitle`], [`none`], [the lecture or the unit ("Lecture 1", "Unit II"): on the cover, in yellow],
  [`author`], [`none`], [one, an array or free content: on the cover and on the right of the footer],
  [`date`], [`none`], [`auto` (today), a `datetime` (written in full in the language of the deck) or a text],
  [`institution`], [`auto`], [one or an array; `auto` is the Universidade Federal do Acre; shown with `#info` (@info)],
  [`logo`], [`auto`], [the logos of the footer and of the cover (@logos)],
  [`contact`], [`none`], [one or an array (an e-mail, a page); shown with `#info` (@info)],
  [`counter-prefix`], [`[1.]`], [prefix of the numbers of exercises and examples: "Exercise 1.N" (@items)],
)

An author written as free content keeps its lines (broken with `\`), and a line only in emphasis is a label over a
group: the cover shows it as written, and the footer and the metadata get the names of the first group, those who
present.

```typ
config-info(author: [
  _Students_ \ First Author \ Second Author \
  _Advisor_ \ Prof. Dr. Advisor Name
])
```

== The kind of work and the aliases <kinds>

In a course, the fields have names of their own, which are aliases of the fields above; giving one field under two
names (`subject` and `title`) is an error. A date given as `semester` or `year` is short, and also goes to the footer, after the title.

#table(
  columns: (auto, auto),
  table.header([Alias], [Field]),
  [`subject`], [`title`], [`subject-code`], [`short-title`], [`unit`], [`short-subtitle`], [`unit-title`], [`subtitle`],
  [`course` (the program, in a final paper)], [`short-subtitle`], [`semester`, `year`], [`date`],
)

`kind` tells what the presentation is, and brings the recommended cover and numbering; anything the deck writes wins
over it. The prefix of the exercises and examples ("Exercise 1.1") stands for the unit of a course, so the kinds
without units number them without it ("Exercise 1"). Without a `kind`, the cover has the style `"line"` and the
numbers have the prefix `[1.]`.

#table(
  columns: (auto, 1fr),
  table.header([`kind`], [Recommends]),
  [`"lecture"`], [the style `"line"`: the authors and the date on one line at the bottom],
  [`"course"`], [the style `"top"` and the label "Instructors" ("Ministrantes") over the authors],
  [`"talk"`], [the style `"line"`; no units: exercises without a prefix],
  [`"coursework"`], [the style `"stack"`: the authors in groups at the bottom left; no units: exercises without a
    prefix],
  [`"tcc"`, `"dissertation"`, `"thesis"`], [the style `"top"` and the tag of the work ("Undergraduate Thesis", …); no
    units: exercises without a prefix],
)

The work of students for a course keeps the names of the course and takes `kind: "coursework"`: the students and the
teacher stack at the bottom left, each group under its label, and the top right is free, for the name of the group.

#slide-example("cover-coursework", pages: (1, 2), columns: (1fr, 1fr))

A final paper takes `kind: "tcc"`: the tag of the work over the title, the program as `course`, and the student and the
advisors at the top right. `"dissertation"` and `"thesis"` do the same with their own tag.

#see("ufac", "ufac-theme()")

#slide-example("cover-tcc", columns: (1fr, 1fr))

= The cover and the closing slide <cover>

== The cover

`#title-slide()` draws the cover in three bands: the logos at the top left, the titles in the center, and the authors
and the date. The `style` decides where the authors and the date go: `"line"` (the default) puts them on one line at
the bottom, with the white line of the footer passing between them; `"stack"` stacks the authors at the bottom left;
`"top"` puts them at the top right and the date in the center of the bottom. Each of the six positions can be changed
on its own, with content, an array (as `footer-left`, @footer), `none` or a function of `self`, the dictionary Touying keeps of the deck
(`self => self.info.title`).

#slide-example("cover-styles", pages: (1, 2, 3, 4), columns: (1fr, 1fr))

The background of the cover and of the closing slide is an option of the theme: `"circles"` (the default),
`"gradient"` or `"plain"`; here, on the cover of a master's dissertation.

#slide-example("cover-background", columns: (1fr, 1fr))

Content given to the cover goes below the titles, in white: a message, where to find the slides, a contact.

#see("ufac", "title-slide()")

#slide-example("cover-body", columns: (1fr, 1fr))

== The closing slide

`#ending-slide` closes the deck on the blue page of the cover: a large title with the yellow rule, a subtitle in yellow
and a free body, with the footer of the slides in white. Without a title it says "Thank you!" in the language of the
deck. The contact of the deck goes in the body, with `#info("contact")` (@info).

#see("ufac", "ending-slide()")

#slide-example("ending-slide", pages: (1, 2, 3), columns: (1fr, 1fr))

= Building the deck <deck>

Headings build the deck: no function call is needed for the ordinary slides.

#table(
  columns: (auto, 1fr),
  table.header([Markup], [Effect]),
  [`= Title`], [section slide: the title under the yellow tag "PART N"; what follows the heading goes to the right],
  [`== Title`], [new slide with a blue header, fitted to the width],
  [`==`], [a slide without a title, with the footer],
  [`== Title <exercise>`, `<example>`], [exercise or example: a box filling the slide, numbered (@items)],
  [`=== Subtitle`], [a pill; no new slide; repeated at the top of every continuation page],
  [`==== Subtitle`], [the same pill, not repeated],
  [`---`, `#pagebreak()`], [next page of the same slide (same header; in an exercise or example, the same box and number)],
)

== Sections and their figure

Every `=` heading opens a section slide: "PART N" in the yellow tag, the title in blue and the yellow rule. The content
right after the `=`, typically an image, sits on the right, one page margin away from the edge, in a frame of 12em ×
66% of the height of the content area. An image without a size fills the frame, scaled up or down with its
proportions. An image with a size keeps it, and shrinks whole when it is larger than the frame, so a small image or an
`#icon` keeps its size; a size in percent (`width: 100%`, `height: 50%`) is a share of the frame. The image is neither cropped nor
stretched, also inside a figure, an `align` or a link. A long caption wraps at the width of the frame; a table or a
drawing wider than the frame keeps its width, and its caption wraps there.

#see("ufac", "new-section-slide()")

#slide-example("section")

== The outline

`#outline()` lists the parts of the deck, each line a link to the slide where the part starts. It usually takes a slide
of its own, right after the cover.

#see("components", "outline()")

#slide-example("outline")

== Slides and continuations <slides>

A `===` subtitle opens a pill without a new slide. A `---` alone on a line goes on to the next page of the same slide,
with the same header (the number in the footer counts the pages); a long content goes on by itself.

#slide-example("heading", pages: (1, 2))

#caution[
  Touying breaks the page at a top-level em dash next to inline markup, as in `Text — *bold*`. Use
  an en dash or put the paragraph in a `#block[ ]`; a plain `#[ ]` does not protect it.
]

The `===` subtitle is repeated on the pages that continue the slide, unless the continuation starts with another
`===`; that holds for `---`, `#pagebreak()` and a content that overflows. Only a top-level `===` is repeated: inside
`#[ ]`, a column or a box, the pill stays in the flow.

#slide-example("subtitle", pages: (1, 2))

#slide-example("overflow", pages: (1, 2))

`#slide` is the slide that every `==` opens; calling it gives Touying's arguments, such as `composer`, which lays out the
bodies of a slide in columns.

#see("ufac", "slide()")

#slide-example("slides", pages: (1, 2))

= Exercises and examples <items>

A label on the `==` heading turns the slide into the box of an exercise (red) or an example (green), as in a printed
handout. The box fills the slide; the title goes on a badge over its top border, with the icon of the kind (a pencil, a
beaker), the name, the number and the title; the footer of the slide closes the box. A suffix makes the label unique,
as in `<exercise-tides>`, so the slide can be cited: `@exercise-tides` becomes "Exercise 1.N", linked to the slide.
A short example inside an ordinary slide, without a number, is the callout `#example` (@callouts).

Exercises and examples are numbered on their own, after a prefix, `config-info(counter-prefix:)`: `[1.]` by default
gives "Exercise 1.1", "Exercise 1.2"; `[3.]`, for the third unit of a course, gives "Exercise 3.1"; `none` gives
"Exercise 1", the default of the kinds without units (@kinds).

```typ
#show: ufac-theme.with(config-info(
  subject: [Ocean Science],
  counter-prefix: [3.],   // "Exercise 3.1"; none gives "Exercise 1"
))
```

Inside the box, the bold text, the markers, the links, the `===` pills and the rest of what has no style of its own
take the color of the item (@context-colors).

`#solution` (in an example) and `#answer` (in an exercise), alone on a line like `#pause`, open the solution: a dashed
line and "Solution." or "Answer." in bold at the start of the next paragraph; after a blank line, the word stays alone
and the solution starts a new paragraph. With a `#pause` right before or after the marker, the solution appears on the
next step of the slide (@touying). The word ends with a period; `#answer(sep: ":")` ends it with a colon, and
`#solution(sep: [:\ ])` with a colon and a line break, so that the solution starts on the next line.

An exercise or example goes on until a slide of another kind: a long content continues on the next page in the same
box, with the same number, and `---` or `#pagebreak()` breaks the page by hand. `#exercise-slide` and
`#example-slide` are the function forms, with a color and an icon of their own; they cannot be cited.

#see("ufac", "exercise-slide()", "example-slide()", "solution()", "answer()")

#slide-example("exercise", pages: (1, 2, 3, 4, 5, 6))

= Writing on a slide <writing>

Most emphases have two forms: a function and a *shorthand*, a short piece of markup that the theme rewrites into the
same function. The shorthands take plain text only (no markup inside), and none of them applies inside `raw`.

#table(
  columns: (auto, auto, 1fr),
  table.header([Function], [Shorthand], [Result]),
  [`#strong[text]`], [`*text*`], [black bold],
  [`#emph[text]`], [`_text_`], [black italic],
  [`#alert[text]`, `#primary[text]`], [`~~text~~`], [blue bold],
  [`#highlight[text]`], [`==text==`], [light-yellow background],
  [`#underline[text]`], [`~text~`], [strong yellow underline],
  [`#secondary`, `#tertiary`, `#quaternary`], [], [bold in yellow, red, green],
  [`#arrows[..]`], [`-> item`], [arrow list],
  [`#emph-box[..]`], [`> text`], [box (@boxes)],
  [`$ #eq-box[$..$] $`], [`> $ .. $`], [equation box (@boxes)],
  [`#quote-box[..]`], [`"text"`], [quotation (@boxes)],
)

== Emphasis

```example
Black *bold* and _italic_.

Blue #alert[alert], the same as
~~this shorthand~~.

#tertiary[Problem:] a colored label.
```

The `==text==` shorthand cannot open a line (there it is a heading), and its text neither starts nor ends with a
space; `#highlight` has no such limits and takes another fill, such as a `-lighter` tone of the palette (@colors).

````example
A ==highlighted== word and a
#highlight(
  fill: colors.quaternary-lighter,
)[green one].

A ~strong underline~ and
#underline[the function form].
````

#see("components", "alert()", "primary()", "secondary()", "tertiary()", "quaternary()")

== Code chips

Inline `raw` is a gray chip. Inside a title or a box it follows the color of the container, and inside a pill it is
inverted.

````example
Call `fit(x, y)` first.

#emph-box(color: colors.tertiary)[
  Never call `predict` before `fit`.
]
````

== Colors by context <context-colors>

Bold text, alerts, highlights, underlines, arrows, the markers of the lists (and, in an exercise or example, their
numbers), chips, links, icons (@icons) and the `===` pills read the color of what
contains them: the color of an `emph-box`, a callout, an exercise or an example, or of a light cell of a table
(@tables); white or yellow inside a pill, where the color of the pill would hide them. What has a style of its own keeps it: a code
block, a box inside another box, which brings its own color, and a reference to an exercise or example, in the
color of its kind.

#slide-example("pills", columns: (1fr, 1fr))

== Lists and terms

Consecutive lines starting with `->` become one list with a blue arrow. The list has to start the paragraph, after a
blank line; an arrow in the middle of a line and the math arrow are left alone. Bullet lists have three levels of
yellow markers, and numbered lists are blue and bold: `1.`, `a)`, `i.` by level. `#set enum(numbering: "a)")` starts
at `a)`; Typst only knows `+` and `1.` as markers, so `a)` at the start of a line is text.

```example
-> consequence
-> another consequence

- first level
  - second level
    - third level

+ first
  + nested

/ Tide: the rise and fall of the sea.
```

#see("components", "arrows()")

== Columns

`#cols` puts its bodies side by side anywhere in a slide, with an optional divider; `#slide(composer:)` lays out a
whole slide (@slides).

```example
#cols[Left][Middle][Right]
```

#see("components", "cols()")

== Escapes <escapes>

A backslash on the sign keeps a shorthand literal. An escaped `>` is only recognized when a word follows it.

````example
\==not highlighted== and
\~not underlined\~

\> not a box

-\> not a list

\"not a quotation\"
````

= Boxes <boxes>

== Emphasis boxes

`#emph-box` frames a definition or a key idea: a thin border in a color of the palette, and an optional title on a
badge over the border, with an optional icon.

```example
#emph-box[
  A definition, in the primary color.
]

#emph-box(color: colors.tertiary,
  title: [Problem])[
  The anchor *drags* and the boat
  ~drifts~.
]

#emph-box(color: colors.quaternary,
  icon: "tip", title: [Tip])[
  An icon before the title.
]
```

A paragraph whose lines start with `>` is the same box in the primary color; a first line `> == Title` gives the title.
Only inline content fits there: lists and code blocks need `#emph-box`. A loose `>` at the start of a paragraph is
read as a box: write `$a > b$`, or escape it (@escapes).

```example
> A box without title, with *bold*
> and $x^2$.

> == Definition
> A box with a title.
```

#see("components", "emph-box()")

== Equation boxes

`#eq-box` frames a key equation from inside the equation, with dollar signs around its body; `>` before a block
equation, on the same line or the line above, does the same.

```example
$ #eq-box[$E = m c^2$] $

> $ c = sqrt(g h) $
```

#see("components", "eq-box()")

== Callouts <callouts>

A callout is a box with the color, the icon and the title of its kind, the title in the language of the deck. Each
kind has a function of its own, short for `#callout(kind)`: `#tip[..]` is `#callout("tip")[..]`.

#block(breakable: false, table(
  columns: (auto, auto, auto, 1fr),
  table.header([Function], [Title], [Color], [For]),
  [`#caution`], [Caution!], [red], [a mistake to avoid],
  [`#tip`], [Tip.], [green], [a shortcut],
  [`#remark`], [Reminder.], [blue], [to recall what was seen before ("Relembrando." in Portuguese)],
  [`#note`], [Note.], [gray], [something secondary],
  [`#example`], [Example.], [green], [a short example inside an ordinary slide, with the beaker of the example slides;
    an example that takes the whole slide is `== Title <example>` (@items)],
  [`#examples`], [Examples.], [green], [the same, for several examples],
))

The default style is the box of a printed handout, with a bar on the left and the title opening the text;
`style: "badge"` gives an emphasis box with the title on a badge, without the punctuation. `title:` and `icon:`
change the title and the icon of one callout; `example-name` and `example-icon` of the theme change only the example
slides, not `#example` and `#examples`.

In the default style a callout does not split: one that does not fit what is left of the page goes whole to the next
one, so a text longer than a page goes outside it. With `style: "badge"` it continues on the next page, as an
`emph-box`.

```example
#caution[
  `x*y` with two lists is an error.
]
#tip[The up arrow recalls a command.]
#remark[
  A *function* is a named block of code.
]
#note[Two versions of the program
  differ here.]
#example[
  The Bay of Fundy has tides of 16 m.
]
#examples[
  Tides that follow the Moon:
  - spring tides, at full moon;
  - neap tides, at the quarter moons.
]
#callout("tip", style: "badge")[
  The badge style.
]
```

#see("components", "callout()", "caution()", "tip()", "remark()", "note()", "example()", "examples()")

== Tags and quotations

`#tag` is the yellow tag of the cover and of the section slides, for the text, the titles and the tables: a short label
in spaced capitals, on any color. A paragraph made only of quoted lines becomes one quotation per line, a
`#quote-box`; Typst's `#quote(attribution:)` is a `#quote-box` too, with the attribution on the right.

```example
#tag[Optional]
#tag(color: colors.tertiary)[Hard]

"All models are wrong"
"but some are useful"

#quote(attribution: [George Box])[
  All models are wrong.
]
```

#see("components", "tag()", "quote-box()")

= Tables, figures, math and code <elements>

== Tables <tables>

The header row is blue with white text. A cell filled with a light tone of the palette
(`table.cell(fill: colors.secondary-lighter)`) colors its chips and bold text like a box of that family; a cell filled
with a dark tone is like a pill, with white text.

```example
#table(
  columns: 3,
  table.header(
    [Fish], [Depth (m)], [$T$ (°C)],
  ),
  [Cod], [200], [4],
  [Tuna], [50], table.cell(
    fill: colors.secondary-lighter,
  )[*18*],
)
```

== Figures and math

A figure caption shows its body only, without "Figure N", at 0.6 of the size of the text, so that it leaves room for
the figure. A deck gives another size with `#show figure.caption: set text(size: 18pt)`, after
`#show: ufac-theme.with(..)`: written before it, the rule gets the 0.6 of the theme on top (18pt gives 10.8pt). A size
in `em` is a share of the caption: `0.8em` gives 0.8 × 0.6 = 0.48 of the 22pt text of a slide, about 10.6pt.

On an ordinary slide, a large image, such as a photo, needs a height, as below: without one it can take the whole
height of the slide, and its caption runs into the footer. A height in percent is a share of the content area of the
slide, not of the room left under the text: `height: 60%` leaves room for a line or two above the figure; with more
text, the figure goes next to it, in `#cols`. A reference to a figure (`@label`) says "Figure 1" in the language of the
deck, a number the slide does not show (the figure of a section slide counts too), so a figure is better cited in
words.

#slide-example("figure")

Math uses New Computer Modern Math, and block equations sit closer to the text than Typst's default.

```example
The speed of a wave in deep water is
$ c = sqrt((g lambda) / (2 pi)) $
```

== Code <code>

A code block goes in the box of the theme: a light blue fill with a bar on the left, the line numbers (a long line
wraps and continues under the code), the language in a pill at the top right and the syntax colors of the theme. The
output of a program, a block in `text` (or `txt`, `output`), goes in a gray box without numbers. Inside a colored box
a block keeps its look. The languages with a pill are `python` (`py`), `typst` (`typ`), `matlab`, `bash` and `sh`, and
the output has its own ("Output"); `ufac-theme(code-languages:)` adds others.

A long block goes on to the next page of the slide, as any long content, with the `===` pill repeated at the top; the
language pill appears only on its first part. A callout in the default style does not split (@callouts), so a long listing goes outside it. For a file
name, highlights or ranges, the deck takes codly (@codly).

#see("code", "code-languages", "ufac-syntax")

#slide-example("code")

= Customization <customization>

== Language

The theme speaks Portuguese by default (`lang: "pt-br"`); `lang: "en"` or `"es"` switches the language of the text and
every word of the theme: the names of exercises, examples and parts, the titles of the callouts, "Solution" and
"Answer", "Output", "Thank you!", the dates and the tags of the cover. The names of exercises, examples and parts can
also be given one by one.

#slide-example("lang", pages: (1, 2))

== Colors <colors>

Five families of seven tones, named after Touying's colors. The light tones serve as fills of highlights and boxes, the
dark ones as text on white; the tones are derived from the base color, and the neutral family goes from black to white.

#let families = ("primary", "secondary", "tertiary", "quaternary", "neutral")
#let tones = ("darkest", "darker", "dark", "", "light", "lighter", "lightest")
#let key(family, tone) = if tone == "" { family } else { family + "-" + tone }
#let swatch(c) = {
  let ink = if c.luma().components().first() > 60% { black } else { white }
  block(width: 100%, height: 2.4em, fill: c, radius: .25em, stroke: .5pt + luma(210),
    align(center + horizon, text(size: .7em, fill: ink, upper(c.to-hex()))))
}

#grid(
  columns: (auto,) + (1fr,) * 7, gutter: .35em, align: center + horizon,
  [], ..tones.map(t => text(size: .8em, if t == "" { [base] } else { raw("-" + t) })),
  ..families.map(f => (align(left, raw(f)), ..tones.map(t => swatch(colors.at(key(f, t)))))).flatten(),
)

```example
A #highlight(
  fill: colors.tertiary-lighter,
)[red fill] and
#text(fill: colors.primary-dark)[dark
blue text]
```

#see("constants", "colors")

== Logos <logos>

The footer and the cover show the UFAC logo. `config-info(logo:)` is the list of the logos shown there, separated by
dots: `(auto, x)` keeps the UFAC logo and adds `x` after it, `(x,)` replaces it and `none` removes them. A logo is
content, or a function of the color of the footer (blue on the slides, white on the cover), so that one drawing serves
both; about `0.64em` high, it matches the UFAC logo. In a slide, `#info("logo")` shows them (@info); outside a deck,
as in a handout, `image(bytes(ufac-logo))` draws the UFAC logo.

#slide-example("logos", pages: (1, 2))

== The footer and the badges <footer>

The footer shows the short title and the title on the left and the authors on the right, each on one line: when the
two do not fit, they are cut with "…" at the end of a word (the authors keep at least a third of the room). `ufac-theme(footer-left:, footer-right:)` replaces either with content, an
array or a function of `self`: the items of an array are joined by a dot, those that show nothing left out (as
`info("semester")` below, in a deck without a date), and with none left the footer line runs unbroken. The badge of the exercises and examples takes
another name (`exercise-name`, `example-name`) and another icon (`exercise-icon`, `example-icon`), and the section
slides another word (`part-name`); the callouts `#example` and `#examples` keep theirs (@callouts).

```typ
#show: ufac-theme.with(
  footer-left: ([Introductory Astronomy], info("semester")),
  exercise-name: [Task], exercise-icon: "terminal",
  config-info(subject: [Astronomy]),
)
```

#see("ufac", "ufac-theme()")

== The information anywhere: `#info` <info>

`#info` shows any field of the table of @information but `counter-prefix`, or any alias, anywhere in a slide, inside boxes and tables
too: the author as written, the date in full, the contact, and with `"logo"` the logos of the footer, with a height and
in white for a dark background. With a function, it receives every field at once.

#see("info", "info()")

#slide-example("info", pages: (1, 2), columns: (1fr, 1fr))

= Integrations <integrations>

The theme sits on Touying and works with the packages a deck usually takes along: codly for the code blocks, and the
icons of any collection of Iconify.

The theme exports short names that other packages also use, such as `example`, `remark` and `solution` of theorion:
with two imports with `*`, the later one wins silently. Import the other package by its name,
`#import "@preview/theorion:0.3.3" as theorion`, and write `#theorion.example[..]`.

== Touying <touying>

The theme leaves the features of Touying alone. Animations work on every element of the theme: covered content stays
faintly visible under a veil in the color of the page, or of the box around it; a covered list, code block or box that
runs on to the next page is hidden instead, as the veil cannot span two pages. Animations work inside a box too, except
inside an `emph-box` with a title or an icon, a callout with `style: "badge"`, an `eq-box` and a `#tag`: there Touying
stops with "Unsupported mark … inside some functions like context", so a `#pause` goes before the box, and
`#uncover`/`#only` around it. A `#pause` between the lines of a `>` box or of quotations does nothing: for a box
revealed in steps, write `#emph-box[..]` without a title, with the `#pause` in a paragraph of its own.

#slide-example("pause", pages: (1, 2, 3))

#caution[
  Keep `#pause` and `#uncover`/`#only` in separate paragraphs: within one paragraph Touying reorders the covered
  part on the first subslide. A `#pause` right before a `===` subtitle, on a slide that goes on to the next page,
  leaves blank pages or the warning "document did not converge": put the `#pause` after the `===`, or split the slide
  with `---`.
]

#table(
  columns: (auto, 1fr),
  table.header([Feature], [Functions]),
  [Animations], [`#pause`, `#meanwhile`, `#jump`, `#uncover`, `#only`, `#alternatives`, `#item-by-item`, `#effect`, `#touying-raw`],
  [Notes and handouts], [`#speaker-note` (it attaches to the previous slide), `#handout-only`, `config-common(handout: true)`],
  [Layout], [`#slide(composer: (1fr, 2fr))`, `#cols`, `components.adaptive-columns`, `components.full-width-block`, `utils.fit-to-width`, `utils.fit-to-height`],
  [Overflow], [`config-common(breakable: false, clip:, detect-overflow:)`],
  [Reuse], [`#touying-recall`, `touying-get-config`, `components.progressive-outline`],
)

The packages Touying integrates work as in any Touying theme:
#link("https://touying-typ.github.io/docs/integration/cetz")[CeTZ] and Fletcher, whose diagrams reveal their parts with
`#pause` through `touying-reduce`; #link("https://touying-typ.github.io/docs/integration/pinit")[pinit], for pointing
at parts of a slide; and #link("https://touying-typ.github.io/docs/integration/mitex")[MiTeX], for LaTeX formulas.
Their pages in the documentation of Touying show how. Instead of the `outline-slide` of other Touying themes, write a
slide with `#outline()`; `focus-slide` and `matrix-slide` have no counterpart here.

== Code blocks with codly <codly>

The theme draws its own code box (@code) and does not need codly. For codly's features (a file name, highlights,
ranges, `diff`), the deck imports codly 2 and passes it to the theme, `ufac-theme(codly: codly)`: every block goes
through codly with the same look, and codly's functions (`codly.new(..)`, `codly.set_(..)`) are at hand. codly 2
requires Typst 0.15. The languages of the codly-languages package can be given to `ufac-theme(code-languages:)`.

#see("code", "codly-ufac-theme")

#slide-example("code-codly", columns: (1fr, 1fr))

== Icons <icons>

`#icon` draws an icon on the line of text, in the color of its surroundings: black in the text, the color of the box
inside a box, white in a pill. The theme ships a set of icons, each with a role that is also its name for `#icon`;
the colored ones keep their colors.

#see("components", "icon()")

```example
#emph-box(color: colors.tertiary)[
  #icon("caution") takes the
  color of the box.
]
```

#{
  set text(size: 6.5pt)
  set par(justify: false)
  grid(
    columns: (1fr,) * 4, row-gutter: .75em, column-gutter: .5em,
    ..theme-icons.pairs().map(((name, full)) => [#icon(name, size: 1.5em) #h(.3em) #name #text(fill: luma(120))[(#full)]]),
  )
}

`"warning"` and `"caution"` are the same icon, under the name of 0.2.0 and the one of the callout. The Octicons the
theme ships also answer to their own names: `"alert"`, `"light-bulb"`, `"info"`, `"note"`,
`"history"`, `"pencil"`, `"beaker"`, `"file-code"`, `"terminal"` and `"mail"`. The icons come from
#link("https://primer.style/octicons/")[Octicons] (© GitHub Inc., MIT license),
#link("https://phosphoricons.com/")[Phosphor] (MIT license), #link("https://devicon.dev/")[Devicon] (MIT license),
#link("https://simpleicons.org/")[Simple Icons] (CC0),
#link("https://github.com/material-extensions/vscode-material-icon-theme")[Material Icon Theme] (MIT license) and
#link("https://github.com/vscode-icons/vscode-icons")[VSCode Icons] (MIT license).

Any other icon comes from a collection in the JSON format of #link("https://iconify.design/")[Iconify], read by the
#link("https://typst.app/universe/package/iconify")[iconify] package, which the theme imports: the deck gives the
collection to `provide-icons` and writes the icon as `"collection:name"`, in `#icon` or wherever the theme takes the
name of an icon (an `emph-box`, a callout, the badge of an exercise or example). It is then an icon like those of the
theme, with the same size, the same place on the line and the color of its surroundings. `#provide-icons` goes in any
slide after the cover, never before it (@first-deck); its icons serve the whole deck, the cover included.

#slide-example("icons-iconify", pages: (1, 2), columns: (1fr, 1fr))

There are two ways to get a collection; the names of its icons are on #link("https://icones.js.org/")[icones.js.org],
and each collection has its own license.

#[
#set par(justify: false)
- *Only the chosen icons*: ask the Iconify API for them and save the answer, here as `ph.json`:
  `https://api.iconify.design/ph.json?icons=boat-bold,sun-bold,waves-bold`.
- *The whole collection*: download its JSON from the #link("https://ecstrema.github.io/iconify-typst")[site of the iconify package]
  (some are several megabytes).
]


= Moving from 0.2.0 <migration>

A deck of 0.2.0 needs the changes of this table and, in some cases, those of the notes after it.

#table(
  columns: (1fr, 1.3fr),
  table.header([In 0.2.0], [In 0.3.0]),
  [`config-info` with the fields of the theme: `subject`, `subject-code`, `title` (the topic), `subtitle` (the unit)],
  [keep `subject` and `subject-code`, now aliases of Touying's `title` and `short-title`; rename the old `title` to
    `unit-title` and the old `subtitle` to `unit` (@information). `subject` and `title` together are an error. A
    function of `footer-left` or `footer-right` reads Touying's names, `self.info.title` and `self.info.short-title`,
    or the footer is content with `#info("subject")`],
  [`ufac-theme(logos: ..)`], [`config-info(logo: ..)` (@logos)],
  [`ufac-theme(section-margin: ..)`; the figure of a section flush with the edge],
  [the figure keeps the page margin; for the old look,
    `config-common(new-section-slide-fn: new-section-slide.with(margin: 0pt))`],
  [`<empty-slide>`, `<empty-slide-COLOR>` and the theme's `#empty-slide`],
  [removed: the theme has no empty slide of its own (below)],
  [`local`, `codly-range`, `no-codly`; codly imported by the theme; `#local(breakable: true)` for a block that
    splits],
  [the theme has its own code box, which goes on to the next page by itself (no `breakable:` needed); for codly,
    `#import "@preview/codly:2.0.0" as codly` and `ufac-theme(codly: codly)`],
  [`#icon("rocket")` and the other Octicons], [only the icons of the theme; another one comes from its collection:
    `#provide-icons(json("octicon.json"))` in a slide and `#icon("octicon:rocket-16")` (@icons)],
  [`ufac-logo-image(..)`], [`#info("logo", height: 2em)`, with `white: true` on a dark background; outside a deck,
    `image(bytes(ufac-logo))`],
  [another package imported with `*` before the theme, such as theorion], [the theme now exports `caution`, `tip`,
    `remark`, `note`, `example`, `examples`, `solution`, `answer`, `info` and `tag`, which win over the names of the
    package it shares (theorion's `example`, `remark`, `solution`): import that package by its name
    (@integrations)],
)

A label `<empty-slide…>` of 0.2.0 is now an ordinary label, so its slide becomes an ordinary one, with its header:
look for these labels in the deck. The blue page of the cover, with the footer, is `#ending-slide(title: none)[..]`
(@cover); a page without header or footer is Touying's `#empty-slide[..]` (the deck imports Touying), which takes
neither `color:` nor `title:`, so a page of another color sets its fill and the color of its text:

```typ
#empty-slide(config: config-page(fill: colors.tertiary))[
  #set text(fill: white)
  #align(center + horizon)[*Break*: 15 minutes]
]
```

A `==` without text gives a slide without a title, with the footer.

The figure of a section, which 0.2.0 cropped to fill 12em × 66% of the slide, now fits whole in that frame; a deck
needs no change for it.

A figure caption, at the size of the text in 0.2.0, is now 0.6 of it. A deck that made its captions smaller by hand
with a size in `em`, as `#show figure.caption: set text(size: 0.6em)` or a `text(size: 0.6em)[..]` in the caption,
drops that, or they get smaller twice.

= Reference <reference>

Every function and variable of the theme, with the type of each parameter, its default and its description. The
chapters above show how to use them.

== The theme and the slides

#reference("ufac", "ufac-theme", "title-slide", "slide", "new-section-slide", "ending-slide", "exercise-slide",
  "example-slide", "solution", "answer")

== The information of the deck

#reference("info", "info")

== Boxes and emphases

#reference("components", "emph-box", "eq-box", "callout", "caution", "tip", "remark", "note", "example", "examples",
  "tag", "quote-box", "alert", "primary", "secondary", "tertiary", "quaternary")

== Lists, columns and the outline

#reference("components", "arrows", "cols", "outline")

== Code

#reference("code", "code-languages", "ufac-syntax", "codly-ufac-theme")

== Icons

#reference("components", "icon")
#reference("icons", "theme-icons", "provide-icons")

== Colors and logo

#reference("constants", "colors", "ufac-logo")

= Index of definitions <index>

#index()
