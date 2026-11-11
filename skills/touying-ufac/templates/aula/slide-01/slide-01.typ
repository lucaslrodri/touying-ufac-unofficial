// Modelo de deck do modo aula da skill touying-ufac (touying-ufac-unofficial 0.4.0). O conteúdo é de Sinais e
// Sistemas, só de exemplo. Copie esta pasta para <disciplina>/slide-NN/ (se a disciplina já tem decks, com o
// header.typ do anterior no lugar do daqui) e compile da pasta do deck; a raiz é a pasta da disciplina:
//   typst compile --root .. slide-NN.typ
// Pastas: as figuras feitas em Typst em figures/<tipo>/, as imagens prontas em assets/, os dados em ../data/ e, no
// header.typ, as funções grandes e o que vários decks usam (o plano, o estilo dos gráficos); não há common.typ.
// Cada assunto: Parte (=), exemplo introdutório, definição, exemplos, questões; sem slide de resumo. Sintaxe e
// componentes: references/padroes-do-tema.md.

#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.4.0": *
// #import "@local/ufac-syllabus:0.0.3": deck   // só na apresentação do curso (primeira aula)

#show: ufac-theme.with(
  aspect-ratio: "16-9",
  config-info(
    flavor: "lecture",
    subject: [Sinais e Sistemas],
    subject-code: [CCET488],
    unit: [Unidade I],
    unit-title: [Sinais de tempo contínuo e de tempo discreto],
    semester: [2026.2],
    author: [Prof. Dr. Nome do Professor],
    counter-prefix: [1.],   // número da unidade: Exemplo 1.1, Questão 1.1
  ),
)

// os ícones Phosphor (JSON do Iconify) que o deck usa, dados na capa, que não mostra nada deles
#title-slide[#provide-icons(json("assets/icones-ph.json"))]

// sem roteiro: da capa, direto para a primeira Parte
// Parte: nome de assunto, nunca de encontro; depois do =, só a imagem (foto de fora: origem no plano-de-aula.md)
= Energia de um sinal
#image("assets/fotos/sol.jpg")

// exemplo introdutório: um caso concreto, antes da definição
== Energia num resistor <example-resistor>
Uma fonte de $2 "V"$ alimenta um resistor de $1 Omega$ durante $3 "s"$. Calcule a energia dissipada.

#pause
#solution
$ p = v^2 / R = 4 "W" quad => quad E = p dot 3 "s" = 12 "J" $

== Energia de um sinal
#emph-box(icon: "ph:lightning-bold", title: [Definição])[
  A energia de $x(t)$ em todo o tempo é
  $ E_infinity = integral_(-infinity)^(+infinity) |x(t)|^2 dif t $
]

-> Se $x(t)$ é a tensão num resistor de $1 Omega$, $E_infinity$ é a energia dissipada.

// exemplo resolvido: a figura num arquivo de figures/graphs/; a solução depois de ---, porque não cabe junto
== Pulso retangular <example-pulso>
Calcule $E_infinity$ de $x(t) = 3$ para $-1 <= t <= 1$ e $x(t) = 0$ fora.

#align(center, include "figures/graphs/pulso.typ")

---

#solution
$ E_infinity = integral_(-1)^1 3^2 dif t = 9 dot 2 = 18 $

// questão: só discursiva; o enunciado, --- e a resposta desenvolvida
== Exponencial decrescente <question-exponencial>
Calcule $E_infinity$ de $x(t) = e^(-t) u(t)$. Mostre cada passo.

#align(center, include "figures/graphs/exponencial.typ")

---

#answer
Para $t < 0$, $x(t) = 0$; para $t >= 0$, $|x(t)|^2 = e^(-2t)$. Então
$ E_infinity = integral_0^(+infinity) e^(-2t) dif t = [-1/2 e^(-2t)]_0^(+infinity) = 1/2 $

// sem slide de resumo: a Parte termina nas questões

// sem slide de créditos: a origem das imagens tiradas inteiras de fora (o Sol, o meme) fica na tabela de figuras do
// plano-de-aula.md; desenho próprio ou refeito não leva crédito, e a aula não tem referências bibliográficas

// último slide: "Fim!" e o meme, sem "Obrigado!" nem a próxima aula; height até 14em cabe, 16em empurra o meme para
// outra página
#ending-slide(title: [Fim!])[#image("assets/meme.svg", height: 12em)]
