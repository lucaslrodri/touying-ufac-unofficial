/// Synopsis: the aliases of a course in `config-info`: `subject`, `subject-code`, `unit`, `unit-title` and `semester`; the footer gets the semester after the name, and `#info` takes the aliases as keys.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  subject: [Control Systems],
  subject-code: [CCET123],
  unit: [Unit II],
  unit-title: [Frequency response],
  semester: [2026.2],
  author: [Prof. Author Name],
))

#title-slide()

== The aliases are the fields of Touying
- `#info("subject")`: #info("subject") (the `title`)
- `#info("subject-code")`: #info("subject-code") (the `short-title`)
- `#info("unit")`: #info("unit"); `#info("unit-title")`: #info("unit-title")
- `#info("semester")`: #info("semester") (the `date`)

A date from `semester` or `year` is short, so the footer gets it after the name of the course.
