# Pedagogia: a sequência didática

A ordem em que cada assunto entra no deck e no plano de aula. Vale para qualquer disciplina; os exemplos são de Sinais e Sistemas (CCET488). As regras do `SKILL.md` mandam: onde a pesquisa sugere votação, quiz ou aquecimento, aqui entra exemplo ou exercício discursivo (regras Aula 1 e Aula 2). Os livros e os artigos citados aqui são fontes do plano de aula e do professor; nos slides da aula não há referência bibliográfica (regra 7).

## 1. A sequência de cada assunto

| Passo | O que é | Forma no tema |
|---|---|---|
| 1. Exemplo introdutório | uma pergunta concreta (física, sensorial) que o aluno entende sem a definição | `== Título <example>` + `#solution` |
| 2. Refinamento | as tentativas de definir, cada uma corrigindo a falha da anterior | slides comuns, setas `->` |
| 3. Definição | o resultado do refinamento, contínuo e discreto lado a lado | dois `emph-box` num `grid` |
| 4. Exemplo resolvido | o professor aplica a definição a um sinal do elenco | `== Título <example>` + `#solution` |
| 5. Exercício | discursivo, com um item reverso, contra uma concepção errada medida | `== Título <exercise>`, `---`, `#answer` |
| 6. Retomada | quando um assunto posterior depende deste | `#remark` pelo nome do conceito |

Nunca a definição antes do exemplo introdutório. Nada de "aquecimento" nem de pergunta solta (regra Aula 1).

Esqueleto de um assunto (trecho de deck; compilado abaixo do cabeçalho `ufac-theme.with(config-info(..))`, com Typst 0.15.1, touying 0.7.4 e tema 0.3.0, sem o `header.typ`):

```typ
= Energia e potência

// 1. Exemplo introdutório concreto, antes da definição
== Quanto o resistor dissipa? <example-resistor>
Uma tensão $v(t) = 2$ V fica ligada de $t = 0$ a $t = 3$ s num resistor de $1 Omega$. Calcule a energia dissipada.

#solution
$ E = integral_0^3 v^2(t) dif t = 4 dot 3 = 12 "J" $

// 2. A definição nasce de refinamento
== Como medir o tamanho de um sinal?
-> A área sob $x(t)$ falha: as partes positiva e negativa se cancelam;
-> A área sob $|x(t)|^2$ não se cancela: é a ~~energia~~.

// 3. Definição, contínuo e discreto lado a lado
== Energia de um sinal
#grid(columns: (1fr, 1fr), gutter: 1.2em,
  emph-box(title: [Contínuo])[$ E_infinity = integral_(-infinity)^(+infinity) |x(t)|^2 dif t $],
  emph-box(color: colors.secondary-dark, title: [Discreto])[$ E_infinity = sum_(n = -infinity)^(+infinity) |x[n]|^2 $],
)

// 4. Exemplo resolvido
== Energia de um pulso <example-pulso>
Calcule $E_infinity$ do pulso $x(t) = u(t) - u(t - 3)$.

#solution
$ E_infinity = integral_0^3 1 dif t = 3 $

// 5. Exercício discursivo com item reverso
== Energia e escala <exercise-escala>
+ Calcule $E_infinity$ de $2 x(t)$, com o pulso do @example-pulso.
+ Um sinal $y(t) = a x(t)$ tem $E_infinity = 27$. Determine $a > 0$ e explique cada passo.

---

#answer
+ $E_infinity = 4 dot 3 = 12$: a energia escala com $a^2$.
+ $a^2 dot 3 = 27$, então $a = 3$.
```

## 2. A definição nasce de refinamento

Cada tentativa é um slide ou um item, e a falha aparece num caso concreto. Exemplos:

- **tamanho do sinal:** máximo, depois área sob $x$ (um período de cosseno dá zero), depois área sob $|x|^2$ (energia), depois média no tempo quando $E_infinity = infinity$ (potência). Ancorar no resistor de 1 Ω e avisar que a unidade não é física (Lathi 1.1; Oppenheim 1.1.2);
- **impulso:** degrau suavizado $u_Delta$, depois pulso $delta_Delta$ de área 1, depois o limite $Delta -> 0$ (Oppenheim 1.4.2);
- **periódico e par:** o sinal que não muda ao ser deslocado de $T$; o que não muda ao ser refletido (Oppenheim 1.2).

