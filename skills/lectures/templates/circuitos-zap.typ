// circuitos-zap.typ: estilo de circuito para o pacote zap 0.6.0 nas aulas com o tema touying-ufac-unofficial, que
// não tem estilo de circuito. Validado com Typst 0.15.1, touying 0.7.4, touying-ufac-unofficial 0.3.0 e zap 0.6.0
// (que traz o cetz 0.5.2). Guia: references/zap.md.
//
// Como levar para o comum.typ do curso:
//   1. No topo do comum.typ, importe o zap e as cores do tema, se ainda não estiverem lá:
//        #import "@preview/zap:0.6.0"
//        #import "@local/touying-ufac-unofficial:0.3.0": colors
//   2. Copie para o comum.typ o trecho entre as marcas INÍCIO e FIM, mais abaixo.
//   3. O deck já importa o comum.typ (`#import "../comum.typ": *`), que traz o `zap` e as funções. Cada circuito é
//      escrito no slide:
//        #align(center, circuito({
//          import zap: *
//          vsource("vs", (0, 0), (0, 4), label: $v_s (t)$)
//          ..
//        }))
// O resto do arquivo é um deck de demonstração, um circuito por slide, escrito como num deck:
//   typst compile circuitos-zap.typ

#import "@preview/touying:0.7.4": *
#import "@local/touying-ufac-unofficial:0.3.0": *
#import "@preview/zap:0.6.0"

// ===== INÍCIO: copiar para o comum.typ ===============================================================================

// Circuitos (zap): símbolos americanos (IEEE: resistor em zigue-zague, fonte com + e −), traço de 1.4pt e as cores
// do tema. Componentes, fios e rótulos em neutral-darkest; tensão em primary; corrente em tertiary; destaque em
// secondary-dark. Desenhe a malha no sentido horário (fonte à esquerda, de baixo para cima; ramo de cima, da
// esquerda para a direita; ramo da direita, de cima para baixo): o rótulo do componente fica fora da malha e a
// tensão (`tensao`) fica dentro. A letra não muda com `length`: se o circuito não couber, alargue as coordenadas,
// tire rótulos secundários ou quebre o slide, nunca use scale() nem text(size: ..).

// Estilo do zap; chame dentro de `zap.circuit({ .. })`, antes dos componentes (o `circuito` já chama).
#let zap-ufac(traco: colors.neutral-darkest, espessura: 1.4pt) = zap.cetz.draw.set-style(zap: (
  variant: "ieee",
  stroke: espessura + traco,
  wire: (stroke: espessura + traco),                       // o fio não herda `stroke`
  node: (stroke: espessura + traco, fill: traco, nofill: colors.neutral-lightest, radius: .08),
  sign: (stroke: 1pt + traco),                             // + e − dentro da fonte de tensão
  opamp: (sign-stroke: 1pt + traco),                       // + e − dentro do amp-op
  decoration: (stroke: espessura + colors.tertiary, scale: 1.6, voltage: (stroke: espessura + colors.primary)),
  label: (distance: 6pt),
))

// Um circuito no estilo do curso. `length` é a unidade das coordenadas: 1.8cm num slide só com o circuito, 1.3cm
// numa coluna ao lado de um gráfico.
#let circuito(length: 1.8cm, corpo) = zap.circuit(length: length, {
  zap-ufac()
  corpo
})

