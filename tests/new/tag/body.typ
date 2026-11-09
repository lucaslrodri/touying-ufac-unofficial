// Body of the `new/tag` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Tags (`#tag`)
#[
#set text(size: .8em)
#demo[
```typst
-> `plot3` #tag[new] in a list
-> #tag(color: colors.tertiary)[exam] on Friday
-> #tag(color: colors.quaternary-light)[optional]
-> #tag(color: colors.primary)[part 2] and
  #tag(color: colors.neutral-lightest)[draft]
-> a bigger one: #tag(size: 1em)[unit II]
```
]
]
In a line of text the tag does not change the height of the line: #tag[a tag] here, and the next line keeps its place.

== In a title #tag[new] and in a table
#table(columns: 3, table.header([Topic], [Status], [Notes]),
  [Functions], tag(color: colors.quaternary)[done], [chapter 3],
  [Plots], tag[new], [`plot3`],
  [Files], tag(color: colors.tertiary)[late], [lab 4],
)

== Alerts and highlights inside a tag
A dark tag: #tag(color: colors.primary)[blue with ~~alert~~ and ==highlight==], and a light one:
#tag[yellow with ~~alert~~ and ==highlight==]. Inside, they follow a pill: yellow on the dark tag, blue on the light.
A gray tag has white text, but the yellow does not read on it: #tag(color: colors.neutral)[gray with ~~alert~~ and ==highlight==].
