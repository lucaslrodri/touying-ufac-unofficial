---
name: touying-ufac-academic
description: Use ao preparar, escrever, revisar ou reorganizar os slides da apresentação de um trabalho acadêmico com o tema Typst touying-ufac-unofficial (Touying), como defesa de TCC, de dissertação ou de tese, exame de qualificação, trabalho de disciplina, seminário ou comunicação em congresso, e sempre que pedirem "slides da defesa", "apresentação do TCC", "slides da qualificação" ou "apresentação no congresso". Para aulas de uma disciplina, use a touying-ufac-lectures.
---

# Trabalhos acadêmicos com o touying-ufac

**Princípio:** a apresentação defende uma mensagem central com as evidências do trabalho, no tempo dado. Cada slide tem uma ideia e pouco conteúdo; o que não cabe vira outro slide ou vai para a reserva.

**Violar a letra destas regras é violar o espírito delas.**

## Regras

1. **Pouco por slide.** Uma ideia, até cerca de 40 palavras de texto ou 5 itens; fórmulas, título e rótulos de figura não contam. Se não couber, quebre em 2 ou mais slides: `---` repete o título, ou abra um `==` novo. A tabela do texto não entra inteira: só as linhas e colunas que sustentam a mensagem; a completa vai para a reserva.
2. **Nunca diminuir a letra.** Proibido:
   - `text(size: …)` ou `set text(size: …)` menor que 1em;
   - `scale()` sobre texto;
   - inset ou margem apertados para caber;
   - figura colada como imagem com números ou rótulos menores que o corpo.

   Referências, tabelas e rótulos de gráfico também ficam no tamanho do corpo. A legenda de figura é do tema (0.6em) e não se mexe.
3. **Fiel ao trabalho e às fontes.**
   - Todo número, unidade, equação, tabela e figura vem do texto do trabalho ou dos dados dele, com o mesmo valor e o mesmo arredondamento. O que não está nas fontes vira pergunta ao autor; nada é inventado.
   - A afirmação não passa do que o resultado sustenta: nada de "prova", "sempre" ou "o melhor" que o texto não diga.
   - Figura, dado ou frase de outro trabalho leva a citação no slide (`@chave`, no estilo da ABNT) e a referência no slide "Referências"; foto de terceiros, o crédito.
4. **Segue o argumento, não o sumário.** A sequência é contexto e lacuna, objetivo, método, resultados e conclusões. A revisão de literatura vira contexto em poucos slides; capítulo do texto não vira Parte por ser capítulo. Cada objetivo específico tem uma conclusão.
5. **O título diz a mensagem.** Nos resultados e na discussão, o título é o achado, até 60 caracteres ("O filtro de Kalman fica a menos de 1% da referência"), e o corpo traz a evidência: gráfico, tabela reduzida ou equação. Nunca "Resultados", "Tabela 3" ou "Gráfico".
6. **O tempo manda.** Cerca de um slide de conteúdo por minuto do tempo dado pelo regimento, pelo evento ou pelo professor. O que passa do tempo vai para a reserva, depois do encerramento; nunca letra menor, nunca fala corrida.
7. **Código explícito.**
   - Use os componentes do tema como estão. Uma mudança pequena se escreve no próprio slide.
   - Não crie função para um elemento parecido com o que já existe (nada de `caixa`, nada de dicionário de argumentos espalhado com `..mini`).
   - Função nova só quando o código é grande ou o tema não tem o recurso (estilo de diagrama, de gráfico, de circuito). Nesse caso ela vai para um `comum.typ` ao lado do deck.
8. **Figuras:**
   - gráficos com lilaq, lendo os dados do trabalho (CSV);
   - circuitos com o pacote `zap`;
   - fluxos do método e diagramas de blocos com fletcher;
   - desenhos com CeTZ;
   - fotos e capturas como imagem, com crédito.

   Cores só do tema (`colors.*`), nada de `rgb()` ou hexadecimal.
