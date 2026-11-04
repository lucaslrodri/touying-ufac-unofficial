/// Synopsis: `kind: "course"`: the cover in the style `"top"`, with the label "Instructors" over the authors (an array, in running text) and the date at the bottom; the institution does not appear on the cover.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  kind: "course",
  title: [Photography for Beginners],
  short-title: [Extension course],
  short-subtitle: [Module 1],
  subtitle: [Light, exposure and composition],
  author: ([First Author], [Second Author], [Third Author]),
  date: [March 2026],
  institution: (auto, [Arts Department]),
))

#title-slide()
