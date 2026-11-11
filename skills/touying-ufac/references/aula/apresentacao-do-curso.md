# Apresentação do curso (primeira aula)

Os slides que apresentam a disciplina na primeira aula: informações, ementa, unidades, bibliografia, avaliações e seminário. Tudo vem do plano de curso. Todo trecho daqui foi compilado (Typst 0.15.1, touying 0.7.4, tema 0.3.0, ufac-syllabus 0.0.3) com o plano real de Sinais e Sistemas e passou no `scripts/verificar_deck.py`.

## Onde fica

- Um arquivo de assunto, `apresentacao-do-curso.typ`, na pasta do deck da primeira unidade (`<disciplina>/slide-01/`). Ele é a primeira Parte (`=`) do deck, como no deck que o professor aprovou.
- O deck o inclui logo depois do roteiro: `#include "apresentacao-do-curso.typ"`.
- O mapa do curso é uma figura do deck, em `figures/diagrams/mapa-do-curso.typ`. O print do Classroom e as capas dos livros ficam em `assets/` do deck (`assets/classroom.png`, `assets/livros/`).
- A capa é o `#title-slide` do deck. A Parte abre com um ícone, não com a capa de um livro (nenhum livro é o principal).

## De onde vem cada dado

| Dado | Fonte | Campo |
|---|---|---|
| horário, carga horária, pré-requisito, professor | JSON do plano | `course.subject-datetime`, `subject-hours`, `prerequisites`, `instructor` |
| ementa | JSON | `course.syllabus`, literal |
| unidades: título, tópicos, período | JSON | `course.program-content` (`deck.units`, `deck.period`) |
| provas e datas | JSON | entradas de `program-content` com `grade` e `date`; `course.evaluations` |
| bibliografia | JSON | `bibliography.main` e `bibliography.complementary` |
| fórmulas das notas | `plano-de-curso.typ` | argumento `assignments` (o JSON não as traz) |
| seminário: temas e data | JSON | a entrada com `grade: "T"` (`topics`, `date`) |
| o plano de curso | `header.typ` do deck | `plano`, lido de `/data/<disciplina>-plano.json` |
| código da turma | `header.typ` do deck | `codigo-turma` |
| print do Classroom, capas dos livros | `assets/` do deck | `assets/classroom.png`, `assets/livros/` |

O que não está nessas fontes não entra: sala, contato, horário de atendimento. Pergunte ao professor e anote como pendência.

## Regras desta parte

- **Nada inventado.** O texto do plano entra literal: ementa, tópicos, referências e as frases das avaliações. Só duas coisas são escolha sua: a divisão da ementa por domínio e a capa de cada livro. Mostre as duas ao professor.
- **A bibliografia é conteúdo, não referência.** Na aula não há referência bibliográfica nos slides (regra 7): nada de `@chave` nem de `#bibliography`. Os slides "Bibliografia básica" e "Bibliografia complementar" são outra coisa: a lista de livros da disciplina, que o plano de curso traz e o aluno precisa conhecer, com o texto de cada referência literal, como os tópicos. É o único lugar da aula em que uma referência aparece.
- **Crédito das capas no fim.** A capa de um livro e o print do Classroom são imagens tiradas inteiras de fora: o crédito vai no slide "Créditos das imagens", no fim do deck, antes do "Fim!" (regra 7). A legenda da capa é a referência do livro, do plano, e não leva "Fonte:".
- **Sem função pequena** (regra 3): o ícone da pílula, a foto e os créditos se escrevem no slide, com os componentes do tema.
- **Sem letra pequena** (regra 2). Fica de fora o que o deck antigo fazia:
  - `text(size: .85em)` nos cartões e `.62em` no período;
  - `#set text(size: .8em)` na bibliografia;
  - o cronograma a `.56em`;
  - `#show figure.caption: set text(size: .6em)` no deck (o tema já põe a legenda a 0.6em).

  O rótulo do `deck.stats` sai a `.56em`: passe `text(size: 1.8em)` no uso. O `#tag[seminário]` (0,6 do corpo) é componente do tema e é a única exceção.
- **Sem encontros** (regra Aula 3). Fica de fora:
  - o número de encontros por unidade;
  - o cronograma do `deck.schedule`, que é por encontro.

  Períodos e datas de prova aparecem, sempre como estimativa.
- **Sem destaque** (`~~ ~~`) nos tópicos das unidades nem na ementa: é o texto do plano.

## Os slides, nesta ordem

| # | Slide | Componentes | Páginas em Sinais e Sistemas |
|---|---|---|---|
| 1 | Capa: `#title-slide` do deck e a Parte `= Apresentação do curso` | ícone grande na seção | 1 + 1 |
| 2 | Informações gerais | 4 `emph-box` com ícone | 1 |
| 3 | Google Classroom | `emph-box` com o código, setas, print | 1 |
| 4 | Ementa do PPC, por domínio, com `#tag[seminário]` | pílula por domínio, `---` entre eles | 4 |
| 5 | Mapa do curso | `figures/diagrams/mapa-do-curso.typ`, incluído | 1 |
| 6 | Uma unidade temática por slide | pílula com o título, lista, `deck.stats` | 9 (7 unidades; 2 delas em 2 páginas) |
| 7 | Bibliografia: 2 capas, depois a terceira sozinha e centralizada; complementar | `figure` com a referência como legenda | 2 + 2 |
| 8 | Avaliações | as frases do plano e as equações em `>` | 2 |
| 9 | Datas das provas, estimadas | `deck.evaluation-dates`, `#note` | 1 |
| 10 | Seminário, em coluna simples | `deck.punctuated`, `#note` | 2 |

