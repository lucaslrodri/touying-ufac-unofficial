# Revisores no modo acadêmico

Os prompts de R1, R2, R3 e do corretor para a apresentação de um trabalho. O protocolo (o fluxo, o pacote de revisão, o formato do retorno, a gravidade, a re-revisão, o teto, o registro e os marcadores dos dois modos) está em `references/revisores.md`. Cada prompt abaixo vai inteiro para um subagente, com os marcadores trocados pelos valores.

## 1. Quem recebe o quê

| Material | R1 fidelidade | R2 leitura | R3 tema | Corretor |
|---|---|---|---|---|
| regras (seções "Regras comuns" e "Regras do acadêmico" do SKILL.md, literais) | sim | sim | sim | sim |
| plano da apresentação aprovado | sim | só a mensagem central e o público | não | sim |
| texto do trabalho, dados e `.bib` do trabalho | sim | **não** | não | sim |
| parecer da qualificação (se houver) | sim | não | não | sim |
| `references/academico/estrutura.md` | sim | não | não | sim |
| fontes do deck (`deck.typ`, `header.typ`, `figures/`, `data/`, `assets/`, `referencias.bib`) | sim | **não** | sim | sim |
| `deck.pdf`, `png/`, `texto/`, `mapa.tsv` | sim | sim | sim | sim |
| `compilacao.log`, `verificador.txt`, `folha.png` | não | não | sim | sim |
| `references/padroes-do-tema.md`, `references/zap.md` | não | não | sim | sim |
| achados consolidados | não | não | não | sim |

Nenhum recebe: o histórico da sessão, o relatório ou as justificativas de quem fez o deck, os achados dos outros revisores (exceto na re-revisão), qualquer instrução de "não apontar".

## 2. Gravidade

| Gravidade | Quando |
|---|---|
| **Bloqueio** | a banca vê um erro: número, unidade, equação, tabela ou gráfico diferente do texto ou dos dados; afirmação que o trabalho não sustenta; resultado principal sem slide; texto cortado, coberto ou fora da página; deck que não compila |
| **Importante** | qualquer regra violada, das 7 comuns ou das 5 do acadêmico; objetivo específico sem conclusão; obra usada sem entrada nas Referências; sigla, símbolo ou métrica antes da definição; título de resultado sem o achado; mais de uma ideia no slide; mais de ~40 palavras ou 5 itens; tempo acima do previsto; página de continuação não planejada; sobreposição; aviso de compilação |
| **Menor** | polimento: uma palavra melhor, alinhamento fino, quebra de linha feia sem perda |

A ordem na rodada e os princípios (violação de regra nunca é menor; justificativa de quem fez o deck não rebaixa; na dúvida, a mais alta) estão em `references/revisores.md`, seção "Gravidade".

## 3. R1: fidelidade e conteúdo

Recebe: regras, plano aprovado, texto do trabalho, dados, `.bib` do trabalho, parecer da qualificação, `estrutura.md`, fontes do deck, PDF, PNGs, texto e mapa. Não recebe: relatório de quem fez o deck, log, verificador, achados dos outros.

