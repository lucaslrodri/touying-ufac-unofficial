// Body of the `new/callout` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Callouts (`#callout`)
#callout("caution")[`x*y` with two vectors is an error: use `x.*y`.]
#callout("tip")[The up arrow recalls the last command.]
#callout("remark")[A *function* is a named block of code.]
#callout("note")[two versions of a program differ here.]

== The shorthands (`#caution`, `#tip`, `#remark`, `#note`)
#caution[`#caution[..]` is `#callout("caution")[..]`.]
#tip[`#tip[..]`, the tip.]
#cols[
  #remark(style: "badge")[`#remark(style: "badge")`: the options go through.]
][
  #note(title: [Aside.], icon: none)[No icon, another title.]
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
  The markers, the *bold* and the arrows take its colour:
  - a list item
  -> an arrow item
]
#callout("caution")[
  A code block keeps its own look:
  ```python
  y = x * 2
  ```
]
