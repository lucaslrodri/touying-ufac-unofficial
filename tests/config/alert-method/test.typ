/// Synopsis: a deck that gives an `alert` method of its own (`config-methods(alert: ..)`): it reaches `~~text~~` (red, here), on a slide and in a box, while `#alert`, the theme's own, keeps the color of the box around it (blue on the slide, green in the box).
#import "../../common.typ": *
#show: ufac-theme.with(
  lang: "en",
  test-info,
  config-methods(alert: (self: none, it) => text(fill: red, weight: "bold", it)),
)

== An alert method of the deck
On a slide: ~~the shorthand~~ takes the method of the deck, and #alert[the function] stays the theme's.

#emph-box(color: colors.quaternary)[In a box: ~~the shorthand~~ and #alert[the function].]
