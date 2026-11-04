/// Synopsis: `config-info(kind: "coursework")`: the style `"stack"` of the cover (the students and the teacher in groups at the bottom left), with the aliases of a course and a `semester`, which the footer shows after the title.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  kind: "coursework",
  subject: [Introduction to Economics],
  subject-code: [ECO101],
  unit-title: [The price of a cup of coffee],
  author: [_Students_ \ First Student, Second Student \ _Teacher_ \ Prof. Teacher Name],
  semester: [2026.1],
))

#title-slide()

== The footer
On the left, the subject code, the subject and the semester; on the right, the students (the first group of the authors).
