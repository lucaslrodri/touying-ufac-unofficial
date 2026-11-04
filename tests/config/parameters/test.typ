/// Synopsis: theme parameters (`exercise-name`, `example-name`, `exercise-icon`, `example-icon`, `part-name`,
/// `footer-left`, `footer-right`) and `counter-prefix` in `config-info`.
#import "../../common.typ": *
#show: ufac-theme.with(
  exercise-name: [Task],
  example-name: [Ex.],
  exercise-icon: iconify.icon("octicon:tools-16", height: 1em),
  example-icon: none,
  part-name: [Chapter],
  footer-left: self => [Custom left footer],
  footer-right: self => [Right: #self.info.author],
  config-info(
    title: [Course],
    short-title: [COD123],
    subtitle: [Title],
    short-subtitle: [Subtitle],
    author: [Author],
    counter-prefix: [2.],
  ),
)

#title-slide()

= First section
#placeholder()

== Task from the book <exercise>
#iconify.provide-icons(octicons)
Pill with the tools icon (an Octicon of the iconify package), "Task 2.1" and the title; footer with the custom texts.

== Example <example>
Pill "Ex. 2.1" and the title, without icon (`example-icon: none`).

#exercise-slide(title: [Function])[Pill with the tools icon, "Task 2.2" and the title.]
