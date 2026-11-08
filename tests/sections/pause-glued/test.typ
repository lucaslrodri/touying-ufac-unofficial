/// Synopsis: a `#pause` alone on its line, glued to the next line (no blank line), before a list item, a numbered item, a list after a paragraph, a `>` box, an `emph-box` with a title, a list right after the title and a table, and `#uncover(2)[..]` with its body on the next lines (a list, a box with a title): the first covered line or block is veiled whole, top included, and the visible lines are left alone, their descenders (gjpqy) included; a covered numbered item keeps its number (2., not 1. under the veil), and a numbered list that no `#pause` splits keeps `#set enum(start: ..)`. A `#pause` with blank lines around it, between two items of a list, works as when glued (the list is the same on every step).
#import "../../common.typ": *
#show: setup
#include "body.typ"
