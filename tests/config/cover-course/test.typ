/// Synopsis: `kind: "course"`: the cover in the style `"top"`, with the label "Instructors" over the authors (an array, in running text) and the date at the bottom; the institution does not appear on the cover.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  kind: "course",
  title: [MATLAB for Engineering],
  short-title: [Extension course],
  short-subtitle: [Module 1],
  subtitle: [Vectors, plots and scripts],
  author: ([First Author], [Second Author], [Third Author]),
  date: [March 2026],
  institution: (auto, [PEI]),
))

#title-slide()
