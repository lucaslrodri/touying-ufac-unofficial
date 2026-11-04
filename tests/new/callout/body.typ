// Body of the `new/callout` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Callouts (`#callout`)
#callout("warning")[`x*y` with two vectors is an error: use `x.*y`.]
#callout("tip")[The up arrow recalls the last command.]
#callout("info")[A *function* is a named block of code.]
#callout("note")[two versions of a program differ here.]

== The shorthands (`#warning`, `#tip`, `#info`, `#note`)
#warning[`#warning[..]` is `#callout("warning")[..]`.]
#tip[`#tip[..]`, the tip.]
#cols[
  #info(style: "badge")[`#info(style: "badge")`: the options go through.]
][
  #note(title: [Aside.], icon: none)[No icon, another title.]
]

== The `"badge"` style and the options
#cols[
  #callout("warning", style: "badge")[The `emph-box` with the title on a badge.]
  #callout("tip", style: "badge", title: none)[`title: none`: only the icon.]
][
  #callout("info", title: [Definition.])[`title:` another title.]
  #callout("note", color: colors.secondary-dark, icon: "code", title: [Application.])[`color:` and `icon:`: the yellow box of the course.]
  #callout("tip", icon: none)[`icon: none`: no icon.]
]

== Inside a callout
#callout("info")[
  The markers, the *bold* and the arrows take its colour:
  - a list item
  -> an arrow item
]
#callout("warning")[
  A code block keeps its own look:
  ```python
  y = x * 2
  ```
]
