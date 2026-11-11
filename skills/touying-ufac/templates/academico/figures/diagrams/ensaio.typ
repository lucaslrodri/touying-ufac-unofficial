// O método como fluxo (fletcher), nas cores do tema. Incluído no slide com
// `#align(center, include "figures/diagrams/ensaio.typ")`.
#import "@preview/touying-ufac-unofficial:0.4.0": colors
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#diagram(
  edge-stroke: 1.6pt + colors.neutral-dark,
  spacing: 3em,
  node((0, 0), [Descarga], name: <a>, stroke: 1.4pt + colors.primary, fill: colors.primary-lightest,
    corner-radius: 6pt, inset: .6em),
  node((1, 0), [Medição], name: <b>, stroke: 1.4pt + colors.primary, fill: colors.primary-lightest,
    corner-radius: 6pt, inset: .6em),
  node((2, 0), [Estimação], name: <c>, stroke: 1.4pt + colors.primary, fill: colors.primary-lightest,
    corner-radius: 6pt, inset: .6em),
  edge(<a>, <b>, "-|>"),
  edge(<b>, <c>, "-|>"),
)
