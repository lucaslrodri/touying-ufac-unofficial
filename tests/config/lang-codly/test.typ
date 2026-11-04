/// Synopsis: a deck in Portuguese (the default language) with codly 2: the pill of the output of a program says "Saída", in the language of the deck, as without codly (`config/lang-default`).
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *
#import "@preview/codly:2.0.0" as codly
#show: ufac-theme.with(codly: codly, config-info(title: [Programação], short-title: [PROG], author: [Autor]))

== A saída de um programa
```python
print(sum([1, 2, 3]))
```
```text
6
```
