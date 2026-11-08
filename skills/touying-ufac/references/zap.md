# Circuitos com o zap 0.6.0

Todo circuito é desenhado com o zap (regra 4), nunca com CeTZ à mão nem como imagem. O tema não tem estilo de circuito, então o estilo e as funções grandes ficam no `header.typ` do deck, copiados de `templates/circuitos/header.typ`, e cada circuito fica num arquivo seu, em `figures/circuits/<nome>.typ` (regra 6). Os trechos daqui foram compilados com Typst 0.15.1, touying 0.7.4, touying-ufac-unofficial 0.3.0 e zap 0.6.0.

## 1. Onde fica cada coisa

| O quê | Onde |
|---|---|
| o estilo (`zap-ufac`) e as funções `tensao`, `corrente` e `regiao` | no `header.typ` do deck; na aula, se vários decks da disciplina têm circuitos, no `common.typ` da pasta da disciplina, uma vez só |
| cada circuito | num arquivo em `figures/circuits/<nome>.typ`, que importa o zap e o que usa do estilo |
| o slide | só inclui o arquivo: `#align(center, include "figures/circuits/rc-serie.typ")` |

- Para começar, copie `templates/circuitos/header.typ` para a pasta do deck. Se o deck já tem um `header.typ`, copie para ele os dois imports e as quatro funções.
- O deck não importa o zap nem o estilo: só o arquivo do circuito os usa.
- O arquivo do circuito importa pelo nome o que usa (regra 3). O caminho depende do modo e de onde está o estilo:

| Modo | Estilo no | Import no arquivo do circuito |
|---|---|---|
| Acadêmico | `header.typ` do deck | `#import "/header.typ": zap-ufac, tensao, corrente` |
| Aula | `header.typ` do deck | `#import "../../header.typ": zap-ufac, tensao, corrente` |
| Aula | `common.typ` da disciplina | `#import "/common.typ": zap-ufac, tensao, corrente` |

No acadêmico, a raiz da compilação é a pasta da apresentação, e `/header.typ` é o do deck. Na aula, a raiz é a pasta da disciplina (`--root ..`): ali `/header.typ` não existe, e o do deck se alcança de `figures/circuits/` por `../../`.

## 2. Import

```typ
#import "@preview/zap:0.6.0"
```

- Essa linha vai no `header.typ` (ou no `common.typ`), para o estilo, e em cada arquivo de `figures/circuits/`, para o `zap.circuit`.
- Não use `import "@preview/zap:0.6.0": *` no topo de um arquivo. Escreva `import zap: *` só dentro do bloco do circuito: no topo, `node`, `wire`, `switch` e `symbol` do zap passam a valer no arquivo todo, e o `node` do zap encobre o do fletcher (no `common.typ` da aula, em todo deck que o importa).
- O CeTZ vem dentro do zap, como `zap.cetz`, ou `cetz` depois do `import zap: *`. Não importe outro.

## 3. API essencial

| Escrita | O que faz |
|---|---|
| `zap.circuit(length: 1.8cm, { import zap: *; zap-ufac(); .. })` | o circuito, com o estilo do tema aplicado antes dos componentes |
| `resistor("r", (2, 4), (7, 4), label: $R$)` | um nome e dois nós: o símbolo fica no meio do trecho e o zap desenha os fios até ele |
| `opamp("op", (5, 0))`, `ground("g", (3.6, -1.1))` | um nó só, para amp-op, terra, `vcc` e `vee` |
| `wire((7, 0), (0, 0))` | fio, por dois ou mais pontos |
| `node("n1", (3, 2))` / `node("a", (5.5, 2), fill: false)` | junção (ponto cheio) / terminal (círculo vazado) |
| `label: (content: $a$, anchor: "east")` | rótulo em outro lado |
| `"r.in"`, `"r.out"`, `"op.minus"`, `"op.plus"`, `"op.out"` | âncoras para ligar fios |
| `cetz.draw.content((5.5, 1), text(fill: colors.primary, $v_o$))` | um texto num ponto do circuito |

