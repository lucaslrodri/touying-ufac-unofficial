// Body of the `sections/pause-overflow` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Covered content that reaches the next page
Before.

#pause

#tip[A tip with ~~alert~~ and ~underline~ and *bold*.]

#emph-box(color: colors.tertiary, title: [Box])[A box with ~~alert~~ and ~underline~.]

#table(columns: 2, table.header([A], [~~B~~]), [~sub~], [~~alert~~])

"A quotation with ~~alert~~ and ~underline~."

Text with #alert[alert] and #underline[underline] and #highlight[highlight] and `code`.

== Arrow lines with a pause that reach the next page
-> Arrow line 1, visible
-> Arrow line 2, visible

#pause

-> Arrow line 3, covered
-> Arrow line 4, covered
-> Arrow line 5, covered
-> Arrow line 6, covered
-> Arrow line 7, covered
-> Arrow line 8, covered
-> Arrow line 9, covered
-> Arrow line 10, covered
-> Arrow line 11, covered
-> Arrow line 12, covered
-> Arrow line 13, covered
-> Arrow line 14, covered
-> Arrow line 15, covered
-> Arrow line 16, covered
-> Arrow line 17, covered
-> Arrow line 18, covered
-> Arrow line 19, covered
-> Arrow line 20, covered

== A covered code block that reaches the next page
Before the code.

#pause

```python
print(1)
print(2)
print(3)
print(4)
print(5)
print(6)
print(7)
print(8)
print(9)
print(10)
print(11)
print(12)
print(13)
print(14)
print(15)
print(16)
print(17)
print(18)
print(19)
print(20)
print(21)
print(22)
print(23)
print(24)
print(25)
print(26)
print(27)
print(28)
print(29)
print(30)
```

== A covered box that reaches the next page
Before the box.

#pause

#emph-box[
  #for i in range(1, 16) [Line #i of a long box.

  ]
]
