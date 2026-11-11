/// Synopsis: compile-only test (no `ref/`): checks the exported API of the theme with assertions.
#import "../../../src/lib.typ": *

// public functions exist
#for f in (ufac-theme, title-slide, slide, ending-slide, new-section-slide, question-slide, example-slide, emph-box, quote-box, arrows, arrow-list, cols,
  alert, primary, secondary, tertiary, quaternary, icon, eq-box, outline, provide-icons, callout, caution, tip, remark, note, example, examples, tag,
  info, solution, answer) {
  assert(type(f) == function, message: "expected a function, got " + str(type(f)))
}
// the syntax colors of the code, exported for `codly`
#assert.eq(type(ufac-syntax), bytes)
#assert(str(ufac-syntax).contains("<plist"))

// the `alert` of a deck is the theme's (it shadows Touying's), and the names of 0.2.0 are gone
#import "../../../src/lib.typ" as lib
#import "@preview/touying:0.7.4" as touying
#assert(lib.alert != touying.alert, message: "the alert of the theme is gone: a deck gets Touying's")
#for name in ("empty-slide", "ufac-logo-image", "local", "codly-range", "no-codly") {
  assert(name not in dictionary(lib) or dictionary(lib).at(name) == dictionary(touying).at(name, default: none),
    message: name + " is exported again")
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

// question/example labels: `question`/`example` prefix, free suffix
#assert.eq(_label-kind(none), none)
#assert.eq(_label-kind(<question>), "question")
#assert.eq(_label-kind(<question-b>), "question")
#assert.eq(_label-kind(<example>), "example")
#assert.eq(_label-kind(<example-a>), "example")
#assert.eq(_label-kind(<questions>), none)
// the label of 0.3.0 is no longer a question
#assert.eq(_label-kind(<exercise>), none)
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
#assert(catch(() => title-slide[a][b]).contains("takes one optional content"))
#assert(catch(() => title-slide(color: red)).contains("unknown argument \"color\""))

// slides by function: level-2 heading with the kind's label
#assert.eq(type(question-slide(title: [T])[body]), content)
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
#assert(catch(() => _lang-parse(none)).contains("lang must be a string"))

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


// config-info: the aliases are their fields; two names of one field, an unknown flavor, an unknown key of `#info` and
// the `logos:` of 0.2.0 fail with a message that names the problem
#assert.eq(_resolve-aliases(config-info(subject: [S], subject-code: [C], unit: [U], unit-title: [T])).info,
  (title: [S], short-title: [C], short-subtitle: [U], subtitle: [T]))
#assert.eq(_resolve-aliases(config-info(semester: [2026.2])).info, (date: [2026.2], date-short: true))
#assert(catch(() => _resolve-aliases(config-info(subject: [S], title: [T]))).contains("same field"))
#assert(catch(() => _prepare-configs("pt", (config-info(flavor: "poster"),))).contains("unknown flavor"))
#assert(catch(() => _prepare-configs("pt", (config-info(flavor: "course"),))).contains("the flavor \"course\" was removed"))
#assert(catch(() => _prepare-configs("pt", (config-info(flavor: "talk"),))).contains("the flavor \"talk\" was removed"))
#assert.eq(_prepare-configs("en", (config-info(flavor: "tcc"),)).before.first().info.short-title, "Undergraduate Thesis")
#assert.eq(_prepare-configs("pt", (config-info(flavor: "tcc"),)).after.first().store, (cover-layout: "top"))
// a deck without a flavor is a lecture: the layout "line" and the prefix of the theme
#assert.eq(_prepare-configs("pt", (config-info(title: [T]),)).after.first().store, (cover-layout: "line"))
#assert.eq(_prepare-configs("pt", ()).before, ())
// the name of 0.3.0 before the flavors fails with the new one and the value given, instead of being kept as an
// unknown field; the flavor given to the theme instead of config-info fails too, instead of being ignored
#assert(catch(() => ufac-theme(config-info(kind: "thesis"))[x]).contains("kind is now flavor (flavor: \"thesis\")"))
#assert(catch(() => ufac-theme(flavor: "tcc")[x]).contains("config-info(flavor:"))
// the flavors removed, by either name, give the way to do the same
#assert(catch(() => ufac-theme(config-info(flavor: "course"))[x]).contains("cover-layout: \"top\", author-label"))
#assert(catch(() => ufac-theme(config-info(kind: "talk"))[x]).contains("counter-prefix: none"))
// an option of the cover in the wrong place fails with the right one, instead of being ignored
#assert(catch(() => ufac-theme(config-info(cover-style: "plain"))[x]).contains("ufac-theme(cover-style:"))
#assert(catch(() => ufac-theme(config-info(cover-layout: "top"))[x]).contains("title-slide(cover-layout:"))
#assert(catch(() => ufac-theme(config-info(author-label: [A]))[x]).contains("title-slide(author-label:"))
#assert(catch(() => title-slide(cover-style: "plain")).contains("ufac-theme(cover-style:"))
#assert(catch(() => ufac-theme(cover-layout: "top")[x]).contains("title-slide(cover-layout:"))
#assert(catch(() => ufac-theme(author-label: [A])[x]).contains("title-slide(author-label:"))
#assert(catch(() => ufac-theme(kind: "tcc")[x]).contains("config-info(flavor:"))
// the flavors that are not part of a course number the questions without a prefix, before the configs of the deck
#for flavor in ("coursework", "tcc", "dissertation", "thesis") {
  let prefix = _prepare-configs("en", (config-info(flavor: flavor),)).before.map(c => c.info).filter(i => "counter-prefix" in i)
  assert.eq(prefix, ((counter-prefix: none),), message: flavor + " has no units: no prefix")
}
#assert(_prepare-configs("en", (config-info(flavor: "lecture"),)).before.all(c => "counter-prefix" not in c.info),
  message: "lecture keeps the prefix of the theme")
