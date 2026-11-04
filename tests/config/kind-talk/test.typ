/// Synopsis: `kind: "talk"`: the style `"line"`, as a lecture, with the deck's own `short-title` as the tag and the date in full in Portuguese; a talk has no units, so its exercises have no prefix ("Exercício 1").
#import "../../common.typ": *
#show: ufac-theme.with(config-info(
  kind: "talk",
  title: [Uma breve história do relógio],
  short-title: [Palestra],
  subtitle: [Do relógio de sol ao relógio atômico],
  author: [Prof. Dr. Seu Nome],
  date: datetime(year: 2026, month: 11, day: 3),
))

#title-slide()

== O relógio de pêndulo <exercise>
"Exercício 1": uma palestra não tem unidades, então o exercício não tem prefixo.
