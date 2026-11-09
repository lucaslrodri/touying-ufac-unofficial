# Padrões do tema touying-ufac-unofficial 0.3.0

Pastas, sintaxe, componentes e armadilhas para escrever o deck, nos dois modos. O tema é o mesmo; o que muda de um modo para o outro vem em "Aula" e "Acadêmico". Todo trecho foi compilado (Typst 0.15.1, touying 0.7.4, tema 0.3.0) nas pastas da seção 1. As regras do `SKILL.md` mandam; nada aqui as contraria.

## 1. Pastas e arquivos

Cada coisa tem a sua pasta (regra 6): o deck tem o texto dos slides, e as figuras, os dados e as imagens ficam fora dele.

### Aula

Uma pasta por disciplina, que é a raiz da compilação, e um deck por assunto:

```
sinais-e-sistemas/               a raiz: typst compile --root .. slide-NN.typ, da pasta do deck
├── common.typ                   o que vários decks usam: o plano, o estilo dos gráficos
├── data/
│   └── sinais-e-sistemas-plano.json
└── slide-01/
    ├── slide-01.typ             o deck
    ├── header.typ               só se o deck tiver uma função grande que só ele usa
    ├── plano-de-aula.md
    ├── figures/
    │   ├── graphs/pulso.typ
    │   └── diagrams/mapa-do-curso.typ
    └── assets/
        ├── fotos/sol.jpg
        ├── icones-ph.json
        └── meme.svg
```

- O `common.typ` traz o que vários decks da disciplina usam: os dados do plano de curso (`#let plano = json("/data/<disciplina>-plano.json")`) e as funções grandes, como o estilo dos gráficos de sinal (no modelo, `grafico(..)`). Se a disciplina ainda não tem um, copie `templates/aula/common.typ`.
- O `header.typ` do deck só existe se o deck tiver uma função grande que nenhum outro usa (regra 3). Se outro deck passar a usá-la, ela vai para o `common.typ`.
- Os dados ficam no `data/` da disciplina, não no deck.

### Acadêmico

Uma pasta por apresentação, que é a raiz da compilação:

```
defesa/                          a raiz: typst compile deck.typ, desta pasta
├── deck.typ                     o deck
├── header.typ                   só se houver uma função grande
├── referencias.bib              só as obras da apresentação
├── plano-da-apresentacao.md
├── data/
│   └── soc.csv
├── figures/
│   ├── graphs/soc.typ
│   └── diagrams/ensaio.typ
└── assets/
    └── fotos/
```

- Não há `common.typ`: a apresentação é um deck só, e a função grande (o estilo de um circuito, por exemplo) vai no `header.typ`.
- Os dados de cada figura vêm do trabalho: o CSV vai para `data/`, nunca os números copiados à mão.

### O arquivo de uma figura

Toda figura feita em Typst é um arquivo seu, em `figures/<tipo>/<nome>.typ`: `graphs/` (lilaq), `diagrams/` (fletcher), `drawings/` (CeTZ) e `circuits/` (zap, em `references/zap.md`). O slide só inclui o arquivo:

```typ
== O ensaio em três etapas
#align(center, include "figures/diagrams/ensaio.typ")

Uma célula de 2,5 Ah descarrega a 0,75 A por 120 min.
```

Com legenda, `#figure(include "figures/diagrams/ensaio.typ", caption: [..])`. O mesmo arquivo pode entrar em vários slides.

- O arquivo importa o que usa: o tema (`colors`), o pacote do desenho e, se houver, a função grande do `header.typ` ou do `common.typ`, pelo nome.
- É só a figura: o texto que diz o que olhar e a legenda ficam no slide.
- O `#zero.set-num(..)` de um gráfico com vírgula decimal vai dentro do arquivo dele.
- Os caminhos dentro do arquivo partem da raiz (com `/`) ou da pasta do próprio arquivo (sem `/`):

| Dentro de `figures/<tipo>/<nome>.typ` | Aula | Acadêmico |
|---|---|---|
| a raiz da compilação | a pasta da disciplina | a pasta da apresentação |
| os dados | `/data/<arquivo>` | `/data/<arquivo>` |
| as funções da disciplina | `/common.typ` | não há |
| as funções do deck | `../../header.typ` | `/header.typ` |
| uma imagem do deck | `../../assets/<arquivo>` | `/assets/<arquivo>` |

As imagens prontas (fotos, capturas, o meme, o JSON dos ícones) ficam em `assets/` e entram no deck pelo caminho a partir dele: `image("assets/fotos/sol.jpg")`.

## 2. Esqueleto e capa