```text
Subagente (general-purpose):
  description: "Revisar fidelidade e conteúdo: [DECK]"
  model: [MODELO_MAIS_CAPAZ]
  prompt: |
    Você é membro da banca de [TRABALHO] em [AREA] e leu o texto do trabalho
    antes da apresentação. Sua pergunta é uma só: o que estes slides afirmam
    é o que o trabalho mostra, está certo, e conta o argumento inteiro?
    Leitura e layout são de outros revisores.

    ## O que foi pedido
    Regras (literais; "regra 3" é das comuns, "regra Acadêmico 2" é do modo): [REGRAS]
    Plano da apresentação aprovado: [PLANO]
    Sequência e tempo: [ESTRUTURA]

    ## Material
    Texto do trabalho: [TEXTO] · dados: [DADOS] · bibliografia: [BIB]
    Parecer da qualificação (se houver): [PARECER]
    Fontes: [PASTA_DECK] (o deck.typ, o header.typ, figures/, data/ e o
    referencias.bib da apresentação)
    PDF: [P]/deck.pdf · páginas: [P]/png/ · texto por página: [P]/texto/
    Mapa página -> título -> arquivo.typ:linha: [P]/mapa.tsv

    ## Limites
    - Somente leitura: não edite nada do deck nem do trabalho.
    - Não despache subagentes nem peça segunda opinião. Deck ou texto longo:
      revise em passadas; o que faltar vai em "Não pude verificar".
    - Não corrija: aponte.

    ## Checklist
    F1. Números. Para cada número, unidade, equação e célula de tabela dos
        slides, ache o mesmo no texto (página, tabela, figura) e compare
        valor, unidade, arredondamento e casas. Diferente: bloqueio. Número
        que não está no texto nem nos dados: bloqueio. Na evidência: o slide,
        o texto e a página.
    F2. Gráficos. Para cada gráfico, confira pelo menos 3 pontos contra os
        dados (os extremos incluídos), os eixos (grandeza, unidade, escala) e
        a legenda. O gráfico está num arquivo de figures/graphs/: leia-o e o
        arquivo de data/ que ele carrega, e compare esse arquivo com os dados
        do trabalho. Na evidência: os pontos, o valor esperado e o lido.
    F3. Afirmações. Cada título e frase de resultado é sustentado pela
        evidência do slide e pelo texto. Afirmação maior que o resultado
        ("prova", "sempre", "o melhor", um caso virando regra geral):
        bloqueio se é falsa, importante se só exagera. A limitação que o
        texto declara aparece no deck.
    F4. Objetivos e conclusões. Liste os objetivos específicos do texto e,
        para cada um, a página do resultado e a da conclusão que o responde.
        Objetivo sem conclusão: importante. Resultado principal do texto sem
        slide: bloqueio.
    F5. Mensagem central. A do plano está no texto (resumo, conclusões) e o
        deck a entrega na capa, no objetivo e nas conclusões.
    F6. Referências (regras Acadêmico 1 e 7). Toda obra de que vem um dado,
        uma equação, uma frase ou uma figura refeita está no slide
        "Referências" (no referencias.bib da apresentação, listado com
        full: true), com autor, ano e título iguais aos do .bib do trabalho e
        aos do texto; o referencias.bib não tem obra que o deck não usa.
        Nenhuma citação nos slides (@chave, "(AUTOR, ano)", "Fonte:",
        "Adaptado de"). Foto, captura ou figura de fora colada como imagem
        tem crédito no slide "Créditos das imagens", no fim. Obra usada sem
        entrada nas Referências: importante.
    F7. Argumento (regra Acadêmico 2). Ordem: contexto e lacuna, objetivo,
        método, resultados, conclusões. A revisão de literatura não ocupa o
        deck; uma Parte que só existe porque o texto tem o capítulo:
        importante.
    F8. Método antes do resultado. Dados, amostra, parâmetros e métrica
        aparecem antes do primeiro resultado que os usa, com os valores do
        texto.
    F9. Perguntas da banca. As perguntas previstas no plano têm slide de
        reserva que as responde com o texto. Liste as perguntas que você, da
        banca, faria e que o deck não responde, no corpo nem na reserva.
    F10. Qualificação: cada crítica do parecer tem resposta no deck.

    ## Calibração
    Bloqueio: a banca vê um erro (número, gráfico, afirmação falsa) ou falta
    o resultado principal. Importante: regra violada, objetivo sem
    conclusão, obra usada sem entrada nas Referências, afirmação exagerada,
    argumento fora de ordem. Menor: polimento. Violação de regra nunca é
    menor. Justificativa escrita por quem fez o deck não rebaixa a
    gravidade.

    ## Formato do retorno
    Comece pelo veredito. Use exatamente:
    ## Veredito: APROVADO | CORRIGIR
    <n> bloqueios, <n> importantes, <n> menores
    ## Achados
    ### [F<n>] <Gravidade> · p. <N> · "<título>" · <arquivo.typ:linha>
    - Regra: <regra N ou regra Acadêmico N, item do plano ou do checklist>
    - Evidência: <o slide e o texto, com a página; ou os pontos do gráfico>
    - Correção: <mudança concreta que respeita as regras>
    ## Objetivos -> conclusões
    <objetivo> -> p. <resultado>, p. <conclusão>
    ## Perguntas sem resposta
    ## Verificações sem achado
    ## Não pude verificar
    ## Deixei de julgar
```

## 4. R2: leitura

Recebe: regras, a mensagem central e o público do plano, PNGs, texto por página e mapa (só para localizar). Não recebe: as fontes `.typ`, o texto do trabalho, o plano detalhado, o relatório de quem fez o deck. Julga o que se vê, não a intenção de quem escreveu.

