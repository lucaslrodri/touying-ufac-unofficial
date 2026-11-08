// O amplificador inversor: o amp-op, o resistor de entrada e o de realimentação.

#import "@preview/zap:0.6.0"
#import "/header.typ": zap-ufac

#zap.circuit(length: 1.7cm, {
  import zap: *
  zap-ufac()
  opamp("op", (5, 0))                                      // entrada − em (4.1, 0.45), + em (4.1, -0.45)
  node("vi", (0, 0.45), fill: false, label: (content: $v_i (t)$, anchor: "west"))
  resistor("r1", (0, 0.45), (3, 0.45), label: $R_1$)
  wire((3, 0.45), "op.minus")
  wire((3, 0.45), (3, 2))
  resistor("rf", (3, 2), (6.8, 2), label: $R_f$)
  wire((6.8, 2), (6.8, 0))
  wire("op.out", (8, 0))
  node("j1", (3, 0.45))
  node("j2", (6.8, 0))
  node("vo", (8, 0), fill: false, label: (content: $v_o (t)$, anchor: "east"))
  wire("op.plus", (3.6, -0.45), (3.6, -1.1))
  ground("g", (3.6, -1.1))
})
