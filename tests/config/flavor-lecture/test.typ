/// Synopsis: `config-info(flavor: "lecture")`: the layout `"line"` of the cover (the author and the date on one line at the bottom), with the aliases of a course (`subject`, `subject-code`, `unit`, `unit-title`) and a date written in full; the exercises keep the prefix of the unit ("Exercise 1.1"); `author-label: auto` on the cover is the default, no label.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  flavor: "lecture",
  subject: [Ocean Science],
  subject-code: [OCE110],
  unit: [Lecture 3],
  unit-title: [Tides and waves],
  author: [Prof. Author Name],
  date: datetime(year: 2026, month: 3, day: 9),
))

#title-slide(author-label: auto)   // `auto` is `none`, the default: no label

== The footer
On the left, the subject code and the subject; on the right, the author. A full date does not go to the footer.

== Tide table <exercise>
"Exercise 1.1": a lecture keeps the prefix of the unit.
