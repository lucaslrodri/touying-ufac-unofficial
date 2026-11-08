// A exponencial decrescente do exercício, x(t) = e^(-t) u(t): zero antes de t = 0 e e^(-t) depois.
#import "/common.typ": grafico
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/touying-ufac-unofficial:0.3.0": colors

#let t = lq.linspace(0, 4, num: 80)
#grafico(
  xlim: (-1, 4),
  ylim: (-0.2, 1.2),
  // os dois trechos são o mesmo sinal: a mesma cor nos dois
  lq.plot((-1, 0), (0, 0), mark: none, stroke: 2pt, color: colors.primary),
  lq.plot(t, t.map(x => calc.exp(-x)), mark: none, stroke: 2pt, color: colors.primary),
)
