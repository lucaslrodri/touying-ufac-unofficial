/// Synopsis: the PDF bookmarks of the questions and examples, in Portuguese with `counter-prefix: [2.]`. Tytanic sees the pages, not the outline of the PDF, so the last page shows Typst's own outline (`std.outline`) of the `==` headings, which takes the same numbering and title as the bookmarks: "Q2.1 — Tabela de marés" for the question (its `---` and `#pagebreak()` continuations add no line), "E2.1 — Velocidade das ondas" for the example (its `#pause` adds none), "Q2.2" alone for a question without a title, "Q2.3 — Forma de função" for `#question-slide`, "E2.2 — Farol" for an example with a label of its own, and the other slides by their title alone. A section (`=`) is a bookmark too, out of this outline, which lists only the `==`.
#import "../../common.typ": *
#show: ufac-theme.with(config-info(
  subject: [Oceanografia],
  subject-code: [OCE110],
  unit-title: [Marés e ondas],
  unit: [Unidade II],
  author: [Autor],
  counter-prefix: [2.],
))

= Marés

== Um slide comum
Só o título no bookmark.

== Tabela de marés <question>
A maré alta foi às 6h10. Quando vem a próxima?

---

Uma continuação com `---`: sem bookmark novo.

#pagebreak()

Outra, com `#pagebreak()`: também sem.

== Velocidade das ondas <example>
Uma onda longa é mais rápida em águas profundas?

#pause
#solution
Sim.

== <question>
Uma questão sem título: o bookmark é só "Q2.2".

#question-slide(title: [Forma de função])[A forma de função entra igual.]

== Farol <example-farol>
Um exemplo com rótulo próprio, citado como @example-farol.

== Os bookmarks
#std.outline(title: none, target: heading.where(level: 2))
