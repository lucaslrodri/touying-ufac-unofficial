# Padrões do tema touying-ufac-unofficial 0.3.0 para trabalhos acadêmicos

Sintaxe, componentes e armadilhas para escrever o deck. Todo trecho foi compilado (Typst 0.15.1, touying 0.7.4). As regras do `SKILL.md` mandam; nada aqui as contraria. Os caminhos são os de um deck numa pasta própria (`defesa/defesa.typ`, com o `.bib` e os dados ao lado), compilado de lá com `typst compile defesa.typ`.

## 1. Esqueleto e capa

Parta de `templates/deck.typ`. A ordem é: imports, `#show: ufac-theme.with(..)`, capa, roteiro, Partes (`=`), "Agradecimentos", "Referências", "Créditos das imagens" (se houver foto de terceiros), `#ending-slide`, `#show: appendix` e os slides de reserva.

| Trabalho | `config-info(..)` | O que a capa mostra |
|---|---|---|
| defesa de TCC | `kind: "tcc"`, `title`, `course` (o curso), `author`, `date`, `contact` | a etiqueta "Trabalho de Conclusão de Curso", o título, o curso e, no alto à direita, o discente e os orientadores |
| defesa de mestrado ou de doutorado | `kind: "dissertation"` ou `"thesis"`, com `course` sendo o programa | a etiqueta "Dissertação de Mestrado" ou "Tese de Doutorado" |
| qualificação | o `kind` da defesa e `short-title: [Exame de qualificação]` | a etiqueta trocada |
| trabalho de disciplina | `kind: "coursework"`, `subject`, `subject-code`, `unit-title` (o título do trabalho), `author`, `semester` ou `year` | os alunos e o professor em grupos, embaixo à esquerda |
| congresso, seminário, palestra | `kind: "talk"`, `title`, `subtitle` (o evento), `author`, `date`, `contact` | os autores e a data numa linha, embaixo |

```typ
#show: ufac-theme.with(
  aspect-ratio: "16-9",
  config-info(
    kind: "dissertation",
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
- Dar um campo com dois nomes (`subject` e `title`, `semester` e `date`) é erro de compilação.
- **Nada que gere conteúdo antes da capa:** um `#zero.set-num(..)`, um `#provide-icons(..)` ou um texto solto antes do `#title-slide` abre uma página em branco. `#import` e `#let` podem ficar ali.
- **Ícones Phosphor** (`"ph:nome-bold"`): o `provide-icons` vai **dentro** da capa, `#title-slide[#provide-icons(icones)]`.
- **Fundo:** `ufac-theme.with(background: "plain")` (ou `"gradient"`) tira os círculos da capa e do encerramento, se o programa pedir sobriedade.
- **Roteiro:** `== Roteiro` e `#outline()`, que lista as Partes. Numa fala de até 10 minutos, ele pode sair.
- Nenhum `#set text(size: ..)` nem `#show figure.caption: set text(..)` no deck.

## 2. Estrutura: `=`, `==`, `===`, `---`

```typ
= Metodologia
#image("figuras/bancada.jpg")

== O ensaio
=== Descarga
Uma célula de 2,5 Ah descarrega a 0,75 A por 120 min.

---

=== Medição
A tensão e a corrente são medidas a cada segundo.
```

- **`=` Parte:** "PARTE N" e o título. Tudo até o próximo `==` vai para o quadro da direita (12em × 66% da altura). Uma imagem sem tamanho preenche o quadro; ponha só a imagem ali, nenhum texto. Uma foto ou figura do próprio trabalho é a melhor escolha; um ícone grande também serve (`#icon("info", size: 6em)`, ou um Phosphor). O nome é a etapa do argumento (Introdução, Metodologia, Resultados, Conclusões), não o número do capítulo.
- **`==` slide:** título de até 60 caracteres. Acima de ~65, o tema encolhe o título, o que viola a regra 2. Nos resultados, o título é o achado (regra 5).
- **`===` pílula:** é repetida em cada continuação, até a próxima `===`. A `====` não se repete, nem a pílula posta dentro de `cols`, `grid` ou de uma caixa.
- **`---`** sozinho na linha (ou `#pagebreak()`): a próxima página do mesmo slide, com o mesmo título e a mesma pílula.
- **Exemplo e exercício** (`== Título <example>` com `#solution`; `<exercise>` com `---` e `#answer`) existem no tema e, nos tipos acima, saem sem prefixo ("Exemplo 1"). Use só se o trabalho pede, como um caso resolvido num trabalho de disciplina.

