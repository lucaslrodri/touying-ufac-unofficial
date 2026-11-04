/// Synopsis: `kind: "tcc"` in Portuguese: the tag "Trabalho de Conclusão de Curso", the style `"top"` and an author written as free content, with the student, the advisor and the co-advisor under labels in emphasis; the footer of the slides gets the student only.
#import "../../common.typ": *
#show: ufac-theme.with(config-info(
  kind: "tcc",
  title: [Detecção de implantes dentários em radiografias panorâmicas],
  course: [Bacharelado em Engenharia Elétrica],
  author: [_Discente_ \ Ana Souza \ _Orientador_ \ Prof. Dr. Carlos Melo \ _Coorientadora_ \ Profa. Dra. Dora Lima],
  date: [Dezembro de 2026],
))

#title-slide()

== O rodapé
O rodapé tem só a discente, o primeiro grupo do autor.