| Grupo | Funções |
|---|---|
| Passivos | `resistor`, `capacitor`, `inductor`, `potentiometer`, `transformer` |
| Fontes | `vsource` (+ no segundo nó), `isource` (seta do primeiro nó para o segundo), `acvsource`, `dvsource`, `disource`, `battery` |
| Chaves | `switch` (`closed: true` para fechada) |
| Semicondutores | `diode`, `led`, `zener`, `npn`, `pnp`, `nmos`, `pmos` |
| Outros | `opamp`, `ground`, `vcc`, `vee`, `voltmeter`, `ammeter` |

Funções do estilo, que o zap não tem:

| Escrita | O que faz |
|---|---|
| `tensao("c", $v_C (t)$)` | "+ rótulo −" ao lado do componente, com o + no primeiro nó; `inverte: true` troca os sinais |
| `corrente((2, 4), (3.8, 4), $i(t)$)` | seta num trecho de fio, de `a` para `b`; `pos: 30%` muda o lugar, `lado: -1` passa o rótulo para o outro lado |
| `regiao((-1.6, -0.5), (3.9, 4.5), rotulo: [Equivalente de Norton])` | retângulo de destaque atrás de parte do circuito; chame antes dos componentes |

A tensão entre dois terminais, que não é de um componente, se escreve no próprio circuito, com três textos em `colors.primary`: o +, o − e o rótulo no meio, como em `templates/circuitos/figures/circuits/divisor-de-tensao.typ`. O arquivo importa as `colors` do tema (`#import "@preview/touying-ufac-unofficial:0.3.0": colors`).

```typ
  cetz.draw.content((5.5, 1.55), text(fill: colors.primary, $+$))
  cetz.draw.content((5.5, 0.45), text(fill: colors.primary, $-$))
  cetz.draw.content((5.5, 1), text(fill: colors.primary, $v_o$))
```

## 4. Desenhe no sentido horário

O rótulo fica à esquerda de quem vai do primeiro nó para o segundo:

| Sentido | Rótulo |
|---|---|
| esquerda → direita | em cima |
| baixo → cima | à esquerda |
| cima → baixo | à direita |
| direita → esquerda | embaixo |

Desenhe a malha no sentido horário: a fonte à esquerda, de baixo para cima; o ramo de cima, da esquerda para a direita; o ramo da direita, de cima para baixo. Assim os rótulos (R, L, C) ficam fora da malha, e a `tensao` (lado `"south"`) fica dentro dela.

## 5. Cores do tema

| Papel | Cor |
|---|---|
| componentes, fios, nós e rótulos | `colors.neutral-darkest` (o `zap-ufac` já aplica) |
| tensão: +, − e rótulo | `colors.primary` (o `tensao` já aplica; entre dois terminais, escreva-a) |
| corrente | `colors.tertiary` (o `corrente` já aplica) |
| destaque | `colors.secondary-dark`, com fundo `colors.secondary-lightest` |

- A mesma cor tem o mesmo papel no circuito, no gráfico e no texto: se $v_C (t)$ é azul no circuito, a curva de $v_C (t)$ também é, e no texto se escreve `#primary[$v_C (t)$]`.
- Para destacar um componente: `inductor("l", (5, 4), (5, 0), label: text(fill: colors.secondary-dark, $L$), stroke: 2pt + colors.secondary-dark)`.
- Nunca use `rgb()`, hexadecimal ou `colors.secondary` puro, que é ilegível como traço.

## 6. Tamanho

| Uso | `length` | Coordenadas |
|---|---|---|
| slide só com o circuito | 1.8cm | malha de 5 a 7 × 4 |
| amp-op, RLC | 1.7cm | 7 a 8 de largura |
| coluna ao lado de um gráfico | 1.3cm | malha de 7 × 4, sem rótulos secundários |

A letra (22pt) e o traço não mudam com o `length`. Para o circuito ao lado de um gráfico, cada um no seu arquivo:

