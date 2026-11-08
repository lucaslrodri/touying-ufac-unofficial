// touying-ufac-unofficial — internal helpers: content inspection, the context color stack, the `raw` gate, backslash
// escapes, exercise/example labels, the localized words, the current-subtitle query and the footer pieces.
// Names starting with `_` are not part of the public API (Typst has no private bindings, so they stay reachable).
#import "@preview/touying:0.7.4": *
#import "constants.typ": colors, _ufac-logo-image

// ---------- content inspection ----------
#let _seq = [].func()
// (`none` is the body of an empty slide, a `== Title` with nothing under it: no children)
#let _children(it) = if it == none { () } else if it.func() == _seq { it.children } else { (it,) }
#let _styled = { set text(fill: red); [x] }.func()
/// Already-realized content arrives as `styled(child: …)`; peel the layers off.
///
/// #test(`_unstyle({ set text(fill: red); [x] }) == [x]`, `_unstyle([x]) == [x]`)
/// -> content
#let _unstyle(
  /// Any content. -> content
  c,
) = { while c.func() == _styled { c = c.child }; c }
#let _is-space(c) = c == [ ]
#let _is-text(c) = c.func() == text and c.has("text")
#let _is-dq(c) = c.func() == smartquote and c.double
/// Level-3 heading before or after layout: `depth` exists before layout, `level` only after it.
///
/// #test(`_is-h3(heading(depth: 3)[x])`, `not _is-h3(heading(depth: 2)[x])`, `not _is-h3([x])`)
/// -> bool
#let _is-h3(
  /// Any content. -> content
  c,
) = c.func() == heading and (c.at("depth", default: none) == 3 or c.at("level", default: none) == 3)
/// Strips empty contents (`[]`, `[ ]`, `parbreak()`, `linebreak()`) from both ends of an array of children
/// (the theme's own, so that it does not depend on where Touying keeps its `trim`: 0.7.4 exports `utils.trim`, 0.8 moved it
/// to `core.tree`, which is not exported).
///
/// #test(
///   `_trim(([ ], [a], parbreak(), [b], [ ], [])) == ([a], parbreak(), [b])`,
///   `_trim(([ ], parbreak())) == ()`,
///   `_trim(()) == ()`,
/// )
/// -> array
#let _trim(
  /// Children of a sequence. -> array
  arr,
  /// What counts as empty. -> array
  empty: ([], [ ], parbreak(), linebreak()),
) = {
  let i = 0; let j = arr.len()
  while i < j and arr.at(i) in empty { i += 1 }
  while j > i and arr.at(j - 1) in empty { j -= 1 }
  arr.slice(i, j)
}
#let _first-child(body) = { let ch = _trim(_children(body)); if ch.len() > 0 { ch.first() } else { none } }
/// A `metadata` of a given kind (`value.kind`): a marker of the theme or a `#pause` of Touying.
///
/// #test(`_is-meta(metadata((kind: "k")), "k")`, `not _is-meta(metadata("k"), "k")`, `not _is-meta([x], "k")`)
/// -> bool
#let _is-meta(
  /// Any content. -> content
  c,
  /// The kind. -> str
  kind,
) = c.func() == metadata and type(c.value) == dictionary and c.value.at("kind", default: none) == kind
/// A value that was given: not `none`, `auto`, `[]` nor `""`.
///
/// #test(`_given([x])`, `not _given([])`, `not _given(none)`, `not _given(auto)`, `not _given("")`)
/// -> bool
#let _given(
  /// Any value. -> any
  x,
) = x not in (none, auto, [], "")
/// A value or an array of values, always as an array (`none` is the empty array).
///
/// #test(`_list(none) == ()`, `_list([a]) == ([a],)`, `_list(([a], [b])) == ([a], [b])`, `_list(auto) == (auto,)`)
/// -> array
#let _list(
  /// A value, an array or `none`. -> any
  x,
) = if x == none { () } else if type(x) == array { x } else { (x,) }
/// A value that shows nothing: not given (`_given`), or a text or content made only of spaces and line breaks.
///
/// #test(`_blank([ ])`, `_blank("  ")`, `_blank(none)`, `_blank([])`, `not _blank([x])`, `not _blank([ x ])`)
/// -> bool
#let _blank(
  /// Any value. -> any
  x,
) = if not _given(x) { true } else if type(x) == str { x.trim() == "" } else if type(x) != content { false } else {
  _children(x).all(c => _is-space(c) or c.func() in (linebreak, parbreak))
}
/// Content that is there and shows nothing: only updates of a state or a counter (`#provide-icons(..)`), metadata,
/// spaces and breaks.
///
/// #test(`_unseen([#state("s").update(1)])`, `_unseen([ #metadata(1) ])`, `not _unseen([])`, `not _unseen([x])`)
/// -> bool
#let _unseen(
  /// Any content. -> content
  x,
) = {
  let quiet = ([#state("_").update(none)].func(), [#counter("_").update(0)].func(), metadata)
  let ch = _children(_unstyle(x)).filter(c => not (_is-space(c) or c.func() in (linebreak, parbreak)))
  ch.len() > 0 and ch.all(c => c.func() in quiet)
}
/// A mark of Touying (`#pause`) in a paragraph of its own between two items of a list (`-`, `+` or `/`), with blank
/// lines around it, glued to them: the paragraph breaks around the mark become spaces. With the breaks, Typst put the
/// covered items in the same (spaced) list as the visible ones, outside the veil, and the step showed everything; glued,
/// the list is the same on every step, as with the mark on its own line.
///
/// #test(`_glue-item-pauses([- a
///
/// #metadata(1)
///
/// - b]).children.filter(c => c.func() == parbreak).len() == 0`)
/// -> any
#let _glue-item-pauses(
  /// A body of the slide. -> any
  body,
) = {
  if type(body) != content or body.func() != _seq { return body }
  let ch = body.children
  let item(c) = c.func() in (list.item, enum.item, terms.item)
  let gap(c) = _is-space(c) or c.func() == parbreak
  let out = ch
  for (i, c) in ch.enumerate() {
    if c.func() != metadata { continue }
    // the nearest children around the mark that are not a space or a paragraph break
    let a = i - 1
    while a >= 0 and gap(ch.at(a)) { a -= 1 }
    let b = i + 1
    while b < ch.len() and gap(ch.at(b)) { b += 1 }
    if a < 0 or b >= ch.len() or not item(ch.at(a)) or not item(ch.at(b)) { continue }
    for j in range(a + 1, b) { if ch.at(j).func() == parbreak { out.at(j) = [ ] } }
  }
  out.join()
}
/// The consecutive `+` items of a body of a slide that a mark of Touying splits (`#pause` is a `metadata` between two
/// items), with their numbers written in (`enum.item(n, ..)`), counted as Typst counts them (an item with its own
/// number sets it). Touying splits a list at a `#pause`, and the covered part, a list of its own under the veil,
/// started again at 1: "1. second" on the first step, "2. second" once revealed. A list that no mark splits is left
/// alone, so that `#set enum(start: ..)` and the like still apply to it.
///
/// #test(`_number-items([+ a
/// #metadata(1)
/// + b]).children.filter(c => c.func() == enum.item).map(c => c.number) == (1, 2)`, `_number-items([+ a
/// + b]).children.filter(c => c.func() == enum.item).all(c => c.at("number", default: auto) == auto)`)
/// -> any
#let _number-items(
  /// A body of the slide. -> any
  body,
) = {
  if type(body) != content or body.func() != _seq { return body }
  let ch = body.children
  // the runs of consecutive items: a space, a paragraph break or a mark of Touying between two items keeps a run going
  let (runs, run) = ((), ())
  for (i, c) in ch.enumerate() {
    if c.func() == enum.item { run.push(i) } else if not (_is-space(c) or c.func() in (parbreak, metadata)) {
      if run.len() > 0 { runs.push(run); run = () }
    }
  }
  if run.len() > 0 { runs.push(run) }
  let out = ch
  for run in runs {
    if not range(run.first(), run.last()).any(i => ch.at(i).func() == metadata) { continue }
    let n = 0
    for i in run {
      let own = ch.at(i).at("number", default: auto)
      n = if own == auto or own == none { n + 1 } else { own }
      if own == auto or own == none { out.at(i) = enum.item(n, ch.at(i).body) }
    }
  }
  out.join()
}
/// A body made of a single paragraph inside a `block`/`grid` does not become a `par` element (Typst treats it as
/// inline content), so the `show par` rewrites (`->`, `> `, `"…"`) never run. A leading `parbreak()` forces the
/// paragraph without adding space.
/// -> content
#let _flow(
  /// Body of a box or column. -> content
  body,
) = { parbreak(); body }

