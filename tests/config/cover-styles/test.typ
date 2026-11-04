/// Synopsis: the three styles of the cover (`"line"`, the default, `"stack"` and `"top"`) with three authors, a label over them and a date; then the positions changed one by one (`none`, content, a function of `self`, `#info`) and the white line switched on and off.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", test-info, config-info(
  author: ([First Author], [Second Author], [Third Author]),
  date: datetime(year: 2026, month: 3, day: 9),
))

#title-slide(author-label: [Instructors])

#title-slide(style: "stack", author-label: [Instructors])

#title-slide(style: "top", author-label: [Instructors])

#title-slide(footer-left: none, footer-right: info("date"), header-center: none, header-left: self => [#self.info.short-title])

#title-slide(style: "top", header-right: none, footer-center: none, footer-left: [Left], footer-right: [Right], footer-line: true)

#title-slide(style: "line", footer-line: false)[
  #tag(color: colors.quaternary)[with a body]
]
