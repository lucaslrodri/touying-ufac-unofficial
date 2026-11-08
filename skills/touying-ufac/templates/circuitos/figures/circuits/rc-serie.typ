// O circuito RC série: a fonte, a chave, o resistor e o capacitor, com a corrente e as duas tensões.

#import "@preview/zap:0.6.0"
#import "/header.typ": zap-ufac, tensao, corrente

#zap.circuit(length: 1.8cm, {
  import zap: *
  zap-ufac()
  vsource("vs", (0, 0), (0, 4), label: $v_s (t)$)          // de baixo para cima: + em cima, rótulo à esquerda
  switch("ch", (0, 4), (2, 4), label: $t = 0$)
  resistor("r", (2, 4), (7, 4), label: $R$)                // símbolo no meio; sobra fio para a corrente
  capacitor("c", (7, 4), (7, 0), label: $C$)               // de cima para baixo: rótulo à direita, fora
  wire((7, 0), (0, 0))
  corrente((2, 4), (3.8, 4), $i(t)$)
  tensao("r", $v_R (t)$)
  tensao("c", $v_C (t)$)
})
