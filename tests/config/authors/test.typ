/// Synopsis: an author written as free content: lines broken with `\` and labels in emphasis; the footer gets the names of the first group (those who present), `#deck-info("author")` the content as written.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", test-info, config-info(
  author: [_Students_ \ First Author \ Second Author \ _Advisor_ \ Prof. Dr. Advisor Name],
))

== Authors written as free content
#cols[
  `#deck-info("author")`:

  #deck-info("author")
][
  The footer gets the names of the first group in running text, without the labels and the advisor.
]

== An array of authors
#[
  #set text(size: .8em)
  `config-info(author: ([First], [Second], [Third]))` gives "First, Second and Third" in the footer and in `#deck-info("author")`; this deck shows the free-content form, the array is checked in `unit/api`.
]
