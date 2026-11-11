// circuitos-zap.typ: deck de demonstração do estilo de circuito para o pacote zap 0.6.0 com o tema
// touying-ufac-unofficial, que não tem estilo de circuito. Validado com Typst 0.15.1, touying 0.7.4,
// touying-ufac-unofficial 0.3.0 e zap 0.6.0 (que traz o cetz 0.5.2). Guia: references/zap.md.
//
// O estilo (`zap-ufac`, `tensao`, `corrente`, `regiao`) está em header.typ; cada circuito, num arquivo de
// figures/circuits/, que importa o zap e as funções do estilo; o deck só inclui o arquivo, um circuito por slide.
//
// Como levar para um deck:
//   1. O estilo vai no header.typ do deck. Se o deck ainda não tem um, copie este header.typ para a pasta dele (no
//      acadêmico, ao lado do deck.typ; na aula, em slide-NN/); se já tem, copie para ele os dois imports e as
//      funções. Na aula, cada deck com circuitos leva a sua cópia (não há common.typ).
//   2. Cada circuito num arquivo de figures/circuits/<nome>.typ, que importa o zap e o que usa do estilo, como os
//      daqui. O caminho do import muda com o modo:
//        acadêmico (a raiz é a pasta da apresentação):  #import "/header.typ": zap-ufac, tensao, corrente
//        aula (a raiz é a pasta da disciplina):          #import "../../header.typ": zap-ufac, tensao, corrente
//   3. No slide, o circuito entra pelo arquivo:
//        #align(center, include "figures/circuits/rc-serie.typ")
//
// Compile desta pasta, que é a raiz: typst compile circuitos-zap.typ

#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *

#show: ufac-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Circuitos com o zap],
    subtitle: [Estilo de circuito para o tema],
    author: [touying-ufac],
  ),
)

== Circuito RC série
#align(center, include "figures/circuits/rc-serie.typ")

== Divisor de tensão
#align(center, include "figures/circuits/divisor-de-tensao.typ")

== Equivalente de Norton
#align(center, include "figures/circuits/equivalente-de-norton.typ")

== Amplificador inversor
#align(center, include "figures/circuits/amplificador-inversor.typ")

// circuito ao lado de um gráfico: o circuito com length: 1.3cm, o gráfico com width: 100% da coluna
== Resposta do RC à rampa
#cols(columns: (auto, 1fr), gutter: 1.5em)[
  #include "figures/circuits/rc-coluna.typ"
][
  #include "figures/graphs/resposta-rampa.typ"
]

== Destaque de um componente
#align(center, include "figures/circuits/rl-destaque.typ")