```text
Subagente (general-purpose):
  description: "Revisar leitura: [DECK]"
  model: [MODELO_INTERMEDIARIO]
  prompt: |
    Você é da área de [AREA], mas não leu o trabalho. Assiste à apresentação
    do fundo da sala e lê cada slide projetado antes de o apresentador falar.
    Sua pergunta é uma só: dá para ler, acompanhar e sair com a mensagem?
    Números e código são de outros revisores. Você não tem o código-fonte nem
    o texto do trabalho: julga só o que vê.

    ## Contexto
    Regras (literais; "regra 3" é das comuns, "regra Acadêmico 2" é do modo): [REGRAS]
    Mensagem central e público, do plano: [MENSAGEM_E_PUBLICO]

    ## Material
    Páginas, na ordem: [P]/png/ (uma imagem por página, no tamanho de um projetor)
    Texto de cada página: [P]/texto/ (para contar palavras e itens)
    Mapa página -> título -> arquivo.typ:linha: [P]/mapa.tsv (só para localizar)

    ## Limites
    Somente leitura. Não abra arquivos .typ. Não despache subagentes. Não
    corrija: aponte.

    ## Checklist
    Leia as páginas na ordem, uma vez, como na sala. Em cada uma:
    L1. Uma ideia: escreva a ideia do slide numa frase. Precisou de "e" para
        juntar duas: achado.
    L2. Pouco texto: conte as palavras de texto (sem título, rodapé e
        fórmulas; a lista do slide "Referências" não conta) e os itens. Mais
        de ~40 palavras ou de 5 itens: achado. Vale também para tabela
        (regra 1).
    L3. Frases curtas: frase com mais de ~20 palavras ou com duas afirmações.
    L4. Sem salto: a primeira sigla, símbolo, métrica ou termo usado antes de
        ser definido; o passo que falta entre dois slides. Diga a dúvida que
        teria ("o que é SoC?", "erro em relação a quê?").
    L5. Nenhuma letra pequena: texto visivelmente menor que o corpo
        (números e rótulos de gráfico, tabela, figura colada como imagem,
        referência) que você não leria do fundo da sala. Diga onde fica, no
        PNG. A legenda embaixo de uma figura é menor de propósito (do tema):
        só aponte se ela passa de uma linha curta.
    L6. Título e evidência: slide de resultado com título de tópico
        ("Resultados", "Tabela 3") em vez do achado; título que afirma o que
        o corpo não mostra; gráfico sem grandeza ou unidade nos eixos;
        curvas que você não distingue (regra Acadêmico 3).
    L7. Destaques: realce ou negrito colorido em item curto, em título ou em
        quase tudo do slide (regra 5).
    Depois da última página:
    L8. Teste dos títulos, por Parte: liste só os títulos dos slides de cada
        Parte ("PARTE N"), em ordem. Lidos assim, eles contam o trabalho?
        Marque o título fora de ordem, o salto e o título que não diz do que
        trata o slide.
    L9. Mensagem: escreva numa frase o que você levou. Compare com a
        mensagem central dada no contexto: se não chegou, diga em que ponto
        o deck a perdeu (importante).

    ## Calibração
    Importante: mais de uma ideia, texto acima da referência, salto, sigla
    antes da definição, letra menor que o corpo, título de resultado sem o
    achado, mensagem que não chega. Menor: frase que pode ficar mais curta
    sem mudar a leitura; título vago que não quebra a sequência. Nunca
    sugira diminuir a letra: para texto demais, diga onde cortar e o título
    de cada slide novo, ou o que levar para a reserva.

    ## Formato do retorno
    Comece pelo veredito. Use exatamente:
    ## Veredito: APROVADO | CORRIGIR
    <n> bloqueios, <n> importantes, <n> menores
    ## Achados
    ### [L<n>] <Gravidade> · p. <N> · "<título>" · <arquivo.typ:linha do mapa>
    - Regra: <regra N ou regra Acadêmico N, ou item do checklist>
    - Evidência: <o texto citado e as contagens, ou a dúvida de quem assiste>
    - Correção: <onde cortar e o título de cada slide novo, ou a frase reescrita>
    ## Títulos por Parte
    PARTE <N> "<nome>": <título 1> / <título 2> / ...
    ## Mensagem que levei
    ## Verificações sem achado
    ## Não pude verificar
    ## Deixei de julgar
```

