#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#show: ufac-theme.with(lang: "en", config-info(
  subject: [Ocean Science],
  subject-code: [OCE110],
  unit-title: [Tides and waves],
  unit: [Unit III],
  author: [Prof. Author Name],
  semester: [2026.1],
  contact: [`author@example.com`],
))

== About this course
#emph-box(title: deck-info("subject-code"))[
  #deck-info("subject"), #deck-info("semester"),
  taught by #deck-info("author").
]
#deck-info(i => [*#i.unit*: #i.unit-title.])
Questions? #deck-info("contact")

#box(fill: colors.primary, inset: 0.4em,
  deck-info("logo", height: 2em, white: true))

#ending-slide(subtitle: [Questions?])[
  #deck-info("contact")
]
