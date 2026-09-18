// Body of the `elements/equations` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Equations
#[
#set text(size: .9em)
Inline: $f(x) = a x^2 + b x + c$, with $x_(1,2) = (-b plus.minus sqrt(b^2 - 4 a c)) / (2a)$; block equation with `above/below: 0.55em`:
$ integral_0^1 f(x) dif x = a/3 + b/2 + c, quad sum_(n=1)^N n = (N (N + 1)) / 2 $
#cols(divider: true)[
  $ |x| = cases(x "if" x >= 0, -x "otherwise") $
][
  $ vec(y_1, y_2) = mat(a_11, a_12; a_21, a_22) vec(x_1, x_2) + vec(c_1, c_2) $
]
#[
#set math.equation(numbering: "(1)")
$ y = f(x) $ <eq-y>
]
Numbering with `#set math.equation(numbering: "(1)")` inside `#[ ]` and the reference `@eq-y`: @eq-y. The equation box (`#eq-box`) is under New elements.
]
