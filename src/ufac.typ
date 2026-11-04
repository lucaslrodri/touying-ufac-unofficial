// touying-ufac-unofficial — the theme: slide header, `slide`, `exercise-slide`/`example-slide`, the cover, the
// closing and section slides and `ufac-theme` (page, fonts, every set/show rule of the syntax, Touying configuration).
#import "@preview/touying:0.7.4": *
#import "constants.typ": colors
#import "utils.typ": *
#import "components.typ": *
#import "code.typ": _code-rules
#import "info.typ": _info-defaults, _prepare-configs, _deck, _date, _author-names, _authors, _contact

// ---------- header ----------
/// Header of a content slide: the current `==` in blue, fit to width. (Exercises and examples have no header: their
/// title is on the badge of their box.)
/// -> content
#let _header(
  /// Touying's `self`. -> dictionary
  self,
) = {
  set std.align(horizon)
  block(inset: (x: 1em), width: 100%, height: 1.5em, context {
    set text(self.colors.primary, size: 1.2em, weight: "bold")
    _in-box(self.colors.primary, utils.display-current-heading(level: 2, setting: utils.fit-to-width.with(grow: false, 100%)), kind: "title")
  })
}

// ---------- slides ----------
// Running subtitles.
// The first body is split at its top-level `===` headings and every segment goes into a one-column `grid` whose
// `grid.header(repeat: true)` re-shows the subtitle pill: Typst repeats that header at the top of every page the
// grid spans, which is the only in-flow mechanism for a running subtitle when the content overflows by itself (a
// page header cannot push the body down). The first page must stay pixel-identical to a plain flow, so the heading
// itself is rendered inside the body cell (the theme's `show heading` rule, with the heading's own spacing) and the
// header row is empty there: in `context` it checks whether it sits on a later page than the start of its own body
// cell, using two `metadata` markers (`_seg-mark` right before the grid, `_seg-body-mark` first in the cell; the
// header of grid k is preceded by marker k and by no later one). A heading inside the repeated header would be
// introspected once per page, hence the markers. A leading segment without `===` (a `---`/`#pagebreak()`
// continuation) shows the current subtitle from `_current-subtitle()` in the cell, as before, and repeats it the
// same way. The gap under a repeated pill is a `pad`, not `block(below:)`: weak spacing is trimmed at the end of
// the header cell. Between segments a weak `v(1.44em)` restores the heading's default `above` (Typst, levels ≥ 2),
// which is trimmed at the start of the cell. Only top-level `===` are handled: a subtitle nested in `#[ ]`, a
// column or a box still renders in flow, without repetition.
#let _seg-mark = "ufac-subtitle-segment"
#let _seg-body-mark = "ufac-subtitle-segment-body"
/// True when the header of a subtitle grid is laid out on a later page than the start of its own body cell.
/// -> bool
#let _is-continuation() = {
  let outer = query(metadata.where(value: _seg-mark).before(here()))
  if outer.len() == 0 { return false }
  let inner = query(metadata.where(value: _seg-body-mark).after(outer.last().location()))
  inner.len() > 0 and inner.first().location().page() < here().page()
}
/// One segment of the slide body: a one-column grid whose repeated header re-shows the subtitle pill on the
/// continuation pages.
/// -> content
#let _subtitle-grid(
  /// Function returning the subtitle body, or `none`. -> function
  title,
  /// Content of the segment. -> content
  body,
) = {
  metadata(_seg-mark)
  grid(columns: 1fr, inset: 0pt, stroke: none,
    grid.header(repeat: true, context { if _is-continuation() { let t = title(); if t != none { pad(bottom: 1em, _pill(t)) } } }),
    { metadata(_seg-body-mark); body })
}
/// Splits the slide body at its top-level `===` headings and wraps every segment in a @_subtitle-grid.
/// -> content
#let _with-running-subtitles(
  /// First body of the slide. -> content
  body,
) = {
  let segments = ((head: none, items: ()),)
  for c in _children(body) {
    if _is-h3(c) { segments.push((head: c, items: ())) } else { segments.last().items.push(c) }
  }
  // subtitles of this very slide: with `#pause` its earlier subpages precede the leading segment (see `_current-subtitle`)
  let own = segments.filter(s => s.head != none).map(s => s.head.body)
  for seg in segments {
    let items = { for c in seg.items { c } }
    if seg.head == none {
      if _trim(seg.items).len() > 0 {
        let current() = { let h = _current-subtitle(skip: own); if h != none { h.body } }
        _subtitle-grid(current, { context { let h = _current-subtitle(skip: own); if h != none { block(below: 1em, _pill(h.body)) } }; items })
      }
    } else {
      v(1.44em, weak: true)
      _subtitle-grid(() => seg.head.body, { seg.head; items })
    }
  }
}
// ---------- light colours ----------
/// True for a light background (a luma of 70% or more: `secondary`, `secondary-light`, `quaternary-light` and the
/// `-lighter` and `-lightest` tones), where the text stays dark and the footer blue; on a darker one (`primary`,
/// `tertiary`, `quaternary`, `neutral`, the other `-light` tones and the `-dark` ones) they turn white, as in the pills.
/// -> bool
#let _is-light(
  /// Background color. -> color
  c,
) = luma(c).components().first() >= 70%
// ---------- exercises and examples ----------
/// The marker of the start of the solution of an example, alone on its line like Touying's `#pause`: what comes before
/// it is the statement and what comes after it the solution, opened by a dashed line and "Solução." / "Solution." in
/// bold. With a `#pause` right before or right after it, the solution appears on the next subslide, opening included.
///
/// ```typ
/// == The state of water <example>
/// A script that reads the temperature and prints the state of the water.
/// #pause
/// #solution
/// Every condition is an `if`: …
/// ```
/// -> content
#let solution = metadata((kind: "ufac-solution", word: "solution"))

/// The marker of the start of the answer of an exercise: the same as @solution, opened by "Resposta." / "Answer.".
/// -> content
#let answer = metadata((kind: "ufac-solution", word: "answer"))

/// The opening of a solution: a thin dashed line almost from border to border of the box and the word ("Solução.",
/// "Resposta.") in bold, in the colour of the box darkened. The word is in the same paragraph as what follows the
/// marker; before a block (a code block), it is alone on its line. At the top of a slide (a continuation after `---`)
/// there is nothing to separate, and the line is left out.
/// -> content
#let _solution-head(
  /// `"solution"` or `"answer"`. -> str
  word,
  /// Whether to draw the dashed line. -> bool
  line: true,
) = {
  // the line goes 0.5em past the text (1em from the border) on each side: almost from border to border, and whole under
  // the veil of `#pause` (which goes 0.5em past the text)
  if line {
    context block(above: 0.65em, below: 0.65em, move(dx: -0.5em, std.line(length: 100% + 1em,
      stroke: (paint: _current-box-color(colors.primary), thickness: 0.4pt, dash: "dashed"))))
  }
  context {
    text(weight: "bold", fill: _current-box-color(colors.primary).darken(30%), _words(text.lang).at(word))
    h(0.35em)
  }
}

