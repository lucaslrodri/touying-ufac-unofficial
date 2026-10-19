// Body of the `sections/empty-slides` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *
== The end <empty-slide>
`<empty-slide>`: no header; the title large and centered, the content below it.

== Primary <empty-slide-primary>
`<empty-slide-primary>`: white text and footer; *bold*, `code` and #icon("rocket") as in a pill.

== Secondary <empty-slide-secondary>
`<empty-slide-secondary>`: a light color keeps the dark text and the blue title and footer.

== Tertiary <empty-slide-tertiary>
`<empty-slide-tertiary>`

== Quaternary <empty-slide-quaternary>
`<empty-slide-quaternary>`

== Neutral <empty-slide-neutral>
`<empty-slide-neutral>`

== A tone <empty-slide-primary-dark>
Any key of `colors`, such as `primary-dark`. #pause The veil of `#pause` takes the page color.

== Back to normal
The next `==` without the label is a normal slide again.

#empty-slide(color: colors.quaternary, title: [Function form])[`#empty-slide(color:, title:)`: the same slide.]

#empty-slide(color: colors.tertiary)[`#empty-slide(color:)` without `title`: the body stays where it is.]
