// touying-ufac-unofficial — the icons: the ones the theme ships (assets/icons/*.json, in the JSON format of Iconify, only
// the icons the theme uses; scripts/icons.sh downloads them) and the role of each one. The theme builds their SVG
// itself and does not depend on the iconify package: a deck that wants other icons imports iconify and passes its
// icons as content (the manual, Integrations).

/// The collections shipped by the theme, by prefix: Octicons (the roles of the theme), Phosphor (output and code),
/// Devicon (the logos of the languages) and Simple Icons (the Typst logo).
/// -> dictionary
#let _shipped = ("octicon", "ph", "devicon", "simple-icons").map(p => (p, json("../assets/icons/" + p + ".json"))).to-dict()

/// The icon of each role of the theme, as `"collection:name"`: the Octicons of 0.2.0 (size 16) for the callouts, the
/// exercise and example pills, the file name of a code block, the terminal (also the pill of the shell) and the
/// contact; Phosphor in the bold weight for the output of a program and for code; the logos of Devicon (Typst from
/// Simple Icons) for the languages. A role is also a valid name for `icon`: `#icon("warning")`.
///
/// #test(
///   `theme-icons.warning == "octicon:alert-16"`,
///   `theme-icons.output == "ph:article-bold"`,
/// )
/// -> dictionary
#let theme-icons = (
  warning: "octicon:alert-16",
  tip: "octicon:light-bulb-16",
  info: "octicon:info-16",
  note: "octicon:note-16",
  exercise: "octicon:pencil-16",
  example: "octicon:beaker-16",
  file: "octicon:file-code-16",
  terminal: "octicon:terminal-16",
  contact: "octicon:mail-16",
  output: "ph:article-bold",
  code: "ph:code-bold",
  python: "devicon:python",
  matlab: "devicon:matlab",
  typst: "simple-icons:typst",
)

/// The message of an icon the theme does not ship: it names the icons of the theme and tells how to get the others,
/// from the iconify package used directly.
/// -> str
#let _not-shipped(
  /// Name given to `icon`. -> str
  name,
  /// The same icon as `"collection:name"` in iconify. -> str
  full,
) = ("unknown icon: \"" + name + "\". The theme ships only its own icons (" + theme-icons.keys().join(", ")
  + "); another one comes from the iconify package, imported by the deck: #import \"@preview/iconify:0.5.3\", "
  + "#iconify.provide-icons(json(..)) with its collection and iconify.icon(\"" + full + "\", height: 1em), which "
  + "emph-box, callout and the pills take as content (see the manual, Integrations)")

/// Where an icon of the theme comes from, decided at the call: `(collection, name)` of a shipped icon. A bare name is a
/// role of the theme (`"warning"`) or the name of a shipped Octicon without its size, as in 0.2.0 (`"alert"`,
/// `"pencil"`, `"beaker"`); a full name is a shipped icon (`"devicon:python"`). Any other name is an error that tells
/// how to get the icon from the iconify package.
///
/// #test(
///   `_icon-source("warning") == ("octicon", "alert-16")`,
///   `_icon-source("pencil") == ("octicon", "pencil-16")`,
///   `_icon-source("devicon:python") == ("devicon", "python")`,
/// )
/// -> array
#let _icon-source(
  /// Name of the icon. -> str
  name,
) = {
  assert(type(name) == str, message: "icon: the name is a string, got " + repr(name))
  let full = theme-icons.at(name, default: name)
  if not full.contains(":") {
    let n = full + "-16"
    assert(n in _shipped.octicon.icons, message: _not-shipped(name, "octicon:" + n))
    return ("octicon", n)
  }
  let (col, n) = (full.split(":").first(), full.split(":").slice(1).join(":"))
  assert(col in _shipped and n in _shipped.at(col).icons, message: _not-shipped(name, full))
  (col, n)
}

/// SVG source of an icon of a collection in the JSON format of Iconify, with `currentColor` replaced by `fill` (the
/// multicolour logos keep their colours). An alias is followed to its parent icon. The `viewBox` is built here rather
/// than by the iconify package, which swaps its width and height (a wide logo came out small).
///
/// #test(
///   `_data-svg((icons: (a: (body: "<path fill=\"currentColor\"/>"))), "a", red).contains("#ff4136")`,
///   `_data-svg((width: 24, height: 12, icons: (a: (body: ""))), "a", red).contains("viewBox=\"0 0 24 12\"")`,
/// )
/// -> str
#let _data-svg(
  /// The collection: a dictionary with `icons` (and optional `aliases`, `width`, `height`). -> dictionary
  data,
  /// Name of the icon in it. -> str
  name,
  /// Colour of the icon. -> color
  fill,
) = {
  let ic = data.icons.at(name, default: none)
  if ic == none {
    let alias = data.at("aliases", default: (:)).at(name)
    ic = alias + data.icons.at(alias.parent)
  }
  let w = str(ic.at("width", default: data.at("width", default: 16)))
  let h = str(ic.at("height", default: data.at("height", default: 16)))
  ("<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 " + w + " " + h + "\" width=\"" + w + "\" height=\"" + h
    + "\">" + ic.body.replace("currentColor", fill.to-hex()) + "</svg>")
}

/// SVG source of a shipped icon.
/// -> str
#let _icon-svg(
  /// Source of the icon, see @_icon-source. -> array
  source,
  /// Colour of the icon. -> color
  fill,
) = _data-svg(_shipped.at(source.first()), source.last(), fill)
