/// Synopsis: compile-only test (no `ref/`): checks the exported API of the theme with assertions.
#import "../../../src/lib.typ": *

// public functions exist
#for f in (ufac-theme, title-slide, slide, ending-slide, new-section-slide, exercise-slide, example-slide, emph-box, quote-box, arrows, cols,
  primary, secondary, tertiary, quaternary, icon, eq-box, outline, provide-icons, callout, caution, tip, remark, note, tag,
  info, solution, answer) {
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

// the UFAC logo: the SVG (blue `#0c4da2` lettering, yellow `#fdb813` shield) and the internal `_ufac-logo-image`,
// which replaces each color only when it is given
#assert.eq(type(ufac-logo), str)
#let logo-svg(..args) = str(_ufac-logo-image(..args).source)
#assert.eq(_ufac-logo-image().func(), image)
#assert(logo-svg().contains("#0c4da2") and logo-svg().contains("#fdb813"))
#assert(not logo-svg(color: white).contains("#0c4da2") and logo-svg(color: white).contains("#fdb813"))
#assert(not logo-svg(color: white, shield: white).contains("#fdb813"))
#assert.eq(_ufac-logo-image().height, 0.64em)
#assert.eq(_ufac-logo-image(height: 2em).height, 2em)

// outline: content (the parts of the deck, read where it stands); Typst's own is still there as `std.outline`
#assert.eq(type(outline()), content)
#assert.eq(type(std.outline), function)

// an empty slide, a `== Title` with nothing under it, compiles: its body is `none` (it used to fail in `_children`)
#ufac-theme[
  == An empty slide

  == The next slide
  Text.
]

// the margin of the section slides is a parameter of `new-section-slide` (auto or a length); the `section-margin` of
// 0.2.0 fails at the call and says where it went
#assert(catch(() => ufac-theme(section-margin: 2em)[]).contains("new-section-slide(margin:)"))
#assert.eq(type(ufac-theme(config-common(new-section-slide-fn: new-section-slide.with(margin: 2em)))[= Part]), content)


// config-info: the aliases are their fields; two names of one field, an unknown kind, an unknown key of `#info` and
// the `logos:` of 0.2.0 fail with a message that names the problem
#assert.eq(_resolve-aliases(config-info(subject: [S], subject-code: [C], unit: [U], unit-title: [T])).info,
  (title: [S], short-title: [C], short-subtitle: [U], subtitle: [T]))
#assert.eq(_resolve-aliases(config-info(semester: [2026.2])).info, (date: [2026.2], date-short: true))
#assert(catch(() => _resolve-aliases(config-info(subject: [S], title: [T]))).contains("same field"))
#assert(catch(() => _prepare-configs("pt", (config-info(kind: "poster"),))).contains("unknown kind"))
#assert.eq(_prepare-configs("en", (config-info(kind: "tcc"),)).before.first().info.short-title, "Undergraduate Thesis")
#assert.eq(_prepare-configs("pt", (config-info(kind: "course"),)).after.first().store,
  (cover-style: "top", author-label: "Ministrantes"))
// the kinds that are not part of a course number the exercises without a prefix, before the configs of the deck
#for kind in ("coursework", "talk", "tcc", "dissertation", "thesis") {
  let prefix = _prepare-configs("en", (config-info(kind: kind),)).before.map(c => c.info).filter(i => "counter-prefix" in i)
  assert.eq(prefix, ((counter-prefix: none),), message: kind + " has no units: no prefix")
}
#for kind in ("lecture", "course") {
  let infos = _prepare-configs("en", (config-info(kind: kind),)).before.map(c => c.info)
  assert(infos.all(i => "counter-prefix" not in i), message: kind + " keeps the prefix of the theme")
}
#assert(catch(() => info("nope")).contains("unknown key"))
#assert(catch(() => ufac-theme(logos: (auto,))[x]).contains("config-info(logo:"))
// authors: an array becomes texts (Touying's `set document(author:)` takes only strings); free content keeps its form
// for the cover and gives the names of its first group
#assert.eq(_fix-author(config-info(author: ([First], [Second]))).info.author, ("First", "Second"))
#let free = _fix-author(config-info(author: [_Students_ \ First \ Second \ _Advisor_ \ Third]))
#assert.eq(free.info.author, ("First", "Second"))
#assert.eq(utils.markup-text(_join-names("en", free.info.author)), "First and Second")
#assert.eq(utils.markup-text(_join-names("pt", ([A], [B], [C]))), "A, B e C")
// the config of a deck of 0.2.0 (`subject` with the old `title`) gets a hint on what to rename
#assert(catch(() => _resolve-aliases(config-info(subject: [S], title: [T]))).contains("rename title to unit-title"))


// cover: an unknown style or background fails with the names that exist
#assert(catch(() => title-slide(style: "left")).contains("\"stack\""))
#assert(catch(() => ufac-theme(background: "dark")[x]).contains("\"gradient\""))

// closing slide: up to three contents, or the body alone with the named title/subtitle; checked at the call
#assert.eq(type(ending-slide()), content)
#assert.eq(type(ending-slide[T][S][B]), content)
#assert.eq(type(ending-slide(title: [T])[B]), content)
#assert(catch(() => ending-slide[a][b][c][d]).contains("at most three"))
#assert(catch(() => ending-slide(title: [T])[a][b]).contains("the body"))
#assert(catch(() => ending-slide(color: red)).contains("unknown argument"))


// exercises and examples: the markers of the solution are functions that give a metadata, with the separator;
// written bare (`#solution`), Typst writes the name of the function, which the theme reads as the marker with "."
#assert.eq(solution().func(), metadata)
#assert.eq(answer(sep: ":").value, (kind: "ufac-solution", word: "answer", sep: ":"))
#assert.eq(_solution-marker([#answer]), ("answer", "."))
#assert.eq(_solution-marker([#solution(sep: [:\ ])]), ("solution", [:\ ]))

// the callouts, the icons and the closing slide refuse what they do not know, with a message that says so
#assert(catch(() => callout("x")[a]).contains("unknown kind"))
#assert(catch(() => callout("tip", style: "x")[a]).contains("style"))
#assert(catch(() => icon(5)).contains("string"))
// the icons of the badges are checked when the theme is applied
#assert(catch(() => ufac-theme(exercise-icon: 5)[x]).contains("exercise-icon is the name of an icon"))
#assert(catch(() => ufac-theme(example-icon: 5)[x]).contains("example-icon"))
// every language has every word of Portuguese, the titles of the bar callouts included
#for (lang, words) in _lang-db {
  assert.eq(words.keys().sorted(), _lang-db.pt.keys().sorted(), message: lang)
  assert.eq(words.bar.keys().sorted(), _lang-db.pt.bar.keys().sorted(), message: lang)
}

API test done.
