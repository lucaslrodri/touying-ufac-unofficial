/// Synopsis: `kind: "talk"`: the style `"line"`, as a lecture, with the deck's own `short-title` as the tag and the date in full in Portuguese.
#import "../../common.typ": *
#show: ufac-theme.with(config-info(
  kind: "talk",
  title: [Typst na sala de aula],
  short-title: [Seminário],
  subtitle: [Slides, apostilas e provas com o mesmo código],
  author: [Prof. Dr. Seu Nome],
  date: datetime(year: 2026, month: 11, day: 3),
))

#title-slide()
