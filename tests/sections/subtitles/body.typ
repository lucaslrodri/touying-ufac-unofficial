// Body of the `sections/subtitles` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *
== Normal title (`==`)
=== Subtitle (`===`): blue pill, repeated after `---`
Text below the subtitle.

==== Sub-subtitle (`====`): same pill, not repeated
Text below the sub-subtitle.

---

Continuation after `---`: the pill "Subtitle (`===`)" reappears at the top; the `====` does not.

#pagebreak()

Continuation after `#pagebreak()`: same behavior as `---`.

---

==== Continuation that starts with `====`
The `===` pill is repeated above as well (only another `===` replaces it).

---

=== New subtitle (replaces the previous one)
Text below the new subtitle.

== Slide without subtitle
Nothing is repeated here.

== Same title
=== The pill of this slide
Text below the pill.

== Same title
A new slide with the title of the slide before: the pill of that slide is not repeated, as on any new slide.
