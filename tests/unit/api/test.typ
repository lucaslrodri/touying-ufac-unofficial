/// Synopsis: compile-only test (no `ref/`): checks the exported API of the theme with assertions.
#import "@preview/touying-ufac-unofficial:0.3.0": *

// public functions exist
#for f in (ufac-theme, title-slide, slide, empty-slide, new-section-slide, exercise-slide, example-slide, emph-box, quote-box, arrows, cols,
  primary, secondary, tertiary, quaternary, icon, eq-box, ufac-logo-image, outline, provide-icons) {
  assert(type(f) == function, message: "expected a function, got " + str(type(f)))
}

// palette: 5 families × (base + 6 tones) = 35 keys, derived with darken/lighten
#assert.eq(colors.len(), 35)
#for fam in ("primary", "secondary", "tertiary", "quaternary", "neutral") {
  for tone in ("darkest", "darker", "dark", "light", "lighter", "lightest") {
    assert(fam + "-" + tone in colors, message: "missing " + fam + "-" + tone)
  }
}
#assert.eq(colors.primary, rgb("#0C4DA2"))
#assert.eq(colors.secondary, rgb("#FFBF14"))
#assert.eq(colors.tertiary, rgb("#BE1E2D"))
#assert.eq(colors.quaternary, rgb("#09B081"))
#assert.eq(colors.primary-lightest, colors.primary.lighten(85%))
#assert.eq(colors.primary-dark, colors.primary.darken(30%))
#assert.eq(colors.neutral-darkest, rgb("#000000"))
#assert.eq(colors.neutral-lightest, rgb("#ffffff"))

// exercise/example labels: `exercise`/`example` prefix, free suffix
#assert.eq(_label-kind(none), none)
#assert.eq(_label-kind(<exercise>), "exercise")
#assert.eq(_label-kind(<exercise-b>), "exercise")
#assert.eq(_label-kind(<example>), "example")
#assert.eq(_label-kind(<example-a>), "example")
#assert.eq(_label-kind(<exercises>), none)
#assert.eq(_label-kind(<eq-y>), none)

// icons: an unknown bare name fails at the call, with a clear message that tells how to get it; a role, a shipped
// Octicon by its 0.2.0 name and a "collection:name" (checked later, in context) return content
#assert-panic(() => icon("does-not-exist"))
#assert(catch(() => icon("does-not-exist")).contains("unknown icon"))
#assert(catch(() => icon("rocket")).contains("octicon:rocket-16"))
#assert.eq(type(icon("warning")), content)
#assert.eq(type(icon("alert")), content)
#assert.eq(type(icon("devicon:python")), content)
#assert.eq(type(icon("mdi:home")), content)
#assert.eq(theme-icons.tip, "octicon:light-bulb-16")

// code: the languages of the theme and codly's theme as plain data
#assert.eq(code-languages.python.name, "Python")
#assert.eq(type(codly-ufac-theme), dictionary)
#assert.eq(codly-ufac-theme.radius, 0pt)

// eq-box: a markup body (`#eq-box[x = 2]` is text, not math) is refused with a hint; math is accepted
#assert-panic(() => eq-box[x = 2])
#assert(catch(() => eq-box[x = 2]).contains("between dollar signs"))
#assert.eq(type(eq-box[$x = 2$]), content)
#assert.eq(type(eq-box(color: colors.quaternary, $x = 2$)), content)
#assert.eq(type(icon("tip", color: colors.tertiary, size: 2em)), content)

// title-slide: one optional content and no named argument, checked at the call
#assert.eq(type(title-slide()), content)
#assert.eq(type(title-slide[Partner]), content)
#assert-panic(() => title-slide[a][b])
#assert(catch(() => title-slide(color: red)).contains("title-slide"))

// slides by function: level-2 heading with the kind's label
#assert.eq(type(exercise-slide(title: [T])[body]), content)
#assert.eq(type(example-slide[body]), content)

