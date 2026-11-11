# Apresentação do curso (primeira aula)

Os slides que apresentam a disciplina na primeira aula: informações, Classroom, o que fica nas aulas e no seminário, a estrutura do curso com os encontros, o cronograma, a bibliografia e as avaliações. O formato é o da apresentação que o professor aprovou, no deck da Unidade I de Sinais e Sistemas. Os números, as datas e as referências vêm do plano de curso. Todo trecho daqui foi compilado (Typst 0.15.1, touying 0.7.4, tema 0.4.0, ufac-syllabus 0.0.3) com o plano real de Sinais e Sistemas e passou no `scripts/verificar_deck.py`.

## Onde fica

- A apresentação é a primeira Parte (`=`) do deck da primeira unidade (`<disciplina>/slide-01/slide-01.typ`), escrita no próprio deck, logo depois da capa. Não há arquivo à parte nem `#include`: o deck inteiro fica num arquivo só.
- O mapa do curso é uma figura do deck, em `figures/diagrams/mapa-do-curso.typ`. O print do Classroom e as capas dos livros ficam em `assets/` do deck (`assets/classroom.png`, `assets/livros/`).
- A data curta de cada avaliação vem da função `data-avaliacao`, no `header.typ` do deck.
- A capa é o `#title-slide` do deck. A Parte abre com um ícone, não com a capa de um livro (nenhum livro é o principal).

## De onde vem cada dado

| Dado | Fonte | Campo |
|---|---|---|
| horário, carga horária, pré-requisito, professor | JSON do plano | `course.subject-datetime`, `subject-hours`, `prerequisites`, `instructor` |
| total de encontros e duração de cada um | JSON | soma dos `meetings` de `course.program-content`; `deck.meeting-minutes` |
| encontros e período de cada unidade | JSON | `meetings` e `period` da unidade (`deck.unit`, `deck.period`) |
| cronograma | JSON | `course.program-content`, pelo `deck.schedule` |
| datas das provas, do seminário e da prova final | JSON | `course.evaluations` (`data-avaliacao`, do `header.typ`) |
| temas do seminário | JSON | a entrada com `grade: "T"` (`topics`) |
| bibliografia | JSON | `bibliography.main` e `bibliography.complementary` |
| fórmulas das notas | `plano-de-curso.typ` | argumento `assignments` (o JSON não as traz) |
| o plano de curso | `header.typ` do deck | `plano`, lido de `/data/<disciplina>-plano.json` |
| código da turma | `header.typ` do deck | `codigo-turma` |
| print do Classroom, capas dos livros | `assets/` do deck | `assets/classroom.png`, `assets/livros/` |

O que não está nessas fontes não entra: sala, contato, horário de atendimento. Pergunte ao professor e anote como pendência.

## Regras desta parte

- **Os encontros só aqui** (regra Aula 3). A divisão por encontro aparece nesta Parte e em nenhum outro lugar do deck:
  - a carga horária, com o total de encontros;
  - cada unidade, com os encontros e o período no `deck.stats`;
  - o "Cronograma previsto", com o `deck.schedule`.

  Depois desta Parte, o deck segue o assunto: nada de "Encontro N", "Resumo do encontro" ou "(encontro N)". Os encontros e as datas são estimativa.
- **Do plano, sem inventar.** Os números, as datas, as referências, os temas do seminário e as fórmulas das notas vêm do plano, como estão. São escolha sua, e você as mostra ao professor:
  - o resumo "Nas aulas", por domínio;
  - o título curto de cada unidade ("I · Sinais") e os tópicos dela, encurtados do plano;
  - o ícone de cada unidade e a capa de cada livro.