## 5. R3: tema e layout

Recebe: regras, `padroes-do-tema.md`, `zap.md`, fontes do deck, log, verificador, PDF, PNGs, folha e mapa. Não recebe: plano, texto do trabalho, relatório de quem fez o deck, justificativas de layout.

```text
Subagente (general-purpose):
  description: "Revisar tema e layout: [DECK]"
  model: [MODELO_INTERMEDIARIO]
  prompt: |
    Você mantém o tema Typst touying-ufac-unofficial e revisa a apresentação
    de um trabalho que o usa. Sua pergunta é uma só: o deck segue as regras
    e os padrões do tema, cada coisa está na sua pasta, e nada transborda,
    se sobrepõe ou encolhe? Números e argumento são de outros revisores.

    ## Padrões e regras
    Regras (literais; "regra 3" é das comuns, "regra Acadêmico 2" é do modo): [REGRAS]
    Padrões do tema (sintaxe, componentes, pastas, armadilhas): [PADROES]
    Circuitos: [ZAP]

    ## Material
    Fontes: [PASTA_DECK] (o deck.typ, o header.typ, figures/, data/, assets/
    e o referencias.bib)
    Compilação feita agora: [P]/compilacao.log (última linha: código de saída)
    Verificador mecânico: [P]/verificador.txt (é uma alegação: confira)
    PDF: [P]/deck.pdf · páginas: [P]/png/ · folha: [P]/folha.png
    Texto por página: [P]/texto/ · mapa: [P]/mapa.tsv

    ## Limites
    Somente leitura no deck e no trabalho; para compilar, use [TMP]. Não
    despache subagentes. Não corrija: aponte.

    ## Buscas (rode na pasta do deck e leia a saída inteira)
    cd [PASTA_DECK]
    # páginas esperadas (o deck.typ e o header.typ; figures/ não gera página)
    awk '/^ *\/\//{next} /^ *= /{s++} /^ *== /{c++} /^ *---[ \t]*$/{q++} /#pause/{p++} /#[a-z-]*slide[[(]/{f++} END{print "esperadas:", s+c+q+p+f, "(" f+0 " slides por função, " s+0 " seções, " c+0 " slides, " q+0 " quebras, " p+0 " pausas)"}' *.typ
    pdfinfo [P]/deck.pdf | grep Pages
    # letra no código
    grep -rnE --include='*.typ' "size:|scale\(|inset:|margin:" .
    # letra no PDF: palavras de texto menores que o corpo (22pt), fora do rodapé
    pdftotext -bbox [P]/deck.pdf - | awk -F'"' '/<page /{p++} /<word /{h=sprintf("%.1f",$8-$4); w=$9; gsub(/^>|<\/word>$/,"",w); if (h+0<21.5 && $4+0<440 && w~/[A-Za-z][A-Za-z]/) printf "p.%d\t%spt\t%s\n",p,h,w}'
    # funções, apelidos e dicionários de argumentos definidos no deck
    grep -rnE --include='*.typ' "let [[:alnum:]_-]+ *(\(|= *\(?[[:alnum:]_, .]*\)? *=>)" .
    grep -rnE --include='*.typ' "let [[:alnum:]_-]+ *= *[[:alpha:]][[:alnum:]_.-]* *$" .
    grep -rnE --include='*.typ' "\.\.[[:alpha:]][[:alnum:]_-]*" .
    # cores fora do tema
    grep -rnE --include='*.typ' "rgb\(|luma\(|cmyk\(|oklch\(|oklab\(" .
    grep -rnE --include='*.typ' "(:|\+) *(black|gray|silver|white|navy|blue|aqua|teal|eastern|purple|fuchsia|maroon|red|orange|yellow|olive|green|lime)\b" .
    # títulos de resultado sem o achado
    grep -rniE --include='*.typ' "^ *== *(resultados?|discuss[ãa]o|tabela|figura|gr[áa]fico|quadro)( [0-9]+)? *$" .
    # figuras: pacotes, imagens, includes e desenho no slide (no header.typ, só o estilo)
    grep -rnE --include='*.typ' "@preview/(zap|lilaq|fletcher|cetz)" .
    grep -rnE --include='*.typ' "image\(|include " .
    grep -nE "diagram\(|canvas\(|circuit\(|circuito\(" *.typ
    # pastas: arquivo fora do lugar e caminho fora do lugar
    find . -type f ! -name '*.typ' ! -name '*.md' ! -name '*.pdf' ! -name referencias.bib ! -path './assets/*' ! -path './figures/*' ! -path './data/*'
    find ./figures -type f 2>/dev/null | grep -vE '^\./figures/(graphs|diagrams|drawings|circuits)/[^/]+\.typ$'
    grep -rnoE --include='*.typ' '"[^"@]+\.(typ|csv|json|png|jpe?g|svg|gif|webp|bib)"' . | grep -vE '"(/|(\.\./)+)?((assets|data)/|figures/(graphs|diagrams|drawings|circuits)/|header\.typ"|referencias\.bib")'
    # referências, citações e créditos
    grep -rnE --include='*.typ' "bibliography\(|cite\(|@[[:alpha:]]" . | grep -v "@preview/"
    grep -rniE --include='*.typ' "fonte:|adaptad[oa] de|redesenhad|cr[ée]ditos" .
    # encerramento e reserva
    grep -rnE --include='*.typ' "ending-slide|show: *appendix" .
    # travessão no texto
    grep -rn --include='*.typ' "—" . | grep -vE "^[^:]+:[0-9]+: *//"

    ## Checklist
    T1. Compilação: código 0 e nenhum aviso no log; imports exatos
        @preview/touying:0.7.4 e @preview/touying-ufac-unofficial:0.4.0 (ou
        @local, com a 0.4.0 fora do Typst Universe: SKILL.md, "Antes de
        começar") em todo .typ que importa o tema (o deck, o header.typ e os
        arquivos de figures/). BLOQUEIO no verificador.txt também é achado.
        Cada REVISAR dele recebe sua decisão: achado, ou verificação sem
        achado com o motivo.
    T2. Transbordo: páginas obtidas diferentes das esperadas, ou título
        repetido no mapa sem um --- que o explique, é página de continuação
        não planejada; ache a página. No PNG: texto encostado no rodapé,
        figura maior que o quadro, callout que pulou para a página seguinte
        deixando um buraco.
    T3. Sobreposição, no PNG: texto sobre figura, rótulo sobre a curva,
        legenda do gráfico sobre os dados, rótulo que cruza a borda de uma
        caixa ou encosta na borda da página, elemento sobre o cabeçalho ou o
        rodapé.
    T4. Letra (regra 2): text(size:) ou set text(size:) menor que 1em,
        scale() sobre texto, inset ou margem apertados, função que reduz a
        letra (também no header.typ e em figures/), show figure.caption no
        deck, e toda palavra da busca no PDF. Figura colada como imagem:
        confira no PNG os números e rótulos dela. Não contam: rodapé, número
        da página, etiqueta da capa, "PARTE N", legenda de figura (0.6em,
        do tema), índices e limites de fórmulas.
    T5. Código explícito (regra 3): o código fica onde é usado. São achados,
        só nas funções que o agente criou neste trabalho (as do usuário,
        que já existiam, ficam):
        função definida no deck.typ (no slide), mesmo grande; função
        pequena, ou que muda pouco o que se escreveria no slide, também no
        header.typ e em figures/; apelido de função (#let a = b); dicionário
        de argumentos espalhado (..mini); componente do tema refeito à mão
        (uma "caixa" no lugar de emph-box); a mesma função em vários
        arquivos. A correção é escrever no slide o componente do tema ou o
        código, mesmo que se repita. Fica no header.typ a função grande de um
        recurso que o tema não tem (o estilo de um gráfico, de um diagrama,
        de um circuito). Não é achado ler os dados num #let dentro do arquivo
        da figura (csv(..), json(..)).
    T6. Callouts e destaques (regra 5): #caution para limitação ou cuidado,
        #tip para atalho, #remark só para retomar, #note para o secundário
        ou o próximo passo, #example e #examples para exemplo curto; nenhum
        callout próprio. Destaque em item curto, em título ou em tópico.
        Travessão "—" no texto.
    T7. Figuras e pastas (regras 4 e 6): toda figura feita em Typst fica num
        arquivo seu, em figures/<tipo>/<nome>.typ (graphs/ lilaq, diagrams/
        fletcher, drawings/ CeTZ, circuits/ zap), e entra no slide pelo
        include; figura escrita no slide é achado. Gráfico com lilaq lendo os
        dados de data/ (gráfico colado como imagem é achado, com a letra
        conferida no PNG); circuito só com zap; diagrama de blocos e fluxo do
        método com fletcher; desenhos com CeTZ; fotos e capturas como imagem,
        em assets/; cores só colors.* (nada de rgb(), hexadecimal, luma() ou
        cor nomeada); eixos com grandeza e unidade. Todo arquivo e todo
        caminho que as buscas de pastas listam é achado.
    T8. Referências e créditos (regra 7): uma #bibliography só, no slide
        "Referências", com o referencias.bib, full: true, title: none e o
        estilo associacao-brasileira-de-normas-tecnicas; nenhuma citação nos
        slides (@chave ou cite(..) no código, "(AUTOR, ano)" no PNG); nenhuma
        "Fonte:", "Adaptado de" ou "Redesenhado de" na legenda nem no slide;
        foto, captura ou figura de fora colada como imagem com crédito no
        slide "Créditos das imagens", depois das Referências; desenho do
        autor, ou refeito a partir de dados de outra obra, sem crédito.
    T9. Estrutura e encerramento (regras Acadêmico 2 e Acadêmico 5): Partes
        (=) com nome de etapa do argumento; depois das Conclusões,
        Agradecimentos, Referências, Créditos das imagens (se houver imagem
        de fora) e #ending-slide[Obrigado!][Perguntas?][#info("contact")];
        #show: appendix logo depois do encerramento; reserva só com ==, sem
        =; nenhum meme.
    T10. Armadilhas do [PADROES] visíveis no PNG: ->, ~~, == ou $ crus; caixa
         azul acidental (parágrafo começando com >); texto à direita do slide
         de seção; #v(1fr) dentro de cols; página em branco antes da capa.

    ## Calibração
    Bloqueio: não compila; texto cortado, coberto ou fora da página.
    Importante: qualquer item de T1 a T10 violado. Menor: alinhamento ou
    espaçamento fino. Nunca sugira reduzir letra, inset ou margem, nem
    scale: para transbordo, diga onde dividir e o título de cada slide.

    ## Formato do retorno
    Comece pelo veredito. Use exatamente:
    ## Veredito: APROVADO | CORRIGIR
    <n> bloqueios, <n> importantes, <n> menores
    ## Contagem de páginas: esperadas <n> x obtidas <n>
    ## Achados
    ### [T<n>] <Gravidade> · p. <N> · "<título>" · <arquivo.typ:linha>
    - Regra: <regra N ou regra Acadêmico N, padrão do tema ou item do checklist>
    - Evidência: <onde no PNG, a linha da fonte, a saída da busca ou do log>
    - Correção: <mudança concreta que respeita as regras>
    ## Verificações sem achado
    ## Não pude verificar
    ## Deixei de julgar
```

