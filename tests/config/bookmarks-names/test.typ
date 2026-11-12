/// Synopsis: the initials of the bookmarks of the PDF come from `question-name` and `example-name`, as the names on the badges: "Task" gives "T1.1 — Tide table" and "Case" gives "C1.1 — Wave speed" (Typst's `std.outline`, with the text of the bookmarks).
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", question-name: [Task], example-name: [Case], test-info)

= Tides

== Tide table <question>
When is the next high tide?

== Wave speed <example>
The speed of a wave in deep water.

== The bookmarks of the PDF
#std.outline(title: none, target: heading.where(level: 2))