9. **Só os callouts do tema:**
   - `#caution`: limitação ou cuidado;
   - `#tip`: atalho;
   - `#remark`: só retoma o que já foi mostrado;
   - `#note`: secundário ou o próximo passo;
   - `#example` e `#examples`: exemplo curto.

   Destaques (`~~ ~~`, `== ==`) com parcimônia, nunca em item curto nem em tópico. Nada de travessão "—" no texto, que quebra a página no tema.
10. **Encerramento e reserva.** Depois das Conclusões: "Agradecimentos" (o fomento, quando houver), "Referências" e `#ending-slide[Obrigado!][Perguntas?][#info("contact")]`, sem meme. Depois, `#show: appendix` e os slides de reserva, um por pergunta prevista da banca.

## Antes de começar: o tema 0.3.0

Os modelos importam o tema pelo nome publicado, `@preview/touying-ufac-unofficial:0.3.0`. Se a 0.3.0 ainda não estiver no Typst Universe, use a versão de desenvolvimento como pacote local: se `@local/touying-ufac-unofficial:0.3.0` não estiver instalado, instale o branch `develop` do [repositório](https://github.com/lucaslrodri/touying-ufac-unofficial) (com o gotpm, ou copiando-o para a pasta de pacotes locais do Typst) e troque `@preview` por `@local` no import do tema. Diga ao usuário o que instalou e onde.

## Fluxo

Crie uma tarefa para cada passo.

1. **Fontes.** Leia:
   - o texto do trabalho (o `.typ`, o `.tex`, o PDF ou o `.docx`), do resumo às conclusões;
   - os dados e os scripts das figuras;
   - a bibliografia (`.bib`);
   - as regras da apresentação: tempo, banca ou público, normas do programa ou do evento;
   - o parecer da qualificação e apresentações anteriores do trabalho, se houver.
2. **Plano da apresentação.** Preencha `templates/plano-da-apresentacao.md` e salve ao lado do deck. Ele traz:
   - a mensagem central, numa frase;
   - os objetivos específicos e a conclusão de cada um;
   - a sequência por Parte, com os minutos e o título de cada slide;
   - os números-chave, conferidos com o texto;
   - as figuras, as siglas e as perguntas previstas, com o slide de reserva de cada uma.

   Mostre o plano ao autor antes dos slides, a menos que ele já tenha pedido os slides direto.
3. **Escrever o deck** a partir de `templates/deck.typ`, com `references/padroes-do-tema.md` (sintaxe, componentes e armadilhas) e `references/zap.md` para circuitos. A sequência, os títulos e o tempo estão em `references/estrutura.md`.
4. **Compilar e verificar:**
   - `typst compile` e PNGs das páginas;
   - `python3 scripts/folha_de_contato.py <deck.pdf>`;
   - `python3 scripts/verificar_deck.py <pasta-do-deck> <deck.pdf> --minutos <N>`. Bloqueio se corrige antes de seguir.
5. **Revisores.** Despache 3 subagentes em paralelo, com os prompts de `references/revisores.md`:
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

| Pensamento | O certo |
|---|---|
| "Cabe se eu diminuir um pouco a letra." | Quebre em dois slides ou leve à reserva. |
| "Colo a tabela inteira do texto." | Só as linhas que sustentam a mensagem; a completa vai para a reserva. |
| "Arredondo diferente, fica mais limpo." | O número é o do texto, com o mesmo arredondamento. |
| "Escrevo 'comprova', soa mais forte." | A afirmação não passa do que o resultado sustenta. |
| "Um slide por capítulo do texto." | Siga o argumento; a revisão de literatura vira contexto. |
| "O título 'Resultados' basta." | O título diz o achado. |
| "São 35 slides para 20 minutos, eu falo rápido." | O excedente vai para a reserva. |
| "O gráfico do texto já está pronto, colo o PNG." | Refaça com lilaq a partir dos dados. |
| "Todo mundo conhece essa figura, dispensa a fonte." | Figura de terceiros tem citação. |
| "Vou criar uma funçãozinha para esta caixa." | Use o componente do tema, escrito no slide. |
| "Já olhei as páginas, não precisa de revisor." | Os 3 revisores rodam sempre; a evidência vem deles. |
