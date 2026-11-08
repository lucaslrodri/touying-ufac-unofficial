# Circuitos com o zap 0.6.0

Todo circuito é desenhado com o zap (regra 8), nunca com CeTZ à mão nem como imagem. O tema não tem estilo de circuito, então o estilo e os auxiliares ficam no `comum.typ` do curso, copiados de `templates/circuitos-zap.typ` (o cabeçalho dele diz como). Os trechos daqui foram compilados com Typst 0.15.1, touying 0.7.4 e zap 0.6.0.

## 1. Import

```typ
#import "@preview/zap:0.6.0"
```

- Essa linha vai no `comum.typ`, e o deck recebe o `zap` pelo `#import "../comum.typ": *`.
- Não use `import "@preview/zap:0.6.0": *` no topo do arquivo. Escreva `import zap: *` só dentro do bloco do circuito: no topo, o `node` do zap encobre o do fletcher, e `wire`, `switch` e `symbol` passam a valer no deck todo.
- O CeTZ vem dentro do zap, como `zap.cetz`. Não importe outro.

## 2. API essencial

| Escrita | O que faz |
|---|---|
| `circuito(length: 1.8cm, { import zap: *; .. })` | o circuito com o estilo do curso (`comum.typ`) |
| `resistor("r", (2, 4), (7, 4), label: $R$)` | um nome e dois nós: o símbolo fica no meio do trecho e o zap desenha os fios até ele |
| `opamp("op", (5, 0))`, `ground("g", (3.6, -1.1))` | um nó só, para amp-op, terra, `vcc` e `vee` |
| `wire((7, 0), (0, 0))` | fio, por dois ou mais pontos |
| `node("n1", (3, 2))` / `node("a", (5.5, 2), fill: false)` | junção (ponto cheio) / terminal (círculo vazado) |
| `label: (content: $a$, anchor: "east")` | rótulo em outro lado |
| `"r.in"`, `"r.out"`, `"op.minus"`, `"op.plus"`, `"op.out"` | âncoras para ligar fios |

| Grupo | Funções |
|---|---|
| Passivos | `resistor`, `capacitor`, `inductor`, `potentiometer`, `transformer` |
| Fontes | `vsource` (+ no segundo nó), `isource` (seta do primeiro nó para o segundo), `acvsource`, `dvsource`, `disource`, `battery` |
| Chaves | `switch` (`closed: true` para fechada) |
| Semicondutores | `diode`, `led`, `zener`, `npn`, `pnp`, `nmos`, `pmos` |
| Outros | `opamp`, `ground`, `vcc`, `vee`, `voltmeter`, `ammeter` |

Auxiliares do curso (`comum.typ`), que o zap não tem:

| Escrita | O que faz |
|---|---|
| `tensao("c", $v_C (t)$)` | "+ rótulo −" ao lado do componente, com o + no primeiro nó; `inverte: true` troca os sinais |
| `tensao-terminais((5.5, 1.55), (5.5, 0.45), $v_o$)` | tensão entre dois pontos, como terminais de saída |
| `corrente((2, 4), (3.8, 4), $i(t)$)` | seta num trecho de fio, de `a` para `b`; `pos: 30%` muda o lugar, `lado: -1` passa o rótulo para o outro lado |
| `regiao((-1.6, -0.5), (3.9, 4.5), rotulo: [Equivalente de Norton])` | retângulo de destaque atrás de parte do circuito; chame antes dos componentes |

## 3. Desenhe no sentido horário

O rótulo fica à esquerda de quem vai do primeiro nó para o segundo:

| Sentido | Rótulo |
|---|---|
| esquerda → direita | em cima |
| baixo → cima | à esquerda |
| cima → baixo | à direita |
| direita → esquerda | embaixo |

Desenhe a malha no sentido horário: a fonte à esquerda, de baixo para cima; o ramo de cima, da esquerda para a direita; o ramo da direita, de cima para baixo. Assim os rótulos (R, L, C) ficam fora da malha, e a `tensao` (lado `"south"`) fica dentro dela.

## 4. Cores do tema

