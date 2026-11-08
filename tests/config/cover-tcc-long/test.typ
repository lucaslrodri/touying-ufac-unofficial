/// Synopsis: the cover of a thesis defense (`flavor: "tcc"`, the layout `"top"`) with a long title and three groups of authors (the student, the advisor and the co-advisor): the titles are scaled down to the room between the authors and the date, which no longer overlap them.
#import "../../common.typ": *
#let info = config-info(
  flavor: "tcc",
  title: [A low-cost weather station for the public schools of the western Amazon, built with open hardware, free sensors and the help of the students of three towns],
  course: [Bachelor's in Physics],
  author: [_Student_ \ Student Name \ _Advisor_ \ Prof. Dr. Advisor Name \ _Co-advisor_ \ Prof. Dr. Co-advisor Name],
  year: 2026,
)
#show: ufac-theme.with(lang: "en", info)

#title-slide()