/// The body of an exercise or example with the solution opened at its marker (`#solution`, `#answer`): the opening
/// takes the place of the marker. A `#pause` right after the marker goes before the opening, which then appears with
/// the solution. Done before Touying handles the `#pause`.
/// -> any
#let _split-solution(
  /// A body of the slide. -> any
  body,
) = {
  if type(body) != content or not body.has("children") { return body }
  let ch = body.children
  let i = ch.position(c => _is-meta(c, "ufac-solution"))
  if i == none { return body }
  let head = ch.slice(0, i)
  let rest = ch.slice(i + 1)
  // the spaces and the paragraph breaks after the marker, and a `#pause` among them, which goes before the opening;
  // the word opens the next paragraph
  while rest.len() > 0 and (rest.first().func() in ([ ].func(), parbreak)
    or _is-meta(rest.first(), "touying-jump/pause/meanwhile")) {
    if rest.first().func() == metadata { head.push(rest.first()) }
    rest = rest.slice(1)
  }
  // nothing before the marker but spaces and markers (a continuation after `---`): no line to separate
  let alone = head.all(c => c.func() in ([ ].func(), parbreak, metadata))
  (head + (_solution-head(ch.at(i).value.word, line: not alone),) + rest).join()
}

/// The outline of the box of an exercise, open at the bottom: the sides go down, turn a quarter of a circle and end
/// where the line of the footer starts, which closes the box. A `curve`: a block without its bottom border draws only
/// half of the bottom corners, and covering the bottom border with a band of the fill leaves a thread of the border at
/// the edges of the band (the antialiasing of the PDF viewer).
/// -> content
#let _box-outline(
  /// Width. -> length
  w,
  /// Height. -> length
  h,
  /// Radius of the corners. -> length
  r,
  /// Stroke. -> stroke
  stroke,
) = {
  let k = 0.5523 * r   // the control points of a quarter of a circle in a Bézier curve
  curve(stroke: stroke,
    curve.move((r, h)),
    curve.cubic((r - k, h), (0pt, h - r + k), (0pt, h - r)),
    curve.line((0pt, r)),
    curve.cubic((0pt, r - k), (r - k, 0pt), (r, 0pt)),
    curve.line((w - r, 0pt)),
    curve.cubic((w - r + k, 0pt), (w, r - k), (w, r)),
    curve.line((w, h - r)),
    curve.cubic((w, h - r + k), (w - r + k, h), (w - r, h)),
  )
}

/// The box of an exercise or example, as in the handout of the MATLAB course, filling the slide: the fill in the colour
/// lightened 95%, the badge with the title over the top border and the footer of the slide over the bottom one, in the
/// colour of the item, its lines being the bottom border (the outline is open at the bottom and its sides turn into
/// them). Inside it only what has no style of its own follows the colour of the item (bold text, markers, arrows,
/// highlights, the numbers of the lists, inline code, links); a code block, a callout and an `emph-box` keep theirs.
/// -> content
#let _item-box(
  /// Touying's `self`. -> dictionary
  self,
  /// Colour of the item. -> color
  c,
  /// The content of the badge. -> content
  badge,
  /// The body. -> content
  body,
) = {
  let badge = box(fill: c, radius: 3pt, inset: (x: 0.7em, y: 0.38em),
    text(fill: white, weight: "bold", _in-box(c, _pill-line(badge), kind: "pill")))
  // the thickness of the lines of the footer (0.1em of its 20pt text), its height (1.5em) and the radius of the corners
  let thick = 2pt
  let foot-h = 30pt
  let r = 6pt
  layout(size => {
    let h = measure(badge, width: size.width - 2em).height
    let box-h = size.height - h / 2 - foot-h / 2
    pad(top: h / 2, bottom: foot-h / 2, block(width: 100%, height: box-h, fill: c.lighten(95%), radius: r,
      breakable: false, {
        place(top + left, _box-outline(size.width, box-h, r, thick + c))
        place(top + left, dx: 0.8em, dy: -h / 2, badge)
        // the footer centred on the bottom border, between the curves of the corners: its lines close the box
        place(bottom + left, dx: r, dy: foot-h / 2, block(width: size.width - 2 * r, height: foot-h,
          text(size: 20pt, _footer(self, color: c, lift: false))))
        block(width: 100%, inset: (x: 1em, top: h / 2 + 0.75em, bottom: foot-h / 2 + 0.6em), {
          // as inside an `emph-box`, plus the numbers of the lists, always blue elsewhere
          set list(marker: _markers(c))
          let num(patterns) = (..nums) => {
            let d = nums.pos().len()
            text(fill: c, weight: "bold", numbering(patterns.at(calc.min(d, patterns.len()) - 1), nums.at(-1)))
          }
          set enum(full: true, numbering: num(("1.", "a)", "i.")))
          _in-box(c, _flow(body))
        })
      }))
  })
}

/// The marker of the continuation of an exercise or example after a `---`, with the heading of the item.
#let _continue-kind = "ufac-continue"

/// Marks the continuations of the exercises and examples. A `---` inside an exercise breaks the page, and the exercise
/// goes on in the next slide, until a `==` heading of another kind. Touying calls the slide of a continuation without
/// headings (`self.headings` is empty), so it would not know that it is an exercise, and its box changes the margins and
/// drops the header and the footer, which is decided before any `context`. So, before Touying splits the deck, a marker
/// with the heading of the item goes right after every `---` inside an exercise or example (also in the parts with
/// `#set`/`#show`, the `styled` ones, and inside `exercise-slide`/`example-slide`).
/// -> content
#let _mark-continuations(
  /// The deck. -> content
  body,
) = {
  let walk(children, h) = {
    let out = ()
    for c in children {
      if c.func() == heading and c.depth <= 2 {
        // a heading of a section or of a slide ends the item; one of an exercise or example opens another
        h = if c.depth == 2 and _label-kind(c.at("label", default: none)) != none { c } else { none }
        out.push(c)
      } else if utils.is-styled(c) {
        let (inner, after) = walk(if utils.is-sequence(c.child) { c.child.children } else { (c.child,) }, h)
        h = after
        out.push(utils.reconstruct-styled(c, inner))
      } else if utils.is-sequence(c) {
        let (inner, after) = walk(c.children, h)
        h = after
        out.push(inner)
      } else {
        out.push(c)
        if h != none and c in ([—], [---]) { out.push(metadata((kind: _continue-kind, heading: h))) }
      }
    }
    (out.join(), h)
  }
  if utils.is-sequence(body) { walk(body.children, none).first() } else { body }
}

/// The heading of the item that a body continues, if it starts with the marker of a continuation.
/// -> content | none
#let _continued-heading(
  /// The bodies of the slide. -> arguments
  bodies,
) = {
  let first = bodies.pos().at(0, default: none)
  if type(first) != content { return none }
  let ch = if first.has("children") { first.children } else { (first,) }
  let m = ch.find(c => c.func() != [ ].func() and c.func() != parbreak)
  if m != none and _is-meta(m, _continue-kind) { m.value.heading }
}