// lang: "pt"/"pt-br" (region BR), "en", "es", optional region; anything else fails
#assert.eq(_lang-parse("pt-br"), (lang: "pt", region: "BR"))
#assert.eq(_lang-parse("pt"), (lang: "pt", region: "BR"))
#assert.eq(_lang-parse("pt_BR"), (lang: "pt", region: "BR"))
#assert.eq(_lang-parse("en"), (lang: "en", region: none))
#assert.eq(_lang-parse("en-US"), (lang: "en", region: "US"))
#assert.eq(_lang-parse("es"), (lang: "es", region: none))
#assert-panic(() => _lang-parse("de"))
#assert(catch(() => _lang-parse("de")).contains("unknown lang"))
#assert-panic(() => _lang-parse(none))

// the UFAC logo: the SVG (blue `#0c4da2` lettering, yellow `#fdb813` shield) and `ufac-logo-image`, which replaces
// each colour only when it is given
#assert.eq(type(ufac-logo), str)
#let logo-svg(..args) = str(ufac-logo-image(..args).source)
#assert.eq(ufac-logo-image().func(), image)
#assert(logo-svg().contains("#0c4da2") and logo-svg().contains("#fdb813"))
#assert(not logo-svg(color: white).contains("#0c4da2") and logo-svg(color: white).contains("#fdb813"))
#assert(not logo-svg(color: white, shield: white).contains("#fdb813"))
#assert.eq(ufac-logo-image().height, 0.64em)
#assert.eq(ufac-logo-image(height: 2em).height, 2em)

// outline: content (the parts of the deck, read where it stands); Typst's own is still there as `std.outline`
#assert.eq(type(outline()), content)
#assert.eq(type(std.outline), function)

// an empty slide, a `== Title` with nothing under it, compiles: its body is `none` (it used to fail in `_children`)
#ufac-theme[
  == An empty slide

  == The next slide
  Text.
]

// section-margin: true, false or a length; anything else fails at the call, with a clear message
#assert-panic(() => ufac-theme(section-margin: "yes")[])
#assert(catch(() => ufac-theme(section-margin: "yes")[]).contains("section-margin"))
#assert.eq(type(ufac-theme(section-margin: 2em)[= Part]), content)   // Touying needs a slide: an empty deck fails

API test done.

// config-info: the aliases are their fields; two names of one field, an unknown kind, an unknown key of `#info` and the
// `logos:` of 0.2.0 fail with a message that names the problem
#assert.eq(_resolve-aliases(config-info(subject: [S], subject-code: [C], unit: [U], unit-title: [T])).info,
  (title: [S], short-title: [C], short-subtitle: [U], subtitle: [T]))
#assert.eq(_resolve-aliases(config-info(semester: [2026.2])).info, (date: [2026.2], date-short: true))
#assert(catch(() => _resolve-aliases(config-info(subject: [S], title: [T]))).contains("same field"))
#assert(catch(() => _prepare-configs("pt", (config-info(kind: "poster"),))).contains("unknown kind"))
#assert.eq(_prepare-configs("en", (config-info(kind: "tcc"),)).before.first().info.short-title, "Undergraduate Thesis")
#assert.eq(_prepare-configs("pt", (config-info(kind: "course"),)).after.first().store,
  (cover-style: "top", author-label: "Ministrantes"))
#assert(catch(() => info("nope")).contains("unknown key"))
#assert(catch(() => ufac-theme(logos: (auto,))[x]).contains("config-info(logo:"))
// authors: an array becomes texts (Touying's `set document(author:)` takes only strings); free content keeps its form
// for the cover and gives the names of its first group
#assert.eq(_fix-author(config-info(author: ([Ana], [Bruno]))).info.author, ("Ana", "Bruno"))
#let free = _fix-author(config-info(author: [_Students_ \ Ana \ Bruno \ _Advisor_ \ Carlos]))
#assert.eq(free.info.author, ("Ana", "Bruno"))
#assert.eq(utils.markup-text(_join-names("en", free.info.author)), "Ana and Bruno")
#assert.eq(utils.markup-text(_join-names("pt", ([A], [B], [C]))), "A, B e C")


// cover: an unknown style or background fails with the names that exist
#assert(catch(() => title-slide(style: "left")).contains("\"stack\""))
#assert(catch(() => ufac-theme(background: "dark")[x]).contains("\"gradient\""))