// Tensão "+ rótulo −" ao lado de um componente já desenhado, como nos livros. O + fica no primeiro nó do componente;
// `inverte: true` troca os sinais. `lado: "south"` fica à direita do sentido do primeiro nó para o segundo (dentro da
// malha horária); "north" é o lado do rótulo do componente, que então deve mudar de lado
// (`label: (content: $R$, anchor: "south")`).
#let tensao(nome, rotulo, lado: "south", inverte: false, afastamento: 0.25, folga: 0.2, cor: colors.primary) = {
  import zap.cetz: draw, coordinate, vector, util
  draw.get-ctx(ctx => {
    let oposto = if lado == "south" { "north" } else { "south" }
    // as âncoras giram com o símbolo: west = primeiro nó, east = segundo, north = lado do rótulo
    let (ctx, m, o, w, e) = coordinate.resolve(ctx, nome + "." + lado, nome + "." + oposto,
      nome + "." + lado + "-west", nome + "." + lado + "-east")
    let fora = vector.norm(vector.sub(m, o))
    let eixo = vector.sub(e, w)
    let comp = vector.len(eixo)
    eixo = vector.norm(eixo)
    let txt = text(fill: cor, rotulo)
    let (lw, lh) = util.measure(ctx, txt)
    let (sw, sh) = util.measure(ctx, text(fill: cor, $+$))
    let horiz = calc.abs(fora.at(0)) > calc.abs(fora.at(1))   // tensão à esquerda ou à direita do símbolo
    let ext-fora = if horiz { lw } else { lh }
    let ext-eixo = if horiz { lh } else { lw }
    let sinal = if horiz { sh } else { sw }
    let centro = vector.add(m, vector.scale(fora, afastamento + ext-fora / 2))
    let meio = calc.max(comp / 2, ext-eixo / 2 + folga + sinal / 2)
    let mais = vector.sub(centro, vector.scale(eixo, meio))
    let menos = vector.add(centro, vector.scale(eixo, meio))
    if inverte { (mais, menos) = (menos, mais) }
    draw.content(mais, text(fill: cor, $+$))
    draw.content(menos, text(fill: cor, $-$))
    draw.content(centro, txt)
  })
}

// Tensão entre dois pontos (terminais de saída): + em `mais`, − em `menos` e o rótulo no meio.
#let tensao-terminais(mais, menos, rotulo, cor: colors.primary) = {
  import zap.cetz.draw: content
  content(mais, text(fill: cor, $+$))
  content(menos, text(fill: cor, $-$))
  content((mais, 50%, menos), text(fill: cor, rotulo))
}

// Corrente num trecho de fio de `a` para `b`: seta em `pos`, apontando para `b`, e o rótulo à esquerda do sentido
// (`lado: 1`) ou à direita (`lado: -1`). Use no lugar de `wire(.., i: ..)`, que dá erro no zap 0.6.0.
#let corrente(a, b, rotulo, pos: 50%, lado: 1, afastamento: 0.2, cor: colors.tertiary) = {
  import zap.cetz: draw, coordinate, vector, util
  draw.get-ctx(ctx => {
    let (ctx, pa, pb) = coordinate.resolve(ctx, a, b)
    let d = vector.norm(vector.sub(pb, pa))
    let p = vector.lerp(pa, pb, pos / 100%)
    draw.mark(p, pb, symbol: ">", anchor: "center", fill: cor, stroke: 0pt, scale: 1.6)
    let n = vector.scale((-d.at(1), d.at(0), 0), lado)
    let txt = text(fill: cor, rotulo)
    let (lw, lh) = util.measure(ctx, txt)
    let ext = if calc.abs(n.at(0)) > calc.abs(n.at(1)) { lw } else { lh }
    draw.content(vector.add(p, vector.scale(n, afastamento + ext / 2)), txt)
  })
}

// Região em destaque atrás de parte do circuito (um equivalente de Thévenin ou Norton): retângulo tracejado em
// secondary-dark, fundo secondary-lightest e rótulo acima. `a` e `b` são cantos opostos, em números. Chame antes
// dos componentes.
#let regiao(a, b, rotulo: none, cor: colors.secondary-dark, fundo: colors.secondary-lightest) = {
  import zap.cetz.draw: content, on-layer, rect
  on-layer(-1, rect(a, b, radius: .15, fill: fundo, stroke: (paint: cor, thickness: 1.4pt, dash: "dashed")))
  if rotulo != none {
    content(((a.at(0) + b.at(0)) / 2, calc.max(a.at(1), b.at(1)) + .1), anchor: "south", text(fill: cor, rotulo))
  }
}

// ===== FIM: copiar para o comum.typ ==================================================================================

// Deck de demonstração: cada circuito escrito como num slide.

#import "@preview/lilaq:0.6.0" as lq

#show: ufac-theme.with(
  aspect-ratio: "16-9",
  config-info(
    kind: "lecture",
    subject: [Circuitos com o zap],
    subject-code: [UFAC],
    unit: [Demonstração],
    unit-title: [Estilo de circuito do curso],
    author: [touying-ufac-lectures],
  ),
)

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