/// The slide of an exercise or example: the box of the item filling the slide, without the header (the badge carries
/// the title) and without the footer of the page (it goes into the box, in the colour of the item). The veil of
/// `#pause` takes the fill of the box.
/// -> content
#let _item-slide(
  /// Touying's `self`. -> dictionary
  self,
  /// The heading of the item. -> content
  h,
  /// `"exercise"` or `"example"`. -> str
  kind,
  /// Arguments of @slide. -> dictionary
  config, repeat, setting, composer,
  /// The slide bodies. -> array
  bodies,
) = {
  let (name, color) = _kind-style(self, kind)
  let ic = _kind-icon(self, kind)
  let sup = h.at("supplement", default: auto)
  if sup != auto and sup.func() == metadata {
    if sup.value.color != auto { color = sup.value.color }
    if sup.value.icon != auto { ic = sup.value.icon }
  }
  let badge = context [#_pill-icon(ic)#name #self.info.counter-prefix#_kind-index(kind, here().page())#if h.body != [] [ — #h.body]]
  // the veil of `#pause` in the fill of the box: the one of the theme takes the colour of the page (white), which would
  // show as a patch on the box
  let fill = color.lighten(95%)
  let cover(self: none, ..args, body) = {
    let s = self
    if type(s) == dictionary { s.page = s.at("page", default: (:)) + (fill: fill) }
    _cover(self: s, ..args, body)
  }
  let self = utils.merge-dicts(self, config-page(header: none, footer: none,
    margin: (top: 1.3em, bottom: 0.5em, x: 1.2em)), config-methods(cover: cover), config)
  touying-slide(self: self, repeat: repeat, composer: composer,
    setting: body => _item-box(self, color, badge, setting(body)), ..bodies.map(_split-solution))
}

/// Default slide of the theme, with header and footer. Every `==` heading opens one, so it is rarely called by
/// hand; the explicit form gives access to Touying's arguments.
///
/// A top-level `===` subtitle is repeated at the top of every continuation page of the slide, whether the page comes
/// from `---`, from `#pagebreak()` or from content that overflows by itself, unless the continuation starts with
/// another `===`. A subtitle nested in `#[ ]`, a column or a box is not repeated.
///
/// A slide without a title is a `==` heading without text: it keeps the footer. The closing slide is @ending-slide.
///
/// ```typ
/// #slide(composer: (1fr, 2fr))[Left][Right]
/// ```
/// -> content
#let slide(
  /// Slide configuration: a `config-xxx` dictionary (merge several with `utils.merge-dicts`). -> dictionary
  config: (:),
  /// Number of subslides; `auto` lets Touying count the animations. -> auto | int
  repeat: auto,
  /// Set/show rules applied to the slide body. -> function
  setting: body => body,
  /// Layout of the bodies, e.g. `(1fr, 2fr)`, as in Touying's `side-by-side`. -> auto | array | function
  composer: auto,
  /// The slide bodies. -> content
  ..bodies,
) = touying-slide-wrapper(self => {
  // the labels of the `empty-slide` of 0.2.0 are gone: say what replaces them
  let hs = self.at("headings", default: ())
  let h = if hs.len() > 0 { hs.last() } else { _continued-heading(bodies) }
  let kind = if h != none and h.depth == 2 { _label-kind(h.at("label", default: none)) }
  if kind != none { return _item-slide(self, h, kind, config, repeat, setting, composer, bodies.pos()) }
  let lbl = if hs.len() > 0 and hs.last().depth == 2 and hs.last().has("label") { str(hs.last().label) }
  assert(lbl == none or not (lbl == "empty-slide" or lbl.starts-with("empty-slide-")), message: "<" + lbl
    + "> was removed in 0.3.0: use #ending-slide[..] for the closing slide, or a `==` heading without text for a slide"
    + " without a title")
  let self = utils.merge-dicts(self, config-page(header: _header, footer: _footer), config)
  let bodies = bodies.pos()
  if bodies.len() > 0 { bodies.at(0) = _with-running-subtitles(bodies.first()) }
  touying-slide(self: self, repeat: repeat, setting: setting, composer: composer, ..bodies)
})

// `exercise-slide`/`example-slide` return a level-2 heading with the label followed by the body (no
// `touying-slide-wrapper`: Touying flattens sequences at document level, so `---` inside the body works too). An
// explicit color or icon travels in the heading `supplement`. `depth` is used rather than `level` because Touying
// reads `depth` before layout.

/// `supplement` of the heading of an exercise or example slide: `auto`, or the color and the icon of the slide.
/// -> auto | content
#let _kind-supplement(
  /// Color of the pill, or `auto`. -> auto | color
  color,
  /// Icon of the pill, or `auto`. -> auto | none | str | content
  icon,
) = if color == auto and icon == auto { auto } else { metadata((color: color, icon: icon)) }

/// Exercise slide: the header becomes a pill with a pencil, "Exercise 1.N — Title", numbered automatically. The
/// function form of `== Title <exercise>`. Only the heading form can carry a unique label (`== Title <exercise-ogata>`)
/// and be cited with `@exercise-ogata`, which shows "Exercise 1.N" linked to the slide.
///
/// ```typ
/// #exercise-slide(title: [Ogata 4.6])[Find the transfer function.]
/// #exercise-slide(title: [Lab], color: colors.primary, icon: "tools")[Another color and icon.]
/// ```
/// -> content
#let exercise-slide(
  /// Text after the number, following a dash; empty omits the dash. -> content
  title: [],
  /// Color of the pill; `auto` is red (`tertiary`). -> auto | color
  color: auto,
  /// Icon before the name: the name of an `icon`, any content (an image) or `none` for no icon; `auto` is the icon of
  /// the theme, `ufac-theme(exercise-icon:)` (a pencil). -> auto | none | str | content
  icon: auto,
  /// Content of the slide; `---` inside it continues the same exercise. -> content
  body,
) = [#heading(depth: 2, supplement: _kind-supplement(color, icon), title) <exercise> #body]

/// Example slide: a pill with a beaker, "Example 1.N — Title", with a counter independent from the exercises. The
/// function form of `== Title <example>`; see @exercise-slide.
///
/// ```typ
/// #example-slide(title: [XOR network])[Two hidden neurons are enough.]
/// ```
/// -> content
#let example-slide(
  /// Text after the number, following a dash; empty omits the dash. -> content
  title: [],
  /// Color of the pill; `auto` is green (`quaternary`). -> auto | color
  color: auto,
  /// Icon before the name: the name of an `icon`, any content (an image) or `none` for no icon; `auto` is the icon of
  /// the theme, `ufac-theme(example-icon:)` (a beaker). -> auto | none | str | content
  icon: auto,
  /// Content of the slide. -> content
  body,
) = [#heading(depth: 2, supplement: _kind-supplement(color, icon), title) <example> #body]

// ---------- cover ----------
/// The backgrounds of the cover and of the closing slide (`ufac-theme(background:)`): the fill of the page and whether
/// it has the circles. `"circles"`, the default, is the solid UFAC blue with two translucent white circles leaving the
/// corners; `"gradient"`, the gradient of the MATLAB course (the blue darkened 35% to the blue, at 60°), with the
/// circles; `"plain"`, the blue alone, the cover of 0.2.0.
///
/// #test(`_backgrounds.keys() == ("circles", "gradient", "plain")`, `not _backgrounds.plain.circles`)
/// -> dictionary
#let _backgrounds = (
  circles: (fill: colors.primary, circles: true),
  gradient: (fill: gradient.linear(colors.primary.darken(35%), colors.primary, angle: 60deg), circles: true),
  plain: (fill: colors.primary, circles: false),
)

/// The translucent white circles of the background: a large one leaving the top right corner and a smaller one the
/// bottom left; for the `background` of the page, which has its size.
/// -> content
#let _circles() = {
  place(top + right, dx: 3cm, dy: -4.2cm, circle(radius: 8.5cm, fill: white.transparentize(94%)))
  place(bottom + left, dx: -2.6cm, dy: 2.8cm, circle(radius: 5.5cm, fill: white.transparentize(95%)))
}

/// The blue page of the cover and of the closing slide, with the background of the theme, without header nor footer.
/// -> dictionary
#let _blue-page(
  /// Touying's `self`. -> dictionary
  self,
) = config-page(fill: self.store.at("cover-fill", default: self.colors.primary), header: none, footer: none,
  margin: (x: 1.8em, top: 1.2em, bottom: 1.1em),
  background: if self.store.at("cover-circles", default: true) { _circles() })

