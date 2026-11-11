// Body of the `sections/questions` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Question from the book <question>
`== Title <question>`: red pill with a pencil, "Question 1.1" and, after a dash, the title (the names follow `lang`; the suite uses `lang: "en"`).

---

Continuation of the question: same number.

== Simple example <example>
`== Title <example>`: green pill with a beaker, "Example 1.1", counter independent from the question one.

#question-slide(title: [Ch. 4, ex. 6])[
  `#question-slide(title: [Ch. 4, ex. 6])[..]`: Question 1.2, with `---` inside.

  ---

  Page 2 of question 1.2.
]

#question-slide[
  `#question-slide[..]` without title: "Question 1.3", no dash.
]

#example-slide(title: [Custom color], color: colors.primary)[`#example-slide(color: colors.primary)`: Example 1.2, blue.]

#question-slide(title: [Custom color], color: colors.secondary)[`#question-slide(color: colors.secondary)`: Question 1.4, yellow.]

== Example with its own label <example-a>
`== Title <example-a>`: any `<example-…>` label counts as an example (Example 1.3) and can be cited with `@example-a`.

== Question with its own label <question-b>
`== Title <question-b>`: likewise for questions (Question 1.5); cited with `@question-b`.

---

Cross references: see @example-a and @question-b (name, prefix and number in the kind's color, linked to the slide). `<example>` without suffix cannot be cited, because it repeats.

== Count
Expected so far: 5 questions and 3 examples; the next question is 1.6 and the next example, 1.4.

== One more <question>
Question 1.6.

#question-slide(title: [Custom icon], icon: "octicon:tools-16")[#provide-icons(octicons)`#question-slide(icon: "octicon:tools-16")`: Question 1.7, an icon of a collection given with `provide-icons`.]

#example-slide(title: [Content as icon], icon: circle(radius: 0.55em, fill: white))[`#example-slide(icon: circle(..))`: Example 1.4, any content as the icon, centered on the capitals.]

#question-slide(title: [No icon], icon: none)[`#question-slide(icon: none)`: Question 1.8, without icon.]

#example-slide(title: [No icon], icon: none)[`#example-slide(icon: none)`: Example 1.5, without icon.]

== A long title that does not fit on the badge of the question, however wide the slide may be <question>
`== A long title <question>`: Question 1.9; the title shrinks to fit the width of the badge, on one line.
