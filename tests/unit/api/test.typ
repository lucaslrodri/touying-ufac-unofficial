/// Synopsis: compile-only test (no `ref/`): checks the exported API of the theme with assertions.
#import "@preview/touying-ufac-unofficial:0.1.0": *

// public functions exist
#for f in (ufac-theme, title-slide, slide, empty-slide, new-section-slide, exercise-slide, example-slide, emph-box, quote-box, arrows, cols,
  primary, secondary, tertiary, quaternary, icon, local, eq-box) {
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

// icons: an unknown name fails at the call, with a clear message; a valid name returns content
#assert-panic(() => icon("does-not-exist"))
#assert(catch(() => icon("does-not-exist")).contains("unknown icon"))
#assert.eq(type(icon("link")), content)

// eq-box: a markup body (`#eq-box[x = 2]` is text, not math) is refused with a hint; math is accepted
#assert-panic(() => eq-box[x = 2])
#assert(catch(() => eq-box[x = 2]).contains("between dollar signs"))
#assert.eq(type(eq-box[$x = 2$]), content)
#assert.eq(type(eq-box(color: colors.quaternary, $x = 2$)), content)
#assert.eq(type(icon("link", color: colors.tertiary, size: 2em)), content)

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

API test done.
