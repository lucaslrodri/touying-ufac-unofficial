/// Synopsis: `section-margin: true`: the content of every section slide keeps the page margin (1.8em) instead of touching the right edge; a section without content is unchanged.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", section-margin: true, info)

= Section with a placeholder
#placeholder(label: [section figure])

= Section with a real image
#image("../../logo.svg")

= Section with an icon (no background)
#icon("gear", size: 7em, color: colors.primary-lighter)

= Section without image

== Content slide
The content slides do not change.
