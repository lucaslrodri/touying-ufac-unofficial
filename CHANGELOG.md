# Changelog

## Unreleased

- Names: `config-info(kind:)` is now `flavor`; `ufac-theme(background:)` is now `cover-style`, and its default `"circles"` is `"bubbles"`; `title-slide(style:)` is now `cover-layout`. The old names stop with an error that gives the new one.
- The flavors `"course"` and `"talk"` are removed, and so is the example deck of an extension course. A talk is a lecture with `config-info(counter-prefix: none)`; an extension course, a lecture with `#title-slide(cover-layout: "top", author-label: [Instructors])`. A deck without a `flavor` is a `"lecture"`: it already looked like one. `title-slide(author-label:)` is `none` by default, and `auto` is `none` too.
- The example deck of a final paper has the cover style `"gradient"`. The example deck of every element (`example/main.typ`) is removed: the README shows the elements, with the decks of a lecture, of coursework and of a final paper.
- The README is short: what the theme is, how to start, what to choose, and the example decks with their code. The details are in the manual, and the changelog is this file.
- A `#pause` in a paragraph of its own, with blank lines around it, between two items of a list, reveals the next item, as a `#pause` on its own line does; also inside an `emph-box` without a title or an icon, a callout in the default style, a column, an `align` (with the list in a block: see the limits), a `pad` or an item, and after a `set` rule. The list then has the spacing of a list without blank lines.
- Numbered items split by a `#pause` keep their numbers under the veil also inside an `emph-box` without a title or an icon, a callout in the default style or a column, and after a `#set enum(numbering: ..)`; a `#set enum(start: ..)`, which 0.3.0 ignored, applies to a list that no `#pause` splits.
- The veil no longer reaches the descenders of the visible line right before a covered block. A shape (`#circle`, `#line`…) after a `#pause` is veiled, where 0.3.0 stopped the compilation.
- An arrow list (`->`), a `>` box, a quote or a `>` before an equation at the start of a callout in the default style starts on the line under the title, where 0.3.0 printed them as text after it ("Tip. -> item").
- The skill for AI agents is one skill with two modes (`skills/touying-ufac/`).

## 0.3.0

Breaking changes, and how to move a 0.2.0 deck:

- The information of the deck is Touying's `config-info`: keep `subject` and `subject-code`, now aliases of `title` and `short-title`; rename the old `title` to `unit-title` (or `subtitle`) and the old `subtitle` to `unit` (or `short-subtitle`), since `subject` and `title` together are an error; `ufac-theme(logos: ..)` → `config-info(logo: ..)`. A function of `footer-left` or `footer-right` reads Touying's names, `self.info.title` and `self.info.short-title` (`self.info.subject` is gone), or the footer is content with `#info("subject")`.
- `<empty-slide>`, `<empty-slide-COLOR>` and the theme's `#empty-slide` are removed: the theme has no empty slide of its own. A label `<empty-slide…>` is now an ordinary label, so the slide becomes an ordinary one, with its header: look for these labels in the deck. The blue page of the cover, with the footer, is the new `#ending-slide(title: none)[...]`; a page without header or footer is Touying's `#empty-slide[...]` (the deck imports Touying), which takes neither `color:` nor `title:`: for another color, `#empty-slide(config: config-page(fill: colors.tertiary))[#set text(fill: white); ...]`. A `==` without text gives a slide without a title, with the footer.
- The theme no longer depends on codly or linguify: the functions of codly 1 it exported (`codly`, `local`, `codly-range`, `no-codly`, …) are gone. The theme's own code box goes on to the next page by itself, so `#local(breakable: true)` is not needed; to keep codly, use codly 2 (Typst ≥ 0.15): `#import "@preview/codly:2.0.0" as codly` and `ufac-theme(codly: codly)`.
- The theme ships only its own icons: `#icon("rocket")` of 0.2.0 needs the Octicons collection, `#provide-icons(json("octicon.json"))` in any slide after the cover, and `#icon("octicon:rocket-16")` (see *Icons* in the manual); the Octicons the theme ships keep their own names (`"alert"`, `"pencil"`, `"beaker"`, …).
- The content of the section slides keeps the page margin by default, and the margin is the `margin` of `new-section-slide`, no longer `ufac-theme(section-margin:)`: for the old look, `config-common(new-section-slide-fn: new-section-slide.with(margin: 0pt))`.
- The theme exports new names: `caution`, `tip`, `remark`, `note`, `example`, `examples`, `solution`, `answer`, `info` and `tag`. A package imported with `*` before the theme loses those it shares, such as theorion's `example`, `remark` and `solution`: import it by its name (see *Integrations* in the manual).
- `#alert` is now the theme's own, so import the theme after Touying, as in the template. Inside a box, `#alert` and `~~text~~` take the color of the box, where 0.2.0 kept them blue: for the blue, write `#primary`. A `config-methods(alert: ..)` of the deck now reaches only `~~text~~`; to restyle `#alert` too, define `#let alert(body) = ..` after the imports.
- `ufac-logo-image` is gone: in a slide, `#info("logo", height: 2em)` (`white: true` on a dark background); outside a deck, as in a handout, `#image(bytes(ufac-logo), height: 2em)`.
- Figure captions are at 0.6 of the size of the text: a deck that made them smaller by hand with a size in `em` removes that, or they get smaller twice; `#show figure.caption: set text(size: 18pt)`, after `#show: ufac-theme.with(..)`, gives another size.

New:

- A new cover, with three styles (`"line"`, `"stack"`, `"top"`), six positions, the tag and the rule, and three backgrounds (`background:`); the section slide follows it.
- Aliases of a course (`subject`, `semester`, …), `kind`, authors as free content with labels, `date`, `institution`, `contact` and `#info`.
- Exercises and examples in a box filling the slide, as in a printed handout: the solution with `#solution` / `#answer`, over several pages.
- Callouts: `#caution`, `#tip`, `#remark`, `#note`, `#example`, `#examples`, or `#callout(kind)`.
- `#tag`, the yellow tag of the cover, for the text, the titles and the tables.
- The code blocks in a box of their own, with the language and its logo, which go on to the next page when they are long; `code-languages` adds languages, and the output has its pill in the language of the deck.
- The texts of the footer stay on one line, cut with "…" when they do not fit, and a long content keeps the repeated `===` pill without running into the footer. `footer-left` and `footer-right` also take an array: its items joined by a dot, those that show nothing left out (with none left, the footer line runs unbroken).
- `provide-icons` gives the deck the icons of any collection of Iconify.
- `#alert` works inside every box, where Touying's stopped the compilation (an `emph-box` with a title or an icon, a callout with `style: "badge"`, an `eq-box`, a `#tag`, the header of a table).
- On a slide with animations that goes on to a second page, every step repeats the page numbers of the first (Touying repeated the number of the last page on the later steps).
- Inside a box, the subtitles and the links follow its color too (a reference to an exercise or example keeps the color of its kind); a slide whose content is only a shorthand (`-> item`, `> box`) is now rewritten too.
- The figure of a section fits whole in a frame of 12em × 66% of the height, neither cropped nor stretched: an image without a size fills it, one with a size shrinks when it is larger than the frame.
- Four more example decks: [lecture](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/example/lecture.typ), [course](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/example/course.typ), [tcc](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/example/tcc.typ) and [coursework](https://github.com/lucaslrodri/touying-ufac-unofficial/blob/v0.3.0/example/coursework.typ).

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
