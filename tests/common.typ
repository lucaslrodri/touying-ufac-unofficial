// Common preamble of the Tytanic tests: imports the package (`@preview/touying-ufac:0.1.0`, i.e. this very folder
// linked by scripts/link.sh), defines `setup` (theme + fixed config-info) and the `demo` helper (code on the left,
// the same text evaluated on the right).
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac:0.1.0": *
#import "placeholder.typ": placeholder

#let info = config-info(
  title: [Presentation title],
  subtitle: [Unit X or subtitle],
  author: [Author Name],
  subject: [Course name],
  subject-code: [CODE],
)
#let setup = ufac-theme.with(lang: "en", info)   // the suite is in English; the default language (pt-br) is covered by config/lang-default

// `eval` does not see the file scope, hence the dictionary with everything the snippets use (`alert` is the plain
// version, the same as `#primary`: Touying's wrapper does not work inside function arguments).
#let _demo-scope = (
  emph-box: emph-box, eq-box: eq-box, quote-box: quote-box, arrows: arrows, cols: cols, colors: colors, icon: icon,
  primary: primary, secondary: secondary, tertiary: tertiary, quaternary: quaternary, alert: primary,
  slide: slide, empty-slide: empty-slide, exercise-slide: exercise-slide, example-slide: example-slide,
  pause: pause, meanwhile: meanwhile, uncover: uncover, only: only, speaker-note: speaker-note,
  codly: codly, codly-range: codly-range, local: local, no-codly: no-codly, utils: utils, components: components,
  placeholder: placeholder,
)
/// Code on the left (raw) + the same text evaluated as markup on the right; `stacked: true` puts one above the other.
#let demo(src, columns: (1fr, 1fr), stacked: false, scope: (:)) = {
  let r = if src.func() == raw { src } else { src.children.find(c => c.func() == raw) }
  let out = eval(r.text, mode: "markup", scope: _demo-scope + scope)
  if stacked { r; parbreak(); out } else { cols(columns: columns, divider: true, r, out) }
}
