// error: Unsupported mark
// A `#meanwhile` inside an `eq-box`: the box is a `context`, which Touying's marks do not go through.
#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en")

== Meanwhile in an equation box
$ #eq-box[$x = 1 #meanwhile + 2$] $
