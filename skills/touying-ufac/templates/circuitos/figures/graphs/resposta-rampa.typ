// A resposta do circuito RC à rampa: a entrada v_s (t) = t e a tensão no capacitor, com R C = 1 s.

#import "@preview/touying-ufac-unofficial:0.4.0": colors
#import "@preview/lilaq:0.6.0" as lq

#lq.diagram(
  width: 100%, height: 6.5cm,
  xlabel: [$t$ (s)],
  legend: (position: top + left),
  lq.plot(lq.linspace(0, 5), t => t, mark: none,
    stroke: (paint: colors.neutral-dark, thickness: 1.5pt, dash: "dashed"), label: $v_s (t)$),
  lq.plot(lq.linspace(0, 5), t => t - (1 - calc.exp(-t)), mark: none, stroke: 2pt + colors.primary,
    label: $v_C (t)$),
)
