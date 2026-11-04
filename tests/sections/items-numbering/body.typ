// Body of the `sections/items-numbering` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

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
The exercise ends with a slide of another kind; the next one is Exercise 1.2.

== Another one <exercise>
Exercise 1.2.
