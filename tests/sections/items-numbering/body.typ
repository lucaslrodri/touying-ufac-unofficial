// Body of the `sections/items-numbering` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== A table <tabuada-question>
Not a question: a `<tabuada-question>` label is not a question label.

== Multiplication table <question>
Write a program that shows the multiplication table of `n`.

---

#answer
A `for` loop over `range(1, 11)`:

```python
for i in range(1, 11):
    print(n, "x", i, "=", n * i)
```

== Next topic
The question ends with a slide of another kind; the next one is Question 1.2.

== Another one <question>
Question 1.2.
