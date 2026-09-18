// Body of the `elements/terms` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *
== Terms (`/ Term: description`)
/ Term: short definition; the term is black bold, followed by `: ` and a line break.
/ Long term: description with *bold*, $x^2$ and `code`, which can be long and wrap over more than one line without losing the left alignment.
/ Constant ($alpha$): term with math.
#v(.5em)
Terms are `terms(tight: false)`; the `show terms.item` rule builds each line.
