# Changelog

## 0.3.0

Breaking changes, and how to move a 0.2.0 deck:

- The information of the deck is Touying's `config-info`: keep `subject` and `subject-code`, now aliases of `title` and `short-title`; rename the old `title` to `unit-title` (or `subtitle`) and the old `subtitle` to `unit` (or `short-subtitle`), since `subject` and `title` together are an error; `ufac-theme(logos: ..)` → `config-info(logo: ..)`. A function of `footer-left` or `footer-right` reads Touying's names, `self.info.title` and `self.info.short-title` (`self.info.subject` is gone), or the footer is content with `#info("subject")`.
- `<empty-slide>`, `<empty-slide-COLOR>` and the theme's `#empty-slide` are removed: the theme has no empty slide of its own. A label `<empty-slide…>` is now an ordinary label, so the slide becomes an ordinary one, with its header: look for these labels in the deck. The blue page of the cover, with the footer, is the new `#ending-slide(title: none)[...]`; a page without header or footer is Touying's `#empty-slide[...]` (the deck imports Touying), which takes neither `color:` nor `title:`: for another color, `#empty-slide(config: config-page(fill: colors.tertiary))[#set text(fill: white); ...]`. A `==` without text gives a slide without a title, with the footer.
- The theme no longer depends on codly or linguify: the functions of codly 1 it exported (`codly`, `local`, `codly-range`, `no-codly`, …) are gone. The theme's own code box goes on to the next page by itself, so `#local(breakable: true)` is not needed; to keep codly, use codly 2 (Typst ≥ 0.15): `#import "@preview/codly:2.0.0" as codly` and `ufac-theme(codly: codly)`.
- The theme ships only its own icons: `#icon("rocket")` of 0.2.0 needs the Octicons collection, `#provide-icons(json("octicon.json"))` in a slide, and `#icon("octicon:rocket-16")` (see *Icons* in the manual); the Octicons the theme ships keep their own names (`"alert"`, `"pencil"`, `"beaker"`, …).
- The content of the section slides keeps the page margin by default, and the margin is the `margin` of `new-section-slide`, no longer `ufac-theme(section-margin:)`: for the old look, `config-common(new-section-slide-fn: new-section-slide.with(margin: 0pt))`.
- The theme exports new names: `caution`, `tip`, `remark`, `note`, `example`, `examples`, `solution`, `answer`, `info` and `tag`. A package imported with `*` before the theme loses those it shares, such as theorion's `example`, `remark` and `solution`: import it by its name (see *Integrations* in the manual).
- `#alert` is now the theme's own, so import the theme after Touying, as in the template. Inside a box, `#alert` and `~~text~~` take the color of the box, where 0.2.0 kept them blue: for the blue, write `#primary`. A `config-methods(alert: ..)` of the deck now reaches only `~~text~~`; to restyle `#alert` too, define `#let alert(body) = ..` after the imports.
- `ufac-logo-image` is gone: in a slide, `#info("logo", height: 2em)` (`white: true` on a dark background); outside a deck, as in a handout, `#image(bytes(ufac-logo), height: 2em)`.
- Figure captions are at 0.6 of the size of the text: a deck that made them smaller by hand with a size in `em` removes that, or they get smaller twice; `#show figure.caption: set text(size: 18pt)`, after `#show: ufac-theme.with(..)`, gives another size.

New:

