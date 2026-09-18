// Body of the `sections/exercises` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Exercise from the book <exercise>
`== Title <exercise>`: red pill "Exercise 1.1 (Exercise from the book)" (the names follow `lang`; the suite uses `lang: "en"`).

---

Continuation of the exercise: same number.

== Simple example <example>
`== Title <example>`: green pill "Example 1.1", counter independent from the exercise one.

#exercise-slide(title: [Ch. 4, ex. 6])[
  `#exercise-slide(title: [Ch. 4, ex. 6])[..]`: Exercise 1.2, with `---` inside.

  ---

  Page 2 of exercise 1.2.
]

#exercise-slide[
  `#exercise-slide[..]` without title: "Exercise 1.3", no parentheses.
]

#example-slide(title: [Custom color], color: colors.primary)[`#example-slide(color: colors.primary)`: Example 1.2, blue.]

#exercise-slide(title: [Custom color], color: colors.secondary)[`#exercise-slide(color: colors.secondary)`: Exercise 1.4, yellow.]

== Example with its own label <example-a>
`== Title <example-a>`: any `<example-…>` label counts as an example (Example 1.3) and can be cited with `@example-a`.

== Exercise with its own label <exercise-b>
`== Title <exercise-b>`: likewise for exercises (Exercise 1.5); cited with `@exercise-b`.

---

Cross references: see @example-a and @exercise-b (name, prefix and number in the kind's color, linked to the slide). `<example>` without suffix cannot be cited, because it repeats.

== Count
Expected so far: 5 exercises and 3 examples; the next exercise is 1.6 and the next example, 1.4.

== One more <exercise>
Exercise 1.6.
