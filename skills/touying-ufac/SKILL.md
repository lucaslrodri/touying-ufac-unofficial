---
name: touying-ufac
description: Use ao preparar, escrever, revisar ou reorganizar slides com o tema Typst touying-ufac-unofficial (Touying) da UFAC, em dois modos. Aula, os slides e o plano de aula de uma disciplina, inclusive a apresentação do curso na primeira aula (ementa, avaliações, bibliografia), sempre que o professor pedir "aula", "slides", "deck" ou "plano de aula". Acadêmico, os slides da apresentação de um trabalho, como defesa de TCC, de dissertação ou de tese, exame de qualificação ou trabalho de disciplina, sempre que pedirem "slides da defesa", "apresentação do TCC" ou "slides da qualificação".
---

# Slides com o touying-ufac

**Princípio:** cada slide tem uma ideia e pouco conteúdo; o que não cabe vira outro slide. Na aula, o deck trata o assunto como um todo e cobre tudo o que cai na prova. No acadêmico, a apresentação defende uma mensagem central com as evidências do trabalho, no tempo dado.

**Violar a letra destas regras é violar o espírito delas.**

## Os modos

| Modo | Para | Quem decide o conteúdo | `flavor` do deck |
|---|---|---|---|
| **Aula** | as aulas de uma disciplina e a apresentação do curso | o professor e o plano de curso | `"lecture"` |
| **Acadêmico** | a apresentação de um trabalho: TCC, dissertação, tese, qualificação, trabalho de disciplina | o texto do trabalho e os dados dele | `"tcc"`, `"dissertation"`, `"thesis"`, `"coursework"` |

Escolha o modo pelo pedido; num deck que já existe, pelo `flavor` do `config-info` (sem ele, o deck é uma aula). Se ainda não estiver claro, pergunte. As regras comuns valem nos dois modos; cada modo soma as suas. Nas referências e nos revisores, "regra 3" é uma regra comum, "regra Aula 2" e "regra Acadêmico 4" são regras do modo.

## Regras comuns

1. **Pouco por slide.** Uma ideia, até cerca de 40 palavras de texto ou 5 itens; fórmulas, título e rótulos de figura não contam. Se não couber, quebre em 2 ou mais slides: `---` repete o título, ou abra um `==` novo. Slides densos por natureza, como ementa, cronograma e tabela, também se quebram; no acadêmico, a tabela do texto entra só com as linhas e colunas que sustentam a mensagem, e a completa vai para a reserva.
2. **Nunca diminuir a letra.** Proibido:
   - `text(size: …)` ou `set text(size: …)` menor que 1em;
   - `scale()` sobre texto;
   - inset ou margem apertados para caber;
   - função que reduza a letra;
   - figura colada como imagem com números ou rótulos menores que o corpo.

   Referências, tabelas e rótulos de gráfico também ficam no tamanho do corpo. A legenda de figura é do tema (0.6em) e não se mexe. Se uma função do `common.typ` da disciplina reduz a letra, passe o tamanho no uso ou proponha ao professor ajustá-la.
3. **Explícito é melhor que implícito.**
   - O código fica onde é usado: os componentes do tema como estão, e uma mudança pequena escrita no próprio slide, mesmo que se repita. Assim o deck guarda a identidade visual do tema.
   - O agente não cria função para tudo: nunca uma função pequena (até umas três linhas, cerca de 50 caracteres), nem uma que muda pouco o que se escreveria no slide, nem apelido de função (`#let a = b`), nem dicionário de argumentos espalhado com `..mini`.
   - Função nova do agente só quando o código é grande e o tema não tem o recurso (o estilo de um gráfico, de um diagrama, de um circuito). Ela vai para o `header.typ` do deck; na aula, se vários decks da disciplina a usam, para o `common.typ` dela.
   - O usuário cria as funções que quiser, e as dele ficam: o agente não as remove nem as reescreve sem pedido. O verificador aponta toda função pequena, só para informar.
