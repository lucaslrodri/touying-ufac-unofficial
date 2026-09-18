// Body of the `sections/animations` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *
== Touying animations <example>
=== Pill, header and number must persist on the subpages
First step (always visible). Each step is a paragraph: `#pause` and `#uncover` in the *same* paragraph reorder the covered text (Touying).

#pause

Second step, after `#pause`.

#pause

#uncover(3)[Third step (`#uncover(3)`).]

#only(3)[And this only on the 3rd subpage (`#only(3)`).]

---

Continuation with `---` + `#pause`: the repeated pill and the example number do not change.

#pause

Second step of the continuation.
#speaker-note[Speaker note (hidden by default).]
