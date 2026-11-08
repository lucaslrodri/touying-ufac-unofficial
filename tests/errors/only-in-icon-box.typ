// error: Unsupported mark
// An `#only` inside an `emph-box` with an icon and no title stops too: the icon goes on a badge, as a title does.
#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en")

== Only in a box with an icon
#emph-box(icon: "tip")[Visible. #only(2)[Shown later.]]