4. **Figuras:**
   - gráficos com lilaq, lendo os dados de `data/`;
   - circuitos com o pacote `zap`, nunca com CeTZ à mão nem como imagem;
   - fluxos e diagramas de blocos com fletcher;
   - desenhos com CeTZ;
   - fotos, capturas e memes como imagem.

   Cores só do tema (`colors.*`), nada de `rgb()` ou hexadecimal.
5. **Só os callouts do tema:**
   - `#caution`: na aula, um erro a evitar; no acadêmico, uma limitação ou um cuidado;
   - `#tip`: atalho;
   - `#remark`: só retoma o que já foi mostrado;
   - `#note`: secundário, ou o que vem adiante;
   - `#example` e `#examples`: exemplo curto.

   Destaques (`~~ ~~`, `== ==`) com parcimônia, nunca em item curto nem em tópico. Nada de travessão "—" no texto: o Touying o toma pelo `---` e quebra a página.
6. **Cada coisa na sua pasta** (a árvore está em "Pastas", abaixo):
   - toda figura feita em Typst num arquivo seu, em `figures/<tipo>/<nome>.typ`: `graphs/` (lilaq), `diagrams/` (fletcher), `drawings/` (CeTZ), `circuits/` (zap);
   - os dados em `data/` (CSV e JSON);
   - as imagens prontas em `assets/` (fotos, capturas, o JSON dos ícones, o meme);
   - as funções grandes do deck no `header.typ`; na aula, o que vários decks da disciplina usam (os dados do plano, o estilo dos gráficos) no `common.typ` da pasta da disciplina. No acadêmico não há `common.typ`.
7. **Créditos e referências só no fim.**
   - Nenhuma "Fonte:", "Adaptado de" ou "Redesenhado de" na legenda nem no slide.
   - Crédito só de imagem tirada inteira de fora (foto, captura, capa de livro, meme), no slide "Créditos das imagens", no fim. Desenho do autor, ou refeito a partir de dados de outro trabalho, não leva crédito.
   - Na aula, nenhuma referência bibliográfica.
   - No acadêmico, as referências só no slide "Referências", no fim, sem `@chave` nos slides: um `referencias.bib` com as obras da apresentação, listado inteiro com `#bibliography("referencias.bib", full: true, ..)`.

## Antes de começar: o tema 0.3.0