// ---------- context color stack ----------
/// Stack of `(color:, kind:, fill:)` entries, `kind` ∈ "box" | "pill" | "title", pushed by `emph-box` (body: "box";
/// title badge: "pill"), `_pill`, the slide header ("title"), the section title ("title") and the content of the
/// cover ("pill": white on blue). `*bold*`,
/// `==highlight==`, the `->` arrow, `#underline`, `#icon` and inline `raw` read the color at layout time (in
/// `context`): in the `> box` form the paragraph reaches `show par` already realized (strong/highlight become
/// `styled(...)` with black/yellow baked in), so set/show rules inside the box cannot reach them anymore; a `state`
/// resolves at the right place. Inline `raw` uses light tones in boxes and titles and dark tones with light text in pills.
/// `fill` is the background of a box that has one (a callout, a light cell of a table, a pill), for the veil of `#pause`.
/// -> state
#let _box-color = state("ufac-box-color", ())
#let _in-box(color, body, kind: "box", fill: none) = {
  _box-color.update(s => s + ((color: color, kind: kind, fill: fill),))
  body
  _box-color.update(s => s.slice(0, -1))
}
/// The color of the veil of `#pause` at this place (in `context`): the background of the nearest box around that has
/// one (a callout, a light cell of a table), else the page; at 85% opacity, so the covered content stays faintly
/// visible. A white veil over a callout left white bands over its color.
/// -> color
#let _veil-color(
  /// The fill of the page. -> any
  page,
) = {
  let boxed = _box-color.get().rev().find(e => e.at("fill", default: none) != none)
  (if boxed != none { boxed.fill } else if type(page) == color { page } else { white }).transparentize(15%)
}
#let _current-box-color(fallback) = { let s = _box-color.get(); if s.len() == 0 { fallback } else { s.last().color } }
#let _in-pill() = { let s = _box-color.get(); s.len() > 0 and s.last().kind == "pill" }
/// Emphasis color readable in the current context: inside a pill (white text on the color) the blue of
/// `#alert`/`#primary` would vanish, so it becomes UFAC yellow (like the underline, already yellow in pills);
/// elsewhere the requested color.
/// -> color
#let _emph-color(
  /// Requested color. -> color
  c,
) = if _in-pill() { colors.secondary } else { c }

