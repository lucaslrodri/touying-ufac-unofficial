// O equivalente de Norton: a fonte de corrente e o resistor em paralelo, destacados pela `regiao`, com a tensão
// entre os terminais a e b.

#import "@preview/touying-ufac-unofficial:0.3.0": colors
#import "@preview/zap:0.6.0"
#import "/header.typ": zap-ufac, regiao

#zap.circuit(length: 1.8cm, {
  import zap: *
  zap-ufac()
  regiao((-1.6, -0.5), (3.9, 4.5), rotulo: [Equivalente de Norton])
  isource("is", (0, 0), (0, 4), label: $i_s (t)$)          // a seta vai do primeiro nó para o segundo
  wire((0, 4), (3, 4))
  resistor("r", (3, 4), (3, 0), label: $R$)
  wire((3, 0), (0, 0))
  wire((3, 4), (5.5, 4))
  wire((3, 0), (5.5, 0))
  node("n1", (3, 4))
  node("n2", (3, 0))
  node("a", (5.5, 4), fill: false, label: (content: $a$, anchor: "east"))
  node("b", (5.5, 0), fill: false, label: (content: $b$, anchor: "east"))
  // tensão entre os terminais: o +, o − e o rótulo no meio, em primary
  cetz.draw.content((5.5, 3.3), text(fill: colors.primary, $+$))
  cetz.draw.content((5.5, 0.7), text(fill: colors.primary, $-$))
  cetz.draw.content((5.5, 2), text(fill: colors.primary, $v(t)$))
})