As capas e o print do Classroom entram nos "Créditos das imagens", no fim do deck, fora desta Parte.

## O código

O arquivo começa assim. O `plano` e o `codigo-turma` vêm do `header.typ` do deck; os ícones Phosphor (`"ph:.."`), do `assets/icones-ph.json` que o deck passa ao `provide-icons` dentro da capa.

```typ
// Apresentação do curso: a primeira Parte do deck da Unidade I. Tudo lido do plano de curso (`plano`, do header.typ).
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *
#import "@local/ufac-syllabus:0.0.3": deck
#import "header.typ": plano, codigo-turma

#let curso = deck.course(plano)

= Apresentação do curso
#icon("ph:graduation-cap-bold", size: 7em)
```

### Informações gerais

Horário e pré-requisito na largura toda, cada um numa linha; carga horária e professor lado a lado. Os cartões ficam com a mesma altura por linha.

```typ
== Informações gerais
#v(1fr)
#grid(
  columns: (1fr, 1fr),
  gutter: 1.2em,
  grid.cell(colspan: 2, emph-box(icon: "ph:clock-bold", title: [Horário])[#curso.subject-datetime]),
  grid.cell(colspan: 2, emph-box(icon: "ph:graduation-cap-bold", title: [Pré-requisito])[
    #curso.prerequisites.join(", ")
  ]),
  emph-box(icon: "ph:hourglass-medium-bold", title: [Carga horária])[#curso.subject-hours],
  emph-box(icon: "ph:chalkboard-teacher-bold", title: [Professor])[#curso.instructor],
)
#v(1fr)
```

### Google Classroom

`grid` com `align: horizon`, sem `#v(1fr)` dentro de colunas. A legenda fica no corpo.

```typ
== Google Classroom
#grid(
  columns: (1fr, 1.4fr),
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
    caption: [A turma no Classroom],
  ),
)
```

### Ementa do PPC

- Cada item é o texto literal do `course.syllabus`, pelo índice.
- Um domínio por página, com até 5 itens.
- `#tag[seminário]` vai nos itens que estão nos temas do seminário (a entrada `T` do plano).
- O ícone do domínio vai na pílula, escrito com o `icon` do tema, que o põe branco nela.
- Os domínios abaixo são os de Sinais e Sistemas; em outra disciplina, proponha-os ao professor.

```typ
#let ementa = curso.syllabus

== Ementa do PPC
O que o PPC diz que a disciplina cobre. Os itens com #tag[seminário] ficam para os seminários.

=== #icon("ph:wave-sine-bold") No tempo: sinais e equações
- #ementa.at(0)
- #ementa.at(1)
- #ementa.at(8)
- #ementa.at(9) #tag[seminário]

---

=== #icon("ph:grid-four-bold") No tempo: espaço de estados
- #ementa.at(10)
- #ementa.at(11)
- #ementa.at(12)
- #ementa.at(13) #tag[seminário]

---

=== #icon("ph:chart-bar-bold") Na frequência
- #ementa.at(3) #tag[seminário]
- #ementa.at(4) #tag[seminário]
- #ementa.at(7) #tag[seminário]

---

=== #icon("ph:waveform-bold") Na amostragem
- #ementa.at(2) #tag[seminário]
- #ementa.at(5)
- #ementa.at(6) #tag[seminário]
```

### Mapa do curso

```typ
== Mapa do curso
#align(center, include "figures/diagrams/mapa-do-curso.typ")
```

O mapa tem uma linha por prova: as unidades que ela cobra, em algarismos romanos, a prova e a data estimada embaixo dela. Tudo no tamanho do corpo e lido do plano.

Se a disciplina ainda não tem esse mapa, crie `figures/diagrams/mapa-do-curso.typ` com o código abaixo e mostre-o ao professor. O arquivo é a figura: ele importa o fletcher e o `ufac-syllabus`, lê o plano pelo `header.typ` do deck (`../../header.typ`) e não define função. Um mapa com rótulos menores que o corpo ou com datas escritas à mão fica de fora (regra 2 e "nada inventado"): o antigo de Sinais e Sistemas tinha rótulos a `.5em` (cerca de 10 pt) e o recesso escrito à mão.

