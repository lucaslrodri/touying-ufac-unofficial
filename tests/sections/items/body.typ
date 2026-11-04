// Body of the `sections/items` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== The state of water <example>
A script that reads the temperature of the water, in °C, and prints its state at sea level.

#solution
Every condition is an `if`, in the same order:

```python
T = float(input("Temperature (°C): "))
if T <= 0:
    state = "solid"
elif T < 100:
    state = "liquid"
else:
    state = "gas"
```

== Power in a resistor <exercise>
For $R = 10$ Ω and $I$ from 0 to 2 A, compute $P = R I^2$:

+ `I` in steps of 0.1 A
+ `P` element by element
  + with `.^`
+ The plot of $P$ against $I$

#answer
$P = 40$ W for $I = 2$ A.

== The mean of a list <example>
A function that returns the mean of a list of numbers.

#pause
#solution
The sum divided by the length:

```python
def mean(values):
    return sum(values) / len(values)
```

== The marker before the pause <example>
The same, with `#solution` right before `#pause`.

#solution
#pause
The opening appears with the solution, on the next subslide.

== Everything without a style of its own <exercise>
==== A subtitle in the colour of the item
Write a program that shows the *amount* of an investment month by month, as in the #link("https://www.ufac.br")[handout]:

+ Read the capital and the rate ==per month==
- Use a ~loop~ `for` from 1 to 12
-> Show the result with ~~two~~ decimals #icon("tip")

== What keeps its own style <example>
#cols[
  #callout("caution")[A callout keeps its colour.]
  #emph-box(title: [Definition])[An `emph-box` keeps its blue.]
][
  ```python
  print("a code block too")
  ```
  ```text
  a code block too
  ```
]

== The answer in a paragraph of its own <exercise>
A blank line after `#answer`: "Answer." stays alone on its line.

#answer

The next high tide comes about 12 h 25 min after the last one:

$ 6"h"10 + 12"h"25 = 18"h"35 $

== The solution in a paragraph of its own <example>
The same with `#pause` and `#solution`, and a blank line after the marker.

#pause
#solution

The solution starts in a new paragraph, below the word.

== A table <tabuada-exercise>
Not an exercise: a `<tabuada-exercise>` label is not an exercise label.

== Multiplication table <exercise>
Write a program that shows the multiplication table of `n`.

---

#answer
A `for` loop over `range(1, 11)`:

```python
for i in range(1, 11):
    print(n, "x", i, "=", n * i)
```

== Next topic
The exercise ends with a slide of another kind; the next one is Exercise 1.4.

== Another one <exercise>
Exercise 1.4.

== Another separator <exercise>
`#answer(sep: ":")` ends the word with a colon.

#answer(sep: ":")
The next high tide is at 18:35.

== A separator with a line break <example>
`#solution(sep: [:\ ])` ends the word with a colon and a line break.

#solution(sep: [:\ ])
The solution starts on the next line, without an indent.
