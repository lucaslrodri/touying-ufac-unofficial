// O pulso retangular do exemplo: x(t) = 3 para -1 <= t <= 1 e 0 fora, no estilo da disciplina (/common.typ).
#import "/common.typ": grafico
#import "@preview/lilaq:0.6.0" as lq

#grafico(
  xlim: (-2.5, 2.5),
  ylim: (-0.5, 4),
  lq.plot((-2.5, -1, -1, 1, 1, 2.5), (0, 0, 3, 3, 0, 0), mark: none, stroke: 2pt),
)
