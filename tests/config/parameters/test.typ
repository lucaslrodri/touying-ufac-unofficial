/// Synopsis: theme parameters (`question-name`, `example-name`, `question-icon`, `example-icon`, `part-name`,
/// `footer-left`, `footer-right`) and `counter-prefix` in `config-info`; the callouts `#example` and `#examples` keep
/// their title and beaker, which only `title:` and `icon:` change.
#import "../../common.typ": *
#show: ufac-theme.with(
  question-name: [Task],
  example-name: [Ex.],
  question-icon: "octicon:tools-16",
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

== Task from the book <question>
#provide-icons(octicons)
Pill with the tools icon (an Octicon given with `provide-icons`), "Task 2.1" and the title; footer with the custom texts.

== Example <example>
Pill "Ex. 2.1" and the title, without icon (`example-icon: none`).

#question-slide(title: [Function])[Pill with the tools icon, "Task 2.2" and the title.]

== The example callouts
`example-name` and `example-icon` change only the example slides:
#example[The title of the language and the beaker.]
#examples(style: "badge")[The same in the plural, on the badge.]
#example(title: [Case.], icon: none)[`title:` and `icon:` change the callout.]
