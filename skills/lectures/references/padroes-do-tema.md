# Padrões do tema touying-ufac-unofficial 0.3.0

Sintaxe, componentes e armadilhas para escrever o deck. Todo trecho foi compilado (Typst 0.15.1, touying 0.7.4). As regras do `SKILL.md` mandam; nada aqui as contraria. Os caminhos são os de um deck em `<curso>/slide-NN/`, compilado com `typst compile --root .. slide-NN.typ`.

## 1. Esqueleto do deck

Parta de `templates/deck.typ`. A ordem é: imports, `#show: ufac-theme.with(..)`, capa, roteiro, Partes (`=`), "Créditos das imagens" e "Fim!".

| `config-info(..)` | Onde aparece |
|---|---|
| `kind: "lecture"` | capa de aula |
| `subject`, `subject-code` | título e etiqueta amarela da capa; rodapé |
| `unit`, `unit-title` | linha amarela ("Unidade I") e linha branca (o assunto) da capa |
| `semester`, `author` | capa e rodapé |
| `counter-prefix: [1.]` | "Exemplo 1.N", "Exercício 1.N": use o número da unidade |

- Dar um campo com dois nomes (`subject` e `title`, `semester` e `date`) é erro de compilação.
- Capa: `#title-slide[#provide-icons(icones)]`. O `provide-icons` vai **dentro** da capa.
- Roteiro: `== Roteiro` e `#outline()`; com muitas Partes, `#columns(2, gutter: 2em, outline())`.
- Nenhum `#set text(size: ..)` nem `#show figure.caption: set text(..)` no deck.

## 2. Estrutura: `=`, `==`, `===`, `---`

```typ
= Energia de um sinal
#image("../assets/fotos/osciloscopio.jpg")

== Exemplos de sinais
=== Circuito RC
A tensão no capacitor varia com o tempo.

---

=== Automóvel
A velocidade varia com a força do motor.
```

- **`=` Parte:** "PARTE N" e o título. Tudo até o próximo `==` vai para o quadro da direita (12em × 66% da altura). Uma imagem sem tamanho preenche o quadro. Ponha só a imagem ali, nenhum texto. Um ícone grande também serve: `#icon("ph:wave-sine-bold", size: 6em)`. O nome é sempre de assunto.
- **`==` slide:** título de até 60 caracteres. Acima de ~65, o tema encolhe o título, o que viola a regra 2. `==` sem texto dá um slide sem título.
- **`===` pílula:** é repetida em cada continuação, até a próxima `===`. A `====` não se repete, nem a pílula posta dentro de `cols`, `grid` ou de uma caixa.
- **`---`** sozinho na linha (ou `#pagebreak()`): a próxima página do mesmo slide. Ela mantém o título e a pílula; num exemplo ou exercício, também a caixa e o número.

## 3. Exemplo e exercício

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
- **Exemplo:** a solução fica no mesmo slide. Um `#pause` antes dela deixa a turma tentar primeiro, mas o conteúdo coberto fica sob um véu claro, ainda visível. Se a solução não couber, `---` antes do `#solution`.
- **Exercício:** sempre `---` antes do `#answer`, e a resposta mostra o desenvolvimento.
- A forma de função, `#exercise-slide(title: [..])[..]` ou `#example-slide(..)[..]`, troca a cor ou o ícone (`color:`, `icon:`). Dentro do corpo, `---` e `#answer` funcionam igual, mas o slide não pode ser citado com `@`.

## 4. Componentes

### Callouts

| Callout | Usar para | Não usar para |
|---|---|---|
| `#caution[..]` "Atenção!", vermelho | um erro a evitar | uma definição |
| `#tip[..]` "Dica.", verde | um atalho | conteúdo obrigatório, logística |
| `#remark[..]` "Relembrando.", azul | retomar o já visto, pelo assunto ou por `@example-..` | fato novo; o que vem adiante |
| `#note[..]` "Nota.", cinza | algo secundário, ou o que vem adiante no assunto | o ponto principal; "na próxima aula" |
| `#example[..]`, `#examples[..]`, verde | exemplo curto num slide comum, sem número | exemplo resolvido (`<example>`) |

```typ
#tip(icon: "ph:lightning-bold")[Comece pelo intervalo onde $x(t) != 0$.]
#caution[Dois erros comuns:

  -> trocar $x(t)$ por $x[n]$;
  -> esquecer o módulo.
]
```

