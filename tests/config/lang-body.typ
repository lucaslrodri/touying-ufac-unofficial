// Shared body of the `config/lang-*` tests: the same deck rendered with `lang: "pt-br"` (the default), `"en"` and `"es"`.
// Checked: `text.lang`/`region`, the smart quotes of the language, the titles of the callouts, the pill names, the
// section prefix, a reference, the word of the solution and the pill of the output.
#import "../common.typ": *
#title-slide()

= Section title
#placeholder()

== Language of the deck
#context [`text.lang` = #text.lang, `text.region` = #repr(text.region)]. Smart quotes of the language around "quoted text".

#callout("caution")[The title of the callouts]
#callout("tip", style: "badge")[in the language of the deck.]

== Exercise title <exercise-a>
Red pill with the localized name and the counter; cited as @exercise-a.

== Example title <example>
Green pill with the localized name.

#solution
The word of the solution.

== More words of the language
#remark[The title of a reminder.] #note[The title of a note.]
```text
the output of a program
```

#exercise-slide(title: [By function])[Same localized name from `#exercise-slide`.]
