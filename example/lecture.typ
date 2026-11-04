// Example deck of the touying-ufac-unofficial theme: a lecture of a course, in Portuguese, with the aliases of a course
// (`subject`, `subject-code`, `unit`, `unit-title`, `semester`), exercises and examples with their solutions, callouts and
// the closing slide.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *

#show: ufac-theme.with(
  config-info(
    kind: "lecture",
    subject: [Sistemas de Controle],
    subject-code: [CCET123],
    unit: [Unidade II],
    unit-title: [Resposta em frequência],
    semester: [2026.2],
    author: [Prof. Dr. Seu Nome],
    contact: [`seu.nome@ufac.br`],
  ),
)

#title-slide()

== Roteiro
#outline()

= Diagramas de Bode

== A ideia
=== Por que olhar a frequência?
-> A resposta a uma senoide é outra senoide, na mesma frequência
-> Muda só a *amplitude* e a *fase*
-> O gráfico das duas, em função de $omega$, é o diagrama de Bode

> == Definição
> A função de transferência em $s = j omega$: $G(j omega) = |G(j omega)| e^(j phi(omega))$.

#callout("tip")[Em decibéis, um ganho de 10 vezes é $20$ dB.]

== Um polo simples <example>
Esboce o diagrama de módulo de $G(s) = 1 / (s + 10)$.

#pause
#solution
Abaixo de $omega = 10$ rad/s o módulo é plano, em $-20$ dB; acima, cai $20$ dB por década:

$ |G(j omega)|_"dB" = -20 log_10 sqrt(omega^2 + 100) $

== Dois polos <exercise>
Para $G(s) = 100 / ((s + 1)(s + 100))$:

+ as frequências de canto
+ a inclinação depois de cada uma
+ o ganho em baixa frequência, em dB

#answer
$omega = 1$ e $omega = 100$ rad/s; $-20$ e $-40$ dB/década; $0$ dB.

= No computador

== A resposta em frequência em Python
```python
import numpy as np
from scipy import signal

G = signal.TransferFunction([100], [1, 101, 100])
w, mag, fase = signal.bode(G, np.logspace(-1, 3, 200))
print(round(mag[0], 1))
```
```text
-0.0
```

#callout("warning")[O `signal.bode` devolve o módulo já em dB.]

#ending-slide[Obrigado!][Próxima aula: margens de estabilidade][Leiam o capítulo 8 do livro.]
