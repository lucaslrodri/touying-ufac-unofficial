// Modelo de deck do modo acadêmico da skill touying-ufac (touying-ufac-unofficial 0.4.0). O trabalho é fictício, só
// de exemplo, e também os números, os dados (data/soc.csv) e as referências (referencias.bib).
// Copie esta pasta para a da apresentação e compile de lá (a raiz é a pasta do deck):
//   typst compile deck.typ
// Pastas: as figuras feitas em Typst em figures/<tipo>/, os dados em data/, as imagens prontas em assets/ e, quando
// houver uma função grande, o header.typ. Sequência: capa, Introdução, Metodologia, Resultados, Conclusões,
// Agradecimentos, Referências, encerramento e os slides de reserva, sem roteiro. Sintaxe e componentes:
// references/padroes-do-tema.md; sequência e tempo: references/academico/estrutura.md.

#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.4.0": *

#show: ufac-theme.with(
  aspect-ratio: "16-9",
  config-info(
    // "tcc", "dissertation" ou "thesis" (defesa ou qualificação: a etiqueta da capa vem do tipo, e short-title: [..]
    // a troca); "coursework" (trabalho de disciplina)
    flavor: "tcc",
    title: [Estimação do estado de carga de baterias de lítio],
    course: [Bacharelado em Engenharia Elétrica],
    // quem apresenta no primeiro grupo; cada rótulo em itálico abre um grupo
    author: [_Discente_ \ Nome do Discente \ _Orientador_ \ Prof. Dr. Nome do Orientador],
    date: [Dezembro de 2026],
    contact: [`nome.discente@sou.ufac.br`],
  ),
)

// nada que gere conteúdo antes da capa: só imports, #let e regras
#title-slide()

// sem roteiro: da capa, direto para a primeira Parte
// Parte: a etapa do argumento, não o capítulo do texto; depois do =, só uma figura que represente o assunto (um
// desenho, um diagrama, um gráfico ou a foto de uma pessoa ou de um objeto), nunca um ícone
= Introdução
#include "figures/drawings/bateria.typ"

// contexto: por que o problema importa; a obra de onde vem cada afirmação entra no referencias.bib, não no slide
== Toda bateria precisa de um indicador de carga
-> Celulares, carros elétricos e sistemas fotovoltaicos usam baterias de lítio;
-> O estado de carga (SoC) não se mede: ele é estimado.

// o problema e a lacuna
== Contar a corrente acumula erro
#emph-box(color: colors.tertiary, title: [Problema])[
  A contagem de Coulomb soma a corrente no tempo, e o erro do sensor se acumula a cada hora.
]

-> O filtro de Kalman corrige a contagem com a tensão medida.

// o objetivo geral e os específicos: cada um volta numa conclusão
== Objetivo
#emph-box(title: [Objetivo geral])[Estimar o SoC de uma célula de lítio com erro menor que 2%.]

+ Modelar a célula por um circuito equivalente;
+ Comparar a contagem de Coulomb com o filtro de Kalman.

= Metodologia
#include "figures/diagrams/ensaio.typ"

// o método como fluxo: um arquivo em figures/diagrams/, incluído no slide
== O ensaio em três etapas
#align(center, include "figures/diagrams/ensaio.typ")

Uma célula de 2,5 Ah descarrega a 0,75 A por 120 min; a tensão e a corrente são medidas a cada segundo.

// a métrica antes do resultado que a usa
== O erro é a diferença para o SoC de referência
> $ e(t) = "SoC"_"est" (t) - "SoC"_"ref" (t) $

-> O $"SoC"_"ref"$ vem da carga descarregada, medida em laboratório.

= Resultados
#include "figures/graphs/soc.typ"

// resultado: o título diz o achado; a figura, num arquivo que lê data/soc.csv, é a evidência
== O filtro de Kalman fica a menos de 1% da referência
#align(center, include "figures/graphs/soc.typ")

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
#include "figures/drawings/bateria.typ"

// uma conclusão por objetivo específico, na ordem dos objetivos
== Conclusões
+ O circuito equivalente reproduz a tensão da célula no ensaio;
+ O filtro de Kalman ficou a menos de 1% da referência, e a contagem chegou a 5,3%.

#note[Próximo passo: ensaios em outras temperaturas.]

// fomento: a agência e o número do processo, quando houver
== Agradecimentos
-> À agência de fomento, pela bolsa (processo nº 0000/2026);
-> Ao laboratório, pelo ensaio das células.

// as obras de onde vêm os dados, as equações e as afirmações, só aqui: os slides não citam. O referencias.bib tem só
// as obras da apresentação, e `full: true` lista todas (sem ele, a lista sairia vazia)
== Referências
#bibliography("referencias.bib", title: none, full: true, style: "associacao-brasileira-de-normas-tecnicas")

// encerramento: agradecimento, perguntas e contato
#ending-slide[Obrigado!][Perguntas?][#info("contact")]

// reserva: depois do encerramento e fora do tempo, um slide por pergunta prevista da banca; o rodapé segue
// numerando, e o #show: appendix congela o total do Touying no encerramento
#show: appendix

== Por que um circuito equivalente de primeira ordem?
-> Um par RC reproduz a tensão do ensaio com erro menor que 10 mV;
-> Um segundo par RC não reduziu o erro do SoC.
