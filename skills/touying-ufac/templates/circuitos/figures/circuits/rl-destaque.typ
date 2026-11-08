// O circuito RL com o indutor em destaque (secondary-dark), com a corrente e a tensão no indutor.

#import "@preview/touying-ufac-unofficial:0.3.0": colors
#import "@preview/zap:0.6.0"
#import "/header.typ": zap-ufac, tensao, corrente

#zap.circuit(length: 1.8cm, {
  import zap: *
  zap-ufac()
  vsource("vs", (0, 0), (0, 4), label: $v_s (t)$)
  resistor("r", (0, 4), (5, 4), label: $R$)
  inductor("l", (5, 4), (5, 0), label: text(fill: colors.secondary-dark, $L$), stroke: 2pt + colors.secondary-dark)
  wire((5, 0), (0, 0))
  corrente((5, 0), (0, 0), $i(t)$)                         // para a esquerda: rótulo abaixo do fio
  tensao("l", $v_L (t)$)
})
