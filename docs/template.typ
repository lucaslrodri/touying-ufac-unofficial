// touying-ufac manual — template, modelled on tidy's own `docs/template.typ`: one `project` function for the PDF shell
// (title block, abstract, outline, page numbers) and a few helpers. The look comes from the theme itself: `chapter`
// applies the theme's `_rules` (emphases, markers, enums, tables, `raw` chips, code blocks, boxes and shorthands) with a
// stand-in `self`, so the manual is written in the same syntax as the decks.
//
// Every chapter in `chapters/` starts with `#show: chapter` and holds content only, so that the same files feed the
// PDF (`manual.typ` includes them) and, later, one web page each (shiroa: `chapter` is the place to wrap `book-page`).
#import "@preview/tidy:0.4.3"
#import "../src/lib.typ": *
#import "../src/lib.typ" as ufac-lib
#import "../src/ufac.typ": _rules
#import "../src/utils.typ": _flow
#import "../src/constants.typ": ufac-logo
#import "style.typ" as mantys-like

#let package = toml("../typst.toml").package
#let body-size = 10.5pt
#let code-size = 8.5pt
// Touying's `alert` only works inside a deck; in the manual (prose and examples) it is the plain `primary`
#let alert = primary

// ---------- look ----------
/// Stand-in for Touying's `self`: what `_rules` reads.
#let _self = (
  colors: colors,
  methods: (alert: (self: none, it) => primary(it)),
  info: (counter-prefix: [1.]),
  store: (lang: "en", region: none, exercise-name: auto, example-name: auto, part-name: auto),
)

/// Font, paragraph and headings of the manual: the theme's font, numbered headings in black (level 1 with a thin
/// rule), blue links. The headings are rebuilt from `it.body`, so applying this twice is harmless.
#let _base(body) = {
  set text(font: "New Computer Modern Sans", size: body-size, weight: 500, lang: "en")
  set par(leading: 0.55em, spacing: 0.9em, justify: true)
  set heading(numbering: (..n) => if n.pos().len() <= 2 { numbering("1.1", ..n) })
  show heading: it => {
    let size = (1.3em, 1.15em, 1.05em).at(it.level - 1, default: 1em)
    let number = if it.numbering != none { counter(heading).display(it.numbering) }
    if it.level == 1 and it.numbering != none { pagebreak(weak: true) }   // a chapter starts a page (not the outline title)
    block(above: if it.level == 1 { 1.8em } else { 1.4em }, below: .8em, sticky: true, {
      set par(justify: false)
      text(fill: colors.neutral-darkest, weight: "bold", size: size, { if number != none { number; h(.6em) }; it.body })
      if it.level == 1 { v(.4em, weak: true); line(length: 100%, stroke: .6pt + colors.neutral-darkest) }
    })
  }
  show link: set text(fill: colors.primary)
  show table.cell: set par(justify: false)
  body
}

// ---------- examples ----------
/// What the example snippets can use (`eval` does not see the file scope).
#let example-scope = dictionary(ufac-lib) + (alert: primary)

/// Code on the left, result on the right, in one frame (Mantys' side-by-side example): the `layout` of tidy's
/// `show-example`, used for the ```` ```example ```` blocks of the chapters and of the doc-comments alike. `_flow` forces
/// a paragraph so that a lone `-> item`, `> box` or `"quote"` is rewritten.
#let _in-example = state("manual-in-example", false)   // code inside an example gets no frame of its own
#let _side-by-side(code, results, columns: (1fr, 1fr), breakable: false) = mantys-like.frame(
  ..mantys-like.code-frame, breakable: breakable, inset: 0pt, clip: true, above: 1.1em, below: 1.1em,
  grid(columns: columns, inset: (x, _) => if x == 0 { 0pt } else { 8pt },
    stroke: (x, _) => if x == 1 { (left: mantys-like.code-frame.stroke) },
    // the zebra code fills the left cell edge to edge; one row per result, the code spanning them all
    grid.cell(rowspan: results.len(), { _in-example.update(true); show raw.where(block: true): set text(size: code-size); code; _in-example.update(false) }),
    ..results),
)
#let example-layout(code, preview, ..options) = _side-by-side(code, ({
  // tidy evaluates the preview inside the `raw` element of the example: undo what `raw` set
  set text(font: "New Computer Modern Sans", size: body-size, weight: 500)
  set par(justify: false)
  _flow(preview)
},))
#let show-example = tidy.show-example.show-example.with(layout: example-layout)

/// A real slide next to its source. `examples/<name>.typ` is a minimal deck compiled to `examples/out/<name>-<n>.svg`
/// by `build.sh`; only what follows the marker line is shown, so the code and the picture cannot drift apart. One row
/// per slide and the code spanning them all, so that a long example can break between two slides.
#let _marker = "// --- example ---"
#let slide-example(name, pages: (1,), columns: (2fr, 3fr)) = {
  let src = read("examples/" + name + ".typ")
  let shown = src.slice(src.position(_marker) + _marker.len()).trim("\n")
  let slides = pages.map(n => block(stroke: .5pt + luma(220), image("examples/out/" + name + "-" + str(n) + ".svg", width: 100%)))
  _side-by-side(columns: columns, breakable: true, raw(shown, lang: "typ", block: true), slides)
}

