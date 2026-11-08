// O divisor de tensão: dois resistores em série e a tensão de saída entre os terminais a e b.

#import "@preview/touying-ufac-unofficial:0.3.0": colors
#import "@preview/zap:0.6.0"
#import "/header.typ": zap-ufac, corrente

#zap.circuit(length: 1.8cm, {
  import zap: *
  zap-ufac()
  vsource("vi", (0, 0), (0, 4), label: $v_i$)
  wire((0, 4), (3, 4))
  resistor("r1", (3, 4), (3, 2), label: $R_1$)
  resistor("r2", (3, 2), (3, 0), label: $R_2$)
  wire((3, 0), (0, 0))
  wire((3, 2), (5.5, 2))
  wire((3, 0), (5.5, 0))
  node("n1", (3, 2))                                       // junção: ponto cheio
  node("n2", (3, 0))
  node("a", (5.5, 2), fill: false)                         // terminal: círculo vazado
  node("b", (5.5, 0), fill: false)
  corrente((0, 4), (3, 4), $i$)
  // tensão entre os terminais: o +, o − e o rótulo no meio, em primary
  cetz.draw.content((5.5, 1.55), text(fill: colors.primary, $+$))
  cetz.draw.content((5.5, 0.45), text(fill: colors.primary, $-$))
  cetz.draw.content((5.5, 1), text(fill: colors.primary, $v_o$))
})
