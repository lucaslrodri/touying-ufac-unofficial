#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#show: ufac-theme.with(
  lang: "en",
  config-info(
    subject: [Ocean Science],
    subject-code: [OCE110],
    unit-title: [Tides and waves],
    unit: [Unit III],
    author: [Prof. Author Name],
    semester: [2026.1],
    contact: [`author@example.com`],
  ),
)

== About this course
#emph-box(
  title: info("subject-code"),
)[
  #info("subject"), #info("semester"),
  taught by #info("author").
]
#info(i => [
  *#i.unit*: #i.unit-title.
])
Questions? #info("contact")

#box(fill: colors.primary,
  inset: 0.4em, info("logo",
    height: 2em, white: true))

#ending-slide(
  subtitle: [Questions?],
)[#info("contact")]