- **A bibliografia é conteúdo, não referência.** Na aula não há referência bibliográfica nos slides (regra 7): nada de `@chave` nem de `#bibliography`. O slide "Bibliografia" é outra coisa: a lista de livros da disciplina, que o plano de curso traz e o aluno precisa conhecer, com o texto de cada referência literal. É o único lugar da aula em que uma referência aparece.
- **Crédito das capas no plano.** A capa de um livro e o print do Classroom são imagens tiradas inteiras de fora. Na aula não há slide de créditos (regra 7): a origem delas fica na tabela de figuras do `plano-de-aula.md`. A legenda da capa é a referência do livro, do plano, e não leva "Fonte:".
- **Sem função pequena** (regra 3): o ícone da pílula e a foto se escrevem no slide, com os componentes do tema. A única função desta Parte é a `data-avaliacao`, no `header.typ`: ela é usada em quase todo slide daqui, e o tema e o ufac-syllabus não a têm.
- **Sem letra pequena** (regra 2). Fica de fora o que o deck antigo fazia:
  - `text(size: .85em)` nos cartões e `.62em` no período;
  - `#set text(size: .8em)` na bibliografia;
  - o cronograma a `.56em`: aqui ele fica no corpo e continua na página seguinte, com o cabeçalho repetido;
  - `#show figure.caption: set text(size: .6em)` no deck (o tema já põe a legenda a 0.6em).

  O rótulo do `deck.stats` sai a `.56em`: passe `text(size: 1.8em)` no uso.
- **Sem destaque** (`~~ ~~`) nos tópicos das unidades: são os do plano, só encurtados.

## Os slides, nesta ordem

| # | Slide | Componentes | Páginas em Sinais e Sistemas |
|---|---|---|---|
| 1 | Capa: `#title-slide` do deck e a Parte `= Apresentação do curso` | ícone grande na seção | 1 + 1 |
| 2 | Informações gerais | 4 `emph-box` com ícone, em 2 × 2 | 1 |
| 3 | Google Classroom | `emph-box` com o código, setas, print | 1 |
| 4 | Nas aulas × No seminário ($T$) | `emph-box` "Nas aulas"; `emph-box` amarela com os temas do seminário, até 4 por página; `#note` | 3 |
| 5 | Estrutura do curso: o mapa | `figures/diagrams/mapa-do-curso.typ`, numa `figure` | 1 |
| 6 | Estrutura do curso: uma unidade por página, agrupadas pela prova | pílula `===` da prova; `emph-box` com ícone, tópicos e `deck.stats` | 8 (7 unidades; a VI em 2) |
| 7 | Cronograma previsto | `deck.schedule` | 3 |
| 8 | Bibliografia: Básica (2 capas, depois a terceira centralizada) e Complementar | `figure` com a referência como legenda; `deck.punctuated` | 2 + 2 |
| 9 | Avaliações | `cols`: as notas, o que cada prova cobra e a data; a média final | 1 |

A origem das capas e do print do Classroom fica no `plano-de-aula.md`: na aula não há slide de créditos.

## O código

O arquivo começa assim. O `plano`, o `codigo-turma` e a `data-avaliacao` vêm do `header.typ` do deck; os ícones Phosphor (`"ph:.."`), do `assets/icones-ph.json` que o deck passa ao `provide-icons` dentro da capa.

```typ
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.4.0": *
#import "@local/ufac-syllabus:0.0.3": deck
#import "header.typ": plano, codigo-turma, data-avaliacao

#let curso = deck.course(plano)

// ... o #show: ufac-theme.with(..) e a capa, #title-slide[#provide-icons(json("assets/icones-ph.json"))]

= Apresentação do curso
#icon("ph:graduation-cap-bold", size: 7em, color: colors.primary)
```

### O plano e a data de uma avaliação, no `header.typ`

```typ
// O header.typ do deck: o plano e o código da turma, que vários decks usam, e a data curta de uma avaliação do
// plano, na apresentação do curso.
#import "@local/ufac-syllabus:0.0.3": deck

#let plano = json("/data/<disciplina>-plano.json")
#let codigo-turma = "<código da turma>"

// `data-avaliacao("P_1")` dá "03/12"; a prova final, que não tem nota, pelo título:
// `data-avaliacao(none, titulo: "Prova final")`.
#let data-avaliacao(nota, titulo: none) = {
  let e = deck.course(plano).evaluations.find(e => if titulo != none { e.title == titulo } else {
    e.at("grade", default: none) == nota
  })
  deck.short-date(e.date)
}
```

### Informações gerais

Os quatro cartões em 2 × 2. A carga horária traz o total de encontros e a duração de cada um.

```typ
== Informações gerais
#let encontros = curso.program-content.map(x => x.meetings).sum()
#v(1fr)
#grid(
  columns: (1fr, 1fr),
  gutter: (1em, 1.5em),
  emph-box(icon: "ph:clock-bold", title: [Horário])[#align(center, curso.subject-datetime)],
  emph-box(icon: "ph:hourglass-medium-bold", title: [Carga horária])[
    #align(center)[#curso.subject-hours: #encontros encontros \ de #deck.meeting-minutes(plano) min]
  ],
  emph-box(icon: "ph:graduation-cap-bold", title: [Pré-requisito])[#align(center, curso.prerequisites.join(", "))],
  emph-box(icon: "ph:chalkboard-teacher-bold", title: [Professor])[#align(center, curso.instructor)],
)
#v(1fr)
```

