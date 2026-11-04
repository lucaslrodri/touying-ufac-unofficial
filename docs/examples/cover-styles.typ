#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#show: ufac-theme.with(
  lang: "en",
  config-info(
    subject: [Ocean Science],
    subject-code: [OCE110],
    unit-title: [Tides and waves],
    unit: [Unit III],
    author: ([First Author],
      [Second Author]),
    date: datetime(
      year: 2026, month: 3, day: 9),
  ),
)

#title-slide()   // style: "line"

#title-slide(style: "stack",
  author-label: [Instructors])

#title-slide(style: "top",
  author-label: [Instructors])

#title-slide(footer-right: none,
  header-right: info("date"))
