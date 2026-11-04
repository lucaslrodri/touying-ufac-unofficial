/// Synopsis: the aliases of a course in `config-info`: `subject`, `subject-code`, `unit`, `unit-title` and `semester`; the footer gets the semester after the name, and `#deck-info` takes the aliases as keys.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  subject: [Introductory Astronomy],
  subject-code: [AST101],
  unit: [Unit II],
  unit-title: [The solar system],
  semester: [2026.2],
  author: [Prof. Author Name],
))

#title-slide()

== The aliases are the fields of Touying
- `#deck-info("subject")`: #deck-info("subject") (the `title`)
- `#deck-info("subject-code")`: #deck-info("subject-code") (the `short-title`)
- `#deck-info("unit")`: #deck-info("unit"); `#deck-info("unit-title")`: #deck-info("unit-title")
- `#deck-info("semester")`: #deck-info("semester") (the `date`)

A date from `semester` or `year` is short, so the footer gets it after the name of the course.