| Papel | Cor |
|---|---|
| componentes, fios, nós e rótulos | `colors.neutral-darkest` (o `zap-ufac` já aplica) |
| tensão: +, − e rótulo | `colors.primary` (o `tensao` já aplica) |
| corrente | `colors.tertiary` (o `corrente` já aplica) |
| destaque | `colors.secondary-dark`, com fundo `colors.secondary-lightest` |

- A mesma cor tem o mesmo papel no circuito, no gráfico e no texto: se $v_C (t)$ é azul no circuito, a curva de $v_C (t)$ também é, e no texto se escreve `#primary[$v_C (t)$]`.
- Para destacar um componente: `inductor("l", (5, 4), (5, 0), label: text(fill: colors.secondary-dark, $L$), stroke: 2pt + colors.secondary-dark)`.
- Nunca use `rgb()`, hexadecimal ou `colors.secondary` puro, que é ilegível como traço.

## 5. Tamanho

| Uso | `length` | Coordenadas |
|---|---|---|
| slide só com o circuito | 1.8cm | malha de 5 a 7 × 4 |
| amp-op, RLC | 1.7cm | 7 a 8 de largura |
| coluna ao lado de um gráfico | 1.3cm | malha de 7 × 4, sem rótulos secundários |

A letra (22pt) e o traço não mudam com o `length`. Para o circuito ao lado de um gráfico, use `#cols(columns: (auto, 1fr), gutter: 1.5em)[circuito][gráfico]`.

## 6. RC série completo

```typ
== Circuito RC série
#align(center, circuito({
  import zap: *
  vsource("vs", (0, 0), (0, 4), label: $v_s (t)$)          // de baixo para cima: + em cima, rótulo à esquerda
  switch("ch", (0, 4), (2, 4), label: $t = 0$)
  resistor("r", (2, 4), (7, 4), label: $R$)                // símbolo no meio; sobra fio para a corrente
  capacitor("c", (7, 4), (7, 0), label: $C$)               // de cima para baixo: rótulo à direita, fora
  wire((7, 0), (0, 0))
  corrente((2, 4), (3.8, 4), $i(t)$)
  tensao("r", $v_R (t)$)
  tensao("c", $v_C (t)$)
}))
```

Para mais modelos (divisor de tensão, equivalente de Norton com `regiao`, amp-op inversor, RC ao lado de um gráfico, destaque de um componente), veja a demonstração no fim de `templates/circuitos-zap.typ`.

Se o mesmo circuito aparece em vários slides, guarde-o num `#let` no `comum.typ` (por exemplo, `#let circ-rc = circuito({ .. })`) em vez de copiar o bloco.

## 7. Armadilhas confirmadas

| Sintoma | Causa | Correção |
|---|---|---|
| Erro "does not have a border for anchor '0deg'" | `wire(a, b, i: ..)` não funciona no zap 0.6.0 | `corrente(a, b, ..)` |
| Erro "value none was equal to none" | Fio de comprimento zero, `wire(p, p)` | Tire o fio |
| Erro "unknown variable: set-style" | O `set-style` é do CeTZ | `zap.cetz.draw.set-style(..)` (o `zap-ufac` já usa) |
| "R i(t)" lido como produto | O `label` e o `i:` nativo saem do mesmo lado | `corrente()` no fio |
| Rótulo do `u:` nativo em cima da seta (componente vertical) | O zap afasta o rótulo pela altura, não pela largura | `tensao()` |
| A tensão caiu em cima do rótulo | `tensao(lado: "north")` usa o lado do rótulo | Mude o rótulo: `label: (content: $R$, anchor: "south")` |
| Fonte com o + embaixo | Fonte de cima para baixo: o + fica no segundo nó | Desenhe a fonte de baixo para cima |
| As tensões se encostam | `length` pequeno: a letra não diminui | Alargue as coordenadas, tire rótulos secundários ou quebre o slide; nunca `scale()` nem `text(size: ..)` |
| O `(t)` foi para o subscrito | `$v_s(t)$` | `$v_s (t)$` |
| Âncoras em letra minúscula no slide | `debug: true` esquecido | Use só para desenvolver; tire antes de compilar o deck |
