#import "../template.typ": *
#show: chapter

= Lists and terms <lists>

== Arrow lists

Consecutive lines starting with `->` become one list with a blue arrow. The list has to start the paragraph: a blank
line comes before the first `->`. An arrow in the middle of a line and the math arrow are left alone.

```example
-> consequence
-> another consequence

Here a -> b stays text, and $a -> b$ is math.
```

#reference("components", "arrows")

== Bullet lists

Three levels of yellow markers: a filled square, a rotated hollow square and a small circle.

```example
- first level
  - second level
    - third level
- first level again
```

== Numbered lists

Numbers are always blue and bold: `1.`, `a)`, `i.` by level. `#set enum(numbering: "a)")` starts at `a)` instead and
keeps the colors. Typst only knows `+` and `1.` as enum markers in markup, so `a)` at the start of a line is text.

```example
+ first
  + nested
    + deeper
+ second

#[
  #set enum(numbering: "a)")
  + starts at a)
    + then i.
]
```

== Terms

```example
/ Epoch: one pass over the training set.
/ Batch: the samples of one update.
```
