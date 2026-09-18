// Body of the `sections/subtitles` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *
== Normal title (`==`)
=== Subtitle (`===`): blue pill, repeated after `---`
Text below the subtitle. The section slide (`= Part`) opens this block with "Part N: …" at 2em, with `\` in the title and the image flush with the right edge.

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
