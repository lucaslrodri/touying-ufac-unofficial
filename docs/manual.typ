// touying-ufac-unofficial manual (PDF), in one file: every `=` heading is a chapter. Build with `sh docs/build.sh`,
// which also renders the slide examples.
#import "template.typ": *

#show: project.with(
  title: package.name,
  subtitle: package.description,
  authors: ("Lucas Lima Rodrigues",),
  abstract: [
    A #link("https://touying-typ.github.io/")[Touying] theme for lecture slides, following the visual identity of
    the #link("https://www.ufac.br/")[Federal University of Acre]. Slides are written with headings and a few
    Markdown-like shorthands for boxes, quotations, arrow lists and emphases. This manual is set with the rules of
    the theme itself.
  ],
  url: package.repository,
  date: datetime.today().display("[month repr:long] [day], [year]"),
  version: package.version,
)
// the look of the chapters: the theme rules and the example blocks (`chapter` in template.typ)
#show: chapter

= Quick start <quick-start>

A deck imports Touying and the theme, applies `ufac-theme` and usually starts with the cover:

```typ
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *
```

#slide-example("cover")

`typst init @preview/touying-ufac-unofficial:0.3.0` creates a deck from the package template, and `example/main.typ`
shows the elements of the syntax in a short deck. From here on, every example shows the source on the left and the result on
the right: a real slide when the feature belongs to the slide (headers, pills, continuations), otherwise the content
alone, laid out by the same rules as in a deck.

== The information of the deck

`config-info` is Touying's; the theme reads these fields:

#table(
  columns: (auto, auto, 1fr),
  table.header([Field], [Default], [What it is and where it appears]),
  [`title`], [`[]`], [the name of the course or of the work: large on the cover, and in the footer],
  [`short-title`], [`none`], [its code or a shorter name: before the title in the footer ("CODE • TITLE")],
  [`subtitle`], [`[]`], [the topic of the lecture: on the cover],
  [`short-subtitle`], [`none`], [the lecture or the unit ("Lecture 1", "Unit II"): on the cover, in yellow],
  [`author`], [`none`], [one, an array or free content (below): on the cover and on the right of the footer],
  [`date`], [`none`], [`auto` (today), a `datetime` (written in full in the language of the deck) or a text],
  [`institution`], [`auto`], [one or an array; `auto` is the Universidade Federal do Acre; only for `#info`],
  [`logo`], [`auto`], [one or an array, in the footer and on the cover (see Logos below)],
  [`contact`], [`none`], [one or an array (an e-mail, a page)],
  [`counter-prefix`], [`[1.]`], [prefix of the exercise and example numbers: `[1.]` gives "Exercise 1.N", `none` gives "Exercise N"],
)

In a course, some fields have clearer names, which are aliases of the fields above (two names of one field are an
error). A date given as `semester` or `year` is short, and also goes to the footer, after the title.

#table(
  columns: (auto, auto),
  table.header([Alias], [Field]),
  [`subject`], [`title`], [`subject-code`], [`short-title`], [`unit`], [`short-subtitle`], [`unit-title`], [`subtitle`],
  [`course` (the program, in a final paper)], [`short-subtitle`], [`semester`, `year`], [`date`],
)

`kind` tells what the presentation is, and brings the recommended style of the cover, the label of the authors and the
tag of the cover; anything the deck writes wins over it.

#table(
  columns: (auto, 1fr),
  table.header([`kind`], [Recommends]),
  [`"lecture"`, `"talk"`], [the style `"line"`],
  [`"course"`], [the style `"top"` and the label "Ministrantes" / "Instructors" over the authors],
  [`"coursework"`], [the style `"stack"`],
  [`"tcc"`, `"dissertation"`, `"thesis"`], [the style `"top"` and the tag of the work ("Trabalho de Conclusão de Curso", …)],
)

