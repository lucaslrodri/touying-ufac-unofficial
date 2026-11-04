/// Synopsis: `kind: "thesis"` in English: the tag "Doctoral Thesis" and the style `"top"`; then `title-slide(style: "line")`, an argument of the slide, wins over the style of the kind.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  kind: "thesis",
  title: [Learning from radiographs],
  author: [_Candidate_ \ First Author \ _Advisor_ \ Prof. Dr. Advisor Name],
  year: 2027,
))

#title-slide()

#title-slide(style: "line")
