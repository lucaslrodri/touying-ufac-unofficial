// Contact sheet of a deck, for the README: its pages, two per row, on a transparent page (the README is read on light
// and on dark backgrounds). scripts/readme.sh renders the pages of the deck into `dir` and compiles this file:
// typst compile --root . --input deck=example --input pages=8 --input dir=.tmp docs/readme/sheet.typ docs/readme/example.png
#let deck = sys.inputs.deck
#let pages = int(sys.inputs.pages)
#let dir = sys.inputs.dir

#let gap = 28pt
#set page(width: auto, height: auto, margin: gap, fill: none)

#grid(
  columns: calc.min(pages, 2),
  gutter: gap,
  ..range(1, pages + 1).map(p => box(
    clip: true,
    radius: 8pt,
    stroke: 1.5pt + luma(160),
    image(dir + "/" + deck + "-" + str(p) + ".svg", width: 841.89pt),
  )),
)