### Google Classroom

`grid` com `align: horizon`, sem `#v(1fr)` dentro de colunas. A legenda fica no corpo.

```typ
== Google Classroom
#grid(
  columns: (1fr, 1.6fr),
  gutter: 1.2em,
  align: horizon,
  [
    #emph-box(icon: "ph:chalkboard-teacher-bold", title: [Código da turma])[
      #align(center, text(size: 1.6em, weight: "bold", tracking: .08em, codigo-turma))
    ]

    -> Slides e materiais das aulas;
    -> Avisos da disciplina.
  ],
  figure(
    box(radius: 8pt, clip: true, stroke: 1pt + colors.neutral-lighter, image("assets/classroom.png", width: 100%)),
    caption: [A turma no Google Classroom],
  ),
)
```

### Nas aulas × No seminário

- "Nas aulas": o que as aulas cobrem, numa ou duas frases por domínio (no tempo, na frequência), a partir das unidades do plano. É escolha sua: mostre ao professor.
- "No seminário": os temas da entrada `T` do plano, separados por `"; "`. A data do seminário vai no título da caixa, nunca no título do slide.
- Até 4 temas por página; o `deck.punctuated` põe o `;` e o ponto final em cada página. O `#note` dos grupos fecha a última.

```typ
#let seminario = curso.program-content.find(x => x.at("grade", default: none) == "T")
#let temas = seminario.topics.at(0).split("; ")

== Nas aulas × No seminário ($T$)
#v(1fr)
#emph-box(icon: "ph:chalkboard-teacher-bold", title: [Nas aulas])[
  *No tempo.* Sinais, sistemas lineares e invariantes no tempo (LIT), convolução, equações diferenciais e de diferenças e espaço de estados.

  *Na frequência.* Série e transformada de Fourier de tempo discreto e transformada Z.
]
#v(1fr)

---

#emph-box(color: colors.secondary-dark, icon: "ph:users-three-bold", title: [No seminário, #data-avaliacao("T")])[
  #deck.punctuated(temas.slice(0, 4))
]

---

#emph-box(color: colors.secondary-dark, icon: "ph:users-three-bold", title: [No seminário, #data-avaliacao("T")])[
  #deck.punctuated(temas.slice(4))
]

#v(1fr)
#note[Os temas e os grupos do seminário serão definidos de acordo com o número de inscritos.]
```

### Estrutura do curso: o mapa

Uma frase com o número de unidades, provas e seminários, e o mapa numa `figure`.

```typ
== Estrutura do curso
Sete unidades temáticas, três provas e um seminário:

#v(1fr)
#figure(include "figures/diagrams/mapa-do-curso.typ", caption: [As unidades, as provas e o seminário])
#v(1fr)
```

O mapa tem uma linha por prova: as unidades que ela cobra, em algarismos romanos, a prova e a data estimada embaixo dela. Tudo no tamanho do corpo e lido do plano.

Se a disciplina ainda não tem esse mapa, crie `figures/diagrams/mapa-do-curso.typ` com o código abaixo e mostre-o ao professor. O arquivo é a figura: ele importa o fletcher e o `ufac-syllabus`, lê o plano pelo `header.typ` do deck (`../../header.typ`) e não define função. Um mapa com rótulos menores que o corpo ou com datas escritas à mão fica de fora (regra 2 e "do plano, sem inventar"): o antigo de Sinais e Sistemas tinha rótulos a `.5em` (cerca de 10 pt) e o recesso escrito à mão.