## 3. Contínuo e discreto lado a lado

- Dois `emph-box`: contínuo à esquerda (azul), discreto à direita (`colors.secondary-dark`).
- Diga em cada resultado se vale no contínuo, no discreto ou nos dois. Isso responde à crítica de que o paralelo confunde o domínio (Mandal e Asif).
- O discreto vem antes só onde é mais simples: impulso e degrau, com somas em vez de limites (Oppenheim 1.4; Freeman, MIT 6.003).
- As diferenças entram como surpresa: $e^(j omega_0 n)$ só é periódica se $omega_0 \/ 2 pi$ for racional; $omega_0$ e $omega_0 + 2 pi$ dão o mesmo sinal (Oppenheim 1.3.3).
- Em outra disciplina, o par equivalente: os dois casos paralelos que a turma confunde.

## 4. Toda regra deduzida e conferida por dois pontos

- Deduza pela substituição do argumento: $x(a t + b)$ vale em $t$ o que $x$ vale em $a t + b$. Regra sem dedução vira "truque mágico" decorado (Wage et al. 2021, citado em Crockett 2022).
- Confira em dois pontos: onde o argumento vale 0 e outro ponto fácil (dois cantos do trapézio).
- No discreto, os mesmos dois pontos: $r[n + 1] - r[n] = u[n]$ dá $0 - 0 = 0 = u[-1]$ em $n = -1$ e $1 - 0 = 1 = u[0]$ em $n = 0$.
- O exercício pede ao aluno a mesma conferência.

```typ
// Regra deduzida e conferida por dois pontos
== Onde vai parar cada ponto de $x(2t - 4)$?
O valor de $x(2t - 4)$ em $t$ é o de $x$ no ponto $2t - 4$.

-> O ponto 0 de $x$: $2t - 4 = 0$, então $t = 2$;
-> O ponto 2 de $x$: $2t - 4 = 2$, então $t = 3$.
```

## 5. Exercícios contra as concepções erradas medidas

- Sempre discursivos: "calcule", "esboce", "mostre", "determine", "explique". Onde a pesquisa usa votação ou alternativas (Crouch e Mazur; os distratores do SSCI), o distrator vira um item "explique por que não é…".
- Pelo menos um **item reverso** por exercício: o que era dado vira pedido (dado o gráfico ou o resultado, ache a expressão ou o parâmetro). Ele separa quem entendeu de quem decorou (Wage et al. 2002).
- Ataque o que foi medido. O que é só alerta de livro entra no plano como "ponto de atenção, não medido".
- O plano de aula lista, por assunto, as concepções e o exercício de cada uma; o revisor de conteúdo confere.

| Concepção errada | Evidência | Exercício |
|---|---|---|
| refletir e deslocar: $x(b - t)$ vai para o lado errado | 41% → 52% de acerto; 43% refletem certo e erram o lado (Crockett 2022) | "O ponto 0 de $x$ foi para $t = 3$ e o ponto 1 para $t = 2$: determine $alpha$ e $beta$ em $x(alpha t + beta)$" |
| deslocar por $b$ em vez de $b \/ a$ | Haykin, cap. 1; Fayyaz 2018 | "Esboce $x(2t - 4)$ e confira em dois pontos" |
| transformar "pedaço a pedaço", casando intervalos | Nasr et al. 2007 | "Escreva o trapézio com degraus e rampas" |
| $t^2 delta(t - 2)$ desenhado como $t^2$; altura no lugar da área | Fayyaz 2022 | "Simplifique $t^2 delta(t - 2)$ e explique por que não é $t^2$" |
| $delta(t)$ sem unidade | 9 de 11 entrevistados (Wilcox e Pollock 2015) | "Determine a unidade de $delta(t)$ com $t$ em segundos, pela área" |
| $e^(j omega_0 t) u(t)$ desenhada como exponencial real | cerca de 95% (Fayyaz 2022) | "Esboce a parte real, a imaginária e o módulo" |
| no discreto, $omega$ maior é oscilação mais rápida | SSCI, questão DT Q1 (Wage et al. 2002) | "Compare $cos(pi n \/ 4)$, $cos(pi n)$ e $cos(7 pi n \/ 4)$ e justifique qual oscila mais rápido" |

