// Shared body of the `config/lang-*` tests: the same deck rendered with `lang: "pt-br"` (the default), `"en"` and `"es"`.
// Checked: `text.lang`/`region`, the smart quotes of the language, the pill names, the section prefix and a reference.
#import "../common.typ": *
#title-slide()

= Section title
#placeholder()

== Language of the deck
#context [`text.lang` = #text.lang, `text.region` = #repr(text.region)]. Smart quotes of the language around "quoted text".

== Exercise title <exercise-a>
Red pill with the localized name and the counter; cited as @exercise-a.

== Example title <example>
Green pill with the localized name.

#exercise-slide(title: [By function])[Same localized name from `#exercise-slide`.]
