// Modelo de deck de trabalho acadêmico (touying-ufac-unofficial 0.3.0). O trabalho é fictício, só de exemplo, e
// também os números, os dados (dados/soc.csv) e as referências (referencias.bib).
// Copie para a pasta da apresentação, com o .bib do trabalho e os dados das figuras, e compile de lá:
//   typst compile defesa.typ
// Sequência: capa, roteiro, Introdução, Metodologia, Resultados, Conclusões, Agradecimentos, Referências,
// encerramento e os slides de reserva. Sintaxe e componentes: references/padroes-do-tema.md; sequência e tempo:
// references/estrutura.md.

#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/zero:0.6.1"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#show: ufac-theme.with(
  aspect-ratio: "16-9",
  config-info(
    // "tcc", "dissertation" ou "thesis" (defesa ou qualificação: a etiqueta da capa vem do tipo, e short-title: [..]
    // a troca); "coursework" (trabalho de disciplina); "talk" (congresso, seminário)
    kind: "tcc",
    title: [Estimação do estado de carga de baterias de lítio],
    course: [Bacharelado em Engenharia Elétrica],
    // quem apresenta no primeiro grupo; cada rótulo em itálico abre um grupo
    author: [_Discente_ \ Nome do Discente \ _Orientador_ \ Prof. Dr. Nome do Orientador],
    date: [Dezembro de 2026],
    contact: [`nome.discente@sou.ufac.br`],
  ),
)

// os dados das figuras, lidos do arquivo do trabalho: nenhum número copiado à mão
#let soc = csv("dados/soc.csv", row-type: dictionary).map(r => r.keys().map(k => (k, float(r.at(k)))).to-dict())

// nada que gere conteúdo antes da capa (um #zero.set-num solto ali cria uma página em branco)
#title-slide()

== Roteiro
#outline()

// Parte: a etapa do argumento, não o capítulo do texto; depois do =, só a imagem ou o ícone
= Introdução
#icon("info", size: 6em)

// contexto: por que o problema importa, com a fonte de cada afirmação
== Toda bateria precisa de um indicador de carga
-> Celulares, carros elétricos e sistemas fotovoltaicos usam baterias de lítio;
-> O estado de carga (SoC) não se mede: ele é estimado @exemplo2021.

// o problema e a lacuna
== Contar a corrente acumula erro
#emph-box(color: colors.tertiary, title: [Problema])[
  A contagem de Coulomb soma a corrente no tempo, e o erro do sensor se acumula a cada hora.
]

-> O filtro de Kalman corrige a contagem com a tensão medida @modelo2023.

// o objetivo geral e os específicos: cada um volta numa conclusão
== Objetivo
#emph-box(title: [Objetivo geral])[Estimar o SoC de uma célula de lítio com erro menor que 2%.]

+ Modelar a célula por um circuito equivalente;
+ Comparar a contagem de Coulomb com o filtro de Kalman.

= Metodologia
#icon("note", size: 6em)

// o método como fluxo: fletcher, nas cores do tema
== O ensaio em três etapas
#align(center, diagram(
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
))

Uma célula de 2,5 Ah descarrega a 0,75 A por 120 min; a tensão e a corrente são medidas a cada segundo.

// a métrica antes do resultado que a usa
== O erro é a diferença para o SoC de referência
> $ e(t) = "SoC"_"est" (t) - "SoC"_"ref" (t) $

-> O $"SoC"_"ref"$ vem da carga descarregada, medida em laboratório.

= Resultados
#icon("example", size: 6em)

// resultado: o título diz o achado; a figura, lida dos dados, é a evidência
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

// a tabela do texto, só com as linhas que sustentam a mensagem; a linha do método proposto em destaque
== Em 120 min, a contagem erra 5,3% e o Kalman, 0,5%
#align(center, table(columns: 3,
  table.header([Método], [Erro máximo], [Erro em 120 min]),
  [Contagem de Coulomb], [5,3%], [5,3%],
  table.cell(fill: colors.secondary-lighter)[*Filtro de Kalman*],
  table.cell(fill: colors.secondary-lighter)[*0,6%*],
  table.cell(fill: colors.secondary-lighter)[*0,5%*],
))

#caution[O ensaio usou uma célula só, a 25 °C.]

= Conclusões
#icon("tip", size: 6em)

// uma conclusão por objetivo específico, na ordem dos objetivos
== Conclusões
+ O circuito equivalente reproduz a tensão da célula no ensaio;
+ O filtro de Kalman ficou a menos de 1% da referência, e a contagem chegou a 5,3%.

#note[Próximo passo: ensaios em outras temperaturas.]

// fomento: a agência e o número do processo, quando houver
== Agradecimentos
-> À agência de fomento, pela bolsa (processo nº 0000/2026);
-> Ao laboratório, pelo ensaio das células.

// só as obras citadas nos slides; o estilo da ABNT dá (EXEMPLO, 2021) no texto
== Referências
#bibliography("referencias.bib", title: none, style: "associacao-brasileira-de-normas-tecnicas")

// encerramento: agradecimento, perguntas e contato
#ending-slide[Obrigado!][Perguntas?][#info("contact")]

// reserva: depois do encerramento e fora do tempo, um slide por pergunta prevista da banca; o rodapé segue
// numerando, e o #show: appendix congela o total do Touying no encerramento
#show: appendix

== Por que um circuito equivalente de primeira ordem?
-> Um par RC reproduz a tensão do ensaio com erro menor que 10 mV;
-> Um segundo par RC não reduziu o erro do SoC.
