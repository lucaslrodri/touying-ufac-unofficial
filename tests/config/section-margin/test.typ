/// Synopsis: `section-margin: false`: the content of every section slide touches the right edge instead of keeping the page margin (1.8em, the default); a section without content is unchanged.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", section-margin: false, test-info)

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