An author can be written as free content: the lines broken with `\`, and a line only in emphasis is a label. The
cover shows it as written; the footer and the metadata of the PDF get the names of the first group, those who present.

```typ
config-info(author: [_Students_ \ First Author \ Second Author \ _Advisor_ \ Prof. Dr. Advisor Name])
```

#reference("info", "info")

== The theme and the cover

#reference("ufac", "ufac-theme", "title-slide")

The cover has three bands: the logos at the top left, the titles in the centre and the authors and the date at the bottom.
The `style` decides where the authors and the date go: `"line"` (the default) puts them on one line at the bottom,
with the white line of the footer passing between them; `"stack"` puts the
authors on several lines at the bottom left; `"top"` puts them at the top right and the date in the centre of the
bottom. Each of the six positions can be changed on its own, with content, `none`, a function of `self` or `#info`.

#slide-example("cover-styles", pages: (1, 2, 3, 4))

The background of the cover and of the closing slide is a parameter of the theme: `"circles"` (the default),
`"gradient"` or `"plain"`. A `kind` brings the recommended style, label and tag; an author written as free content
keeps its lines and labels on the cover.

#slide-example("cover-background")

Content given to the cover goes below the titles, in white, as in a pill: a message, where to find the slides, a
contact, a partner's logo.

#slide-example("cover-body")

== Logos

The footer and the cover show the UFAC logo. `config-info(logo:)` is the list of logos shown there, separated by dots: `(auto, x)`
keeps the UFAC logo and adds `x` after it, `(x,)` replaces it and `none` removes them. A logo is content, or a
function that receives the colour of the footer (blue on the slides, white on the cover), so that one drawing serves
both; `auto` stands for the UFAC logo. A logo about `0.64em` high matches the UFAC one. Outside the footer, as in a
handout that goes with the slides, `ufac-logo-image` draws the UFAC logo in the same colours (@colors).

#slide-example("logos", pages: (1, 2))

== Language

The theme speaks Portuguese by default (`lang: "pt-br"`): Exercício, Exemplo, Parte. `lang: "en"` or `"es"` switches
the text language and those three names, and each name can still be overridden.

#slide-example("lang", pages: (1, 2))

== Dependencies <dependencies>

#let sources = ("lib.typ", "ufac.typ", "components.typ", "utils.typ", "icons.typ", "code.typ").map(f => read("../src/" + f)).join()
#let found = sources.matches(regex("@preview/([a-z0-9-]+):([0-9.]+)")).map(m => m.captures).dedup().sorted()
#let roles = (
  touying: [the slide engine; the deck imports it too, with the same version],
  iconify: [the icons of a collection the deck provides (`provide-icons`); the theme's own icons are shipped with it],
)

The versions below are read from the sources of the package, so this table cannot go stale. They are fetched
automatically by Typst. touying 0.8 requires Typst 0.15; this version stays on 0.7.4, which also works with Typst 0.14.
codly is optional: a deck that wants it imports codly 2 itself and passes it to the theme (see @code).

#table(
  columns: (auto, auto, 1fr),
  table.header([Package], [Version], [Role]),
  ..found.map(((name, version)) => (
    link("https://typst.app/universe/package/" + name, raw(name)), raw(version), roles.at(name, default: []),
  )).flatten(),
)

#let tidy-version = read("template.typ").match(regex("@preview/tidy:([0-9.]+)")).captures.first()

Besides the packages, the theme needs *Typst #package.compiler or later* and the font *New Computer Modern Sans*
installed on the system (it is not bundled with Typst, unlike *New Computer Modern Math*, used for the equations). Building this manual also takes
#link("https://typst.app/universe/package/tidy")[tidy] #tidy-version, and the test suite runs on
#link("https://typst-community.github.io/tytanic/")[Tytanic] 0.4.1.

= Slides and headings <slides>

Headings drive the deck: no function call is needed for the ordinary slides.