// ---------- raw gate and code box ----------
/// True inside any `raw` (inline or block): the `==x==` shorthand is not applied there.
/// -> state
#let _in-raw = state("ufac-in-raw", false)
/// Marks the inside of every `raw` (inline and block) so the `==x==` rule stays literal there. In `init` it comes after
/// the code rules (innermost rule: it runs first, so the marks also wrap the code box and codly's output).
/// -> content
#let _gate-raw(
  /// Content whose `raw` elements are marked. -> content
  body,
) = { show raw: it => { _in-raw.update(true); it; _in-raw.update(false) }; body }
// ---------- key-equation signal ----------
/// Set (to a color) by a lone `>` line: the next block equation gets an `eq-box` (see `show math.equation`
/// in `init`, which consumes the signal).
/// -> state
#let _key-eq = state("ufac-key-eq", none)
/// Invisible marker that `eq-box` leaves in front of its box. The `show math.equation` rule of the shorthand rebuilds
/// the equation with an `eq-box` inside, and the rebuilt equation goes through the same rule: the state cannot stop it
/// (within one layout pass a new location does not see the `update(none)` yet, so the rule recursed forever), a
/// structural check can.
/// -> content
#let _eq-mark = metadata("ufac-eq-box")
/// Where an `eq-box` sits, set by the `show math.equation` rule around every block equation that holds one: "whole"
/// (the box is the whole equation: display style, generous padding), "part" (a part of a block equation: display
/// style, tight padding) or `none` (running text or an inline equation: text style, tight padding that does not
/// add to the line height).
/// -> state
#let _eq-ctx = state("ufac-eq-ctx", none)
/// Children of a content with nested sequences and styles flattened, spaces dropped.
/// -> array
#let _flat(
  /// Any content. -> content
  c,
) = { let c = _unstyle(c); if c.func() == _seq { c.children.map(_flat).flatten() } else if _is-space(c) { () } else { (c,) } }
/// True when the body of an equation is nothing but one `eq-box` (its mark followed by its box).
///
/// #test(
///   `_is-whole-eq-box($#_eq-mark#box[x]$.body)`,
///   `not _is-whole-eq-box($y = #_eq-mark#box[x]$.body)`,
///   `not _is-whole-eq-box($x$.body)`,
/// )
/// -> bool
#let _is-whole-eq-box(
  /// Body of an equation. -> content
  c,
) = { let f = _flat(c); f.len() == 2 and f.first() == _eq-mark }
/// True when the content holds an @_eq-mark, i.e. an `eq-box`.
///
/// #test(`_has-eq-mark([a #_eq-mark b])`, `_has-eq-mark($x + #[#_eq-mark y]$.body)`, `not _has-eq-mark($x + y$.body)`)
/// -> bool
#let _has-eq-mark(
  /// Body of an equation. -> content
  c,
) = { let c = _unstyle(c); c == _eq-mark or (c.func() == _seq and c.children.any(_has-eq-mark)) }

// ---------- backslash escapes ----------
/// Without the backslash, Typst's lexer merges `> word` (and `-> word`) into a single text node; with `\>` the sign
/// arrives alone, followed by (a space and) a text node starting with a letter or digit. That is what tells an
/// escape apart. If what follows is not a word (`==`, `*x*`, `(a)`), both forms are identical and the escape is not
/// recognized. `\"` arrives as the text `"`, not as a `smartquote`, so quotes need no special handling.
///
/// #test(
///   `_alnum-start("word")`, `_alnum-start("1st")`, `_alnum-start("água")`,
///   `not _alnum-start("== T")`, `not _alnum-start("")`, `not _alnum-start(" x")`,
/// )
/// -> bool
#let _alnum-start(
  /// Text that follows the escaped sign. -> str
  s,
) = s.len() > 0 and s.clusters().first().match(regex("[\p{L}\p{N}]")) != none
#let _escaped-after(ch, i) = {
  if i < ch.len() and _is-space(ch.at(i)) { i += 1 }
  i < ch.len() and _is-text(ch.at(i)) and _alnum-start(ch.at(i).text)
}

