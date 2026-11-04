// Report of the test suite: for every test, its name, its synopsis, its code and, beside it, its reference pages.
// Built by scripts/report.sh, which writes the list of the tests (.report.json) first; see that script.
#import "@preview/touying-ufac-unofficial:0.3.0": colors

#set document(title: [touying-ufac-unofficial: test report])
#set page(paper: "a4", margin: (x: 1.3cm, y: 1.5cm), numbering: "1")
#set text(font: "New Computer Modern Sans", size: 10pt, lang: "en")
#set par(justify: false, leading: 0.55em)
#show raw: set text(font: "DejaVu Sans Mono", size: 7pt)
#show heading.where(level: 1): set text(size: 17pt, fill: colors.primary)
#show heading.where(level: 2): set text(size: 13pt, fill: colors.primary)
#show heading: set block(above: 1.2em, below: 0.7em)

#let tests = json(".report.json")
#let version = toml("../typst.toml").package.version

/// The synopsis of a test: the `/// Synopsis:` line of its test.typ and the `///` lines that follow it.
#let synopsis(src) = {
  let lines = src.split("\n")
  let i = lines.position(l => l.starts-with("/// Synopsis:"))
  if i == none { return none }
  let out = (lines.at(i).slice("/// Synopsis:".len()).trim(),)
  for l in lines.slice(i + 1) { if l.starts-with("///") { out.push(l.slice(3).trim()) } else { break } }
  out.join(" ")
}

/// The code shown for a test: its body.typ without the comment line at its top, or its test.typ without the synopsis.
#let code(t) = {
  let src = if t.body { read(t.id + "/body.typ") } else { read(t.id + "/test.typ") }
  src.split("\n").filter(l => not (l.starts-with("/// ") or l.starts-with("// Body of"))).join("\n").trim()
}

/// One test: the name, the synopsis and a frame with the code on the left and the reference pages on the right.
#let entry(t) = block(breakable: true, width: 100%, above: 1.3em, {
  let src = read(t.id + "/test.typ")
  block(sticky: true, below: 0.5em, {
    text(weight: "bold", raw(t.id))
    let s = synopsis(src)
    if s != none { [ --- ]; eval(s, mode: "markup") }
  })
  let pages = range(1, t.pages + 1)
  let shown = if pages.len() == 0 {
    std.align(center + horizon, text(fill: luma(110), size: 9pt)[compile only: no pages to compare])
  } else {
    grid(columns: if pages.len() > 4 { 2 } else { 1 }, gutter: 5pt,
      ..pages.map(p => box(stroke: 0.5pt + luma(215), image(t.id + "/ref/" + str(p) + ".png", width: 100%))))
  }
  block(width: 100%, stroke: 0.75pt + colors.primary, radius: 4pt, inset: 7pt, breakable: true, grid(
    columns: (1fr, 1.15fr), column-gutter: 8pt, align: (left + top, center + top),
    block(width: 100%, fill: luma(247), radius: 3pt, inset: 6pt, breakable: true, raw(code(t), lang: "typ", block: true)),
    shown,
  ))
})

#align(center)[
  #text(size: 20pt, weight: "bold", fill: colors.primary)[Test report] \
  #v(0.2em)
  touying-ufac-unofficial #version: #tests.len() tests, #tests.map(t => t.pages).sum() reference pages
]

Every test of the suite, by group: its name, what it checks, its code and, beside it, its reference pages (`ref/`), which the suite compares pixel by pixel. A test without pages is compiled only (its assertions must hold). Built by `sh scripts/report.sh`.

#for group in tests.map(t => t.id.split("/").first()).dedup() [
  = #group
  #for t in tests.filter(t => t.id.split("/").first() == group) { entry(t) }
]
