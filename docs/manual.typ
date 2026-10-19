// touying-ufac-unofficial manual (PDF), in one file: every `=` heading is a chapter. Build with `sh docs/build.sh`,
// which also renders the slide examples.
#import "template.typ": *
#import "../src/icons.typ" as icons

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
#import "@preview/touying-ufac-unofficial:0.2.0": *
```

#slide-example("cover")

`typst init @preview/touying-ufac-unofficial:0.2.0` creates a deck from the package template, and `example/main.typ`
shows the elements of the syntax in a short deck. From here on, every example shows the source on the left and the result on
the right: a real slide when the feature belongs to the slide (headers, pills, continuations), otherwise the content
alone, laid out by the same rules as in a deck.

== The information of the deck

`config-info` is Touying's; the theme reads these fields:

#table(
  columns: (auto, 1fr),
  table.header([Field], [Where it appears]),
  [`subject`], [first line of the cover (large, white) and left side of the footer],
  [`subtitle`], [second line of the cover, in yellow],
  [`title`], [third line of the cover, in white],
  [`author`], [top right of the cover and right side of the footer],
  [`subject-code`], [before the subject in the footer: "CODE · SUBJECT"],
  [`counter-prefix`], [prefix of the exercise and example numbers: `[1.]` gives "Exercise 1.N", `none` gives "Exercise N"],
)

== The theme and the cover

#reference("ufac", "ufac-theme", "title-slide")

Content given to the cover goes below the titles, in white, as in a pill: a partner's logo, the name of a lab or
of a program.

#slide-example("cover-body")

== Logos

The footer and the cover show the UFAC logo; `logos` puts others after it, separated by dots. A logo is content, or a
function that receives the colour of the footer (blue on the slides, white on the cover), so that one drawing serves
both; `auto` stands for the UFAC logo. A logo about `0.64em` high matches the UFAC one. Outside the footer, as in a
handout that goes with the slides, `ufac-logo-image` draws the UFAC logo in the same colours (@colors).

#slide-example("logos", pages: (1, 2))

== Language

The theme speaks Portuguese by default (`lang: "pt-br"`): Exercício, Exemplo, Parte. `lang: "en"` or `"es"` switches
the text language and those three names, and each name can still be overridden.

#slide-example("lang", pages: (1, 2))

== Dependencies <dependencies>

#let sources = ("lib.typ", "ufac.typ", "components.typ", "utils.typ").map(f => read("../src/" + f)).join()
#let found = sources.matches(regex("@preview/([a-z0-9-]+):([0-9.]+)")).map(m => m.captures).dedup().sorted()
#let roles = (
  touying: [the slide engine; the deck imports it too, with the same version],
  codly: [code blocks; its functions are re-exported by the theme],
  linguify: [localized names (Exercise, Example, Part)],
)

The versions below are read from the sources of the package, so this table cannot go stale. All of them are the
latest releases at the time of writing and are fetched automatically by Typst.

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

The content right after a `=` heading, typically an image, sits on the right, flush with the page edge, which suits
a photo or a figure with a background.

#slide-example("section")

An image without a background or an icon looks better away from the edge: `section-margin: true` in `ufac-theme`
keeps the page margin on every section slide, and a length sets another distance. On a single slide,
`#pad(right: 1.8em)[#image(..)]` does the same.

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

A label on the `==` heading turns the header into a numbered pill: the icon of the kind (a pencil for exercises, a
beaker for examples), the name, the number and, after a dash, the title. Any suffix gives the same slide and makes the
label unique, so the slide can be cited: `@exercise-ogata` becomes "Exercise 1.N", bold, in the color of the kind and
linked to the slide. `#exercise-slide` and `#example-slide` are the function forms, with `color` and `icon` options;
they cannot be cited.

The icon is the name of an `icon`, any content (an image) or `none`, which leaves only the text. It is centered on the
capitals of the text, whatever its height. `ufac-theme(exercise-icon:, example-icon:)` changes it in the whole deck;
`icon:` changes it on one slide.

#slide-example("exercise", pages: (1, 2, 3, 4, 5))

#reference("ufac", "exercise-slide", "example-slide")

== Subtitles

A `===` subtitle is repeated on the pages that continue the slide, unless the continuation starts with another
`===`. That holds for `---`, for `#pagebreak()` and for content that overflows by itself.

#slide-example("subtitle", pages: (1, 2))

#slide-example("overflow", pages: (1, 2))

Only a top-level `===` is repeated; inside `#[ ]`, a column or a box the pill stays in the flow.
`config-common(breakable: false)` makes Touying warn about overflow instead.

== Slide functions

`#slide` is the slide that every `==` opens; calling it gives access to Touying's arguments, such as `composer`.
`#empty-slide` drops the header and keeps the footer. `#title-slide()` is the cover, shown in @quick-start; `#title-slide[..]` adds content below its titles.

#slide-example("slides", pages: (1, 2))

=== Closing and transition slides: `<empty-slide>`

A `==` heading labelled `<empty-slide>` opens an `#empty-slide` with the heading as its title, large and centered,
and the content centered below it. `<empty-slide-primary>` paints the page in that color of the palette; any key of
`colors` works (`<empty-slide-secondary>`, `<empty-slide-tertiary-dark>`, …). On a dark color the text and the
footer turn white, and bold, code and icons follow the pill convention; on a light one (`secondary`, the `-lighter`
tones) they stay as on a white slide. The function form is `#empty-slide(color: colors.primary, title: [..])[..]`.

#slide-example("empty-slide", pages: (1, 2, 3, 4, 5, 6), columns: (1fr, 1fr))

#reference("ufac", "slide", "empty-slide", "new-section-slide")

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
the pills and boxes: in the header they are inverted (dark blue with light text); in a cell filled with a tone of a
family of `colors` (`table.cell(fill: colors.secondary-lighter)`) they take the tones of the family's `-dark` color,
which also colors `*bold*` there.

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

== Code

Inline `raw` is the chip of @inline. Code blocks go through codly: a gray box, gray line numbers, no zebra, never
split across pages unless `#local(breakable: true)[..]` (or `codly(breakable: true)`) allows it; the box then splits
with the lines. The theme re-exports codly, and its `local` wraps codly's for per-block settings;
`#codly-range(..)` and `#no-codly[..]` work as usual. The languages with a label are `python`, `typst`, `bash` and
`text` (labelled "saída").

#slide-example("code")

#reference("components", "local")

#reference("constants", "code-languages")

== Icons

#reference("components", "icon")

```example
#emph-box(color: colors.tertiary)[
  #icon("alert") takes the box color.
]
```

The 320 names, from #link("https://primer.style/octicons/")[Octicons] (© GitHub Inc., MIT license):

#{
  set text(size: 6.5pt)
  set par(justify: false)
  grid(
    columns: (1fr,) * 5, row-gutter: .75em, column-gutter: .5em,
    ..icons.data.keys().sorted().map(name => [#icon(name, size: 1.5em) #h(.3em) #name]),
  )
}

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
