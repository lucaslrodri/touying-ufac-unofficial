# touying-ufac

Touying slide theme for the Federal University of Acre (UFAC), Brazil.

**touying-ufac** is a [Touying](https://touying-typ.github.io/) theme for lecture slides in
[Typst](https://typst.app/), following the visual identity of the
[Federal University of Acre](https://www.ufac.br/). The theme speaks Portuguese by default (`lang: "pt-br"`: `Exercício`,
`Exemplo`, `Parte`); `lang: "en"` or `"es"` switches the text language and those names (via
[linguify](https://typst.app/universe/package/linguify)), and each name can still be overridden.

## Documentation

The manual is [docs/manual.pdf](docs/manual.pdf): every element with its source and the result side by side, and the
function reference (generated from the doc-comments with [tidy](https://typst.app/universe/package/tidy)).
`sh docs/build.sh` rebuilds it.

## Dependencies

| Dependency | Version | Role |
| ---------- | ------- | ---- |
| [Typst](https://typst.app/) | ≥ 0.14 | compiler |
| [touying](https://typst.app/universe/package/touying) | 0.7.4 | slide engine (the deck imports it too) |
| [codly](https://typst.app/universe/package/codly) | 1.3.0 | code blocks, re-exported by the theme |
| [linguify](https://typst.app/universe/package/linguify) | 0.5.0 | localized names |
| *New Computer Modern Sans* | | font, installed on the system (not bundled with Typst, unlike *New Computer Modern Math*, used for the equations) |

The packages are fetched automatically. For development only: [tidy](https://typst.app/universe/package/tidy) 0.4.3
(manual and doc-comment tests) and [Tytanic](https://typst-community.github.io/tytanic/) 0.4.1 (test suite).

## Basic usage

```typst
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac:0.1.0": *

#show: ufac-theme.with(
  aspect-ratio: "16-9",               // anything utils.page-args-from-aspect-ratio accepts
  lang: "en",                         // "pt-br" (default), "en" or "es": text language and the names below
  // exercise-name: [Exercise], example-name: [Example], part-name: [Part],   // override the localized names
  // footer-left: self => ..., footer-right: self => ...   (auto: "CODE · SUBJECT" and the author)
  config-info(
    title: [Title of slide],   // 3rd line of the cover (white)
    subtitle: [Teaching unit],               // 2nd line of the cover (yellow)
    author: [Your Name],
    subject: [Your subject],                    // 1st line of the cover and left footer
    subject-code: [CODE],
    counter-prefix: [1.],                        // "Exercise 1.N" / "Example 1.N"; none gives "Exercise N"
  ),
)

#title-slide()
```

`typst init @preview/touying-ufac:0.1.0` creates a deck from [template/main.typ](template/main.typ) (configuration, cover, one
slide); [example/main.typ](example/main.typ) shows every element of the syntax in a short deck.

## Syntax

### Headings and slide breaks

| Markup                          | Effect                                                                                       |
| ------------------------------- | -------------------------------------------------------------------------------------------- |
| `= Title` + `#image(...)`       | Section slide "Part N: Title" (`Parte` in Portuguese and Spanish); the content right after `=` sits on the right, flush with the page edge (`#pad(right: 1.8em)[...]` restores a margin) |
| `== Title`                      | New slide with a blue header                                                                 |
| `== Title <exercise>`           | Exercise slide: red pill "Exercise 1.N (Title)" (`Exercício`/`Ejercicio`), numbered automatically; `<exercise-id>` makes it citable with `@exercise-id` |
| `== Title <example>`            | Example slide: green pill "Example 1.N (Title)" (`Exemplo`/`Ejemplo`), independent counter; `<example-id>` likewise |
| `=== Subtitle`                  | Blue pill, no new slide; repeated at the top of every `---` continuation                     |
| `==== Subtitle`                 | Same pill, not repeated                                                                      |
| `---` (alone on a line)         | Next page of the same slide (same header, same pill, same number)                            |

Functions: `#title-slide()`, `#slide[...]`, `#empty-slide[...]` (footer only), `#exercise-slide(title:, color:)[...]`,
`#example-slide(title:, color:)[...]`. Touying's `#pause`, `#uncover`, `#only`, `#alternatives`, `#speaker-note`,
`#slide(composer:)` etc. work as usual.

### Inline formatting

| Markup                     | Result                                                                                   |
| -------------------------- | ---------------------------------------------------------------------------------------- |
| `*text*` / `_text_`        | black bold / black italic (bold takes the box color inside `emph-box`, white inside pills) |
| `#alert[text]`, `~~text~~` | blue bold (UFAC yellow inside pills)                                                     |
| `==text==`, `#highlight[...]` | light-yellow background (`#highlight(fill: colors.quaternary-lighter)` for other tones) |
| `~text~`, `#underline[...]` | strong yellow underline (box color inside `emph-box`)                                   |
| `#primary`, `#secondary`, `#tertiary`, `#quaternary` | bold text in blue / yellow / red / green                       |
| `` `code` ``               | gray chip; inside titles, boxes and pills it follows the container color                 |
| `#icon("name", color: auto, size: 1em)` | one of 320 Octicons, colored by context                                    |

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
$ #eq-box[$E = m c^2$] $                              // equation box, inside the equation (`color:` optional)
#quote-box(color: colors.secondary)[...]              // vertical bar on the left
#cols(divider: true, columns: (1fr, 2fr))[A][B]       // Touying's cols, optional blue divider
```

Markdown-like short forms (inline content only, always primary):

```
> Box without title.

> == Title
> Box with title.

> $ y = phi(v) $        // `>` before a block equation (same line or the line above): equation box

"A quotation."          // paragraph made only of quoted lines → one quote box per line
```

### Code

Code blocks go through codly (line numbers, no zebra, gray box). `#local(display-name: true, highlights: ((line: 2,
fill: colors.secondary-lighter),))[...]`, `#local(number-format: none)[...]`, `#codly-range(...)` and `#no-codly[...]`
are re-exported by the theme. Languages with a label: `python`, `typst`, `bash`, `text`.

### Colors

`colors` has five families (`primary` `#0C4DA2`, `secondary` `#FFBF14`, `tertiary` `#BE1E2D`, `quaternary`
`#09B081`, `neutral` `#808080`) × seven tones (`-darkest`, `-darker`, `-dark`, base, `-light`, `-lighter`,
`-lightest`), e.g. `colors.primary-lighter`. The same keys are available as `self.colors.*`.

## License

This project is licensed under the [MIT License](LICENSE).

It also includes third-party components licensed under other open source licenses: the icons in
[src/icons.typ](src/icons.typ) are [Octicons](https://primer.style/octicons/), © GitHub Inc., licensed under the MIT License.

The UFAC logo ([assets/ufac-logo.svg](assets/ufac-logo.svg)) is copyrighted by the
[Federal University of Acre](https://www.ufac.br/) and may be used solely for academic purposes by current students and
faculty.
