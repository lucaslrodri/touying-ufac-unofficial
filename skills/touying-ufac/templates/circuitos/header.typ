// header.typ: o estilo de circuito para o pacote zap 0.6.0 com o tema touying-ufac-unofficial, que não tem estilo de
// circuito. Validado com Typst 0.15.1, touying 0.7.4, touying-ufac-unofficial 0.3.0 e zap 0.6.0 (que traz o cetz
// 0.5.2). Guia: references/zap.md.
//
// Cada circuito fica num arquivo de figures/circuits/, que importa o zap e as funções daqui. O deck não importa nada
// disto: ele só inclui o arquivo do circuito. Como levar para um deck, no comentário do começo de circuitos-zap.typ.

#import "@preview/zap:0.6.0"
#import "@preview/touying-ufac-unofficial:0.3.0": colors

// Circuitos (zap): símbolos americanos (IEEE: resistor em zigue-zague, fonte com + e −), traço de 1.4pt e as cores
// do tema. Componentes, fios e rótulos em neutral-darkest; tensão em primary; corrente em tertiary; destaque em
// secondary-dark. Desenhe a malha no sentido horário (fonte à esquerda, de baixo para cima; ramo de cima, da
// esquerda para a direita; ramo da direita, de cima para baixo): o rótulo do componente fica fora da malha e a
// tensão (`tensao`) fica dentro. A letra não muda com `length`: se o circuito não couber, alargue as coordenadas,
// tire rótulos secundários ou quebre o slide, nunca use scale() nem text(size: ..).

// Estilo do zap. Chame no começo do bloco de `zap.circuit(length: .., { .. })`, logo depois do `import zap: *` e
// antes dos componentes.
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
