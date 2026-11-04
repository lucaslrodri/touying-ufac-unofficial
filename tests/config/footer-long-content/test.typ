/// Synopsis: a long footer given as formatted content (`footer-left` with bold, emphasis and a link): it is cut with "…" between its words, each piece keeping its style, and not reduced to a lone "…".
#import "../../common.typ": *
#show: ufac-theme.with(
  lang: "en",
  test-info,
  footer-left: [*Ocean Science* • _a long course on the tides, the waves and the currents of the western Atlantic_ • #link("https://example.com")[example.com]],
)

== A formatted footer
The left text of the footer is bold, then emphasized, then a link; it is cut at the end of a word, in its style.