Os modelos importam o tema pelo nome publicado, `@preview/touying-ufac-unofficial:0.3.0`. Se a 0.3.0 ainda não estiver no Typst Universe, use a versão de desenvolvimento como pacote local: se `@local/touying-ufac-unofficial:0.3.0` não estiver instalado, instale o branch `develop` do [repositório](https://github.com/lucaslrodri/touying-ufac-unofficial) (com o gotpm, ou copiando-o para a pasta de pacotes locais do Typst) e troque `@preview` por `@local` no import do tema, em todo `.typ` que o importa (o deck, o `header.typ`, o `common.typ` e os arquivos de `figures/`). Diga ao usuário o que instalou e onde.

## Pastas

Aula, uma pasta por disciplina e um deck por pasta (`templates/aula/`):

```
<disciplina>/
├── common.typ          o que vários decks usam: os dados do plano, o estilo dos gráficos e diagramas
├── data/               CSV e JSON da disciplina (o plano do ufac-syllabus)
└── slide-NN/           um deck por assunto, nunca "encontro-N"
    ├── slide-NN.typ    o deck (compile com: typst compile --root .. slide-NN.typ)
    ├── header.typ      só as funções grandes deste deck, quando houver
    ├── plano-de-aula.md
    ├── figures/{graphs,diagrams,drawings,circuits}/<nome>.typ
    └── assets/         fotos, capturas, ícones, meme
```

Acadêmico, uma pasta por apresentação (`templates/academico/`):

```
<apresentacao>/
├── deck.typ            o deck (compile com: typst compile deck.typ)
├── header.typ          só as funções grandes, quando houver
├── referencias.bib     só as obras da apresentação
├── plano-da-apresentacao.md
├── data/               CSV e JSON do trabalho
├── figures/{graphs,diagrams,drawings,circuits}/<nome>.typ
└── assets/             fotos e capturas
```

Uma figura entra no slide pelo arquivo dela: `#align(center, include "figures/graphs/soc.typ")`, ou `#figure(include "figures/graphs/soc.typ", caption: [..])`. O arquivo importa o que usa (o tema, o lilaq, o zap) e lê os dados por caminho absoluto a partir da raiz da compilação: `/data/soc.csv` no acadêmico, `/common.typ` e `/data/<disciplina>-plano.json` na aula; os arquivos do próprio deck da aula, por `../../` (`../../header.typ`). O estilo do zap e o exemplo de cada circuito estão em `templates/circuitos/`.

## Créditos e referências

| | Aula | Acadêmico |
|---|---|---|
| Citação no slide (`@chave`) | não | não |
| Lista de referências | não há | slide "Referências", no fim, com o `.bib` da apresentação inteiro (`full: true`) |
| Foto, captura, capa ou meme de fora | crédito no slide "Créditos das imagens", no fim | crédito no slide "Créditos das imagens", depois das Referências |
| Desenho do autor, ou refeito de dados de fora | sem crédito | sem crédito (a obra dos dados entra nas Referências) |
| Legenda | sem fonte | sem fonte |

## Modo aula

### Regras da aula

1. **Toda questão para o aluno é exercício discursivo:** `== Título <exercise>` (ou `#exercise-slide`), o enunciado, `---` e `#answer` com a solução desenvolvida. O aluno desenvolve a matemática ("calcule", "esboce", "mostre", "determine"). Nunca:
   - questão de marcar: alternativas (A) a (D), verdadeiro ou falso, "qual destes", votação;
   - pergunta solta num slide comum;
   - "aquecimento".
2. **Todo exemplo que o professor resolve é exemplo:** `== Título <example>` e `#solution`. A solução fica no mesmo slide se couber; se não, vai depois de `---`. Cada assunto abre com exemplos introdutórios concretos, antes da definição, e eles também são `<example>`.
3. **Organizar pelo assunto, nunca por encontro.** O encontro é só uma estimativa. Nada de:
   - "Encontro N", "Aula N" ou data de aula;
   - "Resumo do encontro" ou "Próximo encontro";
   - "(encontro N)";
   - arquivos `encontro-N.typ`.

   Partes (`=`), arquivos e resumos têm nome de assunto, e um `#remark` retoma o conceito pelo nome. O planejamento é por prova: todo o conteúdo de cada prova antes dela. A data da prova pode aparecer (vem do plano de curso), mas também é estimativa.
4. **O último slide é "Fim!" com um meme.** Sem "Obrigado!" e sem o que vem na próxima aula. O professor escolhe o meme entre candidatos que você traz, com link e crédito; os créditos das imagens de fora vêm no slide anterior.

### Fluxo da aula

Crie uma tarefa para cada passo.

1. **Fontes.** Leia:
   - o plano de curso (o JSON do `ufac-syllabus`, em `data/`);
   - o roteiro do curso (o README do repositório de aulas);
   - os decks anteriores, para os `#remark` e para não repetir;
   - a bibliografia, para o conteúdo (ela não entra nos slides);
   - as convenções do curso (CLAUDE.md ou README).
2. **Plano de aula.** Preencha `templates/aula/slide-01/plano-de-aula.md` e salve ao lado do deck. Ele traz:
   - o que cai na prova e as datas estimadas;
   - a sequência de assuntos;
   - por assunto: exemplos introdutórios, definição, exemplos resolvidos, exercícios discursivos com a resposta conferida, concepções erradas a atacar, figuras (com o arquivo de cada uma) e circuitos.

   Mostre o plano ao professor antes dos slides, a menos que ele já tenha pedido os slides direto.
3. **Primeira aula:** os slides de apresentação do curso, conforme `references/aula/apresentacao-do-curso.md`.
4. **Escrever o deck:** copie `templates/aula/slide-01/` para `<disciplina>/slide-NN/` (e `templates/aula/common.typ` para a pasta da disciplina, se ela não tiver um). Use `references/padroes-do-tema.md` (sintaxe, componentes, pastas e armadilhas), `references/zap.md` para circuitos e `references/aula/pedagogia.md` para a ordem didática.
5. **Compilar e verificar:**
   - `typst compile --root .. slide-NN.typ` e PNGs das páginas;
   - `python3 scripts/folha_de_contato.py <deck.pdf>`;
   - `python3 scripts/verificar_deck.py --modo aula <pasta-do-deck> <deck.pdf>`. Bloqueio se corrige antes de seguir.
6. **Revisores.** Despache 3 subagentes em paralelo, com o protocolo de `references/revisores.md` e os prompts de `references/aula/revisores.md`:
   - conteúdo e contas;
   - estilo de leitura;
   - tema e layout.

   Um corretor confirma cada achado no PDF antes de corrigir. Faça até 3 rodadas.
7. **Entregar com evidência:**
   - compilação feita agora;
   - verificador sem bloqueio;
   - revisores aprovando;
   - folha de contato.

   Diga o que ficou pendente e os candidatos a meme.

## Modo acadêmico

### Regras do acadêmico

1. **Fiel ao trabalho.**
   - Todo número, unidade, equação, tabela e figura vem do texto do trabalho ou dos dados dele, com o mesmo valor e o mesmo arredondamento. O que não está nas fontes vira pergunta ao autor; nada é inventado.
   - A afirmação não passa do que o resultado sustenta: nada de "prova", "sempre" ou "o melhor" que o texto não diga.
   - Toda obra de que vem um dado, uma equação, uma frase ou uma figura refeita entra no `referencias.bib` e no slide "Referências" (regra 7), não no slide em que é usada.
2. **Segue o argumento, não o sumário.** A sequência é contexto e lacuna, objetivo, método, resultados e conclusões. A revisão de literatura vira contexto em poucos slides; capítulo do texto não vira Parte por ser capítulo. Cada objetivo específico tem uma conclusão.
3. **O título diz a mensagem.** Nos resultados e na discussão, o título é o achado, até 60 caracteres ("O filtro de Kalman fica a menos de 1% da referência"), e o corpo traz a evidência: gráfico, tabela reduzida ou equação. Nunca "Resultados", "Tabela 3" ou "Gráfico".
4. **O tempo manda.** Cerca de um slide de conteúdo por minuto do tempo dado pelo regimento ou pelo professor. O que passa do tempo vai para a reserva, depois do encerramento; nunca letra menor, nunca fala corrida.
5. **Encerramento e reserva.** Depois das Conclusões: "Agradecimentos" (o fomento, quando houver), "Referências", "Créditos das imagens" (se houver imagem de fora) e `#ending-slide[Obrigado!][Perguntas?][#info("contact")]`, sem meme. Depois, `#show: appendix` e os slides de reserva, um por pergunta prevista da banca.

### Fluxo do acadêmico

Crie uma tarefa para cada passo.

1. **Fontes.** Leia:
   - o texto do trabalho (o `.typ`, o `.tex`, o PDF ou o `.docx`), do resumo às conclusões;
   - os dados e os scripts das figuras;
   - a bibliografia (`.bib`);
   - as regras da apresentação: tempo, banca, normas do programa;
   - o parecer da qualificação e apresentações anteriores do trabalho, se houver.
2. **Plano da apresentação.** Preencha `templates/academico/plano-da-apresentacao.md` e salve ao lado do deck. Ele traz:
   - a mensagem central, numa frase;
   - os objetivos específicos e a conclusão de cada um;
   - a sequência por Parte, com os minutos e o título de cada slide;
   - os números-chave, conferidos com o texto;
   - as figuras (com o arquivo de cada uma), as siglas, as obras das Referências e as perguntas previstas, com o slide de reserva de cada uma.

   Mostre o plano ao autor antes dos slides, a menos que ele já tenha pedido os slides direto.
3. **Escrever o deck:** copie `templates/academico/` para a pasta da apresentação. Use `references/padroes-do-tema.md` (sintaxe, componentes, pastas e armadilhas), `references/zap.md` para circuitos e `references/academico/estrutura.md` para a sequência, os títulos e o tempo.
4. **Compilar e verificar:**
   - `typst compile deck.typ` e PNGs das páginas;
   - `python3 scripts/folha_de_contato.py <deck.pdf>`;
   - `python3 scripts/verificar_deck.py --modo academico <pasta-do-deck> <deck.pdf> --minutos <N>`. Bloqueio se corrige antes de seguir.
5. **Revisores.** Despache 3 subagentes em paralelo, com o protocolo de `references/revisores.md` e os prompts de `references/academico/revisores.md`:
   - fidelidade e conteúdo;
   - leitura;
   - tema e layout.

   Um corretor confirma cada achado no PDF e no texto antes de corrigir. Faça até 3 rodadas.
6. **Entregar com evidência:**
   - compilação feita agora;
   - verificador sem bloqueio, com os slides de conteúdo contados para o tempo;
   - revisores aprovando;
   - folha de contato.

   Diga o que ficou pendente e as perguntas da banca sem resposta no deck.

## Sinais de alerta: pare e quebre ou refaça

Em todo deck:

| Pensamento | O certo |
|---|---|
| "Cabe se eu diminuir um pouco a letra." | Quebre em dois slides; no acadêmico, ou leve à reserva. |
| "Vou criar uma funçãozinha para esta caixa, ou para a foto." | Escreva no slide, com o componente do tema. |
| "Escrevo o gráfico direto no slide." | Um arquivo em `figures/graphs/`, incluído no slide. |
| "Ponho a fonte na legenda." | Crédito só de imagem de fora, no fim. |
| "Redesenhei do livro, então dou o crédito." | Figura refeita não leva crédito. |
| "Já olhei as páginas, não precisa de revisor." | Os 3 revisores rodam sempre; a evidência vem deles. |

Na aula:

| Pensamento | O certo |
|---|---|
| "É uma perguntinha rápida, um slide comum basta." | Toda questão é `<exercise>` com `#answer`. |
| "Uma questão de marcar engaja mais a turma." | Só discursiva: o aluno desenvolve a matemática. |
| "Um aquecimento antes do assunto." | Antes do assunto vem um exemplo introdutório (`<example>`); depois, exercício. |
| "Resolvo este caso num slide comum mesmo." | Caso resolvido pelo professor é `<example>`. |
| "A solução junto do enunciado economiza página." | No exercício, a resposta vem depois de `---`. |
| "Resumo do encontro" ou "Na próxima aula…" | Resumo por assunto; o fim é "Fim!" e meme. |
| "Cito o livro no slide." | Na aula não há referências. |
| "A função do curso já reduz a letra do gráfico." | Passe o tamanho no uso ou proponha ajustar o `common.typ`. |

No acadêmico:

| Pensamento | O certo |
|---|---|
| "Colo a tabela inteira do texto." | Só as linhas que sustentam a mensagem; a completa vai para a reserva. |
| "Arredondo diferente, fica mais limpo." | O número é o do texto, com o mesmo arredondamento. |
| "Escrevo 'comprova', soa mais forte." | A afirmação não passa do que o resultado sustenta. |
| "Um slide por capítulo do texto." | Siga o argumento; a revisão de literatura vira contexto. |
| "O título 'Resultados' basta." | O título diz o achado. |
| "São 35 slides para 20 minutos, eu falo rápido." | O excedente vai para a reserva. |
| "O gráfico do texto já está pronto, colo o PNG." | Refaça com lilaq a partir dos dados. |
| "Cito @chave como no texto." | A obra entra só no slide "Referências". |