== Divisor de tensão
#align(center, circuito({
  import zap: *
  vsource("vi", (0, 0), (0, 4), label: $v_i$)
  wire((0, 4), (3, 4))
  resistor("r1", (3, 4), (3, 2), label: $R_1$)
  resistor("r2", (3, 2), (3, 0), label: $R_2$)
  wire((3, 0), (0, 0))
  wire((3, 2), (5.5, 2))
  wire((3, 0), (5.5, 0))
  node("n1", (3, 2))                                       // junção: ponto cheio
  node("n2", (3, 0))
  node("a", (5.5, 2), fill: false)                         // terminal: círculo vazado
  node("b", (5.5, 0), fill: false)
  corrente((0, 4), (3, 4), $i$)
  tensao-terminais((5.5, 1.55), (5.5, 0.45), $v_o$)
}))

== Equivalente de Norton
#align(center, circuito({
  import zap: *
  regiao((-1.6, -0.5), (3.9, 4.5), rotulo: [Equivalente de Norton])
  isource("is", (0, 0), (0, 4), label: $i_s (t)$)          // a seta vai do primeiro nó para o segundo
  wire((0, 4), (3, 4))
  resistor("r", (3, 4), (3, 0), label: $R$)
  wire((3, 0), (0, 0))
  wire((3, 4), (5.5, 4))
  wire((3, 0), (5.5, 0))
  node("n1", (3, 4))
  node("n2", (3, 0))
  node("a", (5.5, 4), fill: false, label: (content: $a$, anchor: "east"))
  node("b", (5.5, 0), fill: false, label: (content: $b$, anchor: "east"))
  tensao-terminais((5.5, 3.3), (5.5, 0.7), $v(t)$)
}))

== Amplificador inversor
#align(center, circuito(length: 1.7cm, {
  import zap: *
  opamp("op", (5, 0))                                      // entrada − em (4.1, 0.45), + em (4.1, -0.45)
  node("vi", (0, 0.45), fill: false, label: (content: $v_i (t)$, anchor: "west"))
  resistor("r1", (0, 0.45), (3, 0.45), label: $R_1$)
  wire((3, 0.45), "op.minus")
  wire((3, 0.45), (3, 2))
  resistor("rf", (3, 2), (6.8, 2), label: $R_f$)
  wire((6.8, 2), (6.8, 0))
  wire("op.out", (8, 0))
  node("j1", (3, 0.45))
  node("j2", (6.8, 0))
  node("vo", (8, 0), fill: false, label: (content: $v_o (t)$, anchor: "east"))
  wire("op.plus", (3.6, -0.45), (3.6, -1.1))
  ground("g", (3.6, -1.1))
}))

== Resposta do RC à rampa
#cols(columns: (auto, 1fr), gutter: 1.5em)[
  #circuito(length: 1.3cm, {
    import zap: *
    vsource("vs", (0, 0), (0, 4), label: $v_s (t)$)
    resistor("r", (0, 4), (7, 4), label: $R$)
    capacitor("c", (7, 4), (7, 0), label: $C$)
    wire((7, 0), (0, 0))
    tensao("c", $v_C (t)$)
  })
][
  #lq.diagram(
    width: 100%, height: 6.5cm,
    xlabel: [$t$ (s)],
    legend: (position: top + left),
    lq.plot(lq.linspace(0, 5), t => t, mark: none,
      stroke: (paint: colors.neutral-dark, thickness: 1.5pt, dash: "dashed"), label: $v_s (t)$),
    lq.plot(lq.linspace(0, 5), t => t - (1 - calc.exp(-t)), mark: none, stroke: 2pt + colors.primary,
      label: $v_C (t)$),
  )
]

== Destaque de um componente
#align(center, circuito({
  import zap: *
  vsource("vs", (0, 0), (0, 4), label: $v_s (t)$)
  resistor("r", (0, 4), (5, 4), label: $R$)
  inductor("l", (5, 4), (5, 0), label: text(fill: colors.secondary-dark, $L$), stroke: 2pt + colors.secondary-dark)
  wire((5, 0), (0, 0))
  corrente((5, 0), (0, 0), $i(t)$)                         // para a esquerda: rótulo abaixo do fio
  tensao("l", $v_L (t)$)
}))
