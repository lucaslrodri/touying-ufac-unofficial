// Common preamble of the Tytanic tests: imports the theme by its entrypoint (`src/lib.typ`, by its path: the root is
// the repository, as in Tytanic, tinymist and `typst compile --root .`), defines `setup` (theme + fixed config-info, `test-info`; not `info`, the name of the
// theme's `#info`) and the `demo` helper (code on the left, the same text evaluated on the right).
#import "@preview/touying:0.7.4": *
#import "../src/lib.typ": *
#import "placeholder.typ": placeholder

#let test-info = config-info(
  title: [Course name],
  short-title: [CODE],
  subtitle: [Presentation title],
  short-subtitle: [Unit X or subtitle],
  author: [Author Name],
)
// the suite is in English; the default language (pt-br) is covered by config/lang-default
#let setup = ufac-theme.with(lang: "en", test-info)
// Octicons the theme does not ship (it ships only its own icons), for the tests that use other icons: a test gives
// them with `#provide-icons(octicons)` inside a slide and writes them as `"octicon:name-16"`
#let octicons = json("octicon.json")

// `eval` does not see the file scope, hence the dictionary with everything the snippets use.
#let _demo-scope = (
  emph-box: emph-box, eq-box: eq-box, quote-box: quote-box, arrows: arrows, arrow-list: arrow-list, cols: cols, colors: colors, icon: icon,
  ufac-logo: ufac-logo,
  primary: primary, secondary: secondary, tertiary: tertiary, quaternary: quaternary, alert: alert,
  slide: slide, empty-slide: empty-slide, ending-slide: ending-slide, question-slide: question-slide, example-slide: example-slide,
  pause: pause, meanwhile: meanwhile, uncover: uncover, only: only, speaker-note: speaker-note,
  utils: utils, components: components, provide-icons: provide-icons, octicons: octicons, tag: tag, callout: callout,
  caution: caution, tip: tip, remark: remark, note: note, example: example, examples: examples, info: info,
  placeholder: placeholder,
)
/// Code on the left (raw) + the same text evaluated as markup on the right; `stacked: true` puts one above the other.
#let demo(src, columns: (1fr, 1fr), stacked: false, scope: (:)) = {
  let r = if src.func() == raw { src } else { src.children.find(c => c.func() == raw) }
  let out = eval(r.text, mode: "markup", scope: _demo-scope + scope)
  if stacked { r; parbreak(); out } else { cols(columns: columns, divider: true, r, out) }
}
