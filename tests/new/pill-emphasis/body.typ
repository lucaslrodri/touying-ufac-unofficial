// Body of the `new/pill-emphasis` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *
== Alert and `#primary` in a badge, a tag and a table header
#emph-box(color: colors.quaternary, title: [A #alert[badge] and #primary[primary] title])[A body with #alert[alert].]

#tip(style: "badge", title: [A ~~badge~~ #primary[callout]])[The alert of the body takes the color of the box: #alert[alert].]

Tags with white text: #tag(color: colors.tertiary)[red ~~alert~~ #primary[primary]] (yellow) and
#tag(color: colors.quaternary)[green ~~alert~~ #primary[primary]] (dark blue).

#table(columns: 2, table.header([#alert[Alert] and #primary[primary]], [B]), [1], [2])

== Alert and `#primary` on dark pills
// yellow where it reads (a contrast of 3:1 or more with the pill), dark blue under it; the names are the colors of the boxes
#grid(columns: 3, gutter: 0.6em,
  ..("quaternary", "neutral", "secondary-dark", "primary-light", "tertiary", "quaternary-dark", "neutral-dark").map(n =>
    emph-box(color: colors.at(n), title: [~~alert~~ and #primary[primary]])[#raw(n)]))

#table(columns: 2, table.header([Cell], [Body]), [A dark cell:], table.cell(fill: colors.quaternary)[~~alert~~ and #primary[primary]])

== `#secondary`, `#tertiary` and `#quaternary` on dark pills
// each keeps its color where it reads on the pill (3:1 or more) and otherwise turns yellow, or dark blue where the yellow does not read either
#grid(columns: 3, gutter: 0.6em,
  ..("primary", "tertiary", "quaternary", "secondary-dark", "neutral-dark").map(n =>
    emph-box(color: colors.at(n), title: [#secondary[sec] #tertiary[ter] #quaternary[qua]])[#raw(n):
      #(("primary": "yellow, yellow, yellow", "tertiary": "yellow, yellow, yellow", "quaternary": "dark blue, dark blue, dark blue",
        "secondary-dark": "dark blue, dark blue, dark blue", "neutral-dark": "yellow, yellow, yellow").at(n))]))

#question-slide(title: [A #tertiary[red] word in a red badge], color: colors.tertiary)[
  === A #tertiary[red] word in a red pill
  Tags: #tag(color: colors.tertiary)[#tertiary[red] in red] and #tag(color: colors.quaternary)[#quaternary[green] in green].
]

== Where the color of the emphasis reads
// the color of the word stays on a pill where it has a contrast of 3:1 or more with it; the expected colors in each box
#grid(columns: 3, gutter: 0.6em,
  ..(("neutral-darkest", "yellow, red, green"), ("primary-dark", "yellow, yellow, green"), ("tertiary-dark", "yellow, yellow, green"),
    ("quaternary-darker", "yellow, yellow, green")).map(((n, e)) =>
    emph-box(color: colors.at(n), title: [#secondary[sec] #tertiary[ter] #quaternary[qua]])[#raw(n): #e]))

#table(columns: 2, table.header([Cell], [Body]), [A `primary-dark` cell:], table.cell(fill: colors.primary-dark)[#quaternary[green] stays])
