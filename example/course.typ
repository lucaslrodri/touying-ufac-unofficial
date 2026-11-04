// Example deck of the touying-ufac-unofficial theme: an extension course (`kind: "course"`) with several instructors,
// the gradient background and code blocks through codly 2, which the deck imports and passes to the theme.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *
#import "@preview/codly:2.0.0" as codly

#show: ufac-theme.with(
  lang: "en",
  background: "gradient",
  codly: codly,
  config-info(
    kind: "course",
    title: [Programming for Everyone],
    short-title: [Extension course],
    short-subtitle: [Module 1],
    subtitle: [Lists, loops and functions],
    author: ([First Instructor], [Second Instructor], [Third Instructor]),
    date: datetime(year: 2026, month: 3, day: 9),
    contact: [`course@example.com`],
  ),
)

#title-slide()

= First steps

== The interpreter
Python answers every line:

```python
fruits = ["apple", "banana", "cherry"]
for fruit in fruits:
    print(fruit.upper())
```

#note[A `for` loop visits the items in order.]

== A shopping list <example>
Add up the prices of a shopping list.

#solution
The built-in `sum` adds the items of a list:

#codly.new(
  ```python
  prices = [2.50, 1.20, 3.80]
  total = sum(prices)
  print(total)
  ```,
  file: "shopping.py",
)

```text
7.5
```

== A function <exercise>
Write a function that returns the largest item of a list.

#tip[Python has `max`, but try writing it with a loop first.]

#ending-slide()