Parta do modelo do modo: `templates/aula/slide-01/slide-01.typ` ou `templates/academico/deck.typ`.

### Aula

A ordem é: imports, `#show: ufac-theme.with(..)`, capa, roteiro, Partes (`=`), "Créditos das imagens" e "Fim!". No deck da primeira unidade, a apresentação do curso é a primeira Parte (`references/aula/apresentacao-do-curso.md`).

| `config-info(..)` | Onde aparece |
|---|---|
| `flavor: "lecture"` (o padrão) | capa de aula |
| `subject`, `subject-code` | título e etiqueta amarela da capa; rodapé |
| `unit`, `unit-title` | linha amarela ("Unidade I") e linha branca (o assunto) da capa |
| `semester`, `author` | capa e rodapé |
| `counter-prefix: [1.]` | "Exemplo 1.N", "Exercício 1.N": use o número da unidade |

### Acadêmico

A ordem é: imports, `#show: ufac-theme.with(..)`, capa, roteiro, Partes (`=`), "Agradecimentos", "Referências", "Créditos das imagens" (se houver imagem de fora), `#ending-slide`, `#show: appendix` e os slides de reserva.

| Trabalho | `config-info(..)` | O que a capa mostra |
|---|---|---|
| defesa de TCC | `flavor: "tcc"`, `title`, `course` (o curso), `author`, `date`, `contact` | a etiqueta "Trabalho de Conclusão de Curso", o título, o curso e, no alto à direita, o discente e os orientadores |
| defesa de mestrado ou de doutorado | `flavor: "dissertation"` ou `"thesis"`, com `course` sendo o programa | a etiqueta "Dissertação de Mestrado" ou "Tese de Doutorado" |
| qualificação | o `flavor` da defesa e `short-title: [Exame de qualificação]` | a etiqueta trocada |
| trabalho de disciplina | `flavor: "coursework"`, `subject`, `subject-code`, `unit-title` (o título do trabalho), `author`, `semester` ou `year` | os alunos e o professor em grupos, embaixo à esquerda |

```typ
#show: ufac-theme.with(
  aspect-ratio: "16-9",
  config-info(
    flavor: "dissertation",
    short-title: [Exame de qualificação],
    title: [Um título de dissertação],
    course: [Programa de Pós-Graduação em Exemplo],
    author: [_Mestrando_ \ Nome \ _Orientadora_ \ Profa. Dra. Nome],
    date: [Março de 2027],
    contact: [`nome@sou.ufac.br`],
  ),
)

#title-slide()
```

- **Autores:** em conteúdo livre, cada linha só em itálico é um rótulo de grupo (`_Discente_`, `_Orientador_`, `_Coorientadora_`). O rodapé e os metadados do PDF levam só o primeiro grupo, quem apresenta.
- **Estilo da capa:** `ufac-theme.with(cover-style: "plain")` tira as bolhas da capa e do encerramento, se o programa pedir sobriedade; `"gradient"` escurece o azul num degradê e mantém as bolhas.
- **Roteiro:** numa fala de até 10 minutos, ele pode sair.

### Nos dois modos

- Dar um campo com dois nomes (`subject` e `title`, `semester` e `date`) é erro de compilação.
- **Nada que gere conteúdo antes da capa:** um `#zero.set-num(..)`, um `#provide-icons(..)` ou um texto solto antes do `#title-slide` abre uma página em branco. `#import` e `#let` podem ficar ali.
- **Ícones Phosphor** (`"ph:nome-bold"`): o `provide-icons` vai **dentro** da capa, `#title-slide[#provide-icons(json("assets/icones-ph.json"))]`.
- **Roteiro:** `== Roteiro` e `#outline()`, que lista as Partes; com muitas Partes, `#columns(2, gutter: 2em, outline())`.
- Nenhum `#set text(size: ..)` nem `#show figure.caption: set text(..)` no deck.

## 3. Estrutura: `=`, `==`, `===`, `---`

```typ
= Energia de um sinal
#image("assets/fotos/sol.jpg")

== Exemplos de sinais
=== Circuito RC
A tensão no capacitor varia com o tempo.

---

=== Automóvel
A velocidade varia com a força do motor.
```

- **`=` Parte:** "PARTE N" e o título. Tudo até o próximo `==` vai para o quadro da direita (12em × 66% da altura). Uma imagem sem tamanho preenche o quadro. Ponha só a imagem ali, nenhum texto. Um ícone grande também serve: `#icon("ph:wave-sine-bold", size: 6em)` ou `#icon("info", size: 6em)`.
  - Na aula, o nome é de assunto, nunca de encontro (regra Aula 3).
  - No acadêmico, o nome é a etapa do argumento (Introdução, Metodologia, Resultados, Conclusões), não o número do capítulo (regra Acadêmico 2), e uma foto ou figura do próprio trabalho é a melhor imagem para o quadro.
