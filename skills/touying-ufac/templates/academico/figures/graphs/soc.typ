// O estado de carga (SoC) no ensaio, lido de data/soc.csv: nenhum número copiado à mão. Incluído no slide do
// resultado com `#align(center, include "figures/graphs/soc.typ")`; o caminho /data/… parte da pasta do deck.
#import "@preview/touying-ufac-unofficial:0.3.0": colors
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/zero:0.6.1"

#zero.set-num(decimal-separator: ",")

#let soc = csv("/data/soc.csv", row-type: dictionary).map(r => r.keys().map(k => (k, float(r.at(k)))).to-dict())

#lq.diagram(
  width: 14cm, height: 6cm,
  xlabel: [Tempo (min)], ylabel: [SoC (%)],
  legend: (position: top + right),
  lq.plot(soc.map(r => r.tempo), soc.map(r => r.real), mark: none, stroke: 2pt + colors.neutral-dark,
    label: [Referência]),
  lq.plot(soc.map(r => r.tempo), soc.map(r => r.contagem), mark: none,
    stroke: (paint: colors.tertiary, thickness: 2pt, dash: "dashed"), label: [Contagem]),
  lq.plot(soc.map(r => r.tempo), soc.map(r => r.kalman), mark: "o", mark-size: 6pt, stroke: none,
    color: colors.primary, label: [Kalman]),
)
