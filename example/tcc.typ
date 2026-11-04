// Example deck of the touying-ufac-unofficial theme: the defence of a final paper (`kind: "tcc"`), with the student, the
// advisor and the co-advisor written as free content, the plain background and the tag of the work on the cover.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *

#show: ufac-theme.with(
  background: "plain",
  config-info(
    kind: "tcc",
    title: [Detecção de implantes dentários em radiografias panorâmicas],
    course: [Bacharelado em Engenharia Elétrica],
    author: [_Discente_ \ Ana Souza \ _Orientador_ \ Prof. Dr. Carlos Melo \ _Coorientadora_ \ Profa. Dra. Dora Lima],
    date: [Dezembro de 2026],
    contact: [`ana.souza@sou.ufac.br`],
  ),
)

#title-slide()

= Introdução

== O problema
-> Uma radiografia panorâmica mostra a arcada inteira
-> Encontrar os implantes à mão é demorado
-> Uma rede neural pode marcá-los com caixas orientadas

#cols(divider: true)[
  #tag[objetivo]

  Detectar e contar os implantes.
][
  #tag(color: colors.quaternary)[resultado]

  Um detector avaliado em 120 imagens, apresentado por #info("author").
]

= Método

== A rede
#table(columns: 3, table.header([Etapa], [Imagens], [mAP]),
  [Treino], [480], [--],
  [Validação], [120], [0,91],
  [Teste], [120], [0,89],
)

#callout("info")[O mAP mede a qualidade das caixas, de 0 a 1.]

= Conclusão

== Contribuições
- Um conjunto de 720 radiografias anotadas
- Um detector com mAP de 0,89 no teste
- O código, aberto

#ending-slide[Obrigada!][Perguntas?]