## 3. Citações e referências

```typ
== Contar a corrente acumula erro
O filtro de Kalman corrige a contagem com a tensão medida @modelo2023.

#figure(image("figuras/modelo.png", height: 7em), caption: [Adaptado de @modelo2023])

== Referências
#bibliography("referencias.bib", title: none, style: "associacao-brasileira-de-normas-tecnicas")
```

| Escrita | Resultado |
|---|---|
| `@modelo2023` | (Modelo; Segundo, 2023) |
| `@exemplo2021 @modelo2023` | (Exemplo, 2021; Modelo; Segundo, 2023) |
| `Modelo e Segundo (#cite(<modelo2023>, form: "year"))` | Modelo e Segundo (2023) |

- **O `.bib` é o do texto do trabalho**, com as mesmas chaves: a referência do slide é a da monografia.
- **Uma `#bibliography` só**, no slide "Referências", com `title: none` (o slide já tem título). Ela lista só as obras citadas nos slides.
- **Citação em prosa:** o `form: "prose"` do estilo ABNT junta dois autores com ponto e vírgula ("Modelo; Segundo (2023)"). Escreva os nomes e cite só o ano, como na tabela.
- **Figura de outro trabalho:** a fonte vai na legenda (`Adaptado de @chave`, ou `Fonte: @chave`). Figura do próprio trabalho não leva fonte.
- **Foto de terceiros:** crédito (autor, licença, fonte com link) no slide "Créditos das imagens", depois das Referências, no tamanho do corpo.
- Uma lista longa continua sozinha na página seguinte, com a letra no corpo; nunca diminua a letra das referências.

## 4. Componentes

### Callouts

| Callout | Usar para | Não usar para |
|---|---|---|
| `#caution[..]` "Atenção!", vermelho | uma limitação do trabalho, uma ameaça à validade, um cuidado | o resultado principal |
| `#tip[..]` "Dica.", verde | um atalho prático (raro numa defesa) | conteúdo obrigatório |
| `#remark[..]` "Relembrando.", azul | retomar o já mostrado: o objetivo, uma figura anterior | fato novo |
| `#note[..]` "Nota.", cinza | algo secundário: um detalhe do ensaio, o próximo passo | o ponto principal |
| `#example[..]`, `#examples[..]`, verde | exemplo curto num slide comum | a evidência de um resultado |

```typ
#caution[O ensaio usou uma célula só, a 25 °C.]
#remark[Objetivo 2: comparar a contagem de Coulomb com o filtro de Kalman.]
```

- Um callout por slide (dois, se curtos): ele complementa, não é o conteúdo. Ele não se divide; se não couber no resto da página, vai inteiro para a seguinte.

### `emph-box`

| Cor | Para |
|---|---|
| padrão (`colors.primary`) | objetivo, pergunta de pesquisa, hipótese, definição |
| `colors.quaternary` | contribuição, vantagem |
| `colors.tertiary` | problema, lacuna |
| `colors.secondary-dark` | nota lateral; o segundo caso de uma comparação |

```typ
#emph-box(title: [Objetivo geral])[Estimar o SoC de uma célula de lítio com erro menor que 2%.]
#grid(columns: (1fr, 1fr), gutter: 1.2em,
  emph-box(color: colors.tertiary, title: [Problema])[A contagem acumula o erro do sensor.],
  emph-box(color: colors.quaternary, title: [Contribuição])[Um filtro que corrige a contagem pela tensão.],
)
```

