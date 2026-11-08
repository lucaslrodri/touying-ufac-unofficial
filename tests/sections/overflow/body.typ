// Body of the `sections/overflow` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *
== Automatic overflow (no `---`)
=== Subtitle repeated on every overflow page
The content below is longer than one page and there is no `---`: Touying lets it flow onto the next pages and the
`===` pill is repeated at the top of each of them (repeating grid header).

#for i in range(1, 19) [- Item #i of the first subtitle]

=== Second subtitle, also overflowing
A new `===` starts a new block: the previous pill stops being repeated and this one takes over on its own overflow pages.

#for i in range(1, 15) [- Item #i of the second subtitle]

---

Continuation after `---` that overflows as well: the pill "Second subtitle, also overflowing" comes from `_current-subtitle()` and is repeated on both pages.

#for i in range(1, 17) [- Item #i of the continuation]

== Overflow with `#pause`
=== Subtitle kept on the subpages and on the overflow page
First step, before the pause.

#pause

Second step: with the pause the list below is revealed and the slide overflows; the pill is repeated on the overflow page of the second subpage.

#for i in range(1, 15) [- Item #i after the pause]

== A callout that does not fit
The style `"bar"` does not split: a callout that does not fit what is left of the page goes whole to the next one,
with the `==` header repeated. #lorem(40)

#tip[
  The whole callout on the next page:
  #for i in range(1, 8) [- Step #i of the tip]
]

== A callout with the badge goes on
With `style: "badge"` the callout continues on the next page, as an `emph-box`. #lorem(30)

#tip(style: "badge")[
  The callout split between two pages:
  #for i in range(1, 11) [- Step #i of the tip]
]

== A box with a title on the next page
#caution[Não confunda distância percorrida com deslocamento.]
#tip[Converta km/h para m/s dividindo por 3,6.]
#remark[A velocidade média depende só das posições inicial e final.]
#note[No MRU, a velocidade instantânea é igual à média.]
#cols[#example[Um carro a 72 km/h anda a 20 m/s.]][#examples[Unidades: m/s, km/h, nós.]]

#emph-box(color: colors.quaternary, icon: "tip", title: [Homework])[Read chapter 2 of the textbook, alone at the top of the next page.]

== Covered content that reaches the next page
Antes.

#pause

#tip[Dica com ~~alerta~~ e ~sublinhado~ e *negrito*.]

#emph-box(color: colors.tertiary, title: [Caixa])[Caixa com ~~alerta~~ e ~sublinhado~.]

#table(columns: 2, table.header([A], [~~B~~]), [~sub~], [~~alerta~~])

"Citação com ~~alerta~~ e ~sublinhado~."

Texto com #alert[alerta] e #underline[sublinhado] e #highlight[destaque] e `código`.