// ---------- exercise / example labels ----------
/// Kind of a heading label: `<exercise>`/`<exercise-id>` → "exercise", `<example>`/`<example-id>` → "example",
/// otherwise `none`. The suffix (id) changes nothing on the slide; it only makes the label unique so the slide can
/// be cited with `@exercise-id` / `@example-id`.
///
/// #test(
///   `_label-kind(label("exercise")) == "exercise"`,
///   `_label-kind(label("exercise-ogata")) == "exercise"`,
///   `_label-kind(label("example-xor")) == "example"`,
///   `_label-kind(label("exercises")) == none`,
///   `_label-kind(label("eq-y")) == none`,
///   `_label-kind(none) == none`,
/// )
/// -> str | none
#let _label-kind(
  /// Label of a level-2 heading, or `none`. -> label | none
  lbl,
) = {
  if lbl == none { return none }
  let s = str(lbl)
  if s == "exercise" or s.starts-with("exercise-") { "exercise" } else if s == "example" or s.starts-with("example-") { "example" }
}
/// Localized words of the theme (`lang.toml`: pt, en, es).
/// -> dictionary
#let _lang-db = toml("lang.toml").lang
/// The words of a language (`"pt"`, `"en"`, `"es"`); an unknown language falls back to Portuguese.
///
/// #test(`_words("en").thanks == "Thank you!"`, `_words("fr").and == "e"`, `_words("es").months.len() == 12`)
/// -> dictionary
#let _words(
  /// Language code, as in `text.lang`. -> str
  lang,
) = _lang-db.at(lang, default: _lang-db.pt)
/// A localized word for the current `text.lang` (contextual content), so that a `#set text(lang:)` in the middle of a
/// deck changes it too.
/// -> content
#let _tr(
  /// Key of `lang.toml`: `"exercise"`, `"thanks"`, … -> str
  key,
) = context _words(text.lang).at(key)
/// `lang` parameter of the theme → `(lang:, region:)` for `set text`: "pt"/"pt-br" (region BR by default), "en", "es";
/// an explicit region may follow the code (`en-US`, `es-MX`); anything else is an error.
///
/// #test(
///   `_lang-parse("pt-br") == (lang: "pt", region: "BR")`,
///   `_lang-parse("pt") == (lang: "pt", region: "BR")`,
///   `_lang-parse("pt-PT") == (lang: "pt", region: "PT")`,
///   `_lang-parse("en") == (lang: "en", region: none)`,
///   `_lang-parse("en_us") == (lang: "en", region: "US")`,
///   `_lang-parse("ES-mx") == (lang: "es", region: "MX")`,
/// )
/// -> dictionary
#let _lang-parse(
  /// The `lang` parameter of the theme. -> str
  lang,
) = {
  assert(type(lang) == str, message: "lang must be a string (\"pt-br\", \"en\" or \"es\"), got " + repr(lang))
  let parts = lower(lang).replace("_", "-").split("-")
  let code = parts.first()
  assert(code in ("pt", "en", "es"), message: "unknown lang \"" + lang + "\": use \"pt-br\" (or \"pt\"), \"en\" or \"es\"")
  let region = if parts.len() > 1 { upper(parts.at(1)) } else if code == "pt" { "BR" } else { none }
  (lang: code, region: region)
}
/// Name shown for `key` ("exercise", "example", "part"): the theme parameter `<key>-name` when given, otherwise the
/// translation for the current `text.lang` (contextual content).
/// -> content
#let _name(
  /// Touying's `self`. -> dictionary
  self,
  /// `"exercise"`, `"example"` or `"part"`. -> str
  key,
) = { let v = self.store.at(key + "-name", default: auto); if v == auto { _tr(key) } else { v } }
/// `(name, color)` of a kind: the name comes from the theme store or the translation, the color from the palette.
/// -> array
#let _kind-style(
  /// Touying's `self`. -> dictionary
  self,
  /// `"exercise"` or `"example"`. -> str
  kind,
) = if kind == "exercise" { (_name(self, "exercise"), self.colors.tertiary) } else { (_name(self, "example"), self.colors.quaternary) }
/// Icon of a kind in its pill: the theme parameter `<kind>-icon` (`ufac-theme(exercise-icon:, example-icon:)`), a
/// pencil for exercises and a beaker for examples when the theme did not set it (a stand-in `self`).
/// -> none | str | content
#let _kind-icon(
  /// Touying's `self`. -> dictionary
  self,
  /// `"exercise"` or `"example"`. -> str
  kind,
) = self.store.at(kind + "-icon", default: if kind == "exercise" { "pencil" } else { "beaker" })
/// Index of an "Exercise"/"Example": position among the level-2 headings of the same kind whose page is ≤ the given
/// page (page based, like `utils.current-heading`, because the header is laid out before the body). The headings
/// re-emitted by Touying on `---` continuations do not show up in `query`, only the original, which keeps the count simple.
/// -> int
#let _kind-index(
  /// `"exercise"` or `"example"`. -> str
  kind,
  /// Page of the slide. -> int
  page,
) = query(heading.where(level: 2)).filter(x => _label-kind(x.at("label", default: none)) == kind and x.location().page() <= page).len()

// ---------- current subtitle (level-3 heading, repeated after `---`) ----------
/// Last level-3 heading between the current `==` and `here()`, or `none`. Touying re-emits the `==` at every
/// continuation, so the group of consecutive identical level-2 headings is walked back to its first member.
/// -> content | none
#let _current-subtitle(
  /// Subtitle bodies declared by the slide that is asking, to be ignored. -> array
  skip: (),
) = {
  let h2s = query(heading.where(level: 2).before(here()))
  if h2s.len() == 0 { return none }
  let i = h2s.len() - 1
  while i > 0 and h2s.at(i - 1).body == h2s.at(i).body { i -= 1 }
  let start = h2s.at(i).location()
  // `skip`: subtitles declared by the slide that is asking. With `#pause`, the earlier subpages of the same slide
  // come before `here()` and would otherwise be taken for a subtitle carried over from a previous `---` page.
  let h3s = query(heading.where(level: 3).after(start).before(here())).filter(h => h.body not in skip)
  if h3s.len() > 0 { h3s.last() }
}

