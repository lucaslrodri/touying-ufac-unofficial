// Body of the `new/eq-box` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Equation box: `#eq-box`
#[
#set text(size: .85em)
The box goes *inside* the equation, which keeps its centering and spacing; the body is math, in display style even
when written as `$…$` without spaces.
#demo[
```typst
$ #eq-box[$f(x) = a x^2 + b x + c$] $
$ #eq-box(color: colors.quaternary)[$ integral_0^1 f(x) dif x = a/3 $] $
```
]
A part of an equation, on the same baseline as the rest:
#demo[
```typst
$ y = #eq-box(color: colors.tertiary)[$phi(v)$] + b $
```
]
]

== Equation box: padding
#[
#set text(size: .85em)
A box around the whole equation is padded generously, a box around a part of it tightly; either way the frame holds
tall fractions and the limits of sums:
#demo[
```typst
$ #eq-box[$E = 1/(2N) sum_(i=1)^N (y_i - hat(y)_i)^2$] $
$ E = 1/(2N) #eq-box[$sum_(i=1)^N (y_i - hat(y)_i)^2$] $
```
]
]

== Equation box: in a line of text
#[
#set text(size: .85em)
In a line of text (or in an inline equation) the body is in text style and the line spacing does not change:
#demo[
```typst
The output #eq-box[$y = phi(v)$] and the mean
#eq-box[$1/N sum_i y_i$], as in $y = #eq-box[$phi(v)$] + b$,
keep the baseline of $x$ #eq-box[$x$] $x$.
```
]
Inside an `emph-box` the default color is the box color:
#demo[
```typst
#emph-box(color: colors.quaternary)[
  Key result: $ #eq-box[$x = 2$] $
]
```
]
]

== Equation box: the `>` shorthand
#[
#set text(size: .85em)
A `>` in front of a block equation, on the same line or alone on the line before it; always primary.
#demo[
```typst
> $ f'(x) = 2 a x + b $

>
$ integral_0^1 f(x) dif x = a/3 + b/2 + c $
```
]
With numbering the number stays outside the box, and both forms share one counter and can be cited:
#demo[
```typst
#set math.equation(numbering: "(1)")
> $ y = f(x) $ <eq-short>

$ #eq-box[$z = g(y)$] $ <eq-fn>
See @eq-short and @eq-fn.
```
]
]