- **`==` slide:** título de até 60 caracteres. Acima de ~65, o tema encolhe o título, o que viola a regra 2. `==` sem texto dá um slide sem título. No acadêmico, nos resultados, o título é o achado (regra Acadêmico 3).
- **`===` pílula:** é repetida em cada continuação, até a próxima `===`. A `====` não se repete, nem a pílula posta dentro de `cols`, `grid` ou de uma caixa.
- **`---`** sozinho na linha (ou `#pagebreak()`): a próxima página do mesmo slide. Ela mantém o título e a pílula; num exemplo ou exercício, também a caixa e o número.

## 4. Exemplo e exercício

```typ
== Sinal constante <example-constante>
Calcule $P_infinity$ de $x[n] = 4$.

#pause
#solution
$ P_infinity = lim_(N -> infinity) 1 / (2N + 1) sum_(n = -N)^N 4^2 = 16 $

== Rampa deslocada <exercise-rampa>
Esboce $x(t) = r(t + 1) - 2 r(t) + r(t - 1)$ e escreva $x(t)$ por partes.

---

#answer
Somando as rampas em cada intervalo:
$ x(t) = cases(t + 1\, quad & -1 <= t < 0, 1 - t\, quad & 0 <= t < 1, 0\, quad & "fora") $
```

- `<example>` dá a caixa verde com "Exemplo 1.N" e o título. `<exercise>` dá a caixa vermelha com "Exercício 1.N". Cada um tem seu contador.
- Com sufixo no rótulo (`<exercise-rampa>`), o slide pode ser citado: `#remark[No @exercise-rampa, três rampas formaram um triângulo.]` mostra "Exercício 1.1", com link.
- `#solution` e `#answer` ficam sozinhos na linha. Fora de um exemplo ou exercício, não aparecem.
- **Exemplo:** a solução fica no mesmo slide. Um `#pause` antes dela deixa a turma tentar primeiro: o que vem depois dele fica escondido até o passo seguinte. Se a solução não couber, `---` antes do `#solution`.
- **Exercício:** sempre `---` antes do `#answer`, e a resposta mostra o desenvolvimento.
- A forma de função, `#exercise-slide(title: [..])[..]` ou `#example-slide(..)[..]`, troca a cor ou o ícone (`color:`, `icon:`). Dentro do corpo, `---` e `#answer` funcionam igual, mas o slide não pode ser citado com `@`.

### Aula

Toda questão para o aluno é exercício discursivo, e todo caso que o professor resolve é exemplo (regras Aula 1 e Aula 2). A ordem de cada assunto está em `references/aula/pedagogia.md`.

### Acadêmico

Os dois existem no tema e, nos tipos acadêmicos, saem sem prefixo ("Exemplo 1"). Use só se o trabalho pede, como um caso resolvido num trabalho de disciplina.

## 5. Componentes

### Callouts

| Callout | Usar para | Não usar para |
|---|---|---|
| `#caution[..]` "Atenção!", vermelho | na aula, um erro a evitar; no acadêmico, uma limitação do trabalho, uma ameaça à validade, um cuidado | uma definição; o resultado principal |
| `#tip[..]` "Dica.", verde | um atalho (raro numa defesa) | conteúdo obrigatório, logística |
| `#remark[..]` "Relembrando.", azul | retomar o já visto, pelo nome ou por `@example-..`; no acadêmico, o objetivo que o resultado responde, uma figura anterior | fato novo; o que vem adiante |
| `#note[..]` "Nota.", cinza | algo secundário, ou o que vem adiante; no acadêmico, um detalhe do ensaio, o próximo passo | o ponto principal; "na próxima aula" |
| `#example[..]`, `#examples[..]`, verde | exemplo curto num slide comum, sem número | exemplo resolvido (`<example>`); a evidência de um resultado |

```typ
// aula
#tip(icon: "ph:lightning-bold")[Comece pelo intervalo onde $x(t) != 0$.]
#caution[Dois erros comuns:

  -> trocar $x(t)$ por $x[n]$;
  -> esquecer o módulo.
]

// acadêmico
#caution[O ensaio usou uma célula só, a 25 °C.]
#remark[Objetivo 2: comparar a contagem de Coulomb com o filtro de Kalman.]
```

- Um callout por slide (dois, se curtos): ele complementa, não é o conteúdo. Ele não se divide; se não couber no resto da página, vai inteiro para a seguinte.

### `emph-box`

