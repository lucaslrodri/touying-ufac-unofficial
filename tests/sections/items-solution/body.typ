// Body of the `sections/items-solution` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
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
The line and the word appear with the solution, on the next subslide.

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

== Another separator <exercise>
`#answer(sep: ":")` ends the word with a colon.

#answer(sep: ":")
The next high tide is at 18:35.

== A separator with a line break <example>
`#solution(sep: [:\ ])` ends the word with a colon and a line break.

#solution(sep: [:\ ])
The solution starts on the next line, without an indent.

== A marker outside an exercise or example
A bare `#solution` on a slide of another kind opens nothing and shows nothing:

#solution
The text goes on, without a line nor a word.

== The separator after a pause <exercise>
`#pause` and then `#answer(sep: ":")`: the line and "Answer:" with the text appear on the next subslide.

#pause
#answer(sep: ":")
The next high tide is at 18:35.

== The separator in a paragraph of its own <example>
`#solution(sep: ":")`, a `#pause` after it and a blank line: "Solution:" stays alone on its line, and the solution comes on the next subslide.

#solution(sep: ":")
#pause

The solution starts in a new paragraph, below the word.
