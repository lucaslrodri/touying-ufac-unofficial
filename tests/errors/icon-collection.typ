// error: no collection "mdi" was given; add `#provide-icons(json("mdi.json"))`
// An icon of a collection that the deck did not give says how to give it.
#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en")

== Icons
#icon("mdi:home")
