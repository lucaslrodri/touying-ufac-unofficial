# Plano da apresentação: <título do trabalho>

<!--
Modelo da skill touying-ufac-academic. Salve ao lado do deck (defesa/plano-da-apresentacao.md) e mostre ao autor
antes dos slides. Troque cada <campo> pelo valor e apague os comentários e as linhas "ex.:" (do TCC fictício do
templates/deck.typ).

- Tudo vem das fontes: o texto do trabalho, os dados, o .bib, as regras do programa ou do evento e, se houver, o
  parecer da qualificação. O que não está nelas vira pergunta ao autor.
- Todo número que vai a um slide foi conferido com o texto (página ou tabela) antes de entrar aqui.
-->

## Identificação

| Campo | Valor |
|---|---|
| Trabalho | <TCC, dissertação, tese, qualificação, trabalho de disciplina, comunicação em congresso> (`kind: "<tipo>"`) |
| Título | <o título, igual ao da capa do texto> |
| Autor e orientação | <quem apresenta; orientador e coorientador> |
| Curso, programa ou evento | <nome> |
| Banca ou público | <membros da banca, ou o público do evento> |
| Data e tempo | <data>; <N> minutos de fala, pelo <regimento, edital, professor> |
| Texto do trabalho | <caminho do .typ, .tex, .pdf ou .docx; versão ou data> |
| Dados e bibliografia | <caminho dos CSV e do .bib> |
| Deck | `<pasta>/<arquivo>.typ`; compilar da pasta: `typst compile <arquivo>.typ` |

<!-- ex.: TCC (`kind: "tcc"`) · Estimação do estado de carga de baterias de lítio · 20 min, pelo regulamento do TCC -->

## Mensagem central

<Uma frase: o problema, o que o trabalho fez e o que encontrou.>

<!-- ex.: Um filtro de Kalman sobre a contagem de Coulomb estima o estado de carga de uma célula de lítio a menos de
1% da referência. -->

## Objetivos e conclusões

| Objetivo específico (literal do texto) | Resultado que o responde | Slide da conclusão |
|---|---|---|
| <objetivo> | <resultado, com o número e a página do texto> | <título do slide> |

<!-- ex.: | Comparar a contagem de Coulomb com o filtro de Kalman | Kalman a 0,6% da referência, contagem a 5,3% (Tabela 4.2, p. 41) | "Conclusões" | -->

## Sequência por Parte

| Parte | Minutos | Slides (o título de cada um) | Evidência | Onde está no texto |
|---|---|---|---|---|
| <Introdução> | <N> | <"título", "título"> | <figura, tabela, equação ou citação> | <seção, página> |

<!-- Uma linha por Parte (=), na ordem do argumento: Introdução, (Fundamentação), Metodologia, Resultados,
Conclusões. Nos resultados, o título é o achado. A soma dos minutos é o tempo da fala; cerca de um slide de conteúdo
por minuto. -->

## Números-chave

| Número no slide | Unidade e arredondamento | Onde está no texto | Conferido como |
|---|---|---|---|
| <valor> | <unidade, casas> | <tabela, figura ou página> | <lido no texto; refeito dos dados> |

<!-- ex.: | 0,6% | %, uma casa | Tabela 4.2, p. 41 | refeito do dados/soc.csv | -->

## Figuras

| Figura | Ferramenta | Dados ou origem | Fonte ou crédito |
|---|---|---|---|
| <o que mostra> | <lilaq, zap, fletcher, CeTZ, foto> | <arquivo de dados; figura N do texto> | <do próprio trabalho; adaptado de @chave; foto: autor, licença, link> |

## Siglas e símbolos

| Sigla ou símbolo | Definido no slide |
|---|---|
| <SoC> | <título do slide, antes do primeiro uso> |

## Perguntas previstas

| Pergunta | Resposta curta | Slide de reserva |
|---|---|---|
| <pergunta> | <resposta, com a fonte no texto> | <título do slide depois do #show: appendix> |

<!-- ex.: | Por que um circuito equivalente de primeira ordem? | Um par RC já reproduz a tensão com erro menor que 10 mV
(p. 30) | "Por que um circuito equivalente de primeira ordem?" | -->

## Críticas da qualificação

<!-- Só se houve qualificação: cada crítica da banca e onde a defesa a responde. Apague a seção se não houve. -->

| Crítica | Resposta | Slide |
|---|---|---|
| <crítica, do parecer> | <o que mudou no trabalho> | <título do slide> |

## Tempo

- Slides de conteúdo previstos: <N> para <M> minutos.
- Se passar: <os slides que vão para a reserva primeiro>.
- Nunca sai do corpo: o objetivo, o resultado principal e as conclusões.

## Pendências para o autor

- <decisão que depende dele>;
- <dado que não está nas fontes>.