- A new cover, with three layouts (`title-slide(cover-layout:)`: `"line"`, `"stack"`, `"top"`), six positions to change one by one (`header-left` … `footer-right`), a label over the authors (`author-label`), the tag and the rule, and three cover styles (`ufac-theme(cover-style:)`: `"bubbles"`, `"gradient"`, `"plain"`); the section slide follows it.
- Aliases of a course (`subject`, `semester`, …), the flavor of the presentation (`config-info(flavor:)`: `"lecture"`, the default, `"coursework"`, `"tcc"`, `"dissertation"`, `"thesis"`), which brings the layout of the cover, the tag of a thesis defense and the numbering, authors as free content with labels, `date`, `institution`, `contact` and `#info`. An option of the cover in the wrong place stops with the right one.
- `#ending-slide`, the closing slide on the blue page of the cover: a title ("Thank you!" by default), a subtitle and a body.
- Exercises and examples in a box filling the slide, as in a printed handout: the solution with `#solution` / `#answer`, over several pages.
- Callouts: `#caution`, `#tip`, `#remark`, `#note`, `#example`, `#examples`, or `#callout(kind)`; a list (`-`, `+`, `->` or `#arrow-list`), a `>` box, a quote or a `>` before an equation at the start of one starts on the line under the title.
- `#arrow-list[..]`, the function form of `-> item`: the `-` items of its body get the arrow.
- A slide shown again with `#touying-recall` keeps the number of its exercise or example, and the next ones go on from where they were.
- `#tag`, the yellow tag of the cover, for the text, the titles and the tables.
- The code blocks in a box of their own, with the language and its logo, which go on to the next page when they are long; `code-languages` adds languages, and the output has its pill in the language of the deck.
- The texts of the footer, in capitals but for inline code, stay on one line, cut with "…" when they do not fit, and a long content keeps the repeated `===` pill without running into the footer. `footer-left` and `footer-right` also take an array: its items joined by a dot, those that show nothing left out (with none left, the footer line runs unbroken).
- `provide-icons` gives the deck the icons of any collection of Iconify.
- On a dark background (a dark pill, badge or tag, the cover, the closing slide, the header of a table, a dark cell), bold and italic are white, a highlight yellow with blue text, and an alert and `#primary` yellow, or dark blue where the yellow does not read (a contrast under 3:1, as on `quaternary`, `neutral` and `secondary-dark`). `#secondary`, `#tertiary` and `#quaternary` keep their color where it reads and otherwise turn yellow or dark blue, as an alert does: on the blue, only `#secondary` keeps it. In the slide header, the footer, an alert and a colored emphasis, bold and italic take the color of the text around them; on a slide they stay black.
- A pill, a badge or a tag in a light color, such as the yellow, has dark blue text, and inside it alerts are blue and highlights light blue; on the others, white text. A box, a callout, an exercise or an example in a light color uses its dark tone for bold, alerts and markers, and an exercise or example also for its list numbers and the text of its footer.
- Inside a box, the subtitles and the links follow its color too (a reference to an exercise or example keeps the color of its kind); a slide whose content is only a shorthand (`-> item`, `> box`) is now rewritten too.
- What a `#pause` covers is hidden until its step, where 0.2.0 left it faintly visible under a veil.
- The figure of a section fits whole in a frame of 12em × 66% of the height, neither cropped nor stretched: an image without a size fills it, one with a size shrinks when it is larger than the frame.
- Three example decks, one for a lecture, one for the work of students for a course and one for a thesis defense: [lecture](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/example/lecture.typ), [coursework](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/example/coursework.typ) and [tcc](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/example/tcc.typ), shown in the README with their code; the example deck of 0.2.0 (`example/main.typ`) is gone.
- A short README, with the details in the manual and the changes in this file.
- A skill for AI agents, in Portuguese, in two modes, the lectures of a course and the presentation of an academic work (`skills/touying-ufac/`).

## 0.2.0

- Closing and transition slides: `<empty-slide>`, `<empty-slide-primary>`, … or `#empty-slide`.
- Icons in the exercise and example pills and in `emph-box`.
- Content below the cover titles (`#title-slide[...]`) and `#outline()`.
- More than one logo (`logos`) and the margin of the section slides (`section-margin`).
- `ufac-logo-image`: the UFAC logo in other colors.
- Code blocks that split across pages (`#local(breakable: true)`).
- Code in table cells follows the cell color.
- The manual is a single document; the example deck is no longer shipped in the package.

## 0.1.0

- First release on Typst Universe: theme, cover, section slides, exercise and example slides, boxes, quotes, columns, icons, code blocks (codly), template and manual.
