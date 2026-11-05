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

== A note in the subtitle
=== A subtitle with a note#footnote[The note of the subtitle, only on the first page.]
Text with a note#footnote[The note of the text.]: the note of the subtitle is 1 and the one of the text 2, each once; the pill repeated on the next page has no note.

#for i in range(1, 15) [- Item #i of the list]
