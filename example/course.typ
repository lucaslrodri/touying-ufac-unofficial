// Example deck of the touying-ufac-unofficial theme: an extension course (`kind: "course"`) with several instructors,
// the gradient background and code blocks through codly 2, which the deck imports and passes to the theme.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *
#import "@preview/codly:2.0.0" as codly

#show: ufac-theme.with(
  background: "gradient",
  codly: codly,
  config-info(
    kind: "course",
    title: [MATLAB para Engenharia],
    short-title: [Curso de extensão],
    short-subtitle: [Módulo 1],
    subtitle: [Vetores, gráficos e scripts],
    author: ([Ana Souza], [Bruno Lima], [Carla Dias]),
    date: datetime(year: 2026, month: 3, day: 9),
    contact: [`matlab@ufac.br`],
  ),
)

#title-slide()

= Primeiros passos

== A Janela de Comandos
O MATLAB responde a cada comando:

```matlab
x = linspace(0, 2*pi, 100);
y = sin(x);
plot(x, y)
```

#callout("note")[O ponto e vírgula no fim da linha esconde o resultado.]

== Vetores elemento a elemento <example>
Calcule $y = x^2$ para $x = 1, 2, 3$.

#solution
O operador `.^` eleva cada elemento:

#codly.new(
  ```matlab
  x = [1 2 3];
  y = x.^2
  ```,
  file: "quadrados.m",
)

```text
y =
     1     4     9
```

== Um script <exercise>
Escreva um script que mostre a tabuada de `n`.

#callout("tip")[Use um laço `for` de 1 a 10.]

#ending-slide()
