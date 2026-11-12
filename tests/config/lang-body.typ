// Shared body of the `config/lang-*` tests: the same deck rendered with `lang: "pt-br"` (the default), `"en"` and `"es"`.
// Checked: `text.lang`/`region`, the smart quotes of the language, the titles of the callouts, the pill names, the
// section prefix, a reference, the word of the solution and the pills of the output and of the console.
#import "../common.typ": *
#title-slide()

= Section title
#placeholder()

== Language of the deck
#context [`text.lang` = #text.lang, `text.region` = #repr(text.region)]. Smart quotes of the language around "quoted text".

#callout("caution")[The title of the callouts]
#callout("tip", style: "badge")[in the language of the deck.]

== Question title <question-a>
Red pill with the localized name and the counter; cited as @question-a.

== Example title <example>
Green pill with the localized name.

#solution
The word of the solution.

== More words of the language
#remark[The title of a reminder.] #note[The title of a note.]
#cols[#example[In the singular.]][#examples[In the plural.]]
#examples(style: "badge")[The plural on the badge, without the period.]
#cols[
  ```text
  the output of a program
  ```
][
  ```console
  $ typst compile
  ```
]

#question-slide(title: [By function])[Same localized name from `#question-slide`.]