```typ
== Resposta do RC à rampa
#cols(columns: (auto, 1fr), gutter: 1.5em)[
  #include "figures/circuits/rc-coluna.typ"
][
  #include "figures/graphs/resposta-rampa.typ"
]
```

## 7. RC série completo

O arquivo `figures/circuits/rc-serie.typ`, num deck acadêmico (na aula, o import do estilo é `"../../header.typ"`):

```typ
// O circuito RC série: a fonte, a chave, o resistor e o capacitor, com a corrente e as duas tensões.

#import "@preview/zap:0.6.0"
#import "/header.typ": zap-ufac, tensao, corrente

#zap.circuit(length: 1.8cm, {
  import zap: *
  zap-ufac()
  vsource("vs", (0, 0), (0, 4), label: $v_s (t)$)          // de baixo para cima: + em cima, rótulo à esquerda
  switch("ch", (0, 4), (2, 4), label: $t = 0$)
  resistor("r", (2, 4), (7, 4), label: $R$)                // símbolo no meio; sobra fio para a corrente
  capacitor("c", (7, 4), (7, 0), label: $C$)               // de cima para baixo: rótulo à direita, fora
  wire((7, 0), (0, 0))
  corrente((2, 4), (3.8, 4), $i(t)$)
  tensao("r", $v_R (t)$)
  tensao("c", $v_C (t)$)
})
```

E o slide:

```typ
== Circuito RC série
#align(center, include "figures/circuits/rc-serie.typ")
```

Com legenda, `#figure(include "figures/circuits/rc-serie.typ", caption: [O circuito RC série])`.

Para mais modelos (divisor de tensão, equivalente de Norton com `regiao`, amp-op inversor, RC ao lado de um gráfico, destaque de um componente), veja os arquivos de `templates/circuitos/figures/circuits/` e o deck de demonstração `templates/circuitos/circuitos-zap.typ`, que inclui cada um num slide.

Se o mesmo circuito aparece em vários slides, inclua o mesmo arquivo em cada um, em vez de copiar o bloco. Um circuito que muda (outro `length`, outro rótulo, um destaque) é outro arquivo.

## 8. Armadilhas confirmadas

| Sintoma | Causa | Correção |
|---|---|---|
| Erro "does not have a border for anchor '0deg'" | `wire(a, b, i: ..)` não funciona no zap 0.6.0 | `corrente(a, b, ..)` |
| Erro "value none was equal to none" | Fio de comprimento zero, `wire(p, p)` | Tire o fio |
| Erro "unknown variable: set-style" | O `set-style` é do CeTZ | `zap.cetz.draw.set-style(..)` (o `zap-ufac` já usa) |
| Erro "unknown variable: zap-ufac" (ou `tensao`, `corrente`, `regiao`) | O arquivo do circuito não importou a função | `#import "/header.typ": zap-ufac, ..` com o caminho da seção 1 |
| Erro "file not found" no `/header.typ`, na aula | Na aula, a raiz é a pasta da disciplina | `"../../header.typ"`, ou `"/common.typ"` se o estilo está lá |
| "R i(t)" lido como produto | O `label` e o `i:` nativo saem do mesmo lado | `corrente()` no fio |
| Rótulo do `u:` nativo em cima da seta (componente vertical) | O zap afasta o rótulo pela altura, não pela largura | `tensao()` |
| A tensão caiu em cima do rótulo | `tensao(lado: "north")` usa o lado do rótulo | Mude o rótulo: `label: (content: $R$, anchor: "south")` |
| Fonte com o + embaixo | Fonte de cima para baixo: o + fica no segundo nó | Desenhe a fonte de baixo para cima |
| As tensões se encostam | `length` pequeno: a letra não diminui | Alargue as coordenadas, tire rótulos secundários ou quebre o slide; nunca `scale()` nem `text(size: ..)` (regra 2) |
| O `(t)` foi para o subscrito | `$v_s(t)$` | `$v_s (t)$` |
| Âncoras em letra minúscula no slide | `debug: true` esquecido | Use só para desenvolver; tire antes de compilar o deck |