| Cor (convenção do tema) | Na aula | No acadêmico |
|---|---|---|
| padrão (`colors.primary`) | definição, notação, o que é retomado | objetivo, pergunta de pesquisa, hipótese, definição |
| `colors.quaternary` | vantagem | contribuição, vantagem |
| `colors.tertiary` | problema | problema, lacuna |
| `colors.secondary-dark` | nota lateral; em Sinais e Sistemas, o par discreto | nota lateral; o segundo caso de uma comparação |

```typ
// aula
#emph-box(title: [Definição])[Um sinal é uma função do tempo.]
#grid(columns: (1fr, 1fr), gutter: 1.2em,
  emph-box(icon: "ph:wave-sine-bold", title: [Tempo contínuo])[$x(t)$, com $t in RR$],
  emph-box(color: colors.secondary-dark, icon: "ph:chart-bar-bold", title: [Tempo discreto])[$x[n]$, com $n in ZZ$],
)

// acadêmico
#grid(columns: (1fr, 1fr), gutter: 1.2em,
  emph-box(color: colors.tertiary, title: [Problema])[A contagem acumula o erro do sensor.],
  emph-box(color: colors.quaternary, title: [Contribuição])[Um filtro que corrige a contagem pela tensão.],
)
```

- **Usar para:** definição, notação, objetivo, um par para comparar (lado a lado em `grid`), um cartão de informação.
- **Não usar para:** envolver o slide inteiro; mais de 3 caixas por slide; caixa feita à mão (`block(stroke: ..)`).
- Use `secondary-dark`, nunca o `secondary` puro, ilegível como texto. Caixas lado a lado só ficam da mesma altura se o texto tiver o mesmo número de linhas.

### Atalho `>` e `eq-box`

```typ
> == Definição
> Um sinal é uma função do tempo.

> $ E_infinity = integral_(-infinity)^(+infinity) |x(t)|^2 dif t $

$ P = #eq-box[$1 / N sum_n |x[n]|^2$] $
```

- `>` com texto dá uma caixa azul, só com conteúdo em linha (para uma lista, use `emph-box`). `> == Título` põe o selo.
- `>` antes de uma equação em bloco dá o `eq-box`. `#eq-box[$..$]` dentro da equação moldura só uma parte; `color:` troca a cor.
- **Usar para:** o resultado que o aluno deve guardar, ou a equação que o público da defesa precisa guardar (o modelo, a métrica), uma por slide. **Não usar para:** passos intermediários.

### `cols` e `grid`

```typ
#grid(columns: (1fr, 1.2fr), gutter: 1.2em, align: horizon)[

  -> Cresce com inclinação 1;
  -> é a integral do degrau.
][
  #image("assets/fotos/lua.jpg", height: 8em)
]
```

- `#cols(columns: (1fr, 1.2fr), gutter: 1.2em)[..][..]` divide o slide; `divider: true` põe uma divisória azul. Uma coluna de metade comporta ~6 palavras por linha.
- **Usar para:** texto ao lado de figura; dois casos lado a lado (o par contínuo e discreto). **Não usar para:** três colunas de texto.
- Para centralizar na vertical, use `grid` com `align: horizon`, nunca `#v(1fr)` dentro de `cols`.

### Termos, `tag` e destaques

- **Termos:** `/ $E_infinity$: energia em todo o tempo`, um por linha. Servem para a legenda de símbolos, os pesos de avaliação e os parâmetros de um ensaio, não para frases longas.
- **`tag`:** `Diagramas de fluxo de sinal. #tag[seminário]` ou `Filtro de Kalman #tag[proposto]` (13.2pt). Uma palavra que marca um item; nunca informação que o público precisa ler, nem título.

| Escrita | Resultado | Para |
|---|---|---|
| `*termo*` | negrito (na cor da caixa, dentro dela) | um termo novo |
| `_texto_` | itálico | ênfase leve, título de obra, termo estrangeiro |
| `~~texto~~` ou `#alert[..]` | negrito na cor da caixa (azul fora dela) | **o** termo-chave do slide |
| `==texto==` ou `#highlight[..]` | fundo amarelo-claro | o que olhar primeiro |
| `#primary[..]`, `#tertiary[..]`, `#quaternary[..]` | negrito na cor | rótulo ligado a uma cor ("#tertiary[Problema:]") |

Destaque com parcimônia: no máximo um por slide, nunca num item curto nem num tópico, e sem espaço nas pontas.

### Setas e listas

```typ
O degrau tem duas propriedades.

-> vale 0 antes de $t = 0$;
-> vale 1 depois.
```