// ---------- cover (`#pause`, `#uncover`) ----------
/// Value of the `metadata` marker left after a covered chunk (see @_cover).
/// -> str
#let _veil-end = "ufac-veil-end"
/// Element functions that make a covered chunk block-level.
/// -> array
#let _block-funcs = (list.item, enum.item, terms.item, list, enum, terms, heading, table, grid, figure, block, stack, pad, align, columns, image, rect, quote,
  // a `layout` (the box with a title): its element is not the function `layout`
  [#layout(_ => none)].func())
/// True when the content holds a block-level element (or a paragraph break).
///
/// #test(`_is-blocky([- item])`, `_is-blocky([a #parbreak() b])`, `not _is-blocky([plain *text*])`)
/// -> bool
#let _is-blocky(
  /// Any content. -> content
  c,
) = {
  let c = _unstyle(c)
  if c.func() == _seq { c.children.any(_is-blocky) }
  else if c.func() == parbreak { true }
  else if c.func() in (raw, math.equation) { c.at("block", default: false) }
  else { c.func() in _block-funcs }
}
/// True when the children are those of a lone shorthand paragraph: `> box`, `"quote"` or `-> item`.
///
/// #test(`_is-shorthand-par(([> box],))`, `_is-shorthand-par(([-], [> item]))`, `not _is-shorthand-par(([text],))`)
/// -> bool
#let _is-shorthand-par(
  /// Trimmed children of the covered body. -> array
  ch,
) = {
  let first = ch.first()
  ((_is-text(first) and first.text.starts-with(">")) or (_is-dq(first) and _is-dq(ch.last()))
    or (_is-text(first) and first.text == "-" and ch.len() > 1 and _is-text(ch.at(1)) and ch.at(1).text.starts-with(">")))
}
/// Covered running text (a paragraph after `#pause`, or the rest of one). Touying's `cover-with-rect` covers each child
/// of a sequence on its own, a `strike` over each piece of text: the text of the line no longer merges, so the rules
/// that match the merged text no longer saw `~underline~` and `~~alert~~` (made of non-breaking spaces, wide spaces in
/// the covered line), and the bar, as tall as the letters, left the sides of a code chip, the edge of a highlight and an
/// icon uncovered. Here each run of inline text stays whole, under one `strike` a little taller than Touying's (it
/// reaches the background of a highlight); a chip, an icon or another inline box gets a rectangle of its measured size
/// and the room the chip paints around it; the rest (an equation, a styled part) goes to `cover-with-rect`.
/// -> content
#let _cover-text(
  /// Touying's `self`. -> dictionary | none
  self,
  /// The color of the veil. -> color
  veil,
  /// Arguments forwarded to `cover-with-rect`. -> arguments
  args,
  /// The covered running text. -> content
  body,
) = {
  let styled = text(red)[].func()
  if body.func() == styled { return styled(_cover-text(self, veil, args, body.child), body.styles) }
  let ch = if body.func() == [].func() { body.children } else { (body,) }
  // in markup, `~` is a `symbol` element, not text
  // a `context` element in running text is text (the word of a solution, `#info`); an icon is a `box`
  let inline = (text, [~].func(), [ ].func(), strong, emph, smartquote, highlight, underline, overline, sub, super, link,
    linebreak, [#context none].func())
  // the bar of `cover-with-rect` (1.6 times the height of the capitals, 0.35 of it above the baseline), taller upwards
  let veil-run(run) = context {
    let h = measure(par[Xg]).height
    strike(stroke: 1.9 * h + veil, offset: -0.5 * h, extent: 0.05 * h, run.join())
  }
  // a chip (with its outset of 0.2em and its border), a tag (outset up to 0.35em), an icon: a rectangle over the box,
  // which keeps its place
  let veil-box(c) = context {
    let size = measure(c)
    let room = 0.35em + 0.5pt
    box({ c; place(top + left, dx: -0.5pt, dy: -room, rect(width: size.width + 1pt, height: size.height + 2 * room,
      fill: veil)) })
  }
  let (out, run) = ((), ())
  for c in ch {
    if c.func() in inline { run.push(c) } else {
      if run.len() > 0 { out.push(veil-run(run)); run = () }
      out.push(if (c.func() == raw and not c.block) or c.func() == box { veil-box(c) } else {
        utils.cover-with-rect(self: self, ..args, fill: veil, c)
      })
    }
  }
  if run.len() > 0 { out.push(veil-run(run)) }
  out.join()
}

/// Covered content stays faintly visible under a veil in the page color at 85% opacity, as in 0.0.1. Touying's own
/// covers cannot do that for this theme (checked with 0.7.4 and 0.8.0, 2026-09-18): `alpha-changing-cover` (0.8) fades `fill`/`stroke` fields
/// by rebuilding the content tree before layout and `cover-with-rect` splits the content into leaves (a thick `strike`
/// over text runs), while the theme colors almost everything later, in show rules and element layout (bold, chips,
/// `===` pills, `> ` boxes, list markers, icons), so those stayed fully visible and a lone shorthand paragraph (`-> item`,
/// `> box`, `"quote"`) was left as literal text.
///
/// `_cover` leaves a block-level chunk in the normal flow, so the layout is identical covered or not, and paints the
/// veil over it afterwards with a `place`d rectangle whose height is the distance between two real positions (the
/// start of the chunk and the point after it): no `measure`, hence no second layout. The `parbreak()` after the chunk
/// forces block mode inside the `context`, which turns a lone shorthand paragraph into a real `par`, so the show rules of
/// the shorthands (`_flow`) see it.
/// The rectangle's outset reaches what the theme paints outside the layout box (pill outset, quote bar, box stroke).
/// A chunk that breaks across pages cannot be veiled by one rectangle: it is hidden instead (same space, breakable),
/// decided from the end marker of the previous layout pass. Plain running text (no block element, no shorthand) goes to
/// `_cover-text`, which veils it line by line, so a `#pause` in the middle of a paragraph still works. The veil takes
/// the background of the box around (`_veil-color`), not always the page.
/// -> content
#let _cover(
  /// Touying's `self`; in Touying 0.8 the sentinel `utils.cover-kind-query` asks for the kind of cover. -> dictionary | none
  self: none,
  /// Arguments forwarded to Touying's `cover-with-rect` (the fallback). -> any
  ..args,
  /// The content to cover. -> content | none
  body,
) = {
  // Touying 0.8 asks the cover for its kind through a sentinel that 0.7.4 does not have: looked up, not referenced
  let kind-query = dictionary(utils).at("cover-kind-query", default: none)
  if kind-query != none and self == kind-query { return "paint" }
  if body == none { return [] }
  let page = if type(self) == dictionary { self.at("page", default: (:)).at("fill", default: white) } else { white }
  // Touying's cover, built only when it is used: it reads fields that some elements do not have yet at this point (a
  // `quote` without `block:`, which the theme veils itself)
  if type(body) != content { return context utils.cover-with-rect(self: self, ..args, fill: _veil-color(page), body) }
  let ch = _trim(_children(_unstyle(body)))
  if ch.len() == 0 { return body }
  let lone-context = ch.len() == 1 and ch.first().func() == [#context none].func()
  if not (_is-blocky(body) or lone-context or _is-shorthand-par(ch)) {
    return context _cover-text(self, _veil-color(page), args, body)
  }
  context {
    let veil = _veil-color(page)
    let s = here().position()
    let ends = query(metadata.where(value: _veil-end).after(here()))
    // hidden, the chunk keeps the `parbreak()` inside `hide`, so a lone shorthand paragraph (`"quote"`, `> box`) is
    // rewritten as when it is veiled and takes the same room: hidden smaller, a chunk at the bottom of the page fitted
    // in one layout pass and not in the next, and the choice never settled (the document did not converge)
    if ends.len() > 0 and ends.first().location().page() != s.page { hide({ body; parbreak() }) } else {
      body
      parbreak()
      context {
        let e = here().position()
        let h = e.y - s.y
        // a chunk that starts inside a paragraph (a `#pause` on its own line between two `-> item` lines) starts on
        // the visible line, at its baseline, to the right of where the chunk ends (the start of a block): the veil
        // starts below that line (its descenders), not with the outset above it. A chunk that opens its paragraph (a
        // `#pause` alone before it) starts where it ends, at the left: the whole veil
        let mid = e.x < s.x - 1pt
        let skip = if mid { 0.7em.to-absolute() } else { 0pt }
        // above the chunk, the room up to the descenders of a visible line right before it (0.55em of leading in a
        // list): 0.3em reaches the accents of the covered line; 0.45em only for a `===` pill (here already the grid
        // of the theme's subtitles), which sticks out more
        let top = if ch.any(c => c.func() in (heading, grid)) { .45em } else { .3em }
        if h > skip { place(start, dy: -h + skip, rect(width: 100%, height: h - skip, outset: (x: .5em, top: top, bottom: .45em), fill: veil)) }
      }
    }
    metadata(_veil-end)
  }
}

// ---------- footer (ported from 0.0.1) ----------
/// The number of the page in the footer (in `context`): the number of the first page of the slide plus the place of the
/// page in the current subslide. Touying steps its slide counter on every page of the first subslide only (the
/// `page-preamble`, in Touying 0.7.4 and 0.8.0), so on a slide that goes on to a second page the later subslides
/// repeated the number of its last page (7, 8, 8, 8 instead of 7, 8, 7, 8). The markers Touying leaves at the start
/// of each slide and subslide give the first page of both; the footer comes after the body of its page, so they are
/// found before it.
/// -> content
#let _slide-number() = context {
  let subslide = query(metadata.where(value: (kind: "touying-new-subslide")).before(here()))
  let slide = query(metadata.where(value: (kind: "touying-new-slide")).before(here()))
  if subslide.len() == 0 or slide.len() == 0 { return utils.slide-counter.display() }
  let first = utils.slide-counter.at(slide.last().location()).first()
  // never below the first page of the slide, even in a layout pass that has not settled yet
  str(calc.max(first, first + here().page() - subslide.last().location().page()))
}
/// Separator of the default `footer-left` ("CODE · SUBJECT"): a drawn disc (radius 0.18em of the 0.4em footer text,
/// centered on the cap height, filled with the current `text.fill`, so it is white on the cover). The font's middle dot
/// was too small and its bullet (U+2022) is a square (2026-09-18).
/// -> content
#let _sep-dot = box(baseline: 0.18em - 0.36em, context circle(radius: 0.18em, fill: text.fill))
/// Items of a text of the footer joined by `_sep-dot`, the empty ones (`_blank`) left out: no dot next to an item that
/// is not there, and `none` when no item is left, so that the rule of the footer runs on without a gap.
///
/// #test(`_dot-join(()) == none`, `_dot-join(([], none, [ ], "")) == none`, `_dot-join(([a], none)) != none`)
/// -> content | none
#let _dot-join(
  /// The items: an array, or one item. -> any
  items,
) = {
  let xs = _list(items).filter(x => not _blank(x)).map(x => [#x])
  if xs.len() > 0 { xs.join([ #_sep-dot ]) }
}
/// Rule line of the footer, in the primary color.
/// -> content
#let _line(
  /// Touying's `self`. -> dictionary
  self,
) = line(stroke: .1em + self.colors.primary, length: 100%)
/// Rule line of the cover, in white.
/// -> content
#let _line-white(
  /// Touying's `self`. -> dictionary
  self,
) = line(stroke: .1em + self.colors.neutral-lightest, length: 100%)

/// The pieces of a text that a cut can keep or drop: its characters and spaces, the characters of bold, emphasis, a
/// link and the other styles of text each in its style, and any other element whole (the dot that separates the parts
/// of the footer).
///
/// #test(
///   `_atoms("ab c") == ("a", "b", " ", "c")`,
///   `_atoms([*ab*]) == (strong[a], strong[b])`,
///   `_atoms([a #box[x] b]).len() == 5`,
/// )
/// -> array
#let _atoms(
  /// The text. -> content | str
  it,
) = {
  if type(it) == str { return it.clusters() }
  if it.func() == text { return it.text.clusters() }
  if it.func() == [ ].func() { return (" ",) }
  if it.has("children") { return it.children.map(_atoms).flatten() }
  let restyle(make) = _atoms(it.body).map(a => if a == " " { a } else { make(a) })
  if it.func() in (strong, emph, underline, overline, strike, highlight, smallcaps) {
    let f = it.fields()
    let _ = f.remove("body")
    return restyle(a => (it.func())(..f, a))
  }
  if it.func() == link { return restyle(a => link(it.dest, a)) }
  // a styled piece (`#text(fill: ..)[..]`) is cut as its text, without the style
  if it.has("child") { return _atoms(it.child) }
  (it,)
}

/// The text of a footer cell on one line: `h(0.4em) + upper(it) + h(0.4em)`, and when that passes `max`, the longest
/// start of the text that fits with "…" after it, cut between its characters (@_atoms). In `context`, with the size of
/// the cell set.
/// -> content
#let _one-line(
  /// Text of the cell. -> content | str
  it,
  /// The widest the text can be, or `none` for any width. -> none | length
  max,
) = {
  let shown(t) = h(0.4em) + box(upper(t)) + h(0.4em)
  if max == none or measure(shown(it)).width <= max { return shown(it) }
  let cs = _atoms(it)
  // what is left before the "…": no space, punctuation or separator (a typed "•" or the dot of the theme) at the end
  let loose(a) = a in (" ", ",", ";", ":", "•", "·", "—", "–", "-") or (type(a) == content and a.func() == box)
  let cut(n) = {
    let kept = cs.slice(0, n)
    while kept.len() > 0 and loose(kept.last()) { kept = kept.slice(0, -1) }
    kept.join(default: "") + "…"
  }
  // a binary search on the number of characters kept
  let (lo, hi) = (0, cs.len())
  while lo < hi {
    let mid = calc.ceil((lo + hi) / 2)
    if measure(shown(cut(mid))).width <= max { lo = mid } else { hi = mid - 1 }
  }
  // a cut inside a word goes back to the end of the word before, when there is one
  if lo < cs.len() and cs.at(lo) != " " {
    let spaces = range(1, lo).filter(i => cs.at(i) == " ")
    if spaces.len() > 0 { lo = spaces.last() }
  }
  shown(cut(lo))
}

/// One footer/header cell: small upper-case text (0.4em) between rule lines.
/// -> content
#let _cell(
  /// Touying's `self`. -> dictionary
  self,
  /// Arguments of `set text` for the cell. -> any
  ..args,
  /// `"left"`, `"center"` or `"right"`. -> str
  pos: "center",
  /// Length of the rule before the cell. -> length
  pad-left: 0em,
  /// Length of the rule after the cell. -> length
  pad-right: 0em,
  /// White text and rules (the cover). -> bool
  white: false,
  /// A `1fr` rule on the free side of a `"left"`/`"right"` cell, so that the cell fills its column. `false` gives the
  /// text and its fixed rule only, at its natural width, for a grid that puts the `1fr` rule between the cells. -> bool
  grow: true,
  /// The widest the text of the cell can be, its inset included: a longer text is cut with "…" (`_one-line`). -> none | length
  max: none,
  /// Text of the cell. -> content | str
  it,
) = {
  let _content(it) = {
    set text(size: 0.4em, ..args)
    context {
      let get-content(it) = {
        // the inset of the block below, 1mm on each side, is part of `max`
        let room = if max == none { none } else { max - 2mm }
        if type(it) == str {
          if it.trim() != "" { return _one-line(it, room) }
        } else if type(it) == content {
          if measure(it).width > 0pt { return _one-line(it, room) }
        } else {
          return none
        }
      }
      // An empty cell has no block: its 1mm inset left a gap in the rule (2026-10-16).
      let c = get-content(it)
      if c != none { block(above: 0pt, below: 0pt, outset: 0pt, breakable: false, inset: 1mm, height: 100%, c) }
    }
  }

  set text(fill: if white { self.colors.neutral-lightest } else { self.colors.primary }) if white

  let l = if white { _line-white(self) } else { _line(self) }

  if pos == "center" {
    grid(columns: (pad-left, 1fr, auto, 1fr, pad-right), l, l, _content(it), l, l)
  } else if pos == "left" and not grow {
    grid(columns: (pad-left, auto), l, _content(it))
  } else if pos == "left" {
    grid(columns: (pad-left, auto, 1fr, pad-right), l, _content(it), l, l)
  } else if pos == "right" and not grow {
    grid(columns: (auto, pad-right), _content(it), l)
  } else if pos == "right" {
    grid(columns: (pad-left, 1fr, auto, pad-right), l, l, _content(it), l)
  }
}

