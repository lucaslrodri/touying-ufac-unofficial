# touying-ufac-unofficial

<p align="center">
  <a href="https://typst.app/universe/package/touying-ufac-unofficial"><img src="https://img.shields.io/badge/dynamic/toml?url=https%3A%2F%2Fraw.githubusercontent.com%2Flucaslrodri%2Ftouying-ufac-unofficial%2Fmain%2Ftypst.toml&amp;query=%24.package.version&amp;label=Typst%20Universe&amp;logo=typst&amp;color=239dad" alt="Version on Typst Universe"></a>
  <a href="https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/docs/manual.pdf"><img src="https://img.shields.io/badge/manual-PDF-orange" alt="Manual (PDF)"></a>
  <a href="https://typst.app/"><img src="https://img.shields.io/badge/dynamic/toml?url=https%3A%2F%2Fraw.githubusercontent.com%2Flucaslrodri%2Ftouying-ufac-unofficial%2Fmain%2Ftypst.toml&amp;query=%24.package.compiler&amp;prefix=%E2%89%A5%20&amp;label=Typst&amp;logo=typst&amp;color=239dad" alt="Minimum Typst version"></a>
  <a href="https://typst.app/universe/package/touying"><img src="https://img.shields.io/badge/Touying-0.7.4-blue" alt="Touying version: 0.7.4"></a>
  <a href="https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/LICENSE"><img src="https://img.shields.io/badge/license-MIT%20AND%20MIT--0-green" alt="License: MIT and MIT-0"></a>
</p>

<p align="center">
  <em><a href="https://touying-typ.github.io/">Touying</a> slide theme in <a href="https://typst.app/">Typst</a> for the <a href="https://www.ufac.br/">Federal University of Acre (UFAC)</a>, Brazil.</em>
</p>

## Basic usage

```sh
typst init @preview/touying-ufac-unofficial:0.3.0
```