- `-` dá um marcador amarelo, `+` uma lista numerada (no acadêmico, os objetivos específicos e as conclusões) e `->` uma seta azul. No máximo 5 itens (regra 1).
- A lista de setas começa um parágrafo: deixe uma linha em branco antes dela depois de texto, no começo de uma célula de `grid` e dentro de um callout. No começo de uma coluna de `cols` ou de um `emph-box`, ela funciona sem a linha em branco.

### Ícones e cores

- **Do tema** (sem `provide-icons`): `"caution"`, `"tip"`, `"info"`, `"note"`, `"remark"`, `"exercise"`, `"example"`.
- **Phosphor:** `"ph:nome-bold"`, do JSON em `assets/icones-ph.json`, passado ao `provide-icons` dentro da capa. Um ícone que não está no JSON dá erro de compilação com o nome dele. Para usá-lo, baixe-o de `https://api.iconify.design/ph.json?icons=a,b` e acrescente-o ao JSON.
- Ícone vai no selo de `emph-box`, no callout (`icon:`), na pílula (`=== #icon("ph:wave-sine-bold") Título`) ou na figura da Parte, e o mesmo assunto tem sempre o mesmo ícone. Não decore cada linha.
- **Cores:** só `colors.*`, nunca `rgb()` nem hexadecimal. São as famílias `primary` (azul), `secondary` (amarelo), `tertiary` (vermelho), `quaternary` (verde) e `neutral`, cada uma com os tons `-darkest`, `-darker`, `-dark`, base, `-light`, `-lighter` e `-lightest`. Traço e texto usam a base ou um tom escuro; fundo, `-lighter` ou `-lightest`.

| Papel | Cor |
|---|---|
| principal, definição, tensão; o sinal principal ou o método proposto num gráfico | `primary` |
| exercício, `#caution`, problema, corrente; o erro, o método que perde | `tertiary` |
| exemplo, `#tip`, vantagem, a contribuição | `quaternary` |
| segundo sinal, segundo caso, destaque, par discreto | `secondary-dark` |
| referência, eixos | `neutral-dark`, `neutral-darker` |

A mesma cor tem o mesmo papel no deck todo: se o método proposto é azul no gráfico, ele é azul na tabela e no texto.

### Tabelas

```typ
#align(center, table(columns: 3,
  table.header([Método], [Erro máximo], [Erro em 120 min]),
  [Contagem de Coulomb], [5,3%], [5,3%],
  table.cell(fill: colors.secondary-lighter)[*Filtro de Kalman*],
  table.cell(fill: colors.secondary-lighter)[*0,6%*],
  table.cell(fill: colors.secondary-lighter)[*0,5%*],
))
```

- Uma tabela longa (um cronograma) continua na página seguinte com o cabeçalho repetido, ou se divide com `---`; a letra nunca diminui. Para comparar dois casos, prefira duas `emph-box` lado a lado.
- No acadêmico, a tabela do texto não entra inteira: só as linhas e colunas que sustentam a mensagem do slide, com a linha do método proposto em destaque (regra 1). A tabela completa vai para a reserva. Os números são os do texto, com a mesma unidade e o mesmo arredondamento (regra Acadêmico 1).

## 6. Figuras, fotos e créditos

```typ
#figure(image("assets/fotos/lua.jpg", height: 8em), caption: [O brilho da Lua: um sinal de duas variáveis])
```

- A legenda sai a 0.6 do corpo (13,2pt), pelo tema, e só com o texto, sem "Figura N": escreva uma linha curta. Não mude o tamanho dela com `show figure.caption`.
- A legenda diz o que a figura mostra, nunca de onde ela veio: nada de "Fonte:", "Adaptado de" ou "Redesenhado de", nem na legenda nem no slide (regra 7).
- **Leva crédito** só a imagem tirada inteira de fora: foto, captura de tela, capa de livro, meme. O crédito (autor, licença, fonte com link) vai no slide "Créditos das imagens", no fim (seção 12), no tamanho do corpo.
- **Não leva crédito** o desenho do autor, nem a figura refeita a partir dos dados ou da figura de outro trabalho. No acadêmico, a obra de que vêm os dados entra nas Referências (seção 9); na aula, não há referência.
- Gráfico, circuito e diagrama de blocos não entram como imagem de outro lugar: refaça com lilaq, zap ou fletcher, num arquivo de `figures/` (regras 4 e 6). Foto, mapa e captura de tela entram como imagem, de `assets/`.
- A foto e os créditos se escrevem no slide, com `image` e o caminho de `assets/`, mesmo que se repitam; nada de função para a foto nem para a lista de créditos (regra 3). Cantos arredondados, se quiser: `box(radius: 6pt, clip: true, image(..))`.