## 6. Elenco fixo e fio condutor

- **Elenco:** poucos sinais que voltam em todo assunto, no contínuo e no discreto (trapézio, pulso, degrau, rampa, $(1\/2)^n u[n]$, cosseno). O conceito novo se aplica primeiro a um deles: a forma já é conhecida, só o conceito é novo.
- **Fio condutor:** um sistema físico que volta onde ajuda: o circuito RC ($v_C (t)$ como sinal, $e^(-t \/ R C)$, $v_C (n T_s)$ amostrado, resposta ao degrau), em poucos lugares escolhidos no plano.
- O plano de aula escreve o elenco e o fio condutor, com fórmulas, e os decks seguintes os reusam.
- O desenho de um sinal do elenco é um arquivo do deck, em `figures/graphs/` (regra 6), com o estilo de gráfico da disciplina, que o `header.typ` de cada deck copia do anterior sem mudar: o mesmo sinal sai igual em todos os decks.

## 7. `#remark` só para retomar

- Retoma o que já foi visto (antes neste deck, num deck anterior ou nos pré-requisitos), pelo nome do conceito ou pela citação `@example-pulso`. Nunca "(encontro N)" nem "aula passada" (regra Aula 3).
- Fato novo não vai num `#remark`: vai no texto do slide. O que vem adiante é `#note`, pelo nome do assunto, nunca "próxima aula".

```typ
// #remark só para retomar, pelo nome do conceito
== Energia de $x(2t)$
#remark[A energia é a área sob $|x|^2$ (Energia e potência, @example-pulso).]

Comprimir pela metade divide a área por 2.

// #note para o que vem adiante
#note[A energia volta na série de Fourier.]
```

## 8. Fontes

- Oppenheim, Willsky e Nawab, *Sinais e Sistemas*, 2ª ed., Pearson, 2010, cap. 1 (1.1 a 1.4).
- Lathi, *Sinais e Sistemas Lineares*, 2ª ed., Bookman, 2007, cap. 1 (1.1, tamanho do sinal).
- Freeman, MIT 6.003 (2011), aulas 1 e 2: https://ocw.mit.edu/courses/6-003-signals-and-systems-fall-2011/pages/lecture-notes/
- Mandal e Asif, *Continuous and Discrete Time Signals and Systems*, prefácio: https://assets.cambridge.org/97805218/54559/frontmatter/9780521854559_frontmatter.pdf
- Wage, Buck, Welch e Wright (2002), *The Signals and Systems Concept Inventory*, ASEE: https://peer.asee.org/10670.pdf
- Buck e Wage (2005), *Active and Cooperative Learning in Signal Processing Courses*, IEEE SPM 22(2): https://people-ece.vse.gmu.edu/~kwage/research/ssci/papers/buck_wage_spmag05.pdf
- Crockett (2022), tese, Univ. of Michigan: https://web.eecs.umich.edu/~fessler/papers/lists/files/diss/22,crockett,caroline.pdf
- Fayyaz (2018), *Trending Mistakes in Signals and Systems courses*, ASEE: https://peer.asee.org/30095.pdf
- Fayyaz (2022), *Problems in learning related to mathematical and graphical representations of signals*, ASEE: https://peer.asee.org/work-in-progress-problems-in-learning-related-to-mathematical-and-graphical-representations-of-signals.pdf
- Nasr, Hall e Garik (2007), *Interval Matching in Student Reasoning*, ASEE: https://peer.asee.org/2543.pdf
- Wilcox e Pollock (2015), *Student difficulties with the Dirac delta function*, PRST-PER 11: https://arxiv.org/abs/1501.07490
- Crouch e Mazur (2001), *Peer Instruction: Ten years of experience and results*, Am. J. Phys. 69(9), DOI 10.1119/1.1374249.
- Freeman et al. (2014), *Active learning increases student performance in STEM*, PNAS: https://pmc.ncbi.nlm.nih.gov/articles/PMC4060683
