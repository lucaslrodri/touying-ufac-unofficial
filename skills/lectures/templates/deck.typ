// Modelo de deck de aula (touying-ufac-unofficial 0.3.0). O conteúdo é de Sinais e Sistemas, só de exemplo.
// Copie para <curso>/slide-NN/slide-NN.typ e compile da pasta do deck (a raiz é a pasta do curso):
//   typst compile --root .. slide-NN.typ
// Cada assunto: Parte (=), exemplo introdutório, definição, exemplos, exercícios, resumo.
// Sintaxe e componentes: references/padroes-do-tema.md.

#import "@preview/touying:0.7.4": *
#import "@local/touying-ufac-unofficial:0.3.0": *
// #import "@local/ufac-syllabus:0.0.3": deck   // só na apresentação do curso (primeira aula)
#import "../comum.typ": *   // ajudantes do curso; define `icones` (ícones Phosphor em JSON do Iconify)

#show: ufac-theme.with(
  aspect-ratio: "16-9",
  config-info(
    kind: "lecture",
    subject: [Sinais e Sistemas],
    subject-code: [CCET488],
    unit: [Unidade I],
    unit-title: [Sinais de tempo contínuo e de tempo discreto],
    semester: [2026.2],
    author: [Prof. Dr. Lucas Lima Rodrigues],
    counter-prefix: [1.],   // número da unidade: Exemplo 1.1, Exercício 1.1
  ),
)

// provide-icons dentro da capa: solto antes dela, cria uma página em branco
#title-slide[#provide-icons(icones)]

== Roteiro
#outline()

// Parte: nome de assunto, nunca de encontro; depois do =, só a imagem
= Energia de um sinal
#image("../assets/fotos/osciloscopio.jpg")

// exemplo introdutório: um caso concreto, antes da definição
== Energia num resistor <example-resistor>
Uma fonte de $2 "V"$ alimenta um resistor de $1 Omega$ durante $3 "s"$. Calcule a energia dissipada.

#pause
#solution
$ p = v^2 / R = 4 "W" quad => quad E = p dot 3 "s" = 12 "J" $

== Energia de um sinal
#emph-box(title: [Definição])[
  A energia de $x(t)$ em todo o tempo é
  $ E_infinity = integral_(-infinity)^(+infinity) |x(t)|^2 dif t $
]

-> Se $x(t)$ é a tensão num resistor de $1 Omega$, $E_infinity$ é a energia dissipada.

// exemplo resolvido: a solução depois de #pause; se não couber, depois de ---
== Pulso retangular <example-pulso>
Calcule $E_infinity$ de $x(t) = 3$ para $-1 <= t <= 1$ e $x(t) = 0$ fora.

#pause
#solution
$ E_infinity = integral_(-1)^1 3^2 dif t = 9 dot 2 = 18 $

// exercício: só discursivo; o enunciado, --- e a resposta desenvolvida
== Exponencial decrescente <exercise-exponencial>
Calcule $E_infinity$ de $x(t) = e^(-t) u(t)$. Mostre cada passo.

---

#answer
Para $t < 0$, $x(t) = 0$; para $t >= 0$, $|x(t)|^2 = e^(-2t)$. Então
$ E_infinity = integral_0^(+infinity) e^(-2t) dif t = [-1/2 e^(-2t)]_0^(+infinity) = 1/2 $

// resumo com nome de assunto, nunca "do encontro"
== Resumo: energia de um sinal
-> $E_infinity$ soma $|x(t)|^2$ em todo o tempo.
-> Num resistor de $1 Omega$, é a energia dissipada.
-> Pulso de altura $A$ e largura $T$: $E_infinity = A^2 T$.

// créditos de toda imagem do deck, inclusive do meme, no tamanho do corpo
== Créditos das imagens
- Osciloscópio: Pittigrilli, CC BY-SA 4.0, #link("https://commons.wikimedia.org/wiki/File:Sine_wave_10_kHz_displayed_on_analog_oscilloscope.jpg")[Wikimedia Commons].
- Meme: autor, licença, fonte.   // o crédito do meme que o professor escolher

// último slide: "Fim!" e o meme, sem "Obrigado!" nem a próxima aula. O meme fica em memes/, ao lado do deck;
// height até 14em cabe, 16em empurra o meme para outra página.
#ending-slide(title: [Fim!])[#image("memes/meme.png", height: 12em)]