- Um callout por slide (dois, se curtos): ele complementa, não é o conteúdo. Ele não se divide; se não couber no resto da página, vai inteiro para a seguinte.

### `emph-box`

| Cor (convenção do tema) | Para |
|---|---|
| padrão (`colors.primary`) | definição, notação, o que é retomado |
| `colors.quaternary` | vantagem |
| `colors.tertiary` | problema |
| `colors.secondary-dark` | nota lateral; em Sinais e Sistemas, o par discreto |

```typ
#emph-box(title: [Definição])[Um sinal é uma função do tempo.]
#grid(columns: (1fr, 1fr), gutter: 1.2em,
  emph-box(icon: "ph:wave-sine-bold", title: [Tempo contínuo])[$x(t)$, com $t in RR$],
  emph-box(color: colors.secondary-dark, icon: "ph:chart-bar-bold", title: [Tempo discreto])[$x[n]$, com $n in ZZ$],
)
```

- **Usar para:** definição, notação, um par para comparar (lado a lado em `grid`), um cartão de informação.
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
- **Usar para:** o resultado que o aluno deve guardar, um por slide. **Não usar para:** passos intermediários.

### `cols` e `grid`

```typ
#grid(columns: (1fr, 1.2fr), gutter: 1.2em, align: horizon)[

  -> Cresce com inclinação 1;
  -> é a integral do degrau.
][
  #image("../assets/fotos/lua.jpg", height: 8em)
]
```

- `#cols(columns: (1fr, 1.2fr), gutter: 1.2em)[..][..]` divide o slide; `divider: true` põe uma divisória azul. Uma coluna de metade comporta ~6 palavras por linha.
- **Usar para:** texto ao lado de figura; o par contínuo/discreto. **Não usar para:** três colunas de texto.
- Para centralizar na vertical, use `grid` com `align: horizon`, nunca `#v(1fr)` dentro de `cols`.

### Termos, `tag` e destaques

- **Termos:** `/ $E_infinity$: energia em todo o tempo`, um por linha. Servem para a legenda de símbolos e os pesos de avaliação, não para frases longas.
- **`tag`:** `Diagramas de fluxo de sinal. #tag[seminário]` (13.2pt). Uma palavra que marca um item ("seminário", "prova"); nunca informação que o aluno precisa ler, nem título.

| Escrita | Resultado | Para |
|---|---|---|
| `*termo*` | negrito (na cor da caixa, dentro dela) | um termo novo |
| `_texto_` | itálico | ênfase leve, título de livro |
| `~~texto~~` ou `#alert[..]` | negrito azul | **o** termo-chave do slide |
| `==texto==` ou `#highlight[..]` | fundo amarelo-claro | o que olhar primeiro |
| `#primary[..]`, `#tertiary[..]`, `#quaternary[..]` | negrito na cor | rótulo ligado a uma cor ("#tertiary[Problema:]") |

Destaque com parcimônia: no máximo um por slide, nunca num item curto nem num tópico, e sem espaço nas pontas.

### Setas e listas

```typ
O degrau tem duas propriedades.

-> vale 0 antes de $t = 0$;
-> vale 1 depois.
```

- `-` dá um marcador amarelo, `+` uma lista numerada e `->` uma seta azul. No máximo 5 itens (regra 1).
- A lista de setas começa um parágrafo: deixe uma linha em branco antes dela depois de texto, no começo de uma célula de `grid` e dentro de um callout. No começo de uma coluna de `cols` ou de um `emph-box`, ela funciona sem a linha em branco.

### Ícones e cores

- **Do tema** (sem `provide-icons`): `"caution"`, `"tip"`, `"info"`, `"note"`, `"remark"`, `"exercise"`, `"example"`.
- **Do curso:** `"ph:nome-bold"`, da coleção Phosphor do JSON passado ao `provide-icons`. Um ícone que não está no JSON dá erro de compilação com o nome dele. Para usá-lo, baixe-o de `https://api.iconify.design/ph.json?icons=a,b` e acrescente-o ao JSON.
- Ícone vai no selo de `emph-box`, no callout (`icon:`), na pílula ou na figura da Parte, e o mesmo assunto tem sempre o mesmo ícone. Não decore cada linha.
- **Cores:** só `colors.*`, nunca `rgb()` nem hexadecimal. São as famílias `primary` (azul), `secondary` (amarelo), `tertiary` (vermelho), `quaternary` (verde) e `neutral`, cada uma com os tons `-darkest`, `-darker`, `-dark`, base, `-light`, `-lighter` e `-lightest`. Traço e texto usam a base ou um tom escuro; fundo, `-lighter` ou `-lightest`.

