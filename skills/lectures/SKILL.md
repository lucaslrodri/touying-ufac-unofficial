---
name: touying-ufac-lectures
description: Use ao preparar, escrever, revisar ou reorganizar slides de aula ou o plano de aula de uma disciplina da UFAC com o tema Typst touying-ufac-unofficial (Touying), inclusive os slides de apresentação do curso na primeira aula (ementa, avaliações, bibliografia), e sempre que o professor pedir "aula", "slides", "deck" ou "plano de aula".
---

# Aulas com o touying-ufac

**Princípio:** cada slide tem uma ideia e pouco conteúdo. O que não cabe vira outro slide. O deck trata o assunto como um todo e cobre tudo o que cai na prova.

**Violar a letra destas regras é violar o espírito delas.**

## Regras do professor

1. **Pouco por slide.** Uma ideia, até cerca de 40 palavras de texto ou 5 itens; fórmulas e título não contam. Se não couber, quebre em 2 ou mais slides: `---` repete o título, ou abra um `==` novo. Slides densos por natureza, como ementa, cronograma e tabela, também se quebram.
2. **Nunca diminuir a letra.** Proibido:
   - `text(size: …)` ou `set text(size: …)` menor que 1em;
   - `scale()` sobre texto;
   - inset ou margem apertados para caber;
   - ajudante que reduza a letra.

   Rótulos e números de gráfico também ficam legíveis. Se um ajudante do curso reduz a letra, passe o tamanho no uso ou proponha ajustar o `comum.typ`.
3. **Toda questão para o aluno é exercício discursivo:** `== Título <exercise>` (ou `#exercise-slide`), o enunciado, `---` e `#answer` com a solução desenvolvida. O aluno desenvolve a matemática ("calcule", "esboce", "mostre", "determine"). Nunca:
   - questão de marcar: alternativas (A) a (D), verdadeiro ou falso, "qual destes", votação;
   - pergunta solta num slide comum;
   - "aquecimento".
4. **Todo exemplo que o professor resolve é exemplo:** `== Título <example>` e `#solution`. A solução fica no mesmo slide se couber; se não, vai depois de `---`. Cada assunto abre com exemplos introdutórios concretos, antes da definição, e eles também são `<example>`.
5. **Organizar pelo assunto, nunca por encontro.** O encontro é só uma estimativa. Nada de:
   - "Encontro N", "Aula N" ou data de aula;
   - "Resumo do encontro" ou "Próximo encontro";
   - "(encontro N)";
   - arquivos `encontro-N.typ`.

   Partes (`=`), arquivos e resumos têm nome de assunto, e um `#remark` retoma o conceito pelo nome. O planejamento é por prova: todo o conteúdo de cada prova antes dela. A data da prova pode aparecer (vem do plano de curso), mas também é estimativa.
6. **O último slide é "Fim!" com um meme.** Sem "Obrigado!" e sem o que vem na próxima aula. O professor escolhe o meme entre candidatos que você traz, com link e crédito.
7. **Código explícito.**
   - Use os componentes do tema e os ajudantes do curso como estão. Uma mudança pequena se escreve no próprio slide.
   - Não crie função para um elemento parecido com o que já existe (nada de `caixa`, nada de dicionário de argumentos espalhado com `..mini`).
   - Função nova só quando o código é grande ou o tema não tem o recurso (estilo de diagrama, de gráfico, de circuito). Nesse caso ela vai para o `comum.typ` do curso.
8. **Figuras:**
   - circuitos com o pacote `zap`;
   - gráficos com lilaq, pelos ajudantes do curso;
   - diagramas de blocos com fletcher;
   - desenhos com CeTZ.

   Cores só do tema (`colors.*`), nada de `rgb()` ou hexadecimal.
9. **Só os callouts do tema:**
   - `#caution`: erro a evitar;
   - `#tip`: atalho;
   - `#remark`: só retoma o que já foi visto;
   - `#note`: secundário ou o que vem adiante;
   - `#example` e `#examples`: exemplo curto.

   Destaques (`~~ ~~`, `== ==`) com parcimônia, nunca em item curto nem em tópico. Nada de travessão "—" no texto, que quebra a página no tema.

## Antes de começar: o tema 0.3.0

Os modelos importam o tema pelo nome publicado, `@preview/touying-ufac-unofficial:0.3.0`. Se a 0.3.0 ainda não estiver no Typst Universe, use a versão de desenvolvimento como pacote local: se `@local/touying-ufac-unofficial:0.3.0` não estiver instalado, instale o branch `develop` do [repositório](https://github.com/lucaslrodri/touying-ufac-unofficial) (com o gotpm, ou copiando-o para a pasta de pacotes locais do Typst) e troque `@preview` por `@local` no import do tema. Diga ao usuário o que instalou e onde.

## Fluxo

Crie uma tarefa para cada passo.

1. **Fontes.** Leia:
   - o plano de curso (JSON do `ufac-syllabus`);
   - o roteiro do curso (README do repositório de aulas);
   - os decks anteriores, para os `#remark` e para não repetir;
   - a bibliografia;
   - as convenções do curso (CLAUDE.md ou README).
2. **Plano de aula.** Preencha `templates/plano-de-aula.md` e salve ao lado do deck. Ele traz:
   - o que cai na prova e as datas estimadas;
   - a sequência de assuntos;
   - por assunto: exemplos introdutórios, definição, exemplos resolvidos, exercícios discursivos com a resposta conferida, concepções erradas a atacar, figuras e circuitos.

   Mostre o plano ao professor antes dos slides, a menos que ele já tenha pedido os slides direto.
3. **Primeira aula:** os slides de apresentação do curso, conforme `references/apresentacao-do-curso.md`.
4. **Escrever o deck** a partir de `templates/deck.typ`, com `references/padroes-do-tema.md` (sintaxe, componentes e armadilhas) e `references/zap.md` para circuitos. A ordem didática está em `references/pedagogia.md`.
5. **Compilar e verificar:**
   - `typst compile` e PNGs das páginas;
   - `python3 scripts/folha_de_contato.py <deck.pdf>`;
   - `python3 scripts/verificar_deck.py <pasta-do-deck> <deck.pdf>`. Bloqueio se corrige antes de seguir.
6. **Revisores.** Despache 3 subagentes em paralelo, com os prompts de `references/revisores.md`:
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

## Sinais de alerta: pare e quebre ou refaça

| Pensamento | O certo |
|---|---|
| "Cabe se eu diminuir um pouco a letra." | Quebre em dois slides. |
| "É uma perguntinha rápida, um slide comum basta." | Toda questão é `<exercise>` com `#answer`. |
| "Uma questão de marcar engaja mais a turma." | Só discursiva: o aluno desenvolve a matemática. |
| "Um aquecimento antes do assunto." | Antes do assunto vem um exemplo introdutório (`<example>`); depois, exercício. |
| "Resolvo este caso num slide comum mesmo." | Caso resolvido pelo professor é `<example>`. |
| "A solução junto do enunciado economiza página." | No exercício, a resposta vem depois de `---`. |
| "Vou criar uma funçãozinha para esta caixa." | Use o componente do tema, escrito no slide. |
| "Resumo do encontro" ou "Na próxima aula…" | Resumo por assunto; o fim é "Fim!" e meme. |
| "O ajudante do curso já reduz a letra do gráfico." | Passe o tamanho no uso ou proponha ajustar o ajudante. |
| "Já olhei as páginas, não precisa de revisor." | Os 3 revisores rodam sempre; a evidência vem deles. |
