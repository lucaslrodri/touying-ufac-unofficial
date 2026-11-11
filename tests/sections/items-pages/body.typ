// Body of the `sections/items-pages` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Overflow by itself <example>
=== A subtitle repeated on the next page
An example whose content is longer than one page goes on to the next one, in the same box, with the same number and the subtitle:

#for i in range(1, 15) [- Step #i of the procedure, with some text to fill the line.\ ]

#solution
The solution after the overflow.

== A long numbered list <question>
Answer every item:

#for i in range(1, 13) [+ Item #i: compute the value and explain the result.\ ]

#answer
The answer on the page after the overflow.

== Broken with `---` <example>
The statement on the first page.

---

#solution
The solution on the second page, opened without the dashed line.

== Broken with `#pagebreak()` <question>
The statement on the first page.

#pagebreak()

#answer
The answer on the second page, as with `---`.

#pagebreak()

And a third page of the same question.

== Next topic
A slide of another kind ends the question.

== The next one <question>
Question 1.3: the breaks did not count as questions.