| Papel | Cor |
|---|---|
| principal, definição, sinal principal num gráfico, tensão | `primary` |
| exercício, `#caution`, problema, corrente | `tertiary` |
| exemplo, `#tip`, vantagem | `quaternary` |
| segundo sinal, destaque, par discreto | `secondary-dark` |
| referência, eixos | `neutral-dark`, `neutral-darker` |

### Tabelas

```typ
#table(columns: 3,
  table.header([Sinal], [$E_infinity$], [$P_infinity$]),
  [Pulso], [$18$], [$0$],
  [Constante], [$infinity$], table.cell(fill: colors.secondary-lighter)[*16*],
)
```

- Uma tabela longa (um cronograma) continua na página seguinte com o cabeçalho repetido, ou se divide com `---`; a letra nunca diminui. Para comparar dois casos, prefira duas `emph-box` lado a lado.

### Figuras, fotos e créditos

```typ
#figure(image("../assets/fotos/lua.jpg", height: 8em), caption: [O brilho da Lua: um sinal de duas variáveis])
```

- A legenda tem o tamanho do corpo (22pt) e só o texto, sem "Figura N": escreva uma linha curta.
- Toda imagem tem crédito (autor, licença, fonte com link) no slide "Créditos das imagens", antes do "Fim!", no tamanho do corpo. Figura redesenhada de um livro leva a fonte no próprio slide ("redesenhado da Figura 1.1 do Oppenheim").
- Em Sinais e Sistemas: `#figure(foto("lua", height: 8em), caption: [..])` e `#lista-creditos(tamanho: 1em, "osciloscopio", "lua")` (o padrão do ajudante é `.6em`).
- Circuito ou gráfico nunca entra como imagem de outro lugar: refaça com zap ou lilaq.

## 5. Gráficos (lilaq)

Use os ajudantes do `comum.typ`. Em Sinais e Sistemas, são `grafico`, `curva`, `poligonal` e `hastes`, com eixos pela origem:

```typ
#grafico(largura: 10cm, altura: 5cm, xlabel: $t$, ylabel: $r(t)$, xaxis: (ticks: (1, 2)), yaxis: (ticks: (1, 2)),
  ylim: (-.3, 2.6), poligonal(((-2, 0), (0, 0), (2.4, 2.4))))
```

Se o curso não tem ajudante, use o lilaq direto. Um estilo que se repete vira função no `comum.typ` (regra 7).

```typ
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/zero:0.6.1"

#zero.set-num(decimal-separator: ",")
#align(center, lq.diagram(
  width: 14cm, height: 6cm,
  xlabel: $t$,
  legend: (position: top + right),
  lq.plot(lq.linspace(0, 5), t => calc.exp(-t), mark: none, stroke: 2pt + colors.primary, label: $x(t)$),
  lq.plot(lq.linspace(0, 5), t => calc.exp(-2 * t), mark: none,
    stroke: (paint: colors.secondary-dark, thickness: 2pt, dash: "dashed"), label: $x^2 (t)$),
))

Em azul, $x(t)$; em amarelo, $x^2 (t)$, que cai mais rápido.
```

- O lilaq direto põe números e rótulos no tamanho do corpo. O `grafico` de Sinais e Sistemas usa 13.6pt nos números e 17pt nos rótulos: proponha ao professor ajustar o `comum.typ`, em vez de contornar com outro gráfico no deck.
- O texto que explica o gráfico vai no corpo do slide, não dentro dele. A largura fica entre 10 e 14cm; o texto não muda com o tamanho.
- No lilaq 0.6.0, `lq.plot-function` não existe: use `lq.plot(lq.linspace(a, b), t => .., mark: none)`.
- Um `ylabel` sai girado 90°. Prefira a legenda, ou o rótulo na ponta do eixo, que o ajudante do curso já põe.

## 6. Diagramas (fletcher) e desenhos (CeTZ)

```typ
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#align(center, diagram(
  edge-stroke: 1.6pt + colors.neutral-dark,
  spacing: 4em,
  node((0, 0), $x(t)$, name: <x>),
  node((1, 0), [Sistema], name: <h>, stroke: 1.4pt + colors.primary, fill: colors.primary-lightest,
    corner-radius: 6pt, inset: .6em),
  node((2, 0), $y(t)$, name: <y>),
  edge(<x>, <h>, "-|>"),
  edge(<h>, <y>, "-|>"),
))
```