- **Não usar para:** envolver o slide inteiro; mais de 3 caixas por slide; caixa feita à mão (`block(stroke: ..)`).
- Use `secondary-dark`, nunca o `secondary` puro, ilegível como texto. Caixas lado a lado só ficam da mesma altura se o texto tiver o mesmo número de linhas.

### Atalho `>` e `eq-box`

```typ
> == Pergunta de pesquisa
> A tensão medida basta para corrigir a contagem?

> $ e(t) = "SoC"_"est" (t) - "SoC"_"ref" (t) $
```

- `>` com texto dá uma caixa azul, só com conteúdo em linha (para uma lista, use `emph-box`). `> == Título` põe o selo.
- `>` antes de uma equação em bloco dá o `eq-box`: a equação que o público precisa guardar (o modelo, a métrica), uma por slide. `#eq-box[$..$]` dentro da equação moldura só uma parte.

### `cols` e `grid`

```typ
#grid(columns: (1fr, 1.2fr), gutter: 1.2em, align: horizon)[

  -> Um par RC por célula;
  -> parâmetros do ensaio de pulso.
][
  #image("figuras/circuito.png", height: 8em)
]
```

- `#cols(columns: (1fr, 1.2fr), gutter: 1.2em)[..][..]` divide o slide; `divider: true` põe uma divisória azul. Uma coluna de metade comporta ~6 palavras por linha.
- **Usar para:** texto ao lado de figura; dois casos lado a lado. **Não usar para:** três colunas de texto.
- Para centralizar na vertical, use `grid` com `align: horizon`, nunca `#v(1fr)` dentro de `cols`.

### Termos, `tag` e destaques

- **Termos:** `/ $R_0$: resistência interna`, um por linha, para a legenda de símbolos e os parâmetros de um ensaio; não para frases longas.
- **`tag`:** `Filtro de Kalman #tag[proposto]` (13.2pt). Uma palavra que marca um item; nunca informação que o público precisa ler, nem título.

| Escrita | Resultado | Para |
|---|---|---|
| `*termo*` | negrito (na cor da caixa, dentro dela) | um termo novo |
| `_texto_` | itálico | ênfase leve, título de obra, termo estrangeiro |
| `~~texto~~` ou `#alert[..]` | negrito azul | **o** termo-chave do slide |
| `==texto==` ou `#highlight[..]` | fundo amarelo-claro | o que olhar primeiro |
| `#primary[..]`, `#tertiary[..]`, `#quaternary[..]` | negrito na cor | rótulo ligado a uma cor ("#tertiary[Problema:]") |

Destaque com parcimônia: no máximo um por slide, nunca num item curto nem num tópico, e sem espaço nas pontas.

### Setas e listas

- `-` dá um marcador amarelo, `+` uma lista numerada (os objetivos específicos, as conclusões) e `->` uma seta azul. No máximo 5 itens (regra 1).
- A lista de setas começa um parágrafo: deixe uma linha em branco antes dela depois de texto, no começo de uma célula de `grid` e dentro de um callout. No começo de uma coluna de `cols` ou de um `emph-box`, ela funciona sem a linha em branco.

### Ícones e cores

- **Do tema** (sem `provide-icons`): `"caution"`, `"tip"`, `"info"`, `"note"`, `"remark"`, `"exercise"`, `"example"`.
- **Outros:** `"ph:nome-bold"`, da coleção Phosphor de um JSON passado ao `provide-icons`. Um ícone que não está no JSON dá erro de compilação com o nome dele. Para usá-lo, baixe-o de `https://api.iconify.design/ph.json?icons=a,b` e acrescente-o ao JSON.
- Ícone vai no selo de `emph-box`, no callout (`icon:`), na pílula ou na figura da Parte, e o mesmo assunto tem sempre o mesmo ícone. Não decore cada linha.
- **Cores:** só `colors.*`, nunca `rgb()` nem hexadecimal. São as famílias `primary` (azul), `secondary` (amarelo), `tertiary` (vermelho), `quaternary` (verde) e `neutral`, cada uma com os tons `-darkest`, `-darker`, `-dark`, base, `-light`, `-lighter` e `-lightest`. Traço e texto usam a base ou um tom escuro; fundo, `-lighter` ou `-lightest`.

