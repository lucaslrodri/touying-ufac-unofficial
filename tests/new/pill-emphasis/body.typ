// Body of the `new/pill-emphasis` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *
== `#alert` inside a badge, a tag and a table header
#emph-box(color: colors.quaternary, title: [A #alert[badge] title])[A body with #alert[alert].]

#tip(style: "badge")[A badge callout with #alert[alert].]

A tag with an alert: #tag[#alert[alert] tag].

#table(columns: 2, table.header([#alert[Alert] header], [B]), [1], [2])

== Alert and `#primary` on dark pills
// yellow where it reads (a contrast of 3:1 or more with the pill), dark blue under it; the names are the colors of the boxes
#grid(columns: 3, gutter: 0.6em,
  ..("quaternary", "neutral", "secondary-dark", "primary-light", "tertiary", "quaternary-dark", "neutral-dark").map(n =>
    emph-box(color: colors.at(n), title: [~~alert~~ and #primary[primary]])[#raw(n)]))

#table(columns: 2, table.header([Cell], [Body]), [A dark cell:], table.cell(fill: colors.quaternary)[~~alert~~ and #primary[primary]])