#table(
  columns: (auto, 1fr),
  table.header([Markup], [Effect]),
  [`= Title`], [section slide "Part N: Title"; what follows the heading goes to the right],
  [`== Title`], [new slide with a blue header, fitted to the width],
  [`== Title <exercise>`], [exercise slide: red pill with a pencil, "Exercise 1.N — Title", numbered automatically],
  [`== Title <example>`], [example slide: green pill with a beaker, "Example 1.N — Title", with its own counter],
  [`=== Subtitle`], [blue pill; no new slide; repeated at the top of every continuation page],
  [`==== Subtitle`], [the same pill, not repeated],
  [`---`], [alone on a line: next page of the same slide (same header, same number)],
)

== Sections

Every `=` heading opens a section slide, as the cover in white: "PART N" in the yellow tag (the name follows the
language of the deck, or `ufac-theme(part-name:)`), the title in blue and the yellow rule. The content right after the
`=`, typically an image, sits on the right, at the page margin from the edge.

#slide-example("section")

A photo or a figure with a background looks better flush with the edge: `section-margin: false` in `ufac-theme` puts
it there on every section slide, and a length sets another distance.

#slide-example("section-margin")

== Outline

`#outline()` lists the parts of the deck, the `= Title` headings, with their numbers in small pills, the titles in
bold blue and the number of the slide where each one starts, the number its footer shows; every line is a link to
that slide. It usually takes a
slide of its own, right after the cover. In a deck it stands for Typst's `outline`, which is still there as
`std.outline`.

#slide-example("outline")

#reference("components", "outline")

== Slides and continuations

#slide-example("heading", pages: (1, 2))

#emph-box(color: colors.tertiary, title: [Caution])[
  Touying breaks the page at _any_ top-level em dash, so an em dash next to inline markup, as in
  `Text — *bold*`, also starts a new page. Use an en dash or wrap the paragraph in `#[ ]`.
]

== Exercises and examples

A label on the `==` heading turns the slide into the box of an exercise (red) or an example (green), as in a printed
handout: the box fills the slide, the title goes on a badge over its top border, with the icon of the kind
(a pencil for exercises, a beaker for examples), the name, the number and, after a dash, the title, and the footer of
the slide closes the box at the bottom, in the colour of the item. Any suffix gives the same slide and makes the label
unique, so the slide can be cited: `@exercise-ogata` becomes "Exercise 1.N", bold, in the color of the kind and linked
to the slide. `#exercise-slide` and `#example-slide` are the function forms, with `color` and `icon` options; they
cannot be cited.

Inside the box, only what has no style of its own takes the colour of the item: the bold text, the markers, the arrows,
the highlights, the numbers of the lists, the inline code, the links and the pills of the `===` and `====` subtitles. A code block, a callout and an `emph-box`
keep their own look.

`#solution` (in an example) and `#answer` (in an exercise), alone on a line like `#pause`, open the solution: a dashed
line and "Solution." / "Answer." in bold. With a `#pause` right before or after the marker, the solution appears on
the next subslide. An exercise or example can take several pages: a content longer than one page goes on to the next
one by itself, in the same box, with the same number and the `===` subtitle; a `---` or a `#pagebreak()` breaks the page
by hand. The item goes on until a slide of another kind.

The icon is the name of an `icon`, any content (an image) or `none`, which leaves only the text. It is centered on the
capitals of the text, whatever its height. `ufac-theme(exercise-icon:, example-icon:)` changes it in the whole deck;
`icon:` changes it on one slide.

#slide-example("exercise", pages: (1, 2, 3, 4, 5, 6))

#reference("ufac", "exercise-slide", "example-slide", "solution", "answer")

== Subtitles

A `===` subtitle is repeated on the pages that continue the slide, unless the continuation starts with another
`===`. That holds for `---`, for `#pagebreak()` and for content that overflows by itself.

#slide-example("subtitle", pages: (1, 2))

#slide-example("overflow", pages: (1, 2))

