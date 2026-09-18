// touying-ufac manual — tidy style with the look of Mantys manuals (Mantys itself does not compile on Typst 0.15):
// the signature in a frame with one parameter per line, default values and filled type chips; every parameter in a
// thin box with an "Argument" legend on its border, `name: default` on the left and the types on the right. The frames
// take UFAC blue instead of Mantys' teal; the type colors are tidy's, the ones of the Typst documentation.
#import "@preview/tidy:0.4.3"
#import "../src/constants.typ": colors

#let mono = "DejaVu Sans Mono"
#let frame-stroke = .75pt + colors.primary   // signatures: UFAC blue instead of Mantys' teal
#let frame-radius = 4pt
#let code-frame = (stroke: 1pt + luma(240), radius: .32em)   // code and examples: codly's default border
#let default-color = rgb(181, 2, 86)   // Mantys' color for default values
#let type-colors = tidy.styles.default.colors

/// Frame of the signatures; with `..code-frame`, of the code blocks and examples.
#let frame(body, ..args) = block(width: 100%, stroke: frame-stroke, radius: frame-radius, inset: 8pt, ..args, body)

/// Filled type chip. Plain text, not `raw`, so that the theme's code chip does not take it over.
#let show-type(type, style-args: (:)) = {
  let palette = if style-args.at("colors", default: auto) == auto { type-colors } else { style-args.colors }
  box(fill: palette.at(type, default: palette.at("default")), radius: 2pt, inset: (x: 3pt), outset: (y: 2.5pt),
    text(font: mono, size: .78em, fill: black, type))
}
#let _types(types, style-args, sep: h(.45em)) = types.map(t => show-type(t, style-args: style-args)).join(sep)
#let _default(value) = text(font: mono, size: .85em, fill: default-color, value)

/// The signature: name, one parameter per line (linked to its box) with default and types, return types.
#let show-parameter-list(fn, style-args: (:)) = frame(breakable: false, {
  set text(font: mono, size: .85em)
  set par(justify: false, leading: .7em, spacing: .7em)
  let lines = (text(fill: colors.primary, weight: "bold", fn.name) + "(",)
  for (name, info) in fn.args {
    if style-args.omit-private-parameters and name.starts-with("_") { continue }
    let documented = info.at("description", default: "") != "" or not style-args.omit-empty-param-descriptions
    let shown = strong(name)
    if style-args.enable-cross-references and documented {
      shown = link(label(style-args.label-prefix + fn.name + "." + name.trim(".")), shown)
    }
    // one paragraph per parameter, so that a long default wraps under itself and not back at the margin
    lines.push(pad(left: 1.2em, par(hanging-indent: 1.2em, {
      shown
      if "default" in info { ": " + text(fill: default-color, info.default) }
      if "types" in info { h(.8em); _types(info.types, style-args) }
    })))
  }
  lines.push(")" + if fn.at("return-types", default: none) != none { " -> " + _types(fn.return-types, style-args) })
  stack(spacing: .7em, ..lines)
})

/// One parameter: a thin box with the "Argument" legend over its top border.
#let show-parameter-block(function-name: none, name, types, content, style-args, show-default: false, default: none) = {
  let legend = box(fill: white, inset: (x: 3pt), text(size: .7em, fill: luma(90), [Argument]))
  block(width: 100%, stroke: .6pt + luma(60), radius: 3pt, inset: (x: 8pt, top: 9pt, bottom: 8pt), above: 1.35em,
    breakable: style-args.break-param-descriptions, {
      place(top + left, dx: 4pt, dy: -9pt - .45em, legend)
      set par(justify: false)
      grid(columns: (1fr, auto), column-gutter: 1em, align: (left + horizon, right + horizon),
        [#text(font: mono, size: .85em, name)#if function-name != none and style-args.enable-cross-references { label(function-name + "." + name.trim(".")) }#if show-default { text(font: mono, size: .85em)[: ]; _default(default) }],
        _types(types, style-args, sep: text(fill: luma(90))[ | ]))
      pad(left: .8em, top: .2em, content)
    })
}

/// A function: its name as a heading (for the outline and the cross-references), the signature, the description with
/// its examples, then the parameters.
#let show-function(fn, style-args) = {
  [#heading(level: style-args.first-heading-level + 1, text(font: mono, fn.name + "()"))#if style-args.enable-cross-references { label(style-args.label-prefix + fn.name + "()") }]
  (style-args.style.show-parameter-list)(fn, style-args: style-args)
  tidy.utilities.eval-docstring(fn.description, style-args)
  for (name, info) in fn.args {
    if style-args.omit-private-parameters and name.starts-with("_") { continue }
    let description = info.at("description", default: "")
    if description == "" and style-args.omit-empty-param-descriptions { continue }
    (style-args.style.show-parameter-block)(
      name, info.at("types", default: ()), tidy.utilities.eval-docstring(description, style-args), style-args,
      show-default: "default" in info, default: info.at("default", default: none),
      function-name: style-args.label-prefix + fn.name,
    )
  }
  v(2em, weak: true)
}

/// A variable: name and type on one line, then the description.
#let show-variable(var, style-args) = {
  grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
    [#heading(level: style-args.first-heading-level + 1, text(font: mono, var.name))#if style-args.enable-cross-references { label(style-args.label-prefix + var.name) }],
    if "type" in var { show-type(var.type, style-args: style-args) })
  tidy.utilities.eval-docstring(var.description, style-args)
  v(2em, weak: true)
}

/// The style, for `tidy.show-module(style:)`; `show-example` is added by the template, which owns the example layout.
#let style = dictionary(tidy.styles.default) + (
  show-type: show-type, show-parameter-list: show-parameter-list, show-parameter-block: show-parameter-block,
  show-function: show-function, show-variable: show-variable,
)
