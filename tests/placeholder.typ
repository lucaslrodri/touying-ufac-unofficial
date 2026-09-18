// Stand-alone helper, not part of the touying-ufac-unofficial theme: marks the place of a figure that does not exist
// yet.
// Usage: #import "placeholder.typ": placeholder (from common.typ; "../../placeholder.typ" from a test body)
// Rectangle with `color.lighten(90%)` fill, 1pt border in the color (`stroke: auto`; accepts `none` or any stroke), an
// image icon (lucide "image") and a caption at 0.6em. Default 12em × 66%: the size of `#image` on the section slide.
#let _image-icon(color) = image(bytes("<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"" + color.to-hex() + "\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><rect width=\"18\" height=\"18\" x=\"3\" y=\"3\" rx=\"2\" ry=\"2\"/><circle cx=\"9\" cy=\"9\" r=\"2\"/><path d=\"m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21\"/></svg>"), width: 2em, height: 2em) // explicit width and height: the section slide has set image(width:, height:)
#let placeholder(width: 12em, height: 66%, color: rgb("#0C4DA2"), label: [image], stroke: auto) = {
  let s = if stroke == auto { 1pt + color } else { stroke }
  // The border is drawn *inside* the box (a rectangle inset by half the thickness): a `stroke` of the `block` itself is
  // centered on the edge and half of it disappears when the box touches the page edge (section slide).
  let th = if s == none { 0pt } else { let t = std.stroke(s).thickness; if t == auto { 1pt } else { t } }
  block(width: width, height: height, fill: color.lighten(90%), breakable: false, clip: true, {
    if s != none { place(center + horizon, rect(width: 100% - th, height: 100% - th, stroke: s)) }
    align(center + horizon, { _image-icon(color); v(.4em, weak: true); text(size: .6em, fill: color, label) })
  })
}