Only a top-level `===` is repeated; inside `#[ ]`, a column or a box the pill stays in the flow.
`config-common(breakable: false)` makes Touying warn about overflow instead.

== Slide functions

`#slide` is the slide that every `==` opens; calling it gives access to Touying's arguments, such as `composer`. A
`==` heading without text gives a slide without a title, with the footer. `#title-slide()` is the cover, shown in
@quick-start; `#title-slide[..]` adds content below its titles.

#slide-example("slides", pages: (1, 2))

=== The closing slide: `#ending-slide`

`#ending-slide` closes the deck on the blue page of the cover: a large title with the yellow rule, a subtitle in
yellow, a free body and the contact of `config-info` right below them, and the footer of the slides in white, with the
logos. Without a title it says "Obrigado!" / "Thank you!" in the language of the deck. The labels
`<empty-slide>` and `<empty-slide-primary>` of 0.2.0 are gone; Touying's own `#empty-slide` (no header nor footer) is
still there for whoever imports Touying.

#slide-example("ending-slide", pages: (1, 2, 3), columns: (1fr, 1fr))

#reference("ufac", "slide", "ending-slide", "new-section-slide")

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

Bold text, alerts, highlights, underlines, arrows, chips, links, icons and the pills of the `===` and `====`
subtitles read the color of what contains them: the box color inside an `emph-box`, a callout, an exercise or an
example and a light cell of a table; white or yellow inside a pill, where the pill color would hide them. What has a
style of its own keeps it: a code block, and a box inside another box, which brings its own color.

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

= Lists and terms <lists>

== Arrow lists

Consecutive lines starting with `->` become one list with a blue arrow. The list has to start the paragraph: a blank
line comes before the first `->`. An arrow in the middle of a line and the math arrow are left alone.

```example
-> consequence
-> another consequence

Here a -> b stays text, and $a -> b$ is math.
```

#reference("components", "arrows")

== Bullet lists

Three levels of yellow markers: a filled square, a rotated hollow square and a small circle.

```example
- first level
  - second level
    - third level
- first level again
```

== Numbered lists

Numbers are always blue and bold: `1.`, `a)`, `i.` by level. `#set enum(numbering: "a)")` starts at `a)` instead and
keeps the colors. Typst only knows `+` and `1.` as enum markers in markup, so `a)` at the start of a line is text.

```example
+ first
  + nested
    + deeper
+ second

#[
  #set enum(numbering: "a)")
  + starts at a)
    + then i.
]
```

== Terms

```example
/ Epoch: one pass over the training set.
/ Batch: the samples of one update.
```

= Boxes and quotes <boxes>

== Emphasis boxes

#reference("components", "emph-box")

```example
#emph-box[A definition, in the primary color.]

#emph-box(color: colors.tertiary, title: [Problem])[
  The gradient *vanishes* and ~stalls~.

  -> the arrow is red too
]

#emph-box(color: colors.quaternary, icon: "light-bulb", title: [Tip])[
  An `icon` before the title, as in the exercise pills.
]
```

== The box shorthand

A paragraph whose lines start with `>` is a box in the primary color; a first line `> == Title` gives the title.

```example
> A box without title, with *bold* and $x^2$.

> == Definition
> A box with a title.
> The second line flows on.
```

#emph-box(color: colors.secondary, title: [Limits of the shorthand])[
  Only inline content fits: lists and code blocks need `#emph-box`, and `>` before a block equation is an `eq-box`.
  A loose `>` at the start of a paragraph is read as a box: write `$a > b$`, or escape it (@escapes).
]

== Equation boxes

#reference("components", "eq-box")

#emph-box(color: colors.secondary, title: [Why the dollar signs inside])[
  A content block inside an equation is markup, not math: `#eq-box[x = 2]` would be the upright text "x=2", and an
  underscore or an asterisk in it would not even parse. `eq-box` refuses such a body with a hint. `> $x$`, with an
  inline equation, is an ordinary box: the shorthand takes a block equation.
]

