// Example deck of the touying-ufac-unofficial theme: a lecture of a course, with the aliases of a course (`subject`,
// `subject-code`, `unit`, `unit-title`, `semester`), exercises and examples with their solutions, callouts and the
// closing slide.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *

#show: ufac-theme.with(
  lang: "en",
  config-info(
    kind: "lecture",
    subject: [Control Systems],
    subject-code: [CODE123],
    unit: [Unit II],
    unit-title: [Frequency response],
    semester: [2026.2],
    author: [Prof. Dr. Your Name],
    contact: [`your.name@example.com`],
  ),
)

#title-slide()

== Contents
#outline()

= Bode plots

== The idea
=== Why look at the frequency?
-> The response to a sinusoid is another sinusoid, at the same frequency
-> Only the *amplitude* and the *phase* change
-> The plot of both against $omega$ is the Bode plot

> == Definition
> The transfer function at $s = j omega$: $G(j omega) = |G(j omega)| e^(j phi(omega))$.

#callout("tip")[In decibels, a gain of 10 is $20$ dB.]

== A single pole <example>
Sketch the magnitude plot of $G(s) = 1 / (s + 10)$.

#pause
#solution
Below $omega = 10$ rad/s the magnitude is flat, at $-20$ dB; above it, it falls $20$ dB per decade:

$ |G(j omega)|_"dB" = -20 log_10 sqrt(omega^2 + 100) $

== Two poles <exercise>
For $G(s) = 100 / ((s + 1)(s + 100))$, find:

+ the corner frequencies
+ the slope after each one
+ the gain at low frequency, in dB

#answer
$omega = 1$ and $omega = 100$ rad/s; $-20$ and $-40$ dB/decade; $0$ dB.

= On the computer

== The frequency response in Python
```python
import numpy as np
from scipy import signal

G = signal.TransferFunction([100], [1, 101, 100])
w, mag, phase = signal.bode(G, np.logspace(-1, 3, 200))
print(round(mag[0], 1))
```
```text
-0.0
```

#callout("warning")[`signal.bode` returns the magnitude already in dB.]

#ending-slide[Thank you!][Next lecture: stability margins][Read chapter 8 of the book.]
