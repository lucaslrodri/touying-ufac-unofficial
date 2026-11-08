# Estrutura: a sequência e o tempo

A ordem em que o trabalho entra no deck e no plano da apresentação. Vale para qualquer área; os exemplos são do modelo (`templates/deck.typ`), um TCC fictício sobre estado de carga de baterias. As regras do `SKILL.md` mandam.

## 1. A mensagem central

Antes de qualquer slide, escreva numa frase o que o público deve levar: o problema, o que o trabalho fez e o que encontrou. Ex.: "Um filtro de Kalman sobre a contagem de Coulomb estima o estado de carga de uma célula de lítio a menos de 1% da referência".

- A mensagem vem do texto do trabalho (resumo e conclusões), não de você.
- A capa, o objetivo e as conclusões dizem a mesma coisa.
- Teste: se a banca lembrar de uma frase só, é esta.

## 2. A sequência

A apresentação segue o argumento, não o sumário do texto (regra 4). Cada Parte (`=`) é uma etapa do argumento.

| Parte | Slides típicos | Fatia do tempo | O que entra |
|---|---|---|---|
| Introdução | 2 a 4 | ~20% | o contexto (por que importa), o problema, a lacuna (o que falta na literatura), o objetivo geral e os específicos |
| Fundamentação | 0 a 2 | ~10% | só o que o público precisa para entender o método; a revisão de literatura inteira não entra |
| Metodologia | 2 a 5 | ~20% | os dados ou o ensaio, o método como fluxo, os parâmetros, a métrica |
| Resultados e discussão | 3 a 8 | ~40% | um resultado por slide, com a evidência e a comparação com a referência ou com a literatura |
| Conclusões | 1 a 2 | ~10% | uma conclusão por objetivo específico, as contribuições, as limitações, os próximos passos |

As fatias são uma referência; o plano diz as do trabalho. Depois das Conclusões vêm Agradecimentos, Referências, o encerramento e a reserva, fora do tempo.

- **Objetivos e conclusões casados:** cada objetivo específico tem uma conclusão, na mesma ordem. Um objetivo sem conclusão é um buraco que a banca vê.
- **A métrica antes do resultado:** símbolo, sigla, dado ou métrica aparece definido antes do slide que o usa.
- **Trabalho em andamento** (qualificação, projeto): os resultados parciais e, no lugar de parte das conclusões, o que falta e o cronograma.

## 3. O título diz o achado

Nos resultados e na discussão, o título é uma frase curta com o achado, e o corpo traz a evidência que o sustenta: um gráfico, uma tabela reduzida, uma equação. É a abordagem afirmação e evidência (Alley, 2013), que melhora a compreensão do público em relação ao título de tópico com lista de itens (Garner e Alley, 2013).

| Em vez de | Escreva |
|---|---|
| "Resultados" | "O filtro de Kalman fica a menos de 1% da referência" |
| "Tabela 3" | "Em 120 min, a contagem erra 5,3% e o Kalman, 0,5%" |
| "Comparação dos métodos" | "O método proposto é 10 vezes mais rápido" |

- Até 60 caracteres (regra 2): um achado por título.
- A afirmação não passa do que a evidência mostra: "neste ensaio", "nesta amostra", quando for o caso (regra 3).
- Slides de estrutura (Roteiro, Objetivo, Metodologia, Conclusões, Referências) podem ter título de tópico.
- Teste dos títulos: lidos em ordem, só os títulos contam o trabalho.

## 4. O tempo

- **Cerca de um slide de conteúdo por minuto** (regra 6). Slide de conteúdo é cada `==` e cada página de `---` entre a capa e o encerramento, menos Roteiro, Agradecimentos e Referências; a página de cada Parte e a reserva não contam. O verificador conta com `--minutos N`.
- **O tempo vem da regra:** o regimento do programa, o edital do evento ou o professor da disciplina. Se as fontes não dizem, pergunte; não suponha.
- **Referência comum**, só para o plano antes de saber o tempo dado: comunicação em congresso, de 10 a 15 min; TCC e trabalho de disciplina, de 15 a 20 min; mestrado, de 30 a 40 min; doutorado, de 40 a 50 min.
- **Passou do tempo:** o slide sai para a reserva, ou dois slides viram um sem juntar ideias. Nunca letra menor, nunca "falo mais rápido".
- **`#pause`:** cada pausa é uma página a mais e custa tempo de fala; numa defesa, use pouco.

## 5. Resultados

- **Um resultado por slide**, com o achado no título e a evidência no corpo.
- **Gráfico com os dados do trabalho** (lilaq, lendo o CSV): eixo com grandeza e unidade, legenda, e a frase do que olhar embaixo.
- **Tabela reduzida:** as linhas e colunas que sustentam o título, com o método proposto em destaque; a tabela completa vai para a reserva.
- **Compare:** com a referência, com o método anterior ou com a literatura (com a citação). Um número sozinho não diz se é bom.
- **Números do texto:** o mesmo valor, a mesma unidade, o mesmo arredondamento e a mesma casa decimal da monografia (regra 3).

## 6. A reserva: as perguntas previstas

A banca pergunta o que o tempo não deixou mostrar. Para cada pergunta provável, um slide de reserva, depois do encerramento e do `#show: appendix`, com a pergunta no título.

| Pergunta comum | O que o slide de reserva mostra |
|---|---|
| Por que este método e não outro? | a alternativa e o critério da escolha |
| Por que estes parâmetros? | a sensibilidade ou o ensaio que os fixou |
| Os resultados valem fora deste caso? | as limitações e as ameaças à validade |
| Como foram os dados? | a amostra, a coleta, a limpeza |
| Qual é o resultado completo? | a tabela completa, o gráfico de cada caso |
| De onde vem esta equação? | a dedução |

- O plano lista as perguntas e o slide de cada uma.
- **Qualificação anterior:** cada crítica da banca tem resposta, num slide do corpo (se mudou o trabalho) ou da reserva.

## 7. `#remark` e `#note`

- `#remark` retoma o que já foi mostrado, pelo nome: o objetivo que o resultado responde ("Objetivo 2: …"), a métrica de um slide anterior. Nunca fato novo.
- `#note` traz o secundário (um detalhe do ensaio) ou o que vem adiante no trabalho (os próximos passos).

## 8. Notas do apresentador

Se o autor pedir um roteiro de fala, use `#speaker-note[..]` depois do conteúdo do slide (ele se prende ao slide anterior). A nota não aparece no slide projetado. Nunca mova para a nota o que o slide precisa mostrar.

## 9. Fontes

- Alley, M. *The Craft of Scientific Presentations*, 2ª ed., Springer, 2013.
- Garner, J. K.; Alley, M. *How the design of presentation slides affects audience comprehension: a case for the assertion-evidence approach*. International Journal of Engineering Education, v. 29, n. 6, p. 1564-1579, 2013.
