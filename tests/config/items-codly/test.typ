/// Synopsis: an example and a question with codly 2 (`ufac-theme(codly: codly)`): the code block, the output and a file name keep their look inside the box of the item, as without codly; with a note, a caution and a tip.
#import "@preview/touying:0.7.4": *
#import "../../../src/lib.typ": *
#import "@preview/codly:2.0.0" as codly
#import "../../common.typ": test-info
#show: ufac-theme.with(lang: "en", codly: codly, test-info)

== The mean of a list <example>
A function that returns the mean of a list of grades.

#solution
The sum divided by the length:

```python
def mean(grades):
    return sum(grades) / len(grades)
print(mean([7.5, 8.0, 9.5]))
```

```text
8.333333333333334
```

#callout("note")[`len` counts the items of the list.]

== Multiplication table <question>
Complete the program to show the table of `n`:

#codly.new(
  ```python
  n = int(input("n = "))
  for i in range(1, 11):
      print(...)
  ```,
  file: "table.py",
)

#callout("caution")[`range(1, 11)` stops before 11.]
#callout("tip")[An *f-string* builds the line: `f"{n} x {i}"`.]
