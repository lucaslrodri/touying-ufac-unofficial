// Contact sheet for the README: pages of the decks, side by side in a grid, each with a rounded gray border, on a
// transparent page (the README is read on light and on dark backgrounds). scripts/readme.sh renders the pages into
// `dir` as SVG files and compiles this file once per picture, naming the pages it takes (the file names without
// `.svg`), the number of columns and the margin around them, in points:
// typst compile --root . --input files=lecture-1,tcc-1 --input columns=2 --input margin=28 --input dir=.tmp \
//   docs/readme/sheet.typ picture.png
// Opened alone (in the editor), without those inputs, it only says so instead of failing.
#let files = sys.inputs.at("files", default: "").split(",").filter(f => f != "")
#let ncols = int(sys.inputs.at("columns", default: "2"))
#let margin = float(sys.inputs.at("margin", default: "28")) * 1pt
#let dir = sys.inputs.at("dir", default: none)

#let gap = 28pt
#set page(width: auto, height: auto, margin: margin, fill: none)

#if files.len() == 0 or dir == none [
  Compiled by `scripts/readme.sh` (`--input files=… columns=… margin=… dir=…`).
] else {
  grid(
    columns: calc.min(files.len(), ncols),
    gutter: gap,
    ..files.map(f => box(
      clip: true,
      radius: 8pt,
      stroke: 1.5pt + luma(160),
      image(dir + "/" + f + ".svg", width: 841.89pt),
    )),
  )
}