- Diagramas de blocos são feitos com fletcher e desenhos com CeTZ. Circuitos, sempre com zap (`references/zap.md`).
- CeTZ: `#import "@preview/cetz:0.5.2"` e `cetz.canvas(length: 1.4em, { import cetz.draw: *; .. })`; com `length` em `em`, o desenho acompanha a letra. Rótulos sem `size:` e traços em `colors.*`.
- Em Sinais e Sistemas, o `bloco` (fletcher) usa `.78em` e o `des-carro` (CeTZ) usa `.7em`. Use-os como estão e proponha ajustar o `comum.typ`, sem criar uma cópia no deck.

## 7. Quanto cabe num slide 16:9 sem diminuir a letra

O corpo tem 22pt. A área útil é de 763 × 364pt num slide comum e de 745 × 336pt num exemplo ou exercício.

| Conteúdo | Cabe | Transborda a partir de |
|---|---|---|
| parágrafos de uma linha | 10 (9 com pílula) | 11 |
| itens `-` ou setas `->` | 13 (12 com pílula, ou num exemplo ou exercício) | 14 |
| texto corrido (~13 palavras por linha) | ~150 palavras | 170 |
| título `==` | ~65 caracteres | 70 (já reduzido) |
| meme no "Fim!" | `height: 14em` | `16em` |

Esses números são o teto. O alvo é a regra 1: até ~40 palavras ou 5 itens; com figura ao lado, até 3 itens curtos; uma equação em destaque; no máximo um callout. O que passar disso vira outro slide.

## 8. Armadilhas confirmadas

| Sintoma | Causa | Correção |
|---|---|---|
| O slide quebra no meio de uma frase | Travessão ao lado de `*`, `_`, `~~` ou `$` vira o `---` de quebra | Dois-pontos ou meia-risca `–`; nunca travessão |
| `->` aparece cru | A seta não começa um parágrafo | Linha em branco antes (depois de texto, em célula de `grid`, em callout) |
| O que vem depois de `cols` foi para outra página | `#v(1fr)` dentro de `cols` | `grid(.., align: horizon)` |
| Página em branco no começo | `#provide-icons` solto antes da capa | `#title-slide[#provide-icons(icones)]` |
| Continuação com 1 ou 2 linhas | Conteúdo maior que a área útil: o tema abre a página sozinho | Quebre à mão com `---` ou abra outro `==` |
| Um callout pula inteiro de página | O callout não se divide | Menos texto antes dele, ou um slide para ele |
| Um título menor que os outros | Título com mais de ~65 caracteres | Até 60 caracteres |
| Uma frase virou caixa azul | `>` no começo do parágrafo | `$x > 0$` ou `\>` |
| Uma frase entre aspas virou citação | Parágrafo feito só de uma citação | Texto fora das aspas, ou `\"..\"` |
| Texto à direita do slide de Parte | Tudo entre `=` e `==` vai para o quadro da Parte | Só a imagem depois do `=` |
| `== realce==` abriu um slide | `==` com espaço no começo da linha é título | `==realce==` sem espaço, ou `#highlight[..]` |
| `#solution` ou `#answer` não aparece | Está fora de `<example>` ou `<exercise>` | Ponha-o dentro do item |
| A solução aparece de leve antes da hora | O `#pause` cobre com um véu claro | `---` antes do `#solution` |
| O `(t)` foi para o subscrito | `$v_s(t)$` | `$v_s (t)$` |
| "Fim!" sozinho e o meme na página seguinte | Meme alto demais | `height: 12em` (até 14em) |
| "Obrigado!" no fim | É o título padrão de `#ending-slide()` | `#ending-slide(title: [Fim!])[..]` |

## 9. Encerramento: "Fim!" com meme

```typ
== Créditos das imagens
- Osciloscópio: Pittigrilli, CC BY-SA 4.0, #link("https://commons.wikimedia.org/wiki/File:Sine_wave_10_kHz_displayed_on_analog_oscilloscope.jpg")[Wikimedia Commons].
- Meme: autor, licença, fonte.

#ending-slide(title: [Fim!])[#image("memes/meme.png", height: 12em)]
```

- O encerramento é a página azul com "Fim!" e o meme no corpo. Não leva subtítulo, "Obrigado!", contato nem a próxima aula.
- Antes, traga ao professor candidatos a meme, cada um com link e crédito. O escolhido fica em `memes/`, ao lado do deck, e o crédito dele vai no slide de créditos.