#assert(catch(() => info("nope")).contains("unknown key"))
// `counter-prefix` and `flavor` are not information to show
#assert(catch(() => info("counter-prefix")).contains("unknown key"))
#assert(catch(() => info("flavor")).contains("unknown key"))
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


// cover: an unknown layout or cover style fails with the names that exist; the names of 0.3.0 (`style`,
// `background`) fail with the new ones
#assert(catch(() => title-slide(cover-layout: "left")).contains("\"stack\""))
#assert(catch(() => ufac-theme(cover-style: "circles")[x]).contains("\"circles\" is now \"bubbles\""))
#assert(catch(() => ufac-theme(cover-style: "dark")[x]).contains("\"plain\""))
#assert(catch(() => title-slide(style: "stack")).contains("style is now cover-layout (cover-layout: \"stack\")"))
#assert(catch(() => ufac-theme(background: "plain")[x]).contains("background is now cover-style (cover-style: \"plain\")"))
#assert(catch(() => ufac-theme(background: "circles")[x]).contains("(cover-style: \"bubbles\")"))

// closing slide: up to three contents, or the body alone with the named title/subtitle; checked at the call
#assert.eq(type(ending-slide()), content)
#assert.eq(type(ending-slide[T][S][B]), content)
#assert.eq(type(ending-slide(title: [T])[B]), content)
#assert(catch(() => ending-slide[a][b][c][d]).contains("at most three"))
#assert(catch(() => ending-slide(title: [T])[a][b]).contains("the body"))
#assert(catch(() => ending-slide(color: red)).contains("unknown argument \"color\""))


// questions and examples: the markers of the solution are functions that give a metadata, with the separator;
// written bare (`#solution`), Typst writes the name of the function, which the theme reads as the marker with "."
#assert.eq(solution().func(), metadata)
#assert.eq(answer(sep: ":").value, (kind: "ufac-solution", word: "answer", sep: ":"))
#assert.eq(_solution-marker([#answer]), ("answer", "."))
#assert.eq(_solution-marker([#solution(sep: [:\ ])]), ("solution", [:\ ]))

// the callouts, the icons and the closing slide refuse what they do not know, with a message that says so
#assert(catch(() => callout("x")[a]).contains("unknown kind"))
#assert(catch(() => callout("tip", style: "x")[a]).contains("style is \"bar\" or \"badge\""))
#assert(catch(() => icon(5)).contains("the name is a string"))
// the icons of the badges are checked when the theme is applied
#assert(catch(() => ufac-theme(question-icon: 5)[x]).contains("question-icon is the name of an icon"))
#assert(catch(() => ufac-theme(example-icon: 5)[x]).contains("example-icon"))
// every kind of callout has its title in both styles; every language has every word of Portuguese, the titles of the
// bar callouts included
#for kind in _callout-kinds.keys() {
  assert(kind in _lang-db.pt, message: kind)
  assert(kind in _lang-db.pt.bar, message: kind)
}
#assert.eq((_lang-db.pt.bar.examples, _lang-db.en.bar.examples, _lang-db.es.bar.examples),
  ("Exemplos.", "Examples.", "Ejemplos."))
#for (lang, words) in _lang-db {
  assert.eq(words.keys().sorted(), _lang-db.pt.keys().sorted(), message: lang)
  assert.eq(words.bar.keys().sorted(), _lang-db.pt.bar.keys().sorted(), message: lang)
}

API test done.

// the names of 0.3.0 for a question stop with the new ones: the function, the options of the theme, the label of a
// slide (when the theme is applied), a citation of it and the role of the icon
#assert.eq(catch(() => exercise-slide(title: [T])[x]), "assertion failed: exercise-slide is now question-slide in 0.4.0")
#assert.eq(catch(() => ufac-theme(exercise-name: [Task])[x]),
  "assertion failed: ufac-theme: exercise-name is now question-name in 0.4.0")
#assert.eq(catch(() => ufac-theme(exercise-icon: "pencil")[x]),
  "assertion failed: ufac-theme: exercise-icon is now question-icon in 0.4.0")
#assert.eq(catch(() => ufac-theme[== Tides <exercise>]),
  "assertion failed: the label <exercise> is now <question> in 0.4.0")
#assert.eq(catch(() => ufac-theme[== Tides <exercise-tides> \ x]),
  "assertion failed: the label <exercise-tides> is now <question-tides> in 0.4.0, cited as @question-tides")
#assert.eq(catch(() => icon("exercise")),
  "assertion failed: icon: the role \"exercise\" is now \"question\" in 0.4.0, #icon(\"question\")")
#assert.eq(theme-icons.question, "octicon:pencil-16")
#assert("exercise" not in theme-icons)
// the initial of the bookmark of a question comes from the text of a name given as content
#assert.eq(_plain-text([*Tarefa* de casa]), "Tarefa de casa")
