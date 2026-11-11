// Uma célula de lítio com o indicador de carga (CeTZ), nas cores do tema: a figura da Parte "Introdução", que mostra
// o objeto do trabalho. Incluída depois do `= Introdução` com `#include "figures/drawings/bateria.typ"`.
#import "@preview/touying-ufac-unofficial:0.4.0": colors
#import "@preview/cetz:0.5.2"

#cetz.canvas(length: 1em, {
  import cetz.draw: *
  // o polo positivo e o corpo da célula
  rect((1.6, 8.6), (3.4, 9.3), radius: .15, fill: colors.neutral-dark, stroke: none)
  rect((0, 0), (5, 8.6), radius: .5, stroke: 3pt + colors.primary, fill: colors.primary-lightest)
  // a carga: quatro barras de seis, a de cima em amarelo
  for i in range(4) {
    let cor = if i == 3 { colors.secondary } else { colors.primary }
    rect((.7, .7 + i * 1.3), (4.3, 1.7 + i * 1.3), radius: .15, fill: cor, stroke: none)
  }
  content((2.5, 7.1), text(fill: colors.primary-dark, weight: "bold")[SoC])
})