== Callouts

A warning, a tip, a remark or a note, each with its colour, icon and title in the language of the deck. The default
style is the box of a printed handout, with a bar on the left and the title opening the text; `style: "badge"` gives an
emphasis box with the title on a badge.

#reference("components", "callout")

== Tags

The yellow tag of the cover and of the section slides is an element of its own, for the text, the titles and the tables:
a short label in spaced capitals, on any colour.

#reference("components", "tag")

== Quotations

#reference("components", "quote-box")

```example
"All models are wrong"
"but some are useful"

A sentence with a "quotation" inside.

#quote(attribution: [George Box])[
  All models are wrong.
]
```

= Columns <columns>

#reference("components", "cols")

```example
#cols[Left][Middle][Right]
```

Touying's `side-by-side` (no divider) is still available, and `#slide(composer: (1fr, 2fr))[..][..]` lays out the
bodies of a whole slide.

= Colors and logo <colors>

Five families of seven tones. The light tones serve as fills of highlights and boxes, the dark ones as text on white.

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

The tones are derived from the base in RGB: `darken(75%)`, `darken(55%)`, `darken(30%)`, the base, `lighten(30%)`,
`lighten(60%)` and `lighten(85%)`. The neutral family follows Touying's default instead, from black to white.

```example
#highlight(fill: colors.tertiary-lighter)[red fill]
and #text(fill: colors.primary-dark)[dark blue text].
```

#reference("constants", "colors")

The UFAC logo comes with the theme, as its SVG (`ufac-logo`) and as an image in the colours the theme uses
(`ufac-logo-image`): blue lettering with the yellow shield in the footer, white lettering on the cover, and all white
on a background where the yellow would not stand out, such as the cover of a handout that goes with the slides.

#reference("constants", "ufac-logo")
#reference("constants", "ufac-logo-image")

= Tables, figures, math, code and icons <elements>

== Tables

The header row is blue with white text, and formulas in it turn white too. Code chips follow the background, as in
the pills and boxes: in the header they are inverted (dark blue with light text). A cell filled with a light tone of a
family of `colors` (`table.cell(fill: colors.secondary-lighter)`) is like a box of the family's `-dark` color, which
colors its chips and `*bold*`; a cell filled with a dark tone (`colors.primary`, `colors.tertiary-dark`) is like a
pill, with white text and inverted chips. White and colors outside the palette change nothing.

```example
#table(
  columns: 3,
  table.header([Model], [Layers], [$eta$]),
  [MLP], [3], [0.1],
  [CNN], [8], [0.01],
)
```

== Figures and math

A figure caption shows its body only, without "Figure N". Math uses New Computer Modern Math, and block equations
sit closer to the text than Typst's default. For a framed key equation, see `eq-box` in @boxes.

```example
#figure(
  rect(width: 60%, height: 3em, fill: colors.primary-lightest),
  caption: [The caption, without a number.],
)

The update rule is
$ bold(w) <- bold(w) - eta nabla E(bold(w)) $
```

== Code <code>

Inline `raw` is the chip of @inline. The theme does not depend on codly: a code block goes in the box of the theme, a
light blue fill with a bar on the left and square corners, at 0.75em, with the line numbers on the left (a long line
wraps and continues under the code), the language in a white pill with its logo at the top right and the syntax colours
of the theme (`ufac-syntax`). The output of a program, a block in `text`, goes in a green box without numbers. A block
never splits across pages, and inside a coloured box (an `emph-box`, an exercise) it keeps its look. The languages with a
pill are `python`, `typst`, `matlab`, `bash` and `text`; a block in another language has no pill, and
`ufac-theme(code-languages:)` adds languages.

#slide-example("code")

