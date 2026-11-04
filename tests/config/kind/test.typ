/// Synopsis: `config-info(kind: "tcc")`: the tag of the work ("Trabalho de Conclusão de Curso", in the language of the deck) fills the `short-title`, which the footer shows before the title; a `year` (a number) is the date.
#import "../../common.typ": *
#show: ufac-theme.with(config-info(
  kind: "tcc",
  title: [Detecção de implantes em radiografias],
  author: [Nome do Autor],
  year: 2026,
))

#title-slide()

== The tag of the kind
`#info("short-title")`: #info("short-title"). The year (`year: 2026`) is a short date: the footer gets it too.
