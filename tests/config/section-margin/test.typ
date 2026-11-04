/// Synopsis: `new-section-slide(margin: 0pt)`, given to Touying's `config-common(new-section-slide-fn:)`: the content of every section slide touches the right edge instead of keeping the page margin (1.8em, the default); a section without content is unchanged.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", test-info, config-common(new-section-slide-fn: new-section-slide.with(margin: 0pt)))

= Section with a placeholder
#placeholder(label: [section figure])

= Section with a real image
#image("../../logo.svg")

= Section with an icon (no background)
#iconify.provide-icons(octicons)
#text(fill: colors.primary-lighter, iconify.icon("octicon:gear-16", height: 7em, width: auto))

= Section without image

== Content slide
The content slides do not change.