With codly 2, the deck imports it and passes it to the theme, `ufac-theme(codly: codly)`: every block goes through
codly with the same look, and codly's own features (a file name, highlights, ranges, `diff`) are at hand through its
functions (`codly.new(..)`, `codly.set_(..)`). The theme never imports codly; codly 2 requires Typst 0.15.

#slide-example("code-codly")

#reference("code", "code-languages", "codly-ufac-theme", "ufac-syntax")

== Icons

#reference("components", "icon")

```example
#emph-box(color: colors.tertiary)[
  #icon("warning") takes the box color.
]
```

The theme ships only the icons it uses, from #link("https://primer.style/octicons/")[Octicons] (© GitHub Inc., MIT
license), #link("https://phosphoricons.com/")[Phosphor] (MIT license),
#link("https://devicon.dev/")[Devicon] (MIT license) and #link("https://simpleicons.org/")[Simple Icons] (CC0); each
one has a role in the theme, which is also its name for `#icon`:

#{
  set text(size: 6.5pt)
  set par(justify: false)
  grid(
    columns: (1fr,) * 5, row-gutter: .75em, column-gutter: .5em,
    ..theme-icons.pairs().map(((name, full)) => [#icon(name, size: 1.5em) #h(.3em) #name #text(fill: luma(120))[(#full)]]),
  )
}

The Octicons of the theme keep their 0.2.0 names (`"alert"`, `"light-bulb"`, `"info"`, `"note"`, `"pencil"`, `"beaker"`,
`"file-code"`, `"terminal"`, `"mail"`). Any other icon comes from a collection in the JSON format of
#link("https://iconify.design/")[Iconify], given to `provide-icons` and written as `"collection:name"`:

- *The whole collection*: download its JSON from the site of the
  #link("https://typst.app/universe/package/iconify")[iconify package] (some are several megabytes).
- *Only the chosen icons*: ask the Iconify API for them, such as
  `https://api.iconify.design/octicon.json?icons=rocket-16,tools-16`, and save the answer as `octicon.json`.

```typ
#provide-icons(json("octicon.json"))
#icon("octicon:rocket-16") launch
```

The names of a collection are on #link("https://icones.js.org/")[icones.js.org]. An Octicon of 0.2.0 that the theme no
longer ships, such as `#icon("rocket")`, is written `#icon("octicon:rocket-16")` with its collection provided.

#reference("icons", "theme-icons", "provide-icons")

= Touying features <touying>

The theme sits on Touying and leaves its features alone. Animations work on every element of the theme: covered
content stays faintly visible under a veil in the page color.

#slide-example("pause", pages: (1, 2, 3))

#emph-box(color: colors.secondary)[
  Keep `#pause` and `#uncover`/`#only` in separate paragraphs: within one paragraph Touying reorders the covered
  part on the first subslide.
]

Available without any wrapper from the theme:

#table(
  columns: (auto, 1fr),
  table.header([Feature], [Functions]),
  [Animations], [`#pause`, `#meanwhile`, `#jump`, `#uncover`, `#only`, `#alternatives`, `#item-by-item`, `#effect`, `#touying-raw`],
  [Notes and handouts], [`#speaker-note` (it attaches to the previous slide), `#handout-only`, `config-common(handout: true)`],
  [Layout], [`#slide(composer: (1fr, 2fr))`, `#cols`, `components.adaptive-columns`, `components.full-width-block`, `utils.fit-to-width`, `utils.fit-to-height`],
  [Overflow], [`config-common(breakable: false, clip:, detect-overflow:)`],
  [Reuse], [`#touying-recall`, `touying-get-config`, `components.progressive-outline`],
)

Slides of other Touying themes that this one does not have: `outline-slide` (here, a slide with `#outline()`, see
@slides), `focus-slide`, `ending-slide` and `matrix-slide`.

= Index of definitions <index>

The reference of every function and variable sits in the chapter that introduces it; it is generated from the
doc-comments of the package with #link("https://typst.app/universe/package/tidy")[tidy]. Names that start with an
underscore are internal and left out.

#index()
