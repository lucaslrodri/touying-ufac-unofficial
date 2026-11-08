// error: Unsupported mark
// A `#pause` in the header of a table stops. In the cells of the body it works.
#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en")

== Pause in the header of a table
#table(columns: 2, table.header([A #pause], [B]), [1], [2])
