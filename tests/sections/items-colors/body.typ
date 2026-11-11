// Body of the `sections/items-colors` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Everything without a style of its own <question>
==== A subtitle in the color of the item
Write a program that shows the *amount* of an investment month by month, as in the #link("https://www.ufac.br")[handout]:

+ Read the capital and the rate ==per month==
- Use a ~loop~ `for` from 1 to 12
-> Show the result with ~~two~~ decimals #icon("tip")

== What keeps its own style <example>
#cols[
  #callout("caution")[A callout keeps its color.]
  #emph-box(title: [Definition])[An `emph-box` keeps its blue.]
][
  ```python
  print("a code block too")
  ```
  ```text
  a code block too
  ```
]
