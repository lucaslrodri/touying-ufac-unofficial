# Plano da apresentação: <título do trabalho>

<!--
Modelo da skill touying-ufac (modo acadêmico). Salve ao lado do deck (<apresentacao>/plano-da-apresentacao.md) e mostre ao autor antes dos slides. Troque cada <campo> pelo valor e apague os comentários e as linhas "ex.:" (do TCC fictício de templates/academico/deck.typ).

- Tudo vem das fontes: o texto do trabalho, os dados, o .bib, as regras do programa ou do evento e, se houver, o parecer da qualificação. O que não está nelas vira pergunta ao autor.
- Todo número que vai a um slide foi conferido com o texto (página ou tabela) antes de entrar aqui.
- Os slides não citam: toda obra de que vem um dado, uma equação, uma frase ou uma figura refeita vai para a tabela "Referências do slide final".
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
| Dados e bibliografia do trabalho | <caminho dos CSV e do .bib> |
| Deck | `<apresentacao>/deck.typ`; compilar da pasta do deck: `typst compile deck.typ` |

<!-- ex.: TCC (`kind: "tcc"`) · Estimação do estado de carga de baterias de lítio · 20 min, pelo regulamento do TCC -->

## Mensagem central

<Uma frase: o problema, o que o trabalho fez e o que encontrou.>

<!-- ex.: Um filtro de Kalman sobre a contagem de Coulomb estima o estado de carga de uma célula de lítio a menos de 1% da referência. -->

## Objetivos e conclusões

| Objetivo específico (literal do texto) | Resultado que o responde | Slide da conclusão |
|---|---|---|
| <objetivo> | <resultado, com o número e a página do texto> | <título do slide> |

<!-- ex.: | Comparar a contagem de Coulomb com o filtro de Kalman | Kalman a 0,6% da referência, contagem a 5,3% (Tabela 4.2, p. 41) | "Conclusões" | -->

## Sequência por Parte

| Parte | Minutos | Slides (o título de cada um) | Evidência | Onde está no texto |
|---|---|---|---|---|
| <Introdução> | <N> | <"título", "título"> | <figura, tabela, equação ou número> | <seção, página> |

<!-- Uma linha por Parte (=), na ordem do argumento: Introdução, (Fundamentação), Metodologia, Resultados, Conclusões. Nos resultados, o título é o achado. A soma dos minutos é o tempo da fala; cerca de um slide de conteúdo por minuto. -->

## Números-chave

| Número no slide | Unidade e arredondamento | Onde está no texto | Conferido como |
|---|---|---|---|
| <valor> | <unidade, casas> | <tabela, figura ou página> | <lido no texto; refeito dos dados> |

<!-- ex.: | 0,6% | %, uma casa | Tabela 4.2, p. 41 | refeito do `data/soc.csv` | -->

## Figuras

| Figura | Ferramenta | Arquivo | Dados ou origem | Crédito (só imagem de fora) |
|---|---|---|---|---|
| <o que mostra> | <lilaq, zap, fletcher, CeTZ; foto ou captura> | <`figures/<tipo>/<nome>.typ`; `assets/<nome>.jpg`> | <`data/<arquivo>.csv`; figura N do texto; a obra de onde vêm os dados> | <sem crédito; foto: autor, licença, link> |

<!-- ex.: | SoC estimado e de referência ao longo do ensaio | lilaq | `figures/graphs/soc.typ` | `data/soc.csv`, do ensaio (Tabela 4.2, p. 41) | sem crédito | -->
<!-- Figura feita em Typst fica em figures/graphs/, diagrams/, drawings/ ou circuits/ e não leva crédito, nem quando é refeita a partir dos dados de outra obra: essa obra entra nas Referências. Crédito só de foto ou captura tirada inteira de fora, no slide "Créditos das imagens", depois das Referências. -->

## Referências do slide final

| Chave | Obra | Onde o deck a usa |
|---|---|---|
| <chave no .bib do trabalho> | <autores, ano, título curto> | <título do slide e o que vem dela: dado, equação, frase ou figura refeita> |

<!-- ex.: | modelo2023 | Modelo e Segundo, 2023, Um artigo de exemplo sobre o filtro de Kalman | "Contar a corrente acumula erro": a correção da contagem pela tensão medida | -->
<!-- O referencias.bib da apresentação tem estas obras e só estas, com as entradas copiadas do .bib do trabalho. O slide "Referências" lista todas com #bibliography("referencias.bib", full: true, ..), e nenhum slide tem @chave. -->

## Siglas e símbolos

| Sigla ou símbolo | Definido no slide |
|---|---|
| <SoC> | <título do slide, antes do primeiro uso> |

## Perguntas previstas

| Pergunta | Resposta curta | Slide de reserva |
|---|---|---|
| <pergunta> | <resposta, com a fonte no texto> | <título do slide depois do #show: appendix> |

<!-- ex.: | Por que um circuito equivalente de primeira ordem? | Um par RC já reproduz a tensão com erro menor que 10 mV (p. 30) | "Por que um circuito equivalente de primeira ordem?" | -->

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
