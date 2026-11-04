/// Synopsis: `new-section-slide(margin: 0pt)`, given to Touying's `config-common(new-section-slide-fn:)`: the content of every section slide touches the right edge instead of keeping the page margin (1.8em, the default); a section without content is unchanged.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", test-info, config-common(new-section-slide-fn: new-section-slide.with(margin: 0pt)))

= Section with a placeholder
#placeholder(label: [section figure])

= Section with a real image
#image("../../logo.svg")

= Section with an icon (no background)
#provide-icons(octicons)
#icon("octicon:gear-16", size: 7em, color: colors.primary-lighter)

= Section without image

== Content slide
The content slides do not change.
