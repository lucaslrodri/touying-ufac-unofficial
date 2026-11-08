/// Synopsis: compile-only test (no `ref/`): every doc-comment of `src/` must be valid markup for tidy, private
/// definitions included, and every doc-comment test (`#test(..)`) must pass.
#import "@preview/tidy:0.4.3"
#import "/src/lib.typ" as lib

// the examples and tests are evaluated with `eval`, which does not see any file scope
#let scope = dictionary(lib)
// `example` is also the name of tidy's own renderer of the ```example blocks, and the scope of a module overrides it:
// tidy gets the scope without the callout `example`, and the snippets get it back through the preamble
#let tidy-scope = {
  let s = scope
  let _ = s.remove("example")
  s
}
#let preamble = "#let example(..args) = callout(\"example\", ..args)\n"
// tidy's default example layout measures the preview and rejects relative widths (`emph-box` is 100% wide)
#let style = dictionary(tidy.styles.default) + (
  show-example: tidy.show-example.show-example.with(layout: (code, preview, ..options) => { code; preview }),
)

#for file in ("constants.typ", "utils.typ", "icons.typ", "components.typ", "code.typ", "info.typ", "ufac.typ") {
  let docs = tidy.parse-module(read("/src/" + file), name: file, scope: tidy-scope, preamble: preamble)
  assert(docs.functions.len() + docs.variables.len() > 0, message: "nothing documented in " + file)
  tidy.show-module(docs, style: style, enable-tests: true, omit-private-definitions: false, show-outline: false)
}