```typ
// Mapa do curso: uma linha por prova, com as unidades que ela cobra (em algarismos romanos), a prova e a data
// estimada embaixo dela, na ordem do plano. Uma prova seguida de outra (P3 e T) fica na mesma linha. Cada prova
// do plano tem `grade`.

#import "@preview/touying-ufac-unofficial:0.4.0": colors
#import "@preview/fletcher:0.5.8": diagram, node, edge
#import "@local/ufac-syllabus:0.0.3": deck
#import "../../header.typ": plano

#{
  let linhas = ((),)
  let n = 0
  for item in deck.course(plano).program-content {
    if deck.is-unit(item) {
      if linhas.last().len() > 0 and linhas.last().last().prova { linhas.push(()) }
      n += 1
      linhas.last().push((prova: false, nome: deck.roman(n)))
    } else {
      linhas.last().push((prova: true, nome: item.grade, data: deck.period(item)))
    }
  }
  let nos = ()
  for (r, linha) in linhas.enumerate() {
    for (c, it) in linha.enumerate() {
      if it.prova {
        // as provas (P_1, P_2...) em azul; o trabalho ou seminário (T) em amarelo
        let prova = it.nome.starts-with("P")
        let cor = if prova { colors.primary } else { colors.secondary }
        let tinta = if prova { white } else { colors.secondary-darkest }
        nos.push(node((c, r), text(fill: tinta, weight: "bold", deck.grade(it.nome)), shape: circle, radius: 1em,
          fill: cor))
        nos.push(node((c, r + .45), it.data))
      } else {
        nos.push(node((c, r), text(fill: colors.primary, weight: "bold", it.nome), shape: rect, width: 3em,
          height: 1.8em, corner-radius: 6pt, fill: colors.primary-lightest, stroke: 1.4pt + colors.primary))
      }
      if c > 0 { nos.push(edge((c - 1, r), (c, r), "-|>")) }
    }
  }
  diagram(edge-stroke: 1.6pt + colors.neutral-dark, mark-scale: 80%, spacing: (2.4em, 3em), ..nos)
}
```

### Estrutura do curso: as unidades

- Depois do mapa, `---` e uma unidade por página, na ordem do plano, escritas à mão (regra 3: o código fica onde é usado).
- Antes da primeira unidade de cada prova, a pílula `=== $P_1$ · <data>: Unidades I, II e III`. Ela continua nas páginas seguintes, até a próxima.
- Cada unidade numa `emph-box` com um ícone e o título curto: o algarismo romano e o assunto ("I · Sinais").
- Os tópicos são os do plano, encurtados, com o `;` e sem destaque. Até 5 por página, com cerca de 40 palavras (regra 1); com mais, a unidade vai em duas páginas, e o `deck.stats` fica na última.
- O `deck.stats` traz os encontros e o período da unidade, lidos do plano. O `\u{a0}` e o `\u{2060}` prendem as datas à meia-risca, para o período não quebrar.

```typ
---

=== $P_1$ · #data-avaliacao("P_1"): Unidades I, II e III

#v(1fr)
#emph-box(icon: "ph:wave-sine-bold", title: [I · Sinais])[
  - Energia e potência de um sinal;
  - Deslocamento, reflexão e mudança de escala no tempo;
  - Sinais periódicos, pares e ímpares;
  - Exponenciais e senoides, contínuas e discretas;
  - Impulso unitário e degrau unitário.
  // o rótulo do deck.stats sai a .56em: 1.8em o põe no corpo
  #deck.stats(
    ([#deck.unit(plano, 1).meetings], text(size: 1.8em)[encontros]),
    (deck.period(deck.unit(plano, 1)).replace(" – ", "\u{a0}–\u{2060}\u{a0}"), text(size: 1.8em)[período]),
  )
]
#v(1fr)

---

#v(1fr)
#emph-box(icon: "ph:flow-arrow-bold", title: [II · Sistemas LIT])[
  - Exemplos de sistemas e interconexões;
  - Memória, invertibilidade, causalidade, estabilidade, invariância no tempo e linearidade;
  - Convolução: a soma (discreta) e a integral (contínua);
  - Propriedades dos sistemas LIT.
  #deck.stats(
    ([#deck.unit(plano, 2).meetings], text(size: 1.8em)[encontros]),
    (deck.period(deck.unit(plano, 2)).replace(" – ", "\u{a0}–\u{2060}\u{a0}"), text(size: 1.8em)[período]),
  )
]
#v(1fr)
```

As outras unidades seguem igual. Uma unidade em duas páginas, como a VI de Sinais e Sistemas, com sete tópicos:

```typ
=== $P_3$ · #data-avaliacao("P_3"): Unidades VI e VII

#v(1fr)
#emph-box(icon: "ph:target-bold", title: [VI · Transformada Z])[
  - Transformada Z, região de convergência e transformada inversa;
  - Propriedades e pares de transformadas;
  - Função de transferência, causalidade e estabilidade;
  - Resposta em frequência a partir dos polos e zeros;
]
#v(1fr)

---

#v(1fr)
#emph-box(icon: "ph:target-bold", title: [VI · Transformada Z])[
  - Interconexões e diagramas de blocos;
  - Transformada Z unilateral e equações de diferenças;
  - Mapeamento s–Z: a ligação entre as transformadas de Laplace e Z.
  #deck.stats(
    ([#deck.unit(plano, 6).meetings], text(size: 1.8em)[encontros]),
    (deck.period(deck.unit(plano, 6)).replace(" – ", "\u{a0}–\u{2060}\u{a0}"), text(size: 1.8em)[período]),
  )
]
#v(1fr)
```

### Cronograma previsto

Uma linha por unidade, prova e seminário, com o período, os encontros, as aulas e a carga horária, e o total. A tabela fica no corpo e continua na página seguinte, com o cabeçalho repetido: em Sinais e Sistemas, 3 páginas. O `deck.schedule` dá erro se os encontros não somam a carga horária do plano.

```typ
== Cronograma previsto
#deck.schedule(plano)
```

### Bibliografia

- Básica: duas capas lado a lado, depois a terceira sozinha e centralizada.
- As capas têm o mesmo tamanho e seguem a ordem do plano. A referência do plano é a legenda; a origem da capa fica no `plano-de-aula.md`.
- Complementar: 3 referências por página.

```typ
== Bibliografia

=== Básica

#v(1fr)
#grid(
  columns: (1fr,) * 2,
  gutter: 2em,
  align: center + top,
  figure(image("assets/livros/oppenheim.jpg", height: 10em), caption: plano.bibliography.main.at(0)),
  figure(image("assets/livros/haykin.jpg", height: 10em), caption: plano.bibliography.main.at(1)),
)
#v(1fr)

---

#v(1fr)
#align(center, box(width: 50%, figure(image("assets/livros/lathi.jpg", height: 10em), caption: plano.bibliography.main.at(2))))
#v(1fr)

---

=== Complementar

#deck.punctuated(plano.bibliography.complementary.slice(0, 3))

---

#deck.punctuated(plano.bibliography.complementary.slice(3))
```

### Avaliações

- As fórmulas são as do `assignments` do plano de curso.
- A lista de termos diz o que cada prova cobra e a data dela.
- A média final traz a regra da prova final, com a data.

```typ
== Avaliações

#cols(divider: true, columns: (1.25fr, 1fr), gutter: 1.2em)[
  === Notas

  $ N_1 = P_1 + P_2 $

  $ N_2 = "0,6" dot P_3 + "0,4" dot T $

  / $P_1$: Unidades I a III, #data-avaliacao("P_1")
  / $P_2$: Unidades IV e V, #data-avaliacao("P_2")
  / $P_3$: Unidades VI e VII, #data-avaliacao("P_3")
  / $T$: seminário, #data-avaliacao("T")
][
  === Média final

  $ M = (N_1 + N_2) / 2 $

  -> $M < "8,0"$: prova final em #data-avaliacao(none, titulo: "Prova final").
]
```

### Origem das imagens

Na aula não há slide de créditos. A origem das capas (editora, fonte com link) e do print do Classroom vai na tabela de figuras do `plano-de-aula.md`.

## Conferir

- Em Sinais e Sistemas, a Parte tem 23 páginas, da seção às avaliações.
- O `verificar_deck.py` não aponta encontro nesta Parte e dá 0 bloqueio e um REVISAR. É a Unidade VII: 43 palavras, mas são os 5 tópicos do plano, que cabem numa página ("cerca de 40", regra 1).
- Na folha de contato, confira:
  - o título de cada unidade numa linha;
  - os rótulos do `deck.stats` em maiúsculas, no tamanho do corpo;
  - o cronograma no corpo, com o cabeçalho em cada página;
  - a terceira capa centralizada.
- Pendências para o professor:
  - sala, contato e horário de atendimento, se ele quiser (não estão no plano);
  - o resumo "Nas aulas", os títulos curtos, os tópicos e os ícones das unidades;
  - o `figures/diagrams/mapa-do-curso.typ`, se a disciplina ainda usar um mapa com letra pequena;
  - a origem de cada capa de livro, no `plano-de-aula.md`.
