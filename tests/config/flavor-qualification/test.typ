/// Synopsis: a qualifying exam in Portuguese: `flavor: "dissertation"` with the deck's own `short-title: [Exame de Qualificação]`, which wins over the tag of the flavor ("Dissertação de Mestrado") on the cover and in the footer; the layout `"top"` and the numbers without a prefix stay those of the flavor.
#import "../../common.typ": *
#show: ufac-theme.with(config-info(
  flavor: "dissertation",
  short-title: [Exame de Qualificação],
  title: [Mapas antigos da Amazônia],
  course: [Programa de Pós-Graduação em História],
  author: [_Mestrando_ \ Nome do Mestrando \ _Orientador_ \ Prof. Dr. Nome do Orientador],
  date: [Março de 2027],
))

#title-slide()

== Uma questão para a banca <question>
"Questão 1": sem o prefixo da unidade, como no flavor.
