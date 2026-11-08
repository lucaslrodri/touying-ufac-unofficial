// O circuito RC sem a chave, menor (length: 1.3cm), para uma coluna ao lado de um gráfico.

#import "@preview/zap:0.6.0"
#import "/header.typ": zap-ufac, tensao

#zap.circuit(length: 1.3cm, {
  import zap: *
  zap-ufac()
  vsource("vs", (0, 0), (0, 4), label: $v_s (t)$)
  resistor("r", (0, 4), (7, 4), label: $R$)
  capacitor("c", (7, 4), (7, 0), label: $C$)
  wire((7, 0), (0, 0))
  tensao("c", $v_C (t)$)
})