| Papel | Cor |
|---|---|
| o método proposto, a série principal num gráfico | `primary` |
| o problema, o erro, o método que perde | `tertiary` |
| a contribuição, a vantagem | `quaternary` |
| o segundo caso, um destaque | `secondary-dark` |
| a referência, os eixos | `neutral-dark`, `neutral-darker` |

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

- A tabela do texto não entra inteira: só as linhas e colunas que sustentam a mensagem do slide, com a linha do método proposto em destaque. A tabela completa vai para a reserva, dividida com `---` se for longa, com o cabeçalho repetido; a letra nunca diminui.
- Os números são os do texto, com a mesma unidade e o mesmo arredondamento (regra 3).

### Figuras e fotos

```typ
#figure(image("figuras/bancada.jpg", height: 8em), caption: [A bancada do ensaio])
```

- A legenda sai a 0.6 do corpo (13,2pt), pelo tema, e só com o texto, sem "Figura N": escreva uma linha curta. Não mude o tamanho dela com `show figure.caption`.
- Gráfico, circuito e diagrama de blocos não entram como imagem: refaça com lilaq, zap ou fletcher (regra 8). Foto, mapa e captura de tela entram como imagem.

## 5. Gráficos (lilaq) a partir dos dados

Leia os dados do arquivo do trabalho, nunca copie os números à mão:

```typ
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/zero:0.6.1"

#let soc = csv("dados/soc.csv", row-type: dictionary).map(r => r.keys().map(k => (k, float(r.at(k)))).to-dict())

== O filtro de Kalman fica a menos de 1% da referência
#zero.set-num(decimal-separator: ",")
#align(center, lq.diagram(
  width: 14cm, height: 6cm,
  xlabel: [Tempo (min)], ylabel: [SoC (%)],
  legend: (position: top + right),
  lq.plot(soc.map(r => r.tempo), soc.map(r => r.real), mark: none, stroke: 2pt + colors.neutral-dark,
    label: [Referência]),
  lq.plot(soc.map(r => r.tempo), soc.map(r => r.contagem), mark: none,
    stroke: (paint: colors.tertiary, thickness: 2pt, dash: "dashed"), label: [Contagem]),
  lq.plot(soc.map(r => r.tempo), soc.map(r => r.kalman), mark: "o", mark-size: 6pt, stroke: none,
    color: colors.primary, label: [Kalman]),
))

A maior distância do Kalman à referência foi de 0,6%.
```

- O lilaq põe números e rótulos no tamanho do corpo. A largura fica entre 10 e 14cm; o texto não muda com o tamanho.
- O `#zero.set-num` vai dentro do primeiro slide com gráfico, nunca antes da capa.
- Eixo com grandeza e unidade (`[Tempo (min)]`). O `ylabel` sai girado 90°; num gráfico de resultado, ele fica.
- Duas séries que quase coincidem (o resultado é justamente isso): uma delas com marcadores (`mark: "o"`, `stroke: none`).
- O texto que diz o que olhar vai no corpo do slide, embaixo, não dentro do gráfico.
- No lilaq 0.6.0, `lq.plot-function` não existe: para uma curva teórica, use `lq.plot(lq.linspace(a, b), t => .., mark: none)`.
- Sem os dados (só uma imagem do gráfico), peça os dados ao autor. Se a imagem ficar, confira no PNG que os números e os rótulos têm o tamanho do corpo; senão, a figura é refeita na origem com letra maior.

## 6. Diagramas (fletcher) e desenhos (CeTZ)

