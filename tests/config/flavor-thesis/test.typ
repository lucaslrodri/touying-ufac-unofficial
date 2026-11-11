/// Synopsis: `flavor: "thesis"` in English: the tag "Doctoral Thesis" and the layout `"top"`; then `title-slide(cover-layout: "line")`, an argument of the slide, wins over the layout of the flavor, and `counter-prefix: [2.]`, given by the deck, wins over the `none` of the flavor ("Question 2.1").
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  flavor: "thesis",
  title: [Learning from tree rings],
  author: [_Candidate_ \ First Author \ _Advisor_ \ Prof. Dr. Advisor Name],
  year: 2027,
  counter-prefix: [2.],
))

#title-slide()

#title-slide(cover-layout: "line")

== A question for the committee <question>
"Question 2.1": the prefix of the deck wins over the `none` of the flavor.