```typ
// Mapa do curso: uma linha por prova, com as unidades que ela cobra (em algarismos romanos), a prova e a data
// estimada embaixo dela, na ordem do plano. Uma prova seguida de outra (P3 e T) fica na mesma linha. Cada prova
// do plano tem `grade`.

#import "@preview/touying-ufac-unofficial:0.3.0": colors
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

### As unidades

- Um `==` por unidade, gerado do plano.
- O título da unidade vai na pílula: o mais longo de Sinais e Sistemas, com 68 caracteres, cabe numa linha. Como título `==`, ele passaria de 65 caracteres e o tema diminuiria a letra.
- Os tópicos ficam como estão no plano, com o `;` dele e sem destaque.
- Mais de 4 tópicos vão em duas páginas.
- A prova de cada unidade é a primeira entrada com `grade` depois dela.

```typ
#let conteudo = curso.program-content
#for (n, u) in deck.units(plano).enumerate(start: 1) [
  #let prova = conteudo.slice(conteudo.position(x => x == u)).find(x => "grade" in x)
  #let metade = calc.ceil(u.topics.len() / 2)
  == Unidade #deck.roman(n)
  === #u.title
  #if u.topics.len() > 4 [
    #list(..u.topics.slice(0, metade))

    ---

    #list(..u.topics.slice(metade))
  ] else [
    #list(..u.topics)
  ]

  // o rótulo do deck.stats sai a .56em: 1.8em o põe no corpo
  #deck.stats(
    (deck.period(u), text(size: 1.8em)[período]),
    ([#deck.grade(prova.grade) · #deck.period(prova)], text(size: 1.8em)[prova]),
  )
]
```

O `---` gerado no laço quebra a página como o escrito à mão: o `#for` de markup funciona com o Touying.

### Bibliografia

- Básica: duas capas lado a lado, depois a terceira sozinha e centralizada.
- As capas têm o mesmo tamanho e seguem a ordem do plano. A referência do plano é a legenda, no corpo; o crédito da capa vai no fim do deck.
- Complementar: 3 referências por página.

```typ
#let basica = plano.bibliography.main

== Bibliografia básica
#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  figure(image("assets/livros/oppenheim.jpg", height: 8em), caption: basica.at(0)),
  figure(image("assets/livros/haykin.jpg", height: 8em), caption: basica.at(1)),
)

---

#align(center, box(width: 50%, figure(image("assets/livros/lathi.jpg", height: 8em), caption: basica.at(2))))

#let complementar = plano.bibliography.complementary

== Bibliografia complementar
#list(..complementar.slice(0, 3))

---

#list(..complementar.slice(3))
```

### Avaliações

As frases e as fórmulas são as do `assignments` do plano de curso. O `>` sozinho na linha põe a equação em destaque (`eq-box`), e o `&` alinha as duas notas.

```typ
== Avaliações
As notas $N_1$ e $N_2$ são dadas por:

>
$
  N_1 & = P_1 + P_2 \
  N_2 & = "0,6" dot P_3 + "0,4" dot T
$

$P_1$, $P_2$ e $P_3$ são as avaliações teóricas, e $T$ é o trabalho (seminários).

---

E a média final é dada por:

>
$ M = (N_1 + N_2) / 2 $

Caso o discente não atinja média 8,0, será realizada uma avaliação que terá o valor do exame final.
```

### Datas das provas

A tabela do `deck.evaluation-dates` fica no corpo, numa página, com a prova final.

```typ
== Datas das provas
#deck.evaluation-dates(plano)

#note[As datas são estimadas. O que cada prova cobra não muda.]
```

### Seminário

- Os temas vêm da entrada `T` do plano, separados por `"; "`.
- Coluna simples, em duas páginas. O `deck.punctuated` põe o `;` e o ponto final em cada página.
- A data do seminário já está na tabela de datas.

```typ
#let seminario = conteudo.find(x => x.at("grade", default: none) == "T")
#let temas = seminario.topics.at(0).split("; ")

== Seminário ($T$)
Os demais tópicos da ementa são estudados pelos discentes e apresentados em seminários:

#deck.punctuated(temas.slice(0, 4))

---

#deck.punctuated(temas.slice(4))

#note[Os temas e a formação dos grupos serão definidos de acordo com o número de inscritos na disciplina.]
```

### Créditos, no fim do deck

O slide "Créditos das imagens" fica no fim do deck, antes do "Fim!", não nesta Parte. Uma linha por imagem de fora, no tamanho do corpo; as capas podem dividir uma linha.

```typ
== Créditos das imagens
- Capas da bibliografia básica: editora, fonte com link.
- Google Classroom: captura de tela da turma.
- Meme: autor, licença, fonte.
```

## Conferir

- Em Sinais e Sistemas, a Parte tem 26 páginas, da seção ao seminário.
- O `verificar_deck.py` dá 0 bloqueio e um REVISAR. É a Unidade V: 41 palavras, mas são os 4 tópicos do plano, que cabem numa página ("cerca de 40", regra 1).
- Na folha de contato, confira:
  - cada pílula de unidade numa linha;
  - os rótulos do `deck.stats` em maiúsculas, no tamanho do corpo;
  - a terceira capa centralizada.
- Pendências para o professor:
  - sala, contato e horário de atendimento, se ele quiser (não estão no plano);
  - a divisão da ementa por domínio;
  - o `figures/diagrams/mapa-do-curso.typ`, se a disciplina ainda usar um mapa com letra pequena;
  - o crédito de cada capa de livro, no slide "Créditos das imagens".
