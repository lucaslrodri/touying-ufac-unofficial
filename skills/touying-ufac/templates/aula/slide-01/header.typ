// O header.typ do deck (modelo do modo aula da skill touying-ufac; a disciplina do exemplo é Sinais e Sistemas): as
// funções grandes e o que vários decks da disciplina usam. Aqui, o estilo dos gráficos de sinal; numa disciplina de
// verdade, também os dados do plano (`#let plano = json("/data/<disciplina>-plano.json")`, do ufac-syllabus) e o
// código da turma. Não há common.typ: cada deck leva a sua cópia, tirada do header.typ do deck anterior. Os arquivos
// de figura o importam por `#import "../../header.typ": grafico`.
#import "@preview/touying-ufac-unofficial:0.4.0": colors
#import "@preview/lilaq:0.6.0" as lq

// Um gráfico de sinal no estilo da disciplina: os eixos passam pela origem, sem grade, e os rótulos ficam no tamanho
// do corpo (nunca menor); as curvas vêm nas cores do tema, a principal em azul. `curvas` são os `lq.plot` do gráfico;
// `width` e `height` dão o tamanho no slide (12cm × 5cm num slide com enunciado e figura).
#let grafico(xlabel: $t$, ylabel: $x(t)$, width: 12cm, height: 5cm, xlim: auto, ylim: auto, ..curvas) = lq.diagram(
  width: width,
  height: height,
  xlim: xlim,
  ylim: ylim,
  grid: none,
  xaxis: (position: 0, label: xlabel),
  yaxis: (position: 0, label: ylabel),
  cycle: (colors.primary, colors.secondary-dark, colors.tertiary),
  ..curvas,
)