creates a deck from [template/main.typ](template/main.typ), the cover and one slide. The font *New Computer Modern Sans* must be installed (see [Dependencies](#dependencies)).

<!-- template:begin (generated from template/main.typ by scripts/readme.sh: do not edit by hand) -->
```typst
// Starting deck for the touying-ufac-unofficial theme. Syntax: package README; every element: example/main.typ.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *

#show: ufac-theme.with(
  aspect-ratio: "16-9",
  lang: "en",   // "pt-br" (default), "en" or "es"
  config-info(
    title: [Subject name],                    // or `subject:`
    short-title: [CODE or Department],        // or `subject-code:`
    subtitle: [Title of the teaching unit],
    short-subtitle: [Teaching unit I],
    author: [Prof. Dr. Your Name],
    counter-prefix: [1.],   // "Exercise 1.N"; none gives "Exercise N"
  ),
)

#title-slide()

== Slide title
=== Subtitle

Text.
```

![The 2 pages of template/main.typ](https://raw.githubusercontent.com/lucaslrodri/touying-ufac-unofficial/v0.3.0/docs/readme/template.png)
<!-- template:end -->

`config-info` (Touying's) fills the cover and the footer:

| Field | What it is and where it goes |
| ----- | ---------------------------- |
| `title` | the course or the work: large on the cover; footer, on the left ("CODE • TITLE") |
| `short-title` | its code or a shorter name: the yellow tag of the cover; footer, before the title |
| `subtitle` | the topic: on the cover |
| `short-subtitle` | the lecture or the unit: on the cover, in yellow |
| `author` | one, an array or free content (`[_Advisor_ \ Name]`: lines and labels in emphasis): on the cover; footer, on the right (the first group) |
| `date` | `none`, `auto` (today), a `datetime` (in full, in the language of the deck) or a text |
| `institution` | `auto` (the Federal University of Acre) or an array; only for `#info` |
| `logo` | the logos of the footer and of the cover: `auto` is the UFAC logo; an array, in order, separated by dots; each one content, `color => ...` or `auto` |
| `contact` | on the closing slide |
| `counter-prefix` | "Exercise 1.N" / "Example 1.N"; `none` gives "Exercise N" |

Aliases in the words of a course: `subject` (`title`), `subject-code` (`short-title`), `unit` and `course` (`short-subtitle`), `unit-title` (`subtitle`), `semester` and `year` (`date`, which then also goes to the footer). `kind` (`"lecture"`, `"course"`, `"coursework"`, `"talk"`, `"tcc"`, `"dissertation"`, `"thesis"`) brings the recommended style of the cover, label of the authors and tag; what the deck writes wins. `#info("title")` (any field or alias, or `#info(i => ..)`) shows them anywhere.

Options of `ufac-theme`: `aspect-ratio` (`"16-9"`, `"4-3"`, anything Touying's `utils.page-args-from-aspect-ratio` accepts), `lang` (`"pt-br"`, `"en"` or `"es"`), `background` of the cover and of the closing slide (`"circles"`, the default, `"gradient"` or `"plain"`), `exercise-name`, `example-name` and `part-name` (override the localized names), `exercise-icon` and `example-icon` (the icon on the badge of the exercises and examples: the name of an icon, content or `none`; a pencil and a beaker by default), `footer-left` and `footer-right` (content or `self => ...`), `section-margin` (`true`, the default, keeps the page margin to the right of the content of the section slides; `false` puts it flush with the edge, for a photo; a length sets the distance), `codly` (the module of codly 2, when the deck imports it) and `code-languages` (more languages for the code blocks).

## Example

[example/main.typ](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/example/main.typ) shows the elements of the [syntax](#syntax) in a short deck:

<!-- example:begin (generated from example/main.typ by scripts/readme.sh: do not edit by hand) -->
```typst
// Example deck of the touying-ufac-unofficial theme: the elements of the syntax at a glance (details: package README).
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *

#show: ufac-theme.with(
  aspect-ratio: "16-9",
  lang: "en",                         // "pt-br" (default), "en" or "es": text language and pill/section names
  // exercise-name: [Exercise], example-name: [Example], part-name: [Part],   // override the localized names
  config-info(
    title: [Subject name],
    short-title: [CODE or Department],
    subtitle: [Title of the teaching unit],
    short-subtitle: [Teaching unit I],
    author: [Prof. Dr. Your Name],
    counter-prefix: [1.],
  ),
)

#title-slide()

= Name of the first section
// Content right after `=` goes to the right of the section slide, flush with the page edge (usually an image):
// #image("figure.png")

== Slide title
=== Subtitle (repeated after `---`)

Text with *bold*, _italic_, ~~blue emphasis~~, ==yellow highlight== and ~underline~.

-> Item with an arrow
-> Another item

- Item
  - Sub-item
    - Sub-sub-item

> == Definition
> Box with a title (same as `#emph-box(title: [Definition])[...]`).

---

> Box without title

"A quotation in a box."


$
x^2 - 3x + 2 = 0
$

Equation box:

> $
x = {2, 1}
$

---

"A list of quotation boxes"
"Another item"
"Another item \
with 2 lines"
"Another item"
"Another item"


#cols(divider: true)[
  Column with blue divider
][
  Column 2
]

#v(3em)

#cols[Col without divider][Column 2]

== Boxes with an icon

#emph-box(color: colors.quaternary, icon: "light-bulb", title: [Tip])[
  An icon before the title: any `#icon` of the set (`"light-bulb"`, `"alert"`, …) or any content.
]

#emph-box(color: colors.tertiary, icon: "alert", title: [Caution])[
  The icon is centered on the capitals of the title, and the badge keeps the same height.
]

== Callouts
// a warning, a tip, a remark or a note: the colour, the icon and the title in the language of the deck;
// `style: "badge"` gives the look of the boxes above
#callout("warning")[A warning: `x * y` with two lists is an error.]
#callout("tip")[A tip: the up arrow recalls the last command.]
#callout("info")[A remark: a *function* is a named block of code.]
#callout("note")[A note: something secondary.]

== An exercise <exercise-a>

Statement. (Also `#exercise-slide(title: [Title])[...]`.)

== An example <example>

Citing the @exercise-a.

// closing slide: the blue page of the cover with the footer in white; `#ending-slide()` alone says "Thank you!", and
// the contact of `config-info(contact:)` goes right below the text
#ending-slide[Thank you!][Questions and suggestions][`your.name@example.com`]
```

![The 11 pages of example/main.typ](https://raw.githubusercontent.com/lucaslrodri/touying-ufac-unofficial/v0.3.0/docs/readme/example.png)
<!-- example:end -->

The deck above as a PDF: [main.pdf](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/docs/decks/main.pdf). More example decks, one for each kind of presentation, with the PDF of each one:

- [lecture](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/example/lecture.typ) ([PDF](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/docs/decks/lecture.pdf)): a lecture of a course, with the aliases of a course, an outline, exercises and examples with their solutions, code and callouts.
- [course](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/example/course.typ) ([PDF](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/docs/decks/course.pdf)): an extension course, with several instructors, the `"gradient"` background and code through codly 2.
- [tcc](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/example/tcc.typ) ([PDF](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/docs/decks/tcc.pdf)): the defence of a final paper, with the student and the advisors under labels on the cover and the `"plain"` background.
- [coursework](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/example/coursework.typ) ([PDF](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/docs/decks/coursework.pdf)): a paper for a course, with the students and the teacher in groups on the cover (the style `"stack"`).

## Syntax

### Headings and slide breaks

| Markup                          | Effect                                                                                       |
| ------------------------------- | -------------------------------------------------------------------------------------------- |
| `= Title` + `#image(...)`       | Section slide "Part N: Title" (`Parte` in Portuguese and Spanish); the content right after `=` sits on the right, flush with the page edge (`section-margin: true` in `ufac-theme`, or `#pad(right: 1.8em)[...]` on one slide, keeps the margin) |
| `== Title`                      | New slide with a blue header                                                                 |
| `== Title <exercise>`           | Exercise slide: a red box filling the slide, "Exercise 1.N — Title" (`Exercício`/`Ejercicio`) on a badge with a pencil, the footer closing the box; numbered automatically; `<exercise-id>` makes it citable with `@exercise-id` |
| `== Title <example>`            | Example slide: the same in green, with a beaker, "Example 1.N — Title" (`Exemplo`/`Ejemplo`), independent counter; `<example-id>` likewise |
| `#solution`, `#answer`          | Alone on a line, inside an example or an exercise: a dashed line and "Solution." / "Answer."; with a `#pause` before or after, it appears on the next subslide |
| `=== Subtitle`                  | Pill in the color of the box around it (blue on a slide), no new slide; repeated at the top of every continuation and overflow page |
| `==== Subtitle`                 | Same pill, not repeated                                                                      |
| `---` (alone on a line), `#pagebreak()` | Next page of the same slide (same header, same box, same number); a long content also goes on by itself |
| `==` (without text)            | A slide without a title, with the footer |

Functions: `#title-slide()` (`style:` `"line"`, `"stack"` or `"top"`; `header-left` … `footer-right` change each position; `#title-slide[...]` puts content below the titles: a message, a contact, a logo), `#outline()` (the parts of the deck, numbered, with their slides), `#slide[...]`, `#ending-slide[title][subtitle][body]` (the closing slide, on the blue page of the cover; without a title, "Thank you!"), `#exercise-slide(title:, color:, icon:)[...]`, `#example-slide(title:, color:, icon:)[...]`, `#ufac-logo-image(height:, color:, shield:)` (the UFAC logo in the colours of the theme, for a handout that goes with the slides). Touying's `#pause`, `#uncover`, `#only`, `#alternatives`, `#speaker-note`, `#slide(composer:)` etc. work as usual. Code blocks never split across pages; with codly 2 (`ufac-theme(codly: codly)`) codly's own options apply.

### Inline formatting

| Markup                     | Result                                                                                   |
| -------------------------- | ---------------------------------------------------------------------------------------- |
| `*text*` / `_text_`        | black bold / black italic (bold takes the box color inside `emph-box`, white inside pills) |
| `#alert[text]`, `~~text~~` | blue bold (the box color inside a box, UFAC yellow inside pills)                         |
| `==text==`, `#highlight[...]` | light-yellow background (`#highlight(fill: colors.quaternary-lighter)` for other tones) |
| `~text~`, `#underline[...]` | strong yellow underline (box color inside `emph-box`)                                   |
| `#primary`, `#secondary`, `#tertiary`, `#quaternary` | bold text in blue / yellow / red / green                       |
| `` `code` ``               | gray chip; inside titles, boxes, pills and table cells it follows the container color (inverted in the blue header and in cells of a dark palette tone, light tones in cells of a light one) |
| `#icon("name", color: auto, size: 1em)` | an icon of the theme (`"warning"`, `"tip"`, `"python"`, …) or of a collection given with `#provide-icons(json(..))`, as `"collection:name"`; colored by context |
| `#tag[text]`               | the yellow tag of the cover, for the text, the titles and the tables; `color:` for another one |

Escapes: `\==x==`, `\> text`, `-\> item`, `\~text\~`, `\"quote\"`. No shorthand is applied inside `raw`.

### Lists and terms

| Markup                                  | Result                                                    |
| --------------------------------------- | --------------------------------------------------------- |
| `-> item` (start of a paragraph)        | list with a blue `→` marker (`#arrows(color:)[...]` recolors it) |
| `- item` / `  - sub` / `    - sub`      | yellow filled square / rotated hollow square / small circle |
| `+ item` / `  + sub` / `    + sub`      | `1.` / `a)` / `i.`, blue and bold; `#set enum(numbering: "a)")` starts at `a)` |
| `/ Term: description`                   | bold term, colon, line break                              |

### Boxes, quotes and columns

```typst
#emph-box[...]                                        // thin blue border; `color:` for another family
#emph-box(color: colors.quaternary, title: [Title])[...]   // badge over the top border
#emph-box(color: colors.tertiary, icon: "alert", title: [Caution])[...]   // icon before the title (name or content)
$ #eq-box[$E = m c^2$] $                              // equation box, inside the equation (`color:` optional)
#callout("warning")[...]                              // "tip", "info", "note"; style: "badge" for the emph-box look
#quote-box(color: colors.secondary)[...]              // vertical bar on the left
#cols(divider: true, columns: (1fr, 2fr))[A][B]       // Touying's cols, optional blue divider
```

Markdown-like short forms (inline content only, always primary):

```
> Box without title.

> == Title
> Box with title.

> $ E = m c^2 $         // `>` before a block equation (same line or the line above): equation box

"A quotation."          // paragraph made only of quoted lines → one quote box per line
```

### Colors

`colors` has five families (`primary` `#0C4DA2`, `secondary` `#FFBF14`, `tertiary` `#BE1E2D`, `quaternary` `#09B081`, `neutral` `#808080`) × seven tones (`-darkest`, `-darker`, `-dark`, base, `-light`, `-lighter`, `-lightest`), e.g. `colors.primary-lighter`. The same keys are available as `self.colors.*`.

## Documentation

A full set of documentation in PDF can be found in the [repository](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/docs/manual.pdf).

## Dependencies

| Dependency | Version | Role |
| ---------- | ------- | ---- |
| [Typst](https://typst.app/) | ≥ 0.14 | compiler |
| [touying](https://typst.app/universe/package/touying) | 0.7.4 | slide engine (the deck imports it too) |
| [iconify](https://typst.app/universe/package/iconify) | 0.5.3 | the icons of a collection the deck provides (`provide-icons`); the theme's own icons are shipped with it |
| *New Computer Modern Sans* | | font, installed on the system (not bundled with Typst, unlike *New Computer Modern Math*, used for the equations) |

The packages are fetched automatically. [codly](https://typst.app/universe/package/codly) is optional: a deck that wants it imports codly 2 itself (Typst ≥ 0.15) and passes it to the theme, `ufac-theme(codly: codly)`. The font is not: *New Computer Modern Sans* belongs to the [New Computer Modern](https://ctan.org/pkg/newcomputermodern) family (download the archive from CTAN; the fonts are the `NewCMSans10-*.otf` files of its `otf` folder). Install them on the system, or keep them in a folder and compile with `typst compile --font-path <folder> main.typ`. In the [Typst web app](https://typst.app/), upload the `.otf` files to the project: fonts inside the project are found automatically.

## License

The theme is licensed under the [MIT License](LICENSE). The contents of [template/](template/) are licensed under [MIT No Attribution](LICENSE-MIT-0) (MIT-0), so a deck created from the template can be used and shared without restriction, with no attribution required.

Third-party components: the icons in [assets/icons/](assets/icons/) come from [Octicons](https://primer.style/octicons/) (© GitHub Inc., MIT License), [Phosphor](https://phosphoricons.com/) (MIT License), [Devicon](https://devicon.dev/) (MIT License) and [Simple Icons](https://simpleicons.org/) (CC0), in the format of [Iconify](https://iconify.design/).

The UFAC logo ([assets/ufac-logo.svg](assets/ufac-logo.svg)) is the property of the [Federal University of Acre](https://www.ufac.br/), and the theme is used for academic purposes. This theme is unofficial: it is not affiliated with or endorsed by the university.

## Changelog

### 0.3.0

Breaking changes, and how to move a 0.2.0 deck:

- The information of the deck is Touying's `config-info`: `subject` → `title` (or keep `subject`, now an alias), `subject-code` → `short-title`, the old `title` → `subtitle`, the old `subtitle` → `short-subtitle`; `ufac-theme(logos: ..)` → `config-info(logo: ..)`.
- The closing slide is `#ending-slide[...]`; `<empty-slide>`, `<empty-slide-COLOR>` and `#empty-slide` are gone (a slide without a title is a `==` without text).
- The theme no longer depends on codly nor on linguify: `local`, `codly-range` and `no-codly` are gone; with codly 2, `#import "@preview/codly:2.0.0" as codly` and `ufac-theme(codly: codly)`.
- The theme ships only its own icons: `#icon("rocket")` of 0.2.0 needs the Octicons collection, `#provide-icons(json("octicon.json"))`, and `#icon("octicon:rocket-16")`.
- The content of the section slides keeps the page margin by default (`section-margin: false` for the old look).

New:

- A new cover, with three styles (`"line"`, `"stack"`, `"top"`), six positions, the tag and the rule, and three backgrounds (`background:`); the section slide follows it.
- Aliases of a course (`subject`, `semester`, …), `kind`, authors as free content with labels, `date`, `institution`, `contact` and `#info`.
- Exercises and examples in a box, as in the handouts: the solution with `#solution` / `#answer`, over several pages.
- `#callout`, `#tag` and the code blocks in a box of their own, with the language and its logo.
- Inside a box, the alert, the subtitles and the links follow its color too; a slide made only of a shorthand is rewritten.
- Four more example decks: [lecture](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/example/lecture.typ), [course](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/example/course.typ), [tcc](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/example/tcc.typ) and [coursework](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/example/coursework.typ).

### 0.2.0

- Closing and transition slides: `<empty-slide>`, `<empty-slide-primary>`, … or `#empty-slide`.
- Icons in the exercise and example pills and in `emph-box`.
- Content below the cover titles (`#title-slide[...]`) and `#outline()`.
- More than one logo (`logos`) and the margin of the section slides (`section-margin`).
- `ufac-logo-image`: the UFAC logo in other colors.
- Code blocks that split across pages (`#local(breakable: true)`).
- Code in table cells follows the cell color.
- The manual is a single document; the example deck is no longer shipped in the package.

### 0.1.0

- First release on Typst Universe: theme, cover, section slides, exercise and example slides, boxes, quotes, columns, icons, code blocks (codly), template and manual.
