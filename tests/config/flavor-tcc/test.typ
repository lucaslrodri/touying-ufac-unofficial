/// Synopsis: `config-info(flavor: "tcc")` in a Spanish deck: the tag of the work in the language of the deck ("Trabajo de Fin de Grado"; the Portuguese one is in `config/cover-tcc`) fills the `short-title`, which the footer shows before the title; a `year` (a number) is the date.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "es", config-info(
  flavor: "tcc",
  title: [Cantos de aves en parques urbanos],
  author: [Nombre del Autor],
  year: 2026,
))

#title-slide()

== The tag of the flavor
`#info("short-title")`: #info("short-title"). The year (`year: 2026`) is a short date: the footer gets it too.