// ---------- API reference ----------
/// The documented modules of `src/`, parsed once. Labels are `<module>-<name>()` for functions and `<module>-<name>`
/// for variables (tidy's convention), which the index chapter links to.
#let modules = ("ufac", "components", "constants").map(name =>
  (name, tidy.parse-module(read("../src/" + name + ".typ"), name: name, scope: example-scope))).to-dict()
#let api-style = mantys-like.style + (show-example: show-example)

/// Reference of the given definitions of a module, in the given order, shown where the chapter introduces them (as
/// in the Typst documentation): signature with the type of every parameter, description, examples, parameters.
#let reference(module, ..names) = {
  let names = names.pos()
  let docs = modules.at(module)
  let pick(defs) = names.map(n => defs.find(d => d.name == n)).filter(d => d != none)
  let picked = pick(docs.functions) + pick(docs.variables)
  assert(picked.len() == names.len(), message: "not documented in " + module + ": " + repr(names))
  docs.functions = pick(docs.functions)
  docs.variables = pick(docs.variables)
  set par(justify: false)   // the descriptions are full of code chips, which justify badly
  tidy.show-module(docs, style: api-style, first-heading-level: 2, show-module-name: false, show-outline: false,
    sort-functions: none, omit-private-parameters: true)
}

/// Every public definition with the page of its reference. A definition that no chapter documents has no label,
/// so forgetting one is a compile error.
#let index() = for (module, docs) in modules {
  let entries = (docs.functions.map(f => (f.name, f.name + "()")) + docs.variables.map(v => (v.name, v.name)))
    .filter(((name, _)) => not name.starts-with("_")).sorted()
  block(above: 1.2em, below: .6em, strong(raw(module + ".typ")))
  grid(columns: (1fr,) * 3, row-gutter: .65em, ..entries.map(((name, shown)) => {
    let target = label(module + "-" + shown)
    link(target, text(font: mantys-like.mono, size: .85em, shown)) + context [ #h(.3em) #text(fill: luma(110), size: .85em)[p. #locate(target).page()]]
  }))
}

// ---------- shells ----------
/// First line of every chapter: the look, the theme rules and the example blocks.
#let chapter(body) = {
  show: _base
  // code blocks: the theme's codly setup plus a zebra; the theme's gray box is switched off and every block that is
  // not part of an example gets the frame instead (this rule is inner to `_rules`, so it wraps the `raw` first)
  show: _rules.with(_self, code-box: (fill: none, stroke: none, radius: 0pt, inset: 0pt))
  show raw.where(block: true): it => context if _in-example.get() { it } else { mantys-like.frame(..mantys-like.code-frame, inset: 0pt, clip: true, it) }
  show raw.where(block: true): set text(size: code-size)
  show raw.where(block: true): set par(justify: false)
  // Typst underlines headings in highlighted markup; without this they would get the theme's thick yellow underline.
  // Only for the displayed `typ` code: tidy evaluates a preview inside the `example` raw, which must keep the theme's.
  show raw.where(lang: "typ"): set underline(stroke: auto, offset: auto, evade: true, background: false)
  show: tidy.render-examples.with(scope: example-scope, layout: example-layout)
  codly(zebra-fill: luma(240), inset: (x: .5em, y: .22em))   // codly's default zebra; after the `codly(..)` of `_rules`
  body
}

/// PDF shell, same signature as tidy's: title block, abstract and outline on the first page, then the chapters.
#let project(title: "", subtitle: "", abstract: [], authors: (), url: none, date: none, version: none, body) = {
  set document(author: authors, title: title)
  set page(paper: "a4", margin: (x: 2.4cm, y: 2.6cm), numbering: "1", number-align: center)
  _base({
    v(3em)
    align(center, {
      image(bytes(ufac-logo), height: 2.2em)
      v(1.2em, weak: true)
      block(text(weight: "bold", size: 2em, fill: colors.primary, title))
      block(text(size: 1.1em, subtitle))
      v(2.5em, weak: true)
      [v#version #h(1.2cm) #date]
      block(link(url))
      block(strong(authors.join(", ")))
    })
    v(2.5em, weak: true)
    pad(x: 3.8em, align(center, abstract))
    v(3em, weak: true)
    {
      show outline.entry.where(level: 1): it => { v(.4em, weak: true); strong(it) }
      heading(numbering: none, outlined: false, [Contents])
      columns(2, gutter: 2em, outline(title: none, depth: 2, indent: 1.2em))
    }
  })
  pagebreak()
  body
}
