/// Synopsis: `logos`: the UFAC logo, a partner's logo (content) and one drawn in the colour of the footer (a function), separated by dots, in the footer and, in white, on the cover.
#import "../../common.typ": *
#show: ufac-theme.with(
  lang: "en",
  logos: (auto, image("../../logo.svg", height: 0.64em), color => text(size: 0.5em, weight: "bold", fill: color)[LAB]),
  info,
)

#title-slide()

= First section
#placeholder()

== The footer
The UFAC logo, the yellow square and "LAB" in blue, with a dot between each two; on the cover, the same in white.