```typ
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#align(center, diagram(
  edge-stroke: 1.6pt + colors.neutral-dark,
  spacing: 3em,
  node((0, 0), [Descarga], name: <a>, stroke: 1.4pt + colors.primary, fill: colors.primary-lightest,
    corner-radius: 6pt, inset: .6em),
  node((1, 0), [Medição], name: <b>, stroke: 1.4pt + colors.primary, fill: colors.primary-lightest,
    corner-radius: 6pt, inset: .6em),
  edge(<a>, <b>, "-|>"),
))
```

- O método como fluxo (etapas, entradas e saídas) e os diagramas de blocos são feitos com fletcher; desenhos, com CeTZ; circuitos, sempre com zap (`references/zap.md`).
- CeTZ: `#import "@preview/cetz:0.5.2"` e `cetz.canvas(length: 1.4em, { import cetz.draw: *; .. })`; com `length` em `em`, o desenho acompanha a letra. Rótulos sem `size:` e traços em `colors.*`.
- Um estilo de nó que se repete em vários slides vira função no `comum.typ` (regra 7).

## 7. Quanto cabe num slide 16:9 sem diminuir a letra

O corpo tem 22pt. A área útil é de 763 × 364pt num slide comum.

| Conteúdo | Cabe | Transborda a partir de |
|---|---|---|
| parágrafos de uma linha | 10 (9 com pílula) | 11 |
| itens `-` ou setas `->` | 13 (12 com pílula) | 14 |
| texto corrido (~13 palavras por linha) | ~150 palavras | 170 |
| título `==` | ~65 caracteres | 70 (já reduzido) |

Esses números são o teto. O alvo é a regra 1: até ~40 palavras ou 5 itens; com figura ao lado, até 3 itens curtos; uma equação em destaque; no máximo um callout. O que passar disso vira outro slide ou vai para a reserva.

## 8. Armadilhas confirmadas

| Sintoma | Causa | Correção |
|---|---|---|
| Página em branco antes da capa | `#zero.set-num`, `#provide-icons` ou texto antes do `#title-slide` | O `set-num` no slide do gráfico; o `provide-icons` dentro da capa |
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
| O `(t)` foi para o subscrito | `$v_s(t)$` | `$v_s (t)$` |
| "Modelo; Segundo (2023)" no texto | `form: "prose"` do estilo ABNT com dois autores | `Modelo e Segundo (#cite(<chave>, form: "year"))` |
| Duas curvas viraram uma | As séries quase coincidem | Marcadores numa delas (`mark: "o"`, `stroke: none`) |
| A reserva sem marca, contada no total do Touying | Slides depois do encerramento sem `#show: appendix` | `#show: appendix` logo depois do `#ending-slide` |

## 9. Encerramento e reserva

```typ
== Agradecimentos
-> À agência de fomento, pela bolsa (processo nº 0000/2026);
-> Ao laboratório, pelo ensaio das células.

== Referências
#bibliography("referencias.bib", title: none, style: "associacao-brasileira-de-normas-tecnicas")

#ending-slide[Obrigado!][Perguntas?][#info("contact")]

#show: appendix

== Por que um circuito equivalente de primeira ordem?
-> Um par RC reproduz a tensão do ensaio com erro menor que 10 mV;
-> Um segundo par RC não reduziu o erro do SoC.
```

- **Agradecimentos:** a agência de fomento e o número do processo, quando houver (a agência costuma exigir a menção); pessoas, só se o autor pedir.
- **Encerramento:** "Obrigado!", "Perguntas?" e o contato (`#info("contact")`, do `contact` do `config-info`). Sem meme.
- **Reserva:** depois de `#show: appendix`, um slide por pergunta prevista no plano, com a pergunta no título, para achar rápido. O rodapé continua numerando (a banca pode pedir "volta no slide 19"); o `appendix` marca o começo da reserva e congela o total do Touying no encerramento. A reserva não entra no tempo nem no roteiro (não use `=` nela).