/// The logos of the footer and of the cover (`config-info(logo:)`), in a row separated by a dot. `auto` is the UFAC
/// logo, blue on the slides and white with its yellow shield on the cover; a function receives the color of the
/// footer (the primary color, or white on the cover); content goes as it is. A single logo is the same box as the
/// UFAC logo alone had before the option (0.1.0), so the default footer did not change (2026-10-16). The dot has the
/// size of `_sep-dot` in the 0.4em text (radius 0.18 × 0.4em) and sits in its own cell, centered on the logos.
/// `logo: none` gives no logos.
/// -> content | none
#let _logos(
  /// Touying's `self`. -> dictionary
  self,
  /// White logos and dot, for the cover. -> bool
  white: false,
  /// The logos; `auto` takes those of `config-info(logo:)` (the UFAC logo by default). -> auto | array
  logos: auto,
  /// Color of the logos and the dot, for the footer of an exercise or example: the UFAC logo all in this color, its
  /// shield too. `auto` is the primary color, or white with `white: true`. -> auto | color
  color: auto,
) = {
  let logos = if logos == auto { _list(self.info.at("logo", default: auto)) } else { logos }
  if logos.len() == 0 { return none }
  let mono = color != auto
  let color = if color != auto { color } else if white { self.colors.neutral-lightest } else { self.colors.primary }
  // the UFAC logo keeps its blue on the slides and takes the white of the cover, the shield yellow on both; in one
  // color (`color:`), letters and shield
  let one(logo) = if logo == auto {
    if mono { _ufac-logo-image(color: color, shield: color) } else {
      _ufac-logo-image(color: if white { color } else { auto })
    }
  } else if type(logo) == function { logo(color) } else { logo }
  if logos.len() == 1 { return box(one(logos.first()), inset: 0.2em) }
  let dot = circle(radius: 0.072em, fill: color)
  box(inset: 0.2em, grid(columns: 2 * logos.len() - 1, column-gutter: 0.3em, align: horizon,
    ..logos.map(one).intersperse(dot)))
}