## 7. Gráficos (lilaq)

Cada gráfico é um arquivo em `figures/graphs/<nome>.typ` (seção 1), que lê os dados de `data/` ou calcula a curva. O slide inclui o arquivo e traz, embaixo, a frase do que olhar.

### Aula

Use o estilo de gráfico do `common.typ` da disciplina. No modelo (`templates/aula/common.typ`), é a função `grafico(..)`, com os eixos pela origem e sem grade:

```typ
// figures/graphs/pulso.typ: o pulso retangular do exemplo, no estilo da disciplina.

#import "@preview/lilaq:0.6.0" as lq
#import "/common.typ": grafico

#grafico(
  xlim: (-2.5, 2.5),
  ylim: (-0.5, 4),
  lq.plot((-2.5, -1, -1, 1, 1, 2.5), (0, 0, 3, 3, 0, 0), mark: none, stroke: 2pt),
)
```

- Se a disciplina não tem estilo de gráfico, use o lilaq direto, como no acadêmico. Um estilo que vários decks repetem vira uma função grande no `common.typ` (regra 3).
- Se o estilo do `common.typ` reduz a letra (números a 13.6pt, rótulos a 17pt), passe o tamanho no uso, se a função deixar, ou proponha ao professor ajustá-la, em vez de contornar com outro gráfico no deck (regra 2).
- Num gráfico de sinal, prefira a legenda, ou o rótulo na ponta do eixo, ao `ylabel` girado 90°.

### Acadêmico

Leia os dados do arquivo do trabalho, nunca copie os números à mão:

```typ
// figures/graphs/soc.typ: o estado de carga no ensaio, lido de data/soc.csv.

#import "@preview/touying-ufac-unofficial:0.3.0": colors
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/zero:0.6.1"

#zero.set-num(decimal-separator: ",")

#let soc = csv("/data/soc.csv", row-type: dictionary).map(r => r.keys().map(k => (k, float(r.at(k)))).to-dict())

#lq.diagram(
  width: 14cm, height: 6cm,
  xlabel: [Tempo (min)], ylabel: [SoC (%)],
  legend: (position: top + right),
  lq.plot(soc.map(r => r.tempo), soc.map(r => r.real), mark: none, stroke: 2pt + colors.neutral-dark,
    label: [Referência]),
  lq.plot(soc.map(r => r.tempo), soc.map(r => r.contagem), mark: none,
    stroke: (paint: colors.tertiary, thickness: 2pt, dash: "dashed"), label: [Contagem]),
  lq.plot(soc.map(r => r.tempo), soc.map(r => r.kalman), mark: "o", mark-size: 6pt, stroke: none,
    color: colors.primary, label: [Kalman]),
)
```

```typ
== O filtro de Kalman fica a menos de 1% da referência
#align(center, include "figures/graphs/soc.typ")

A maior distância do Kalman à referência foi de 0,6%.
```

- Eixo com grandeza e unidade (`[Tempo (min)]`). O `ylabel` sai girado 90°; num gráfico de resultado, ele fica.
- Duas séries que quase coincidem (o resultado é justamente isso): uma delas com marcadores (`mark: "o"`, `stroke: none`).
- Sem os dados (só uma imagem do gráfico), peça os dados ao autor. Se a imagem ficar, confira no PNG que os números e os rótulos têm o tamanho do corpo; senão, a figura é refeita na origem com letra maior.

### Nos dois modos

- O lilaq direto põe números e rótulos no tamanho do corpo. A largura fica entre 10 e 14cm; o texto não muda com o tamanho.
- O `#zero.set-num(decimal-separator: ",")` vai dentro do arquivo do gráfico, nunca antes da capa.
- O texto que diz o que olhar vai no corpo do slide, embaixo, não dentro do gráfico.
- No lilaq 0.6.0, `lq.plot-function` não existe: para uma curva teórica, use `lq.plot(lq.linspace(a, b), t => .., mark: none)`.

## 8. Diagramas (fletcher) e desenhos (CeTZ)

```typ
// figures/diagrams/ensaio.typ: o método como fluxo, nas cores do tema.

#import "@preview/touying-ufac-unofficial:0.3.0": colors
#import "@preview/fletcher:0.5.8": diagram, node, edge

#diagram(
  edge-stroke: 1.6pt + colors.neutral-dark,
  spacing: 3em,
  node((0, 0), [Descarga], name: <a>, stroke: 1.4pt + colors.primary, fill: colors.primary-lightest,
    corner-radius: 6pt, inset: .6em),
  node((1, 0), [Medição], name: <b>, stroke: 1.4pt + colors.primary, fill: colors.primary-lightest,
    corner-radius: 6pt, inset: .6em),
  node((2, 0), [Estimação], name: <c>, stroke: 1.4pt + colors.primary, fill: colors.primary-lightest,
    corner-radius: 6pt, inset: .6em),
  edge(<a>, <b>, "-|>"),
  edge(<b>, <c>, "-|>"),
)
```

