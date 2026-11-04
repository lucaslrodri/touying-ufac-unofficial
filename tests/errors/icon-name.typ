// error: the collection "octicon" given to provide-icons has no icon "nope-16"
// An icon that the collection given to provide-icons does not have.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *
#show: ufac-theme.with(lang: "en")

== Icons
#provide-icons(json("../octicon.json"))
#icon("octicon:nope-16")
