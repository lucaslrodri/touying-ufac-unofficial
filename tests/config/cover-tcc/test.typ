/// Synopsis: `kind: "tcc"` in Portuguese: the tag "Trabalho de Conclusão de Curso", the style `"top"` and an author written as free content, with the student, the advisor and the co-advisor under labels in emphasis; the footer of the slides gets the student only.
#import "../../common.typ": *
#show: ufac-theme.with(config-info(
  kind: "tcc",
  title: [Reconhecimento de cantos de aves em parques urbanos],
  course: [Bacharelado em Ciências Biológicas],
  author: [_Discente_ \ Nome do Discente \ _Orientador_ \ Prof. Dr. Nome do Orientador \ _Coorientadora_ \ Profa. Dra. Nome da Coorientadora],
  date: [Dezembro de 2026],
))

#title-slide()

== O rodapé
O rodapé tem só o discente, o primeiro grupo do autor.
