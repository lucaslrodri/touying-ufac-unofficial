/// Synopsis: theme parameters (`exercise-name`, `example-name`, `part-name`, `footer-left`, `footer-right`) and `counter-prefix` in `config-info`.
#import "../../common.typ": *
#show: ufac-theme.with(
  exercise-name: [Task],
  example-name: [Ex.],
  part-name: [Chapter],
  footer-left: self => [Custom left footer],
  footer-right: self => [Right: #self.info.author],
  config-info(
    title: [Title], subtitle: [Subtitle], author: [Author], subject: [Course], subject-code: [COD123],
    counter-prefix: [2.],
  ),
)

#title-slide()

= First section
#placeholder()

== Task from the book <exercise>
Pill "Task 2.1 (Task from the book)"; footer with the custom texts.

== Example <example>
Pill "Ex. 2.1 (Example)".

#exercise-slide(title: [Function])[Pill "Task 2.2 (Function)".]