- O fluxo do método e os diagramas de blocos são feitos com fletcher, em `figures/diagrams/`; desenhos, com CeTZ, em `figures/drawings/`; circuitos, sempre com zap, em `figures/circuits/` (`references/zap.md`).
- O estilo de cada nó se escreve nele, mesmo que se repita, como acima (regra 3). Uma função de estilo só se o código for grande: no `header.typ` do deck ou, na aula, se vários decks a usam, no `common.typ`.
- CeTZ: `#import "@preview/cetz:0.5.2"` e `cetz.canvas(length: 1.4em, { import cetz.draw: *; .. })`; com `length` em `em`, o desenho acompanha a letra. Rótulos sem `size:` e traços em `colors.*`.
- Na aula, se um estilo do `common.typ` reduz a letra, passe o tamanho no uso, se a função deixar, ou proponha ao professor ajustá-lo, sem criar uma cópia no deck (regra 2).

## 9. Referências (só no acadêmico)

```typ
== Referências
#bibliography("referencias.bib", title: none, full: true, style: "associacao-brasileira-de-normas-tecnicas")
```

- **Nenhuma citação nos slides:** nada de `@chave`, e a legenda não leva fonte (regra 7). A obra aparece só neste slide.
- **O `referencias.bib` é da apresentação:** só as obras de que vem um dado, uma equação, uma frase ou uma figura refeita (regra Acadêmico 1), copiadas do `.bib` do texto, com as mesmas chaves. O `.bib` inteiro da monografia não entra.
- **`full: true` é obrigatório:** ele lista o `.bib` inteiro. Sem ele, a lista sai vazia, sem erro nem aviso, porque nenhum slide cita.
- **Uma `#bibliography` só**, com `title: none` (o slide já tem título).
- Uma lista longa continua sozinha na página seguinte, com a letra no corpo; nunca diminua a letra das referências.
- Na aula não há referência bibliográfica (regra 7). A bibliografia da disciplina, na apresentação do curso, é conteúdo do plano (`references/aula/apresentacao-do-curso.md`).

## 10. Quanto cabe num slide 16:9 sem diminuir a letra

O corpo tem 22pt. A área útil é de 763 × 364pt num slide comum e de 745 × 336pt num exemplo ou exercício.

| Conteúdo | Cabe | Transborda a partir de |
|---|---|---|
| parágrafos de uma linha | 10 (9 com pílula) | 11 |
| itens `-` ou setas `->` | 13 (12 com pílula, ou num exemplo ou exercício) | 14 |
| texto corrido (~13 palavras por linha) | ~150 palavras | 170 |
| título `==` | ~65 caracteres | 70 (já reduzido) |
| meme no "Fim!" | `height: 14em` | `16em` |

Esses números são o teto. O alvo é a regra 1: até ~40 palavras ou 5 itens; com figura ao lado, até 3 itens curtos; uma equação em destaque; no máximo um callout. O que passar disso vira outro slide; no acadêmico, também pode ir para a reserva.

## 11. Armadilhas confirmadas