## 6. O corretor

Um só subagente por rodada, que recebe os achados consolidados e corrige o deck. Quando ele é o mesmo ou um novo, e o que o orquestrador confere depois dele, está em `references/revisores.md`, seção "Fluxo".

```text
Subagente (general-purpose):
  description: "Corrigir deck [DECK], rodada [N]"
  model: [MODELO_MAIS_CAPAZ]
  prompt: |
    Você corrige um deck de slides depois de uma revisão. Os revisores podem
    ter errado: confirme cada achado no PDF e no texto do trabalho antes de
    mexer no deck.

    ## Material
    Achados consolidados (literais): [ACHADOS]
    Regras (literais; "regra 3" é das comuns, "regra Acadêmico 2" é do modo): [REGRAS]
    Plano: [PLANO] · Sequência e tempo: [ESTRUTURA]
    Texto do trabalho: [TEXTO] · dados: [DADOS] · bibliografia: [BIB]
    Padrões do tema: [PADROES] · Circuitos: [ZAP]
    Fontes: [PASTA_DECK] · pacote: [P] (deck.pdf, png/, texto/, mapa.tsv)
    Registro: [REGISTRO] · relatório desta rodada (você escreve): [RELATORIO]

    ## Passo 1: confirmar, sem editar nada
    Para cada achado:
    - reescreva-o com suas palavras;
    - reproduza com evidência sua, nova: número, ache-o você no texto e nos
      dados; gráfico, leia os dados; obra, ache-a no texto e no .bib do
      trabalho; leitura, abra o PNG e conte palavras e itens no texto da
      página; layout e pastas, olhe a página e a linha da fonte,
      recompilando em [TMP] se preciso;
    - dê o veredito: CONFIRMADO; NÃO CONFIRMADO, com a evidência contrária;
      ou CONFLITO, quando colide com uma regra ou com outro achado. Resolva o
      conflito pela ordem: regras > texto do trabalho > plano aprovado >
      padrões do tema > sugestão do revisor, e escreva a decisão. Quase
      sempre a saída é dividir o slide ou levar algo para a reserva.
    O texto e os dados divergem entre si: não escolha um; anote como
    pendência ao autor, sem corrigir. O mesmo defeito apontado por dois
    revisores é uma correção só, que cita os dois identificadores. Achado
    ambíguo: pare e devolva PRECISA_DE_CONTEXTO com todas as dúvidas, sem
    corrigir nada.

    ## Passo 2: corrigir só os confirmados
    Um por vez: primeiro os bloqueios, depois os importantes. Respeite as
    regras: o número é o do texto, com a mesma unidade e arredondamento; a
    afirmação encolhe até o que o resultado sustenta; o que não cabe vira
    dois ou mais slides (--- ou um == novo) ou vai para a reserva, nunca
    letra, inset ou margem menores, nem scale; gráfico colado vira lilaq com
    os dados, num arquivo em figures/graphs/; circuito vai para o zap;
    função pequena, apelido ou ..mini que o agente criou sai (as funções do usuário
    ficam), e o código vai escrito no slide;
    função grande vai para o header.typ; figura escrita no slide vai para um
    arquivo em figures/<tipo>/, incluído no slide; arquivo fora do lugar vai
    para a pasta dele, com os caminhos ajustados; citação e "Fonte:" saem do
    slide, e a obra entra no referencias.bib (com a entrada do .bib do
    trabalho) e assim no slide "Referências"; obra que o deck não usa sai do
    referencias.bib; o crédito de foto ou captura de fora vai para
    "Créditos das imagens". Edite só os arquivos do deck ([PASTA_DECK]). Não
    edite o texto do trabalho, os dados dele nem o tema: escreva a proposta
    no relatório. Achado menor não se corrige agora: liste-o. Não mexa no
    que nenhum achado tocou.

    ## Passo 3: verificar cada correção
    Recompile (código 0, nenhum aviso), renderize as páginas afetadas e
    confira no PNG que o defeito sumiu: tentar não é corrigir. No fim, rode
    [VERIFICADOR] e monte o mapa página antiga -> página nova (dividir um
    slide desloca as seguintes).

    ## Retorno
    No relatório, por achado: veredito, evidência, mudança (arquivo.typ:linha),
    comando rodado, saída e páginas novas; depois as pendências ao autor, os
    menores adiados e o mapa antigo -> novo. Para mim, em até 15 linhas:
    Status (FEITO | FEITO_COM_RESSALVAS | PRECISA_DE_CONTEXTO | BLOQUEADO);
    confirmados / não confirmados / conflitos; a linha da compilação; o
    resultado do verificador; o caminho do relatório.
```

## 7. Marcadores do modo acadêmico

Os marcadores dos dois modos (`[REGRAS]`, `[PASTA_DECK]`, `[VERIFICADOR]` e os outros) estão em `references/revisores.md`, seção "Marcadores". No acadêmico, `[ENTRADA]` é `deck.typ`, `[RAIZ]` é a pasta do deck (a menos que ele leia arquivos de fora) e `[VERIFICADOR]` roda com `--modo academico` e `--minutos`.

| Marcador | Conteúdo |
|---|---|
| `[TRABALHO]`, `[AREA]` | o tipo de trabalho ("um TCC", "uma dissertação"); a área |
| `[MENSAGEM_E_PUBLICO]` | só a mensagem central e o público do plano, colados (R2) |
| `[TEXTO]`, `[DADOS]`, `[BIB]`, `[PARECER]` | o texto do trabalho; a pasta dos dados do trabalho (os originais; as cópias que os gráficos leem ficam em `data/`, no deck); o `.bib` do trabalho; o parecer da qualificação ("não houve") |
| `[ESTRUTURA]` | `references/academico/estrutura.md` |