/// White content on the blue page, with the convention of the pills (`*bold*`, code and icons readable).
/// -> content
#let _on-blue(
  /// Touying's `self`. -> dictionary
  self,
  /// The content. -> content
  body,
) = {
  set text(fill: self.colors.neutral-lightest)
  _in-box(self.colors.primary, body, kind: "pill")
}

/// A small label in spaced bold capitals, in yellow ("INSTRUCTORS", "ADVISOR").
/// -> content
#let _kicker(
  /// Touying's `self`. -> dictionary
  self,
  /// The label. -> content
  body,
  /// Size of the text. -> length
  size: 0.5em,
) = text(size: size, weight: "bold", fill: self.colors.secondary, tracking: 0.12em, upper(body))

/// The yellow rule under the title of the cover, of the closing slide and of the section slides.
/// -> content
#let _rule(
  /// Touying's `self`. -> dictionary
  self,
  /// Length of the rule. -> length
  length: 2.6cm,
) = line(length: length, stroke: 2.5pt + self.colors.secondary)

/// The logos of the deck in white, at a given height (the logos are sized in `em`, 0.64em high in the footer).
/// -> content | none
#let _logos-white(
  /// Touying's `self`. -> dictionary
  self,
  /// Height of the logos. -> length
  height: 0.9cm,
) = { let l = _logos(self, white: true); if l != none { text(size: height / 0.64, l) } }

/// The style of the cover (`"line"`, `"stack"`, `"top"`), kept by `title-slide` for `#ending-slide` to put the logos
/// in the same place.
/// -> state
#let _cover-style = state("ufac-cover-style", none)

/// The size of the text in the positions of the top and of the bottom of the cover, relative to the slide.
#let _slot-size = 0.7em

/// The authors on several lines: the label (`author-label`) and the authors as written, with the `\` breaks and the
/// labels in emphasis (`_Advisor_` becomes "ADVISOR" in yellow, with some room above it).
/// -> content
#let _authors-block(
  /// Touying's `self`. -> dictionary
  self,
  /// Label over the authors, or `none`. -> none | content
  label,
  /// Alignment of the lines. -> alignment
  align: left,
) = block(std.align(align, {
  if label != none { _kicker(self, label); v(0.35em) }
  show emph: it => box(inset: (top: 0.55em), text(size: 0.5em / 0.7, weight: "bold",
    fill: self.colors.secondary, tracking: 0.12em, style: "normal", upper(it.body)))
  text(size: _slot-size, _authors(self))
}))

/// The authors on one line: the label and the names in running text ("A, B and C"); of an author written as free
/// content, the names of its first group, as in the footer of the slides.
/// -> content
#let _authors-line(
  /// Touying's `self`. -> dictionary
  self,
  /// Label before the authors, or `none`. -> none | content
  label,
) = {
  if label != none {
    // the label is smaller than the names: on the same baseline, its middle would be below the middle of the capitals
    // of the names, where the white line passes; it goes up half the difference of the heights of the capitals
    context {
      let cap(size) = measure(text(size: size, weight: "bold", top-edge: "cap-height", bottom-edge: "baseline")[X]).height
      text(baseline: -(cap(_slot-size) - cap(0.5em)) / 2, _kicker(self, label))
    }
    h(0.6em)
  }
  text(size: _slot-size, _author-names(self))
}

/// Whether each style of the cover has the white line at the bottom.
#let _preset-lines = (stack: false, line: true, top: false)

/// What each style puts in each position of the cover.
/// -> dictionary
#let _presets(
  /// Touying's `self`. -> dictionary
  self,
  /// Label of the authors, or `none`. -> none | content
  label,
) = {
  let d = _date(self)
  let d = if _given(d) { text(size: _slot-size, fill: white.transparentize(12%), d) }
  let a = _given(_authors(self))
  let logos = _logos-white(self)
  (
    // the authors at the top right, in front of the logos; at the bottom, only the date, in the centre
    top: (header-left: logos, header-right: if a { _authors-block(self, label, align: right) }, footer-center: d),
    // the logos in the centre of the top; one line at the bottom: the authors on the left, the white line and the date
    line: (header-center: logos, footer-left: if a { _authors-line(self, label) }, footer-right: d),
    // the authors on several lines at the bottom left and the date on the right, without the line
    stack: (header-left: logos, footer-left: if a { _authors-block(self, label) }, footer-right: d),
  )
}

/// A band of the cover (the top or the bottom) without the line: the left and right positions with half the width each,
/// or, with something in the centre, the centre at its width and the sides with the rest, equally.
/// -> content | none
#let _row(
  /// The positions `left`, `center` and `right`. -> dictionary
  slots,
  /// Vertical alignment of the band. -> alignment
  valign,
) = {
  if slots.values().all(c => c == none) { return none }
  if slots.center == none {
    grid(columns: (1fr, 1fr), column-gutter: 1em, align: (left + valign, right + valign), slots.left, slots.right)
  } else {
    grid(columns: (1fr, auto, 1fr), column-gutter: 1em, align: (left + valign, center + valign, right + valign),
      slots.left, slots.center, slots.right)
  }
}