| Sintoma | Causa | Correção |
|---|---|---|
| Página em branco antes da capa | `#zero.set-num`, `#provide-icons` ou texto antes do `#title-slide` | O `set-num` no arquivo do gráfico; o `provide-icons` dentro da capa |
| O slide quebra no meio de uma frase | Travessão ao lado de `*`, `_`, `~~` ou `$` vira o `---` de quebra | Dois-pontos ou meia-risca `–`; nunca travessão |
| `->` aparece cru | A seta não começa um parágrafo | Linha em branco antes (depois de texto, em célula de `grid`, em callout) |
| O que vem depois de `cols` foi para outra página | `#v(1fr)` dentro de `cols` | `grid(.., align: horizon)` |
| Continuação com 1 ou 2 linhas | Conteúdo maior que a área útil: o tema abre a página sozinho | Quebre à mão com `---` ou abra outro `==` |
| Um callout pula inteiro de página | O callout não se divide | Menos texto antes dele, ou um slide para ele |
| Um título menor que os outros | Título com mais de ~65 caracteres | Até 60 caracteres |
| Uma frase virou caixa azul | `>` no começo do parágrafo | `$x > 0$` ou `\>` |
| Uma frase entre aspas virou citação | Parágrafo feito só de uma citação | Texto fora das aspas, ou `\"..\"` |
| Texto à direita do slide de Parte | Tudo entre `=` e `==` vai para o quadro da Parte | Só a imagem depois do `=` |
| `== realce==` abriu um slide | `==` com espaço no começo da linha é título | `==realce==` sem espaço, ou `#highlight[..]` |
| `#solution` ou `#answer` não aparece | Está fora de `<example>` ou `<exercise>` | Ponha-o dentro do item |
| O `(t)` foi para o subscrito | `$v_s(t)$` | `$v_s (t)$` |
| Erro "file not found" num arquivo de `figures/` | Caminho sem `/` parte da pasta do arquivo: `"data/soc.csv"` vira `figures/graphs/data/soc.csv` | `/data/soc.csv`; na aula, os arquivos do deck por `../../` (seção 1) |
| Erro "unknown variable: colors" (ou `grafico`, `lq`) num arquivo de `figures/` | O arquivo não importou o que usa | O import no próprio arquivo: `#import "@preview/touying-ufac-unofficial:0.3.0": colors` |
| Duas curvas viraram uma | As séries quase coincidem | Marcadores numa delas (`mark: "o"`, `stroke: none`) |
| O slide "Referências" sai vazio | `#bibliography` sem `full: true`: nenhum slide cita | `full: true` |
| "Fim!" sozinho e o meme na página seguinte | Meme alto demais | `height: 12em` (até 14em) |
| "Obrigado!" no fim de uma aula | É o título padrão de `#ending-slide()` | `#ending-slide(title: [Fim!])[..]` |
| A reserva sem marca, contada no total do Touying | Slides depois do encerramento sem `#show: appendix` | `#show: appendix` logo depois do `#ending-slide` |

## 12. Encerramento

### Aula: "Créditos das imagens" e "Fim!" com meme

```typ
== Créditos das imagens
- Sol: NASA/SDO (AIA), domínio público, #link("https://commons.wikimedia.org/wiki/File:The_Sun_by_the_Atmospheric_Imaging_Assembly_of_NASA%27s_Solar_Dynamics_Observatory_-_20100819.jpg")[Wikimedia Commons].
- Meme: autor, licença, fonte.

#ending-slide(title: [Fim!])[#image("assets/meme.svg", height: 12em)]
```

- **Créditos das imagens:** uma linha por imagem tirada inteira de fora (foto, captura, capa de livro, o meme), escrita no slide e no tamanho do corpo. Desenho próprio ou refeito não entra (regra 7).
- **"Fim!":** a página azul com "Fim!" e o meme no corpo. Não leva subtítulo, "Obrigado!", contato nem a próxima aula (regra Aula 4).
- Antes, traga ao professor candidatos a meme, cada um com link e crédito. O escolhido fica em `assets/meme.png` (ou `.svg`), e o crédito dele vai no slide de créditos.

### Acadêmico: Agradecimentos, Referências, Créditos, encerramento e reserva

```typ
== Agradecimentos
-> À agência de fomento, pela bolsa (processo nº 0000/2026);
-> Ao laboratório, pelo ensaio das células.

== Referências
#bibliography("referencias.bib", title: none, full: true, style: "associacao-brasileira-de-normas-tecnicas")

== Créditos das imagens
- Célula de lítio: autor, licença, fonte com link.

#ending-slide[Obrigado!][Perguntas?][#info("contact")]

#show: appendix

== Por que um circuito equivalente de primeira ordem?
-> Um par RC reproduz a tensão do ensaio com erro menor que 10 mV;
-> Um segundo par RC não reduziu o erro do SoC.
```

- **Agradecimentos:** a agência de fomento e o número do processo, quando houver (a agência costuma exigir a menção); pessoas, só se o autor pedir.
- **Referências:** o `referencias.bib` inteiro, com `full: true` (seção 9).
- **Créditos das imagens:** só se o deck tiver foto, captura ou outra imagem tirada inteira de fora; uma linha por imagem, no tamanho do corpo. Figura refeita do trabalho ou de outro não entra.
- **Encerramento:** "Obrigado!", "Perguntas?" e o contato (`#info("contact")`, do `contact` do `config-info`). Sem meme.
- **Reserva:** depois de `#show: appendix`, um slide por pergunta prevista no plano, com a pergunta no título, para achar rápido. O rodapé continua numerando (a banca pode pedir "volta no slide 19"); o `appendix` marca o começo da reserva e congela o total do Touying no encerramento. A reserva não entra no tempo nem no roteiro (não use `=` nela).
