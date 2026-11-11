# Plano de aula: <assunto do deck>

<!--
Modelo da skill touying-ufac (modo aula). Salve ao lado do deck (slide-NN/plano-de-aula.md) e mostre ao professor antes dos slides. Troque cada <campo> pelo valor e apague os comentários e as linhas "ex.:" (exemplos de Sinais e Sistemas).

- Tudo vem das fontes: o plano de curso (o JSON do ufac-syllabus, em data/), o README do repositório de aulas, os decks anteriores e a bibliografia. O que não está nelas vira pergunta ao professor.
- Nada por encontro: sem data de aula, horário, sala, minutos por slide ou "na aula 3". O planejamento é por prova.
- Toda resposta de questão foi refeita por você (à mão, em Python ou conferida no livro) antes de entrar aqui.
- A bibliografia serve ao conteúdo e não entra nos slides: na aula não há referências.
-->

## Identificação

| Campo | Valor |
|---|---|
| Disciplina | <nome> (<código>), <semestre> |
| Unidade | <Unidade N: título no plano de curso> |
| Assunto deste deck | <o assunto como um todo> |
| Deck | `slide-NN/slide-NN.typ`; compilar da pasta do deck: `typst compile --root .. slide-NN.typ` |
| Livros e seções | <livro, seções; livro, seções> (para o conteúdo; não entram nos slides) |
| Decks anteriores lidos | <slide-NN: Partes que este deck retoma> |

<!-- ex.: Sinais e Sistemas (CCET488), 2026.2 · Unidade II: Sistemas e sistemas lineares invariantes no tempo (LIT) · Oppenheim 1.5; Lathi 1.6 e 1.8 · slide-01: Impulso e degrau -->

## Prova

| Prova | Data estimada | O que cobra (do plano de curso) | O que este deck cobre |
|---|---|---|---|
| <$P_N$> | <dd/mm> | <unidades e tópicos> | <tópicos deste deck> |

<!-- ex.: | $P_1$ | 03/12 | Unidades I a III | Unidade II, tópicos 1 e 2: exemplos de sistemas e interconexões | -->

- O que da mesma prova fica em outros decks: <deck e assunto>.
- Nenhum tópico da prova sai do deck. Se o ritmo atrasar, o que sai da sala vira estudo em casa (seção Ritmo).

## Pré-requisitos a retomar

| Conceito | Onde foi visto | Como volta no deck |
|---|---|---|
| <conceito> | <deck, Parte, slide ou @rótulo> | `#remark[<o conceito, pelo nome>]` no slide <título> |

<!-- ex.: | degrau unitário | slide-01, "Impulso e degrau", @example-degrau | `#remark[O degrau $u[n]$ vale 1 para $n >= 0$ e 0 antes.]` no slide "Acumulador" | -->

## Objetivos

Ao fim do deck, o aluno consegue:

1. <verbo que se verifica numa prova discursiva (calcular, esboçar, mostrar, determinar) e o conteúdo>;
2. <...>.

## Sequência por Parte

<!-- Uma Parte (=) por assunto, na ordem lógica do conteúdo, com nome de assunto. Em cada assunto: exemplos introdutórios, definição, exemplos resolvidos e questões (as de sala e as para casa). Não há slide de resumo. Copie o bloco abaixo para cada Parte. -->

### Parte <N>: <assunto>

**Tópicos do plano de curso:** <o texto literal do tópico no JSON>.

**Exemplos introdutórios** (`<example>`, antes da definição: um caso concreto que o professor resolve)

| # | Enunciado | Solução |
|---|---|---|
| <N.1> | <enunciado> | <resultado e passos> |

**Definição**

- Enunciado: <texto do slide>.
- Equação em destaque: <$ ... $>.
- Contínuo e discreto: <como aparecem, lado a lado ou em páginas seguidas>.

**Exemplos resolvidos** (`<example>` com `#solution`)

| # | Enunciado | Solução (resultado e passos) |
|---|---|---|
| <N.2> | <enunciado> | <solução> |

**Questões discursivas** (`<question>`: enunciado, `---` e `#answer` com o desenvolvimento)

| # | Enunciado ("calcule", "esboce", "mostre", "determine") | Resposta | Conferida como |
|---|---|---|---|
| <N.1> | <enunciado> | <resposta desenvolvida> | <à mão, Python, livro (problema N)> |

<!-- ex.: | 2.3 | Calcule a saída do acumulador para $x[n] = u[n]$. | $y[n] = (n + 1) u[n] = r[n + 1]$ | à mão, n = 0 a 3 | -->
<!-- Nada de questão de marcar, verdadeiro ou falso, "qual destes" ou votação. -->

**Concepções erradas atacadas**

| Erro comum | Onde o deck ataca | Como |
|---|---|---|
| <o erro, como o aluno o comete> | <slide ou questão> | <`#caution`, exemplo, item da questão> |

<!-- ex.: | achar que a soma acumulada de $u[k]$ até $n$ dá $r[n]$ | Questão 2.3 | `#caution` e a conta em n = 0 | -->

**Figuras e circuitos**

| Figura | Ferramenta | Arquivo | Origem (só imagem de fora) |
|---|---|---|---|
| <o que mostra> | <zap, lilaq, fletcher, CeTZ; foto ou captura> | <`figures/<tipo>/<nome>.typ`; `assets/<nome>.jpg`> | <sem crédito; foto: autor, licença, link> |

<!-- ex.: | circuito RC | zap | `figures/circuits/rc.typ` | sem crédito | -->
<!-- ex.: | o Sol (figura da Parte) | foto | `assets/fotos/sol.jpg` | NASA/SDO (AIA), domínio público, [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:The_Sun_by_the_Atmospheric_Imaging_Assembly_of_NASA%27s_Solar_Dynamics_Observatory_-_20100819.jpg) | -->
<!-- Figura feita em Typst fica em figures/graphs/, diagrams/, drawings/ ou circuits/ e não leva crédito, nem quando é refeita de um livro. Crédito só de imagem tirada inteira de fora (foto, captura, capa de livro, meme), e só aqui: na aula não há slide de créditos. -->

## Ritmo (estimativa)

- Páginas previstas: <N> (<a> exemplos, <b> questões).
- Aulas estimadas: <N>, pelo ritmo dos decks anteriores (<páginas por aula>). É só estimativa; o deck não muda com ela.
- Se atrasar, sai da sala e vira estudo em casa, sem cortar conteúdo de prova:

| O que | Como o aluno estuda | Onde está no deck |
|---|---|---|
| <questão ou exemplo repetido> | <em casa, com a resposta no deck> | <título do slide> |

- Nunca sai: a definição, o primeiro exemplo de cada assunto e o que a prova cobra.

## Cobertura

| Tópico do plano de curso (literal) | Parte | Slides (títulos) |
|---|---|---|
| <tópico> | <N> | <"título", "título"> |

<!-- Todo tópico da prova que cai neste deck tem ao menos um exemplo e uma questão. Um tópico do plano que não está aqui vai com o deck onde está. Depois de compilar, acrescente as páginas do PDF a cada título. -->

## Pendências para o professor

- <decisão que depende dele>;
- <dado que não está nas fontes>.
