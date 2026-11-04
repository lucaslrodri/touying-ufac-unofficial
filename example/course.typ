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
    title: [MATLAB for Engineering],
    short-title: [Extension course],
    short-subtitle: [Module 1],
    subtitle: [Vectors, plots and scripts],
    author: ([First Instructor], [Second Instructor], [Third Instructor]),
    date: datetime(year: 2026, month: 3, day: 9),
    contact: [`course@example.com`],
  ),
)

#title-slide()

= First steps

== The Command Window
MATLAB answers every command:

```matlab
x = linspace(0, 2*pi, 100);
y = sin(x);
plot(x, y)
```

#callout("note")[A semicolon at the end of the line hides the result.]

== Element by element <example>
Compute $y = x^2$ for $x = 1, 2, 3$.

#solution
The operator `.^` raises each element:

#codly.new(
  ```matlab
  x = [1 2 3];
  y = x.^2
  ```,
  file: "squares.m",
)

```text
y =
     1     4     9
```

== A script <exercise>
Write a script that shows the multiplication table of `n`.

#callout("tip")[Use a `for` loop from 1 to 10.]

#ending-slide()