/// Cover: the blue page (`ufac-theme(background:)`) with the logos large at the top; in the centre, the tag
/// (`short-title`), the `title`, the yellow rule, the `short-subtitle` in yellow, the `subtitle` and the content given
/// to it, centered both ways in the room between the top and the bottom; the authors and the date where the `style`
/// puts them. The institution does not appear (it is for `#info`). The slide counter is frozen, so the cover does not
/// count.
///
/// Each position takes `auto` (what the style puts there), `none` (nothing), content (such as `#info("date")`) or a
/// function of `self`, like `footer-left` of the theme. The text of the positions is 0.7 of the size of the slide.
///
/// ```typ
/// #title-slide()
/// #title-slide(style: "top", footer-center: none, footer-right: info("date"))
/// #title-slide[#image("lab-white.svg", height: 1.7em)]
/// ```
/// -> content
#let title-slide(
  /// `"line"`: the authors on one line at the bottom left, the white line and the date on the right, with the logos
  /// in the centre of the top. `"stack"`: the authors on several lines at the bottom left and the date on the right,
  /// without the line. `"top"`: the authors at the top right and the date in the centre of the bottom, without the
  /// line. `auto` is the one of the `kind` of the deck, or `"line"`. -> auto | str
  style: auto,
  /// Label over the authors ("Instructors"); before them in `"line"`. `auto` is the one of the `kind`, or none.
  /// -> auto | none | content
  author-label: auto,
  /// What goes at the top left. -> auto | none | content | function
  header-left: auto,
  /// What goes at the top centre. -> auto | none | content | function
  header-center: auto,
  /// What goes at the top right. -> auto | none | content | function
  header-right: auto,
  /// What goes at the bottom left. -> auto | none | content | function
  footer-left: auto,
  /// What goes at the bottom centre. -> auto | none | content | function
  footer-center: auto,
  /// What goes at the bottom right. -> auto | none | content | function
  footer-right: auto,
  /// The white line at the bottom, like the one of the footer of the slides: from edge to edge, passing between what
  /// is at the bottom, at the height of the line of the footer. `auto` is the one of the style. -> auto | bool
  footer-line: auto,
  /// Content in the centre, below the titles, `#title-slide[..]`; `#title-slide()` has none. -> content
  ..body,
) = {
  assert(body.named().len() == 0, message: "title-slide: unknown argument " + repr(body.named().keys().at(0, default: "")))
  assert(body.pos().len() <= 1, message: "title-slide: takes one optional content, `#title-slide[..]`")
  assert(style == auto or style in _preset-lines, message: "title-slide: style is auto (\"line\"), \"line\", \"stack\" or \"top\"")
  let body = body.pos().at(0, default: none)
  touying-slide-wrapper(self => {
    // `auto`: what the `kind` of the deck recommends (in the store), else the default of the theme ("line", no label)
    let style = if style == auto { self.store.at("cover-style", default: "line") } else { style }
    let author-label = if author-label == auto { self.store.at("author-label", default: none) } else { author-label }
    let self = utils.merge-dicts(self, _blue-page(self), config-common(freeze-slide-counter: true))
    let i = self.info
    let with-line = if footer-line == auto { _preset-lines.at(style) } else { footer-line }
    let preset = _presets(self, author-label).at(style)
    // the value of a position: the one of the style, nothing, or the given content (or function of `self`) at the
    // size of the positions
    let slot(name, value) = {
      if value == auto { return preset.at(name, default: none) }
      if value == none { return none }
      text(size: _slot-size, if type(value) == function { value(self) } else { value })
    }
    let header = (left: slot("header-left", header-left), center: slot("header-center", header-center),
      right: slot("header-right", header-right))
    let footer = (left: slot("footer-left", footer-left), center: slot("footer-center", footer-center),
      right: slot("footer-right", footer-right))
    touying-slide(self: self, _on-blue(self, {
      _cover-style.update(style)   // for `#ending-slide` to put the logos in the same place
      set par(leading: 0.4em, spacing: 0pt, justify: false)
      // the centre: a stack from top to bottom, the tag (`short-title`), the `title`, the rule, the `short-subtitle` and
      // the `subtitle` (together, on two lines) and, last, the body
      let lines = (
        if _given(i.at("short-subtitle", default: none)) { text(size: 1.2em, fill: self.colors.secondary, i.short-subtitle) },
        if _given(i.subtitle) { text(size: 1.2em, i.subtitle) },
      ).filter(x => x != none)
      let items = (
        if _given(i.at("short-title", default: none)) { tag(i.short-title) },
        if _given(i.title) { text(size: 2em, weight: "bold", i.title) },
        // the rule goes with the title: without one, nothing in the middle of the page
        if _given(i.title) { _rule(self) },
        if lines.len() > 0 { lines.join(linebreak()) },
        body,
      ).filter(x => x != none)
      let titles = block(width: 90%, {
        set std.align(center)
        stack(dir: ttb, spacing: 0.75em, ..items)
      })
      let foot = {
        // at the bottom the text sits on its baseline: what is side by side lines up by its last line
        set text(bottom-edge: "baseline")
        if with-line {
          // the line of the footer of the slides, from edge to edge, passing between what is at the bottom and centred
          // on the capitals of its last line; the baseline is 0.55em from the edge, at the height of the footer
          let gap = 0.45em
          let edge = 1.8em - gap
          context {
            let cap = measure(text(size: _slot-size, top-edge: "cap-height", bottom-edge: "baseline")[X]).height
            let line-cell = box(width: 100%, height: cap, std.align(horizon, _line-white(self)))
            let (columns, cells) = ((), ())
            if footer.left != none { columns += (edge, auto); cells += (line-cell, footer.left) }
            if footer.center != none { columns += (1fr, auto, 1fr); cells += (line-cell, footer.center, line-cell) }
            else { columns.push(1fr); cells.push(line-cell) }
            if footer.right != none { columns += (auto, edge); cells += (footer.right, line-cell) }
            move(dx: -1.8em, dy: 0.55em, block(width: 100% + 3.6em,
              grid(columns: columns, column-gutter: gap, align: bottom, ..cells)))
          }
        } else { _row(footer, bottom) }
      }
      // three bands: the top, the centre and the bottom. The titles and the body stay in the middle of the centre, both
      // ways: in the middle of the page when the top and the bottom have similar heights, and in the middle of the free
      // room when the authors take many lines (at the top or at the bottom), without touching them
      block(width: 100%, height: 100%, grid(columns: 100%, rows: (auto, 1fr, auto), row-gutter: 0.6em,
        _row(header, top), std.align(center + horizon, titles), foot))
    }))
  })
}

// ---------- closing ----------
/// The checks of the arguments of @ending-slide, at the call: `(title, subtitle, body)`.
/// -> array
#let _ending-args(
  /// `title:` of the call. -> auto | none | content
  title,
  /// `subtitle:` of the call. -> auto | none | content
  subtitle,
  /// The other arguments. -> arguments
  args,
) = {
  assert(args.named().len() == 0, message: "ending-slide: unknown argument " + repr(args.named().keys().at(0, default: "")))
  let pos = args.pos()
  if title != auto or subtitle != auto {
    assert(pos.len() <= 1, message: "ending-slide: with title: or subtitle:, give at most one content, the body")
    (title, subtitle, pos.at(0, default: none))
  } else {
    assert(pos.len() <= 3, message: "ending-slide: at most three contents, [title][subtitle][body]")
    (pos.at(0, default: auto), pos.at(1, default: none), pos.at(2, default: none))
  }
}

/// Closing slide (the name of the templates of Tylina): the blue page of the cover, with the logos where the cover put
/// them (in the centre for its style `"line"`), a large title with the yellow rule under it, a subtitle in yellow, a
/// free body and the contact of `config-info` right below them, centered; and the footer of the slides in white (the
/// logos, the title, the authors and the slide number). Without a title it says "Obrigado!" / "Thank you!" in the
/// language of the deck; `title: none` removes the title and the rule.
///
/// Two forms: up to three contents in order, `[title][subtitle][body]`, or the named `title:` and `subtitle:` with
/// the content as the body.
///
/// ```typ
/// #ending-slide()
/// #ending-slide[Good work!][Next lecture: functions][Read chapter 3.]
/// #ending-slide(title: [Questions?], subtitle: [Lab 4 on Friday])[*See you!*]
/// ```
/// -> content
#let ending-slide(
  /// The title; `auto` is "Obrigado!" in the language of the deck, `none` removes it. -> auto | none | content
  title: auto,
  /// The subtitle, in yellow; `auto` and `none` give none. -> auto | none | content
  subtitle: auto,
  /// The contact under the content; `auto` is the one of `config-info(contact:)`, `none` hides it.
  /// -> auto | none | content
  contact: auto,
  /// Up to three contents, `[title][subtitle][body]`, or the body alone with `title:` or `subtitle:`. -> content
  ..args,
) = {
  let (t, st, body) = _ending-args(title, subtitle, args)
  touying-slide-wrapper(self => {
    let t = if t == auto { _tr("thanks") } else { t }
    let st = if st == auto { none } else { st }
    let c = if contact == auto { _contact(self) } else { contact }
    // the page of the cover, with the footer of the slides in white (the logos, the title, the authors, the number)
    let self = utils.merge-dicts(self, _blue-page(self), config-page(footer: self => _footer(self, white: true),
      margin: (x: 1.8em, top: 1.2em, bottom: 1.75em)))
    let decorate(body) = _on-blue(self, {
      set par(leading: 0.45em, justify: false)
      // the logos where the cover put them: in the centre for "line", on the left for the other styles; without a
      // cover, the style of the `kind` of the deck
      context {
        let style = _cover-style.get()
        let style = if style == none { self.store.at("cover-style", default: "line") } else { style }
        place(top + if style == "line" { center } else { left }, _logos-white(self))
      }
      std.align(center + horizon, {
        let gap = false   // room before every part but the first
        if t != none {
          block(spacing: 0pt, {
            set par(spacing: 0pt)
            text(size: 2em, weight: "bold", t)
            v(0.6em)
            _rule(self)
          })
          gap = true
        }
        if st != none {
          if gap { v(0.75em) }
          block(spacing: 0pt, text(size: 1.2em, fill: self.colors.secondary, st))
          gap = true
        }
        if body not in (none, []) {
          if gap { v(0.75em) }
          // the body goes through `_flow`, so that a lone `-> item`, `> box` or `"quote"` is rewritten
          _flow(body)
          gap = true
        }
        if _given(c) { if gap { v(1.1em) }; text(size: 0.8em, c) }
      })
    })
    touying-slide(self: self, setting: decorate, if body == none { [] } else { body })
  })
}

