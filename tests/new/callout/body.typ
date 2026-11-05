// Body of the `new/callout` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Callouts (`#callout`)
#callout("caution")[`x*y` with two vectors is an error: use `x.*y`.]
#callout("tip")[The up arrow recalls the last command.]
#callout("remark")[A *function* is a named block of code.]
#callout("note")[Two versions of a program differ here.]
#callout("example")[The constant signal $x[n] = 4$ has infinite energy.]

== The functions of each kind (`#caution`, `#tip`, `#remark`, `#note`, `#example`)
#caution[`#caution[..]` is `#callout("caution")[..]`.]
#tip[`#tip[..]`, the tip.]
#example(style: "badge")[`#example(style: "badge")`: green, with the beaker of the example slides.]
#cols[
  #remark(style: "badge")[`#remark(style: "badge")`: the options go through.]
][
  #note(title: [Aside.], icon: none)[No icon, another title.]
]

== The text on the same line and on the next
#cols[
  #remark[The same text.]
][
  #remark[
    The same text.
  ]
]

== An icon given as content
#cols[
  #tip(icon: text(weight: "bold")[Σ])[Content as the icon takes the color of the callout.]
][
  #tip(style: "badge", icon: text(weight: "bold")[Σ])[White on the badge.]
]

== The `"badge"` style and the options
#cols[
  #callout("caution", style: "badge")[The `emph-box` with the title on a badge.]
  #callout("tip", style: "badge", title: none)[`title: none`: only the icon.]
][
  #callout("remark", title: [Definition.])[`title:` another title.]
  #callout("note", color: colors.secondary-dark, icon: "code", title: [Application.])[`color:` and `icon:`: the yellow box of the course.]
  #callout("tip", icon: none)[`icon: none`: no icon.]
]

== Inside a callout
#callout("remark")[
  The markers, the *bold* and the arrows take its color:
  - a list item
  -> an arrow item
]
#callout("caution")[
  A code block keeps its own look:
  ```python
  y = x * 2
  ```
]

== Several examples (`#examples`)
#cols[
  #examples[
    - speech, in time;
    - air pressure, in altitude.
  ]
][
  #examples(style: "badge")[
    - speech, in time;
    - air pressure, in altitude.
  ]
]
#examples(title: [Two examples.])[`title:` replaces the title in the plural too.]

== Two lines in a centered layout
#grid(columns: (1fr, 1fr), gutter: 1em, align: horizon,
  [A `grid(align: horizon)`, the usual layout of a slide: the icon stays on the first line of the callout.],
  tip[A callout of two lines keeps its icon on the first one.],
)
#align(center, block(width: 60%, remark[Centered on the page, the text of the callout stays on the left.]))
