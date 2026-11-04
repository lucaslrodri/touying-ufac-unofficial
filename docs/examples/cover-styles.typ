#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  title: [Ocean Science],
  short-title: [OCE110],
  subtitle: [Tides and waves],
  short-subtitle: [Unit III],
  author: ([First Author], [Second Author]),
  date: datetime(year: 2026, month: 3, day: 9),
))
// --- example ---
#title-slide()   // style: "line"

#title-slide(style: "stack", author-label: [Instructors])

#title-slide(style: "top", author-label: [Instructors])

#title-slide(footer-right: none, header-right: deck-info("date"))