// ---------- section ----------
/// Section slide, created by every `= Title`: on the left, "PART N" in the yellow tag, the title in blue and the yellow
/// rule, as on the cover; on the right, the content right after the `=` (typically an `#image`), at the page margin
/// from the edge. `ufac-theme(section-margin: false)` puts it flush with the edge on every section slide, for photos and
/// figures with a background. Not meant to be called by hand.
/// -> content
#let new-section-slide(
  /// Slide configuration, see @slide.config. -> dictionary
  config: (:),
  /// Heading level, passed by Touying. -> int
  level: 1,
  /// Passed by Touying; the part is always numbered. -> bool
  numbered: true,
  /// Content that follows the `=` heading. -> content
  body,
) = touying-slide-wrapper(self => {
  // the body goes in the second column of a `grid((1fr, auto))` and is moved by the horizontal page margin, so the
  // grid still reserves its width and the title never runs under it; `section-margin` pads it on the right inside
  // the move (as `#pad(right:)` in the deck does), so it stops that far from the edge
  let slide-body = {
    set std.align(left + horizon)
    set image(width: 12em, height: 66%)
    let margin = self.page.at("margin", default: (:))
    let dx = if type(margin) == dictionary { margin.at("x", default: 1.8em) } else { margin }
    let gap = self.store.at("section-margin", default: true)
    let gap = if gap == true { dx } else if gap == false { 0pt } else { gap }
    let body = if body in (none, []) or gap == 0pt { body } else { pad(right: gap, body) }
    grid(columns: (1fr, auto), column-gutter: 1em, {
      set par(leading: 0.4em, spacing: 0pt, justify: false)
      // "PART N" in the yellow tag, the title in blue and the yellow rule, as on the cover
      tag(size: 0.7em, context [#_name(self, "part") #utils.display-current-heading-number(level: 1, numbering: "1")])
      v(0.7em)
      _in-box(self.colors.primary, text(size: 2em, fill: self.colors.primary, weight: "bold",
        utils.display-current-heading(level: 1, numbered: false)), kind: "title")
      v(0.75em)
      _rule(self, length: 3.2cm)
    }, move(dx: dx, body))
  }
  let self = utils.merge-dicts(self, config-page(footer: _footer), config)
  touying-slide(self: self, slide-body)
})

// ---------- rules ----------
// The `init` method of the theme is `_slide-rules` around `_rules`, in that order (the slide rules stay the outermost
// ones). They are separate so that a document that is not a deck (the manual in `docs/`) can apply `_rules` alone, with
// a stand-in `self` (`colors`, `methods.alert`, `info.counter-prefix`, `store`), and keep its own page, font size and headings.

/// Rules that only make sense on a slide: font and size, paragraph spacing and the headings (`=` hidden, `==` blue,
/// `===`/`====` as pills).
/// -> content
#let _slide-rules(
  /// Touying's `self`. -> dictionary
  self,
  /// The deck. -> content
  body,
) = {
  set text(font: "New Computer Modern Sans", size: 22pt, weight: 500, lang: self.store.lang, region: self.store.region)
  set par(leading: 0.55em, spacing: 0.9em)
  set heading(numbering: (..n) => none)
  show heading.where(level: 1): none
  show heading.where(level: 2): set text(fill: self.colors.primary, weight: "bold")
  // `===` and `====` are pills that do not create a slide; a top-level `===` is repeated on every continuation
  // and overflow page by `slide` (grid header), this rule renders the nested ones
  show heading.where(level: 3): it => block(below: 1em, _pill(it.body))
  show heading.where(level: 4): it => block(below: 1em, _pill(it.body))
  body
}

/// Every other set/show rule of the syntax: lists, enums, bold/italic, underline, highlight, the `==x==`, `~x~` and
/// `~~x~~` shorthands, paragraph rewriting, quotes, references and links, math, code (inline chip, blocks), tables, terms
/// and captions.
/// -> content
#let _rules(
  /// Touying's `self`, or a stand-in with `colors`, `methods.alert`, `info.counter-prefix` and `store`. -> dictionary
  self,
  /// The content. -> content
  body,
  /// Whether code blocks get the code rules of the theme (`_code-rules`); the manual frames its code itself. -> bool
  code: true,
) = {
  set list(marker: _markers(self.colors.secondary))
  // enum numbers: pattern by level, always blue and bold (levels 2+ were yellow until 2026-09-16)
  let num(patterns) = (..nums) => { let d = nums.pos().len(); text(fill: self.colors.primary, weight: "bold", numbering(patterns.at(calc.min(d, patterns.len()) - 1), nums.at(-1))) }
  set enum(full: true, numbering: num(("1.", "a)", "i.")))
  // `#set enum(numbering: "a)")`: rebuild the enum with the alternative pattern order (a `set` would not
  // override an explicit field)
  show enum.where(numbering: "a)"): it => { let f = it.fields(); let ch = f.remove("children"); enum(..f, full: true, numbering: num(("a)", "i.", "1.")), ..ch) }
  // bold: black; the box color inside `emph-box` and the `==` title; white inside a pill (the pill color would hide it)
  show strong: it => context { set text(fill: if _in-pill() { white } else { _current-box-color(self.colors.neutral-darkest) }); it }
  show emph: set text(fill: self.colors.neutral-darkest)
  // strong underline in UFAC yellow, behind the text and without evading descenders; the text color does not change.
  // Inside `emph-box` (kind "box" only: in pills/titles the yellow stays) it takes the box color; an explicit `stroke:` wins.
  let ul-stroke = .14em + self.colors.secondary
  set underline(stroke: ul-stroke, offset: .12em, evade: false, background: true)
  show underline: it => context {
    let s = _box-color.get()
    if s.len() == 0 or s.last().kind != "box" or it.stroke != ul-stroke { it } else { underline(stroke: .14em + s.last().color, it.body) }
  }
  set highlight(fill: self.colors.secondary-lighter)
  // inside a box the default highlight becomes `color.lighten(80%)`; an explicit fill is kept (this also avoids recursion)
  show highlight: it => context {
    let s = _box-color.get()
    if s.len() == 0 or it.fill != self.colors.secondary-lighter { it } else { highlight(fill: s.last().color.lighten(80%), it.body) }
  }
  // `==x==` → highlight, except inside `raw` (state `_in-raw`, set by the `show raw` gate below `codly-init`).
  // The inner text neither starts nor ends with a space, so the `==` left over by an escape (`=\=x== … ==z==`)
  // or an `a == b == c` in prose does not pair with the following `==`.
  show regex("==([^=\\s](?:[^=\n]*?[^=\\s])?)=="): it => context { if _in-raw.get() { it } else { highlight(it.text.slice(2, -2)) } }
  // Escape `\==x==` / `=\=x==`: the escaped `=` arrives as a lone text node ("="), but Typst merges neighbouring
  // text nodes before matching the regex (and `show par` only sees the paragraph after that). This rule, more
  // inner than the regex, wraps the lone "=" in a `styled` with a redundant `set text` (`tracking: 0pt`):
  // different styles prevent the merge without changing the look. A `box` would also work, but it opens a
  // line-break opportunity between the two `=` (the box is U+FFFC for the line breaker). Cost: one comparison
  // per text node (0.02 s over 301 pages).
  show text: it => if it.text == "=" { text(tracking: 0pt, it) } else { it }
  // `~text~` → underline and `~~text~~` → alert. In markup `~` is the non-breaking space (U+00A0), so the rules
  // look for those spaces in the already-merged text (like `==x==`: plain text only inside; `\~` escapes; in
  // `raw` the `~` is a literal tilde and nothing matches). `~text~` requires start/space/opening bracket before,
  // space/punctuation/end after, and no space at the ends of the inner text, so that `Fig.~1 and Tab.~2` is
  // left alone. The `~~` rule comes last (innermost) to win over `~`, since `\s` also matches U+00A0.
  let ul-re = regex("(^|[\\s(\\[{\"“‘])\u{a0}([^\u{a0}\\s](?:[^\u{a0}]*?[^\u{a0}\\s])?)\u{a0}($|[\\s)\\]}.,;:!?\"”’])")
  show ul-re: it => {
    let m = it.text.match(ul-re).captures
    text(m.at(0)) + underline(m.at(1)) + text(m.at(2))
  }
  show regex("\u{a0}\u{a0}([^\u{a0}]+?)\u{a0}\u{a0}"): it => (self.methods.alert)(self: self, it.text.trim("\u{a0}"))
  show par: _rewrite-par
  show quote: it => quote-box[#it.body #if it.attribution != none { linebreak(); std.align(right, text(size: .85em)[— #it.attribution]) }]
  // links and references inside a coloured box (an `emph-box`, a callout, an exercise) in the colour of the box,
  // darkened 25%, as in the boxes of the MATLAB course; elsewhere the theme does not colour them
  let in-box-color(it) = context {
    let s = _box-color.get()
    if s.len() == 0 or s.last().kind != "box" { it } else { show text: set text(fill: s.last().color.darken(25%)); it }
  }
  show link: in-box-color
  // @exercise-id / @example-id → "Exercício 1.N" / "Exemplo 1.N", bold in the kind's color, linked to the slide.
  // `self.headings` cannot be used: Touying resets it after every `---` (`call-slide-fn-and-reset`).
  show ref: it => {
    let kind = _label-kind(it.target)
    if kind == none { in-box-color(it) } else { context {
      let hs = query(it.target)
      if hs.len() == 0 { it } else {
        let h = hs.first(); let (name, color) = _kind-style(self, kind)
        link(h.location(), text(fill: color, weight: "bold")[#name #self.info.counter-prefix#_kind-index(kind, h.location().page())])
      }
    } }
  }
  show math.equation: set text(font: "New Computer Modern Math")
  show math.equation.where(block: true): set block(above: 0.55em, below: 0.55em)
  // code: inline `raw` as a gray chip (0.85em); blocks at 0.75em in the box of the theme (see code.typ). Chip colors:
  // gray out of context; inside a title or `emph-box` fill lightest / a light border / text dark of the container
  // color; inside a pill (already dark) fill dark / border darker / text lightest.
  show raw.where(block: false): it => context {
    let s = _box-color.get()
    let (bg, line, ink) = if s.len() == 0 { (luma(247), luma(210), self.colors.neutral-darkest) }
      else if s.last().kind == "pill" { let c = s.last().color; (c.darken(30%), c.darken(55%), c.lighten(85%)) }
      // the border lightened 78%: at 60% it was stronger than the border of the gray chip
      else { let c = s.last().color; (c.lighten(85%), c.lighten(78%), c.darken(30%)) }
    // baseline: -.07em lifts the chip to center it on the cap height (without it the top matches the top of
    // the letters and the bottom hangs 0.14em below the baseline, so the chip looks pushed down).
    // Width: `auto` lets the content wrap inside the chip when it contains spaces (long chips in a narrow
    // column). A single-token chip never wraps: in a column narrower than itself the `box` would be capped to
    // the available width and the text would spill out of the fill (the "y" of `quaternary` in 5 columns,
    // 2026-09-16); so without a space the width is the measured content and the fill covers the text even
    // when it overflows the column.
    let body = text(size: .85em, fill: ink, it)
    let w = if it.text.contains(" ") { auto } else { measure(body).width + .6em }
    box(width: w, fill: bg, stroke: .5pt + line, radius: 3pt, inset: (x: .3em), outset: (y: .2em), baseline: -.07em, body)
  }
  show raw.where(block: true): set text(size: .75em)
  // code blocks: the box of the theme, or codly 2 when the deck passed it (code.typ)
  show: body => if code { _code-rules(self, body) } else { body }
  // `raw` gate for the `==x==` shorthand (see `_gate-raw`): after the code rules, to be the innermost rule
  show: _gate-raw
  // a lone `>` line set the signal: the next block equation gets an `eq-box` around its body. The equation is rebuilt
  // with the box inside (its numbering and label are kept); the rebuilt one is recognized by `_eq-mark` and left alone.
  show math.equation.where(block: true): it => if _has-eq-mark(it.body) {
    // already boxed: only tell the box where it sits (style and padding, see `_eq-ctx`)
    _eq-ctx.update(if _is-whole-eq-box(it.body) { "whole" } else { "part" }); it; _eq-ctx.update(none)
  } else { context {
    let c = _key-eq.get()
    if c == none { it } else {
      _key-eq.update(none)
      // The label stays on the original equation (attaching it again would duplicate it), which still counts as a
      // numbered equation although it is not drawn: step the counter back so that both share one number.
      let fields = it.fields(); let _ = fields.remove("body"); let _ = fields.remove("label", default: none)
      if it.numbering != none { counter(math.equation).update(n => calc.max(n - 1, 0)) }
      math.equation(..fields, eq-box(color: c, it))
    }
  } }
  // tables, terms and captions, ported from 0.0.1 (blue header with white text and white formulas)
  set table(inset: 0.5em, fill: (_, y) => if y == 0 { self.colors.primary },
    stroke: (x, y) => (y: self.colors.primary, right: self.colors.primary, x: if x > 0 and y == 0 { self.colors.neutral-lightest } else { self.colors.primary }))
  // the header is a pill (white text on the color), so its code chips, `*bold*` and icons follow the pill convention
  show table.cell.where(y: 0): it => { set text(fill: self.colors.neutral-lightest, weight: "bold"); show math.equation: set text(fill: self.colors.neutral-lightest); _in-box(self.colors.primary, it, kind: "pill") }
  // a cell filled with a tone of the palette follows its background, as the boxes and the pills do: on a light tone
  // (`table.cell(fill: colors.secondary-lighter)`) it is a box of the family's `-dark` color, readable on the fill
  // (code chips in light tones of it, `*bold*` in it); on a dark one (`colors.primary`, `colors.tertiary-dark`) it is a
  // pill, with white text as in the header. White (`neutral-lightest`) counts as no fill.
  show table.cell: it => {
    if it.y == 0 or type(it.fill) != color or it.fill == self.colors.neutral-lightest { return it }
    let tones = ("", "-light", "-lighter", "-lightest", "-dark", "-darker", "-darkest")
    let family = ("primary", "secondary", "tertiary", "quaternary", "neutral").find(f =>
      tones.any(t => self.colors.at(f + t, default: none) == it.fill))
    if family == none { it } else if _is-light(it.fill) { _in-box(self.colors.at(family + "-dark"), it) } else {
      set text(fill: self.colors.neutral-lightest)
      _in-box(it.fill, it, kind: "pill")
    }
  }
  show figure.caption: it => it.body
  set terms(tight: false)
  show terms.item: it => { text(weight: "bold", fill: self.colors.neutral-darkest, it.term + ": "); it.description; linebreak() }
  body
}

// ---------- theme ----------
/// The theme. It sets the page (22pt New Computer Modern Sans, the UFAC header and footer) and every rule of the
/// syntax, and takes Touying's configs as extra arguments.
///
/// ```typ
/// #show: ufac-theme.with(
///   aspect-ratio: "16-9",
///   config-info(
///     title: [Neural Networks], short-title: [PPGEE016],
///     subtitle: [Training and evaluation], short-subtitle: [Units III and IV],
///     author: [Prof. Name], counter-prefix: [1.],
///   ),
/// )
/// ```
///
/// `config-info` carries the fields of Touying: `title` (the name of the course or of the work), `short-title` (its code
/// or a shorter name: the tag of the cover), `subtitle` (the topic), `short-subtitle` (the lecture or the unit), `author`
/// (one, an array or free content), `date`, `institution`, `logo` and `contact`; the aliases of a course (`subject`,
/// `subject-code`, `unit`, `unit-title`, `course`, `semester`, `year`); the `kind` of presentation; and
/// `counter-prefix`, the prefix of the exercise and example numbers ("Exercise 1.N"; `none` gives "Exercise N").
/// -> content
#let ufac-theme(
  /// Any ratio accepted by Touying's `utils.page-args-from-aspect-ratio`: `"16-9"`, `"4-3"`, … -> str
  aspect-ratio: "16-9",
  /// Language of the deck: `"pt-br"` (or `"pt"`), `"en"` or `"es"`, optionally with a region (`"en-US"`). It sets
  /// `text.lang`/`region` and the localized names below. -> str
  lang: "pt-br",
  /// Name in the pill of exercise slides; `auto` is Exercício / Exercise / Ejercicio. -> auto | content
  exercise-name: auto,
  /// Name in the pill of example slides; `auto` is Exemplo / Example / Ejemplo. -> auto | content
  example-name: auto,
  /// Icon before the name in the pill of exercise slides: the name of an `icon`, any content (an image or a symbol,
  /// centered on the capitals like the icons) or `none` for no icon. `exercise-slide(icon:)` changes it on one slide.
  /// -> none | str | content | symbol
  exercise-icon: "pencil",
  /// Icon before the name in the pill of example slides, like `exercise-icon`. -> none | str | content | symbol
  example-icon: "beaker",
  /// Prefix of the section slide ("Part N:"); `auto` is Parte / Part / Parte. -> auto | content
  part-name: auto,
  /// Left text of the footer; a function receives `self`. `auto` is the `short-title` and the `title` separated by a
  /// dot and, when the date is a `semester` or a `year`, the date too ("CCET123 • Control Systems • 2026.2").
  /// -> auto | content | function
  footer-left: auto,
  /// Right text of the footer; a function receives `self`. `auto` is the authors in running text ("A, B and C"); of an
  /// author written as free content, the names of its first group. -> auto | content | function
  footer-right: auto,
  /// Distance between the content of the section slides (what follows `=`, on the right) and the right edge of the
  /// page. `true` keeps the page margin (`1.8em`, the same as the text); `false` puts it flush with the edge, which
  /// suits a photo or a figure with a background; a length sets the distance. -> bool | length
  section-margin: true,
  /// Background of the cover and of the closing slide: `"circles"` (the solid UFAC blue with two translucent circles),
  /// `"gradient"` (a blue gradient, with the circles) or `"plain"` (the blue alone, the cover of 0.2.0). -> str
  background: "circles",
  /// The codly 2 module, when the deck imports it (`#import "@preview/codly:2.0.0" as codly`): the code blocks then go
  /// through codly, with the look of the theme (`codly-ufac-theme`). `none` gives the code box of the theme, without
  /// codly. -> none | module
  codly: none,
  /// Languages added to those of the theme (`code-languages`) or replacing them, as `(name:, icon:)`; the dictionary of
  /// the codly-languages package works too. -> dictionary
  code-languages: (:),
  /// Touying configs, typically `config-info(..)`; also `config-common(..)`, `config-page(..)`. -> dictionary
  ..args,
  /// The deck. -> content
  body,
) = {
  let l = _lang-parse(lang)
  assert("logos" not in args.named(), message: "ufac-theme: logos moved to config-info(logo: ..) in 0.3.0")
  let footer-left = if footer-left != auto { footer-left } else { self => {
    let parts = (self.info.at("short-title", default: none), self.info.title)
    if self.info.at("date-short", default: false) { parts.push(_date(self)) }
    parts.filter(_given).map(x => [#x]).join([ #_sep-dot ])
  } }
  let footer-right = if footer-right != auto { footer-right } else { self => _author-names(self) }
  let configs = _prepare-configs(l.lang, args.pos())
  assert(background in _backgrounds, message: "ufac-theme: background is "
    + _backgrounds.keys().map(k => "\"" + k + "\"").join(", "))
  let bg = _backgrounds.at(background)
  assert(type(section-margin) in (bool, length),
    message: "ufac-theme: section-margin is true (the page margin), false (flush with the edge) or a length")
  for (key, ic) in (("exercise-icon", exercise-icon), ("example-icon", example-icon)) {
    assert(ic == none or type(ic) in (str, content, symbol),
      message: "ufac-theme: " + key + " is the name of an icon, content (an image, a symbol) or none")
  }
  set text(size: 20pt)
  show: touying-slides.with(
    config-page(..utils.page-args-from-aspect-ratio(aspect-ratio), header-ascent: 0em, footer-descent: 0em, margin: (top: 3.25em, bottom: 1.75em, x: 1.8em)),
    config-common(slide-fn: slide, new-section-slide-fn: new-section-slide, receive-body-for-new-section-slide-fn: true, show-strong-with-alert: false),
    config-methods(
      init: (self: none, body) => {
        // the information of the deck, for `#info` (which reads it in `context`, anywhere)
        _deck.update((info: self.info, store: self.store, colors: self.colors,
          datetime-format: self.at("datetime-format", default: auto)))
        _slide-rules(self, _rules(self, body))
      },
      // in the colour of the box around it, like bold text (blue elsewhere); yellow in a pill
      alert: (self: none, it) => context text(weight: "bold",
        fill: if _in-pill() { colors.secondary } else { _current-box-color(self.colors.primary) }, it),
      cover: _cover,   // veil in the page colour at 85% over the laid-out content (see `_cover` in utils.typ)
    ),
    config-colors(..colors),
    config-store(lang: l.lang, region: l.region, exercise-name: exercise-name, example-name: example-name,
      exercise-icon: exercise-icon, example-icon: example-icon, part-name: part-name, footer-left: footer-left,
      footer-right: footer-right, section-margin: section-margin, codly: codly, code-languages: code-languages,
      cover-fill: bg.fill, cover-circles: bg.circles),
    // `author: none`, not `[]`: Touying turns a content author into a string for `set document(author:)` and an empty
    // content gives `none` there, so a deck without `config-info(author:)` failed to compile
    _info-defaults,
    ..configs.before,
    ..configs.configs,
    ..configs.after,
    ..args.named(),
  )
  _mark-continuations(body)
}
