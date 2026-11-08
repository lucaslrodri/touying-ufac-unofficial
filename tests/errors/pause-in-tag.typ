// error: Unsupported mark
// A `#pause` inside a `#tag`: the tag is a `context`, which Touying's marks do not go through.
#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en")

== Pause in a tag
Text #tag[visible #pause covered].