/// Footer of every slide except the cover: rule 1em, the logos (the UFAC logo, 0.64em, by default), rule 1.25em,
/// "CODE • TITLE", rule 1fr, author, rule 2em, slide number (0.6em), rule 1em. The last column is as wide as the
/// last slide number. The two texts take their natural width and the `1fr` rule between them the rest: when each
/// text carried its own `1fr` rule, both cells claimed the whole width and got half of it each, so a long left text
/// broke into two lines with room to spare on the right (2026-10-16). Each text stays on one line: when the two do not
/// fit in the room left by the rules, the logos and the number, the right one gets what the left one leaves (at least a
/// third of the room) and the left one the rest, and a longer text is cut with "…". `white: true` draws it in white, with the white
/// logos of the cover, for the closing slide (`#ending-slide`); `color:` draws it in another color, with the UFAC logo
/// in that color too, for the box of an exercise or example.
/// -> content
#let _footer(
  /// Touying's `self`. -> dictionary
  self,
  /// White text, rules and logos. -> bool
  white: false,
  /// Color of the text, the rules and the logos, instead of the primary color. -> auto | color
  color: auto,
  /// Lift the footer by 0.05em, as on the page. The box of an exercise has its border at the exact middle of the
  /// footer, so its footer is not lifted. -> bool
  lift: true,
) = {
  let mono = color
  let self = self
  if color != auto { self.colors.primary = color }
  set text(if white { self.colors.neutral-lightest } else { self.colors.primary })
  set std.align(bottom)
  let rule = if white { _line-white(self) } else { _line(self) }
  context layout(size => {
    let last-column-size = measure(box(text(utils.last-slide-number, size: 0.6em), inset: 0.4em)).width
    let logos = _logos(self, white: white, color: mono)
    // a text of the footer, or what its function returns, may be an array: the items that show something (an empty
    // `#info` has no width) joined by the dot (`_dot-join`)
    let shown(it) = {
      let v = if type(it) == function { it(self) } else { it }
      if type(v) == array { _dot-join(v.filter(x => measure([#x]).width > 0pt)) } else { [#v] }
    }
    let (left, right) = (shown(self.store.footer-left), shown(self.store.footer-right))
    // the room of the two texts: the width less the rules (1em, 1.25em, at least 2em between the texts, 2em, 1em),
    // the logos and the number. When both texts do not fit, the right one gets what the left one leaves, at least a
    // third of the room, and the left one the rest
    let room = size.width - measure(logos).width - last-column-size - (7.25em).to-absolute()
    let natural(cell, pad) = measure(cell).width - pad.to-absolute()
    let left-width = natural(_cell(self, pad-left: 1.25em, pos: "left", grow: false, white: white, left), 1.25em)
    let right-max = calc.max(room - left-width, room / 3)
    let right-cell = _cell(self, pad-right: 2em, pos: "right", grow: false, white: white, max: right-max, right)
    let left-max = room - natural(right-cell, 2em)
    move(grid(
      columns: (1em, auto, auto, 1fr, auto, last-column-size, 1em),
      rows: 1.5em,
      align: horizon,
      rule,
      logos,
      _cell(self, pad-left: 1.25em, pos: "left", grow: false, white: white, max: left-max, left),
      rule,
      right-cell,
      _cell(self, pos: "center", size: 0.6em, white: white, _slide-number()),
      rule,
    ), dy: if lift { -0.05em } else { 0pt })
  })
}
