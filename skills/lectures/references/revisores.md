# Revisores

Três revisores independentes leem o deck em paralelo, depois do verificador mecânico. Um corretor confirma cada achado no PDF e só então corrige. A re-revisão olha só o que mudou. No máximo 3 rodadas. As regras do professor (SKILL.md) mandam em tudo, também nas correções que os revisores sugerem.

## 1. Fluxo

```text
verificador sem bloqueio (SKILL.md, passo 5)
  -> pacote de revisão r1 (seção 2)
  -> na MESMA mensagem, 3 subagentes: R1 conteúdo e contas | R2 estilo de leitura | R3 tema e layout
  -> orquestrador junta os retornos, sem julgar, e grava no registro
       os 3 APROVADO -> entrega (passo 7)
  -> corretor: confirma cada achado no PDF, corrige os confirmados, recompila, roda o verificador
  -> pacote r2 + re-revisão com escopo:
       o revisor de cada achado aberto + R3 sempre, nas páginas alteradas
       tudo RESOLVIDO ou RETIRADO, nada novo de bloqueio ou importante -> entrega
       algo aberto -> nova rodada
  -> rodada 3 ainda aberta -> o orquestrador decide cada achado, registra e leva ao professor
```

- **Rodada** = um corretor + uma re-revisão. No máximo 3 por deck.
- **Os 3 rodam sempre**, também em deck curto e depois de correção pequena.
- **Paralelo:** as 3 chamadas de subagente na mesma resposta. Um só editor por vez: o corretor nunca roda junto com outro agente que edita.
- **Modelo explícito** em todo despacho: R1 e corretor no mais capaz disponível (erro de conta é o mais caro); R2, R3 e re-revisões num intermediário. Modelo omitido herda o da sessão.
- **Contexto construído, nunca herdado:** cada subagente recebe o prompt desta página e caminhos de arquivo. Nunca o histórico, o raciocínio ou o relatório do autor, nem os achados de outro revisor.
- **Sem pré-julgamento:** nada de "não aponte X", "no máximo menor", "o plano escolheu", "é de propósito". Se o autor discorda, o corretor mostra a evidência e a re-revisão decide.
- **Papéis:** o orquestrador (a sessão principal) monta o pacote, despacha, junta, mantém o registro e decide no teto. Os revisores só leem. Só o corretor edita.

## 2. Pacote de revisão

Uma pasta por rodada, fora do repositório do curso (na pasta temporária da sessão): `[TMP]/revisao-<deck>/r<N>/`. Os comandos abaixo montam a `r1`; nas rodadas seguintes, troque o `r1`. O registro fica em `[TMP]/revisao-<deck>/registro.md`.

| Arquivo | Conteúdo |
|---|---|
| `deck.pdf`, `compilacao.log` | compilação feita agora; a última linha do log é o código de saída |
| `png/p01.png`… | uma imagem por página, a 110 ppi (cerca de 1280 × 720, o tamanho de um projetor) |
| `texto/p01.txt`… | o texto de cada página (`pdftotext -layout`) |
| `mapa.tsv` | página, título do slide e `arquivo.typ:linha` (`?` na capa e no fim) |
| `verificador.txt` | a saída de `scripts/verificar_deck.py` sobre este `deck.pdf` |
| `folha.png` | a folha de contato de `scripts/folha_de_contato.py` |

```sh
P=[TMP]/revisao-<deck>/r1; mkdir -p "$P/png" "$P/texto"
typst compile --root [RAIZ] [ENTRADA] "$P/deck.pdf" > "$P/compilacao.log" 2>&1; echo "código de saída: $?" >> "$P/compilacao.log"
typst compile --root [RAIZ] --ppi 110 [ENTRADA] "$P/png/p{0p}.png"
n=$(pdfinfo "$P/deck.pdf" | awk '/^Pages:/ {print $2}')
for i in $(seq 1 "$n"); do pdftotext -layout -f "$i" -l "$i" "$P/deck.pdf" "$P/texto/p$(printf "%0${#n}d" "$i").txt"; done
```

O mapa lê o título de cada página pela posição e pelo tamanho da letra e procura o `=` ou `==` igual nos `.typ` da pasta do deck:

```sh
python3 -I - "$P/deck.pdf" [PASTA_DECK] > "$P/mapa.tsv" <<'EOF'
import pathlib, re, subprocess, sys
pdf, pasta = sys.argv[1], pathlib.Path(sys.argv[2])
norm = lambda s: " ".join(re.sub(r"[^a-zà-ú ]", " ", s.lower()).split())
fonte = lambda l: norm(re.sub(r"\$[^$]*\$|<[\w-]*>\s*$", " ", l.lstrip(" =")))
heads = [(fonte(l), f"{f.relative_to(pasta)}:{i}") for f in sorted(pasta.rglob("*.typ"))
         for i, l in enumerate(f.read_text().splitlines(), 1) if re.match(r"\s*={1,2} ", l)]
xml = subprocess.run(["pdftotext", "-bbox", pdf, "-"], capture_output=True, text=True).stdout
for p, pg in enumerate(xml.split("<page ")[1:], 1):
    ws = [(float(a), float(b) - float(a), w) for a, b, w in
          re.findall(r'yMin="([\d.]+)" xMax="[\d.]+" yMax="([\d.]+)">(.*?)</word>', pg)]
    big = [w for y, h, w in ws if h > 40]
    top = [(y, w) for y, h, w in ws if y < 60 and h > 21.5]
    titulo = " ".join(big or [w for y, w in top if y == min(top)[0]] if top or big else [])
    titulo = re.sub(r"^(Exemplo|Exercício) [\d.]+ — ", "", titulo)
    linha = next((loc for t, loc in heads if norm(titulo) and t == norm(titulo)), "?")
    print(p, titulo, linha, sep="\t")
EOF
```

O mesmo título em páginas seguidas é continuação, por `---` ou por transbordo; o R3 separa uma do outro.

## 3. Quem recebe o quê

| Material | R1 conteúdo | R2 leitura | R3 tema | Corretor |
|---|---|---|---|---|
| regras do professor (seção "Regras do professor" do SKILL.md, literal) | sim | sim | sim | sim |
| plano de aula aprovado | sim | só objetivos e pré-requisitos | não | sim |
| `references/pedagogia.md` | sim | não | não | sim |
| decks anteriores do curso | sim (para os `#remark`) | não | não | não |
| fontes `.typ` do deck e o `comum.typ` | sim | **não** | sim | sim |
| `deck.pdf`, `png/`, `texto/`, `mapa.tsv` | sim | sim | sim | sim |
| `compilacao.log`, `verificador.txt`, `folha.png` | não | não | sim | sim |
| `references/padroes-do-tema.md`, `references/zap.md` | não | não | sim | sim |
| achados consolidados | não | não | não | sim |

Nenhum recebe: o histórico da sessão, o relatório ou as justificativas do autor, os achados dos outros revisores (exceto na re-revisão), qualquer instrução de "não apontar".

## 4. Formato comum do retorno

Os 3 revisores devolvem o mesmo formato, para o corretor juntar e deduplicar.

```text
## Veredito: APROVADO | CORRIGIR
<n> bloqueios, <n> importantes, <n> menores

## Achados

### [C1] Importante · p. 14 · "Um triângulo feito de rampas" · rampa.typ:335
- Regra: <regra N do SKILL.md, item do plano ou do checklist (ex.: "C5")>
- Evidência: <o que se vê, se mede ou se calcula; outra pessoa consegue refazer>
- Correção: <mudança concreta que respeita as regras do professor>

## Verificações sem achado
- <o que foi conferido, onde e como; ex.: "p. 5 a 15: refiz as 7 contas; gráficos das p. 5, 6 e 11 em 3 pontos">

## Não pude verificar
- <o que ficou de fora, por quê, e o que o orquestrador deve conferir> (ou "nada")

## Deixei de julgar
- <o que vi e deixei de lado por ser papel de outro revisor ou estar fora do material, com o motivo> (ou "nada")
```

- **Prefixos:** `C` (conteúdo), `L` (leitura), `T` (tema e layout), numerados em sequência.
- **Localização tripla:** página do `deck.pdf`, título do slide e `arquivo.typ:linha` (do mapa). A página sozinha não basta: dividir um slide desloca as seguintes.
- **Um achado por defeito.** O mesmo defeito com a mesma origem (um ajudante, um padrão repetido) é um achado só, com a lista de páginas.
- **Direto ao ponto:** começa pelo veredito, sem narrar o processo. `APROVADO` só sem bloqueio nem importante.
- **A correção nunca viola uma regra.** Não cabe: dividir em 2 ou mais slides, dizendo onde cortar e o título de cada um; nunca diminuir a letra, o `inset` ou a margem, nem `scale`. Questão de marcar: a versão discursiva. Pergunta solta: um `<exercise>` com `#answer`, ou sai do slide.
- **"Parece certo" não é verificação.** Cada linha de "Verificações sem achado" diz o que foi conferido e como.

## 5. Gravidade

| Gravidade | Quando | Na rodada? |
|---|---|---|
| **Bloqueio** | o aluno aprende errado ou perde conteúdo: conta, fórmula, resposta, definição ou gráfico errado; conteúdo de prova sem slide; texto cortado, coberto ou fora da página; deck que não compila | sim, primeiro |
| **Importante** | qualquer das 9 regras do professor violada; assunto do plano sem slide; definição antes do exemplo introdutório; mais de uma ideia no slide; mais de ~40 palavras ou 5 itens; salto ou símbolo antes da definição; página de continuação não planejada; sobreposição; aviso de compilação | sim |
| **Menor** | polimento: uma palavra melhor, alinhamento fino, quebra de linha feia sem perda | não: vai para o registro e para o relatório ao professor |

- Violação de regra do professor nunca é menor.
- Justificativa do autor (no código, no plano, no slide) nunca rebaixa a gravidade.
- Na dúvida entre duas, a mais alta, com a dúvida dita na evidência.

## 6. R1: conteúdo e contas

Recebe: regras, plano aprovado, `pedagogia.md`, decks anteriores, fontes, PDF, PNGs, texto e mapa. Não recebe: relatório do autor, log, verificador, achados dos outros.

```text
Subagente (general-purpose):
  description: "Revisar conteúdo e contas: [DECK]"
  model: [MODELO_MAIS_CAPAZ]
  prompt: |
    Você é professor de [DISCIPLINA] na UFAC e revisa os slides de uma aula
    antes de ela ser dada. Sua pergunta é uma só: o que estes slides ensinam
    está certo, cobre o plano e a prova, e segue a ordem didática pedida?
    Estilo de leitura e layout são de outros revisores.

    ## O que foi pedido
    Regras do professor (literais): [REGRAS]
    Plano de aula aprovado: [PLANO]
    Sequência didática: [PEDAGOGIA]
    Decks anteriores do curso (só para saber o que já foi visto): [DECKS_ANTERIORES]

    ## Material
    Fontes: [PASTA_DECK] (o deck e os arquivos que ele inclui) e [COMUM]
    PDF: [P]/deck.pdf · páginas: [P]/png/ · texto por página: [P]/texto/
    Mapa página -> título -> arquivo.typ:linha: [P]/mapa.tsv

    ## Limites
    - Somente leitura: não edite nada do deck nem do curso.
    - Não despache subagentes nem peça segunda opinião. Deck longo: revise em
      passadas; o que faltar vai em "Não pude verificar".
    - Não corrija: aponte.

    ## Checklist
    C1. Cobertura. Liste o que o plano diz que cai na prova e os assuntos do
        plano; para cada um, as páginas da definição, do exemplo e do
        exercício. Conteúdo de prova sem página: bloqueio. Assunto do plano
        sem página: importante. Assunto fora do plano, ou de outra unidade
        posto aqui pela cronologia das aulas (regra 5): importante.
    C2. Respostas refeitas. Para cada <example> e <exercise>: resolva a partir
        do enunciado ANTES de ler o #solution, o #answer e a resposta do
        plano. Só então compare passo a passo. Se divergir, refaça por outro
        caminho e mostre as duas contas na evidência.
    C3. Gráficos. Para cada gráfico, confira pelo menos 3 pontos da fórmula
        (bordas e descontinuidades incluídas), a inclinação, o período, a
        simetria e a escala dos eixos. Se o gráfico é gerado no .typ, leia os
        dados. Na evidência: os pontos, o valor esperado e o valor lido.
    C4. Definições e fórmulas: condições (contínuo ou discreto, domínio, valor
        na descontinuidade), sinais, limites, índices, unidades; notação igual
        à do plano e à dos outros slides; nada falso ou geral demais;
        coerência com a bibliografia do plano.
    C5. Ordem didática, por assunto: exemplo introdutório concreto
        (<example>) antes da definição; definição que nasce de refinamento;
        exemplo resolvido; exercício discursivo com item reverso. Definição
        antes do primeiro exemplo introdutório: importante.
    C6. Toda regra deduzida no slide (pela substituição do argumento ou
        equivalente) e conferida em dois pontos.
    C7. Exercícios: discursivos (o aluno calcula, esboça, mostra, determina),
        com os dados necessários e resposta verificável; cada um ataca uma
        concepção errada listada no plano e tem item reverso. Questão de
        marcar, verdadeiro ou falso, votação ou "aquecimento": importante
        (regra 3); a correção traz a versão discursiva.
    C8. Caso resolvido pelo professor num slide comum (entrada dada e conta
        feita): importante (regra 4). Exposição de modelo ou dedução não
        entra.
    C9. Cada #remark retoma algo já visto (antes neste deck, num deck
        anterior ou nos pré-requisitos) e não traz fato novo.
    C10. Quando o assunto tem dois casos paralelos (em Sinais e Sistemas,
         contínuo e discreto), os dois aparecem, lado a lado, e cada
         resultado diz a qual caso vale.
    C11. Primeira aula: ementa, avaliações, datas e bibliografia batem com o
         plano de curso.

    ## Calibração
    Bloqueio: o aluno aprende errado ou perde conteúdo de prova. Importante:
    regra do professor violada, assunto do plano faltando, ordem didática
    quebrada, salto que esconde um passo, notação inconsistente. Menor:
    polimento. Violação de regra nunca é menor. Justificativa escrita pelo
    autor não rebaixa a gravidade.

    ## Formato do retorno
    Comece pelo veredito. Use exatamente:
    ## Veredito: APROVADO | CORRIGIR
    <n> bloqueios, <n> importantes, <n> menores
    ## Achados
    ### [C<n>] <Gravidade> · p. <N> · "<título>" · <arquivo.typ:linha>
    - Regra: <regra do SKILL.md, item do plano ou do checklist>
    - Evidência: <a conta refeita, ou os pontos do gráfico: esperado x lido>
    - Correção: <mudança concreta que respeita as regras>
    ## Cobertura
    <assunto ou item de prova> -> p. <definição>, <exemplo>, <exercício>
    ## Verificações sem achado
    ## Não pude verificar
    ## Deixei de julgar
```

## 7. R2: estilo de leitura

Recebe: regras, objetivos e pré-requisitos do plano, PNGs, texto por página e mapa (só para localizar). Não recebe: as fontes `.typ`, o plano detalhado, o relatório do autor. Julga o que se vê, não a intenção de quem escreveu.

```text
Subagente (general-purpose):
  description: "Revisar estilo de leitura: [DECK]"
  model: [MODELO_INTERMEDIARIO]
  prompt: |
    Você é aluno de [DISCIPLINA] na UFAC. Sabe o que está nos pré-requisitos
    abaixo e nada além. Está no fundo da sala e lê cada slide projetado antes
    de o professor explicar. Sua pergunta é uma só: dá para ler e acompanhar?
    Contas e código são de outros revisores. Você não tem o código-fonte:
    julga só o que vê.

    ## Contexto
    Regras do professor (literais): [REGRAS]
    Objetivos e pré-requisitos da aula: [OBJETIVOS_E_PREREQUISITOS]

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
        fórmulas) e os itens. Mais de ~40 palavras ou de 5 itens: achado.
        Vale também para ementa, cronograma e tabela (regra 1).
    L3. Frases curtas: frase com mais de ~20 palavras ou com duas afirmações.
    L4. Sem salto: o primeiro ponto em que você travaria (símbolo não
        definido, passo pulado, "é fácil ver", notação trocada sem aviso).
        Diga a dúvida que teria ("de onde veio o fator 2?").
    L5. Nenhuma letra pequena: texto visivelmente menor que o corpo (legenda,
        número ou rótulo de gráfico, rótulo de circuito, tabela, nota) que
        você não leria do fundo da sala. Diga onde fica, no PNG.
    L6. Perguntas: pergunta ao aluno fora de uma caixa de exercício (vermelha,
        "Exercício N.M"); alternativas (A) a (D), verdadeiro ou falso, "qual
        destes", votação, "aquecimento"; "Resposta." visível na mesma página
        do enunciado do exercício (regra 3).
    L7. Destaques: realce ou negrito colorido em item curto, em título ou em
        quase tudo do slide (regra 9).
    Depois da última página:
    L8. Teste dos títulos, por Parte: liste só os títulos dos slides de cada
        Parte ("PARTE N"), em ordem. Lidos assim, eles contam a sequência do
        assunto? Marque o título fora de ordem, o salto e o título que não diz
        do que trata o slide.
    L9. Encontro e data: título, Parte ou resumo com "Encontro N", "Aula N",
        data de aula, "Resumo do encontro", "Próximo encontro" ou "Próxima
        aula"; último slide diferente de "Fim!" com um meme; "Obrigado!"
        (regras 5 e 6). A data de uma prova pode aparecer.

    ## Calibração
    Importante: mais de uma ideia, texto acima da referência, salto, símbolo
    antes da definição, letra menor que o corpo, pergunta solta ou de marcar,
    resposta junto do enunciado, encontro ou data, final fora da regra 6.
    Menor: frase que pode ficar mais curta sem mudar a leitura; título vago
    que não quebra a sequência. Nunca sugira diminuir a letra: para texto
    demais, diga onde cortar e o título de cada slide novo.

    ## Formato do retorno
    Comece pelo veredito. Use exatamente:
    ## Veredito: APROVADO | CORRIGIR
    <n> bloqueios, <n> importantes, <n> menores
    ## Achados
    ### [L<n>] <Gravidade> · p. <N> · "<título>" · <arquivo.typ:linha do mapa>
    - Regra: <regra do SKILL.md ou item do checklist>
    - Evidência: <o texto citado e as contagens (palavras, itens), ou a dúvida do aluno>
    - Correção: <onde cortar e o título de cada slide novo, ou a frase reescrita>
    ## Títulos por Parte
    PARTE <N> "<nome>": <título 1> / <título 2> / ...
    ## Verificações sem achado
    ## Não pude verificar
    ## Deixei de julgar
```

## 8. R3: tema e layout

Recebe: regras, `padroes-do-tema.md`, `zap.md`, fontes e `comum.typ`, log, verificador, PDF, PNGs, folha e mapa. Não recebe: plano, relatório do autor, justificativas de layout.

```text
Subagente (general-purpose):
  description: "Revisar tema e layout: [DECK]"
  model: [MODELO_INTERMEDIARIO]
  prompt: |
    Você mantém o tema Typst touying-ufac-unofficial e revisa um deck que o
    usa. Sua pergunta é uma só: o deck segue as regras do professor e os
    padrões do tema, e nada transborda, se sobrepõe ou encolhe? Contas e
    didática são de outros revisores.

    ## Padrões e regras
    Regras do professor (literais): [REGRAS]
    Padrões do tema (sintaxe, componentes, armadilhas): [PADROES]
    Circuitos: [ZAP]

    ## Material
    Fontes: [PASTA_DECK] e [COMUM]
    Compilação feita agora: [P]/compilacao.log (última linha: código de saída)
    Verificador mecânico: [P]/verificador.txt (é uma alegação: confira)
    PDF: [P]/deck.pdf · páginas: [P]/png/ · folha: [P]/folha.png
    Texto por página: [P]/texto/ · mapa: [P]/mapa.tsv

    ## Limites
    Somente leitura no deck e no curso; para compilar, use [TMP]. Não
    despache subagentes. Não corrija: aponte.

    ## Buscas (rode na pasta do deck e leia a saída inteira)
    cd [PASTA_DECK]
    # páginas esperadas
    awk '/^ *\/\//{next} /^ *= /{s++} /^ *== /{c++} /^ *---[ \t]*$/{q++} /#pause/{p++} /#[a-z-]*slide[[(]/{f++} END{print "esperadas:", s+c+q+p+f, "(" f+0 " slides por função, " s+0 " seções, " c+0 " slides, " q+0 " quebras, " p+0 " pausas)"}' *.typ
    pdfinfo [P]/deck.pdf | grep Pages
    # letra no código
    grep -nE "size:|scale\(|inset:|margin:" *.typ [COMUM]
    # letra no PDF: palavras de texto menores que o corpo (22pt), fora do rodapé
    pdftotext -bbox [P]/deck.pdf - | awk -F'"' '/<page /{p++} /<word /{h=sprintf("%.1f",$8-$4); w=$9; gsub(/^>|<\/word>$/,"",w); if (h+0<21.5 && $4+0<440 && w~/[A-Za-z][A-Za-z]/) printf "p.%d\t%spt\t%s\n",p,h,w}'
    # funções e dicionários de argumentos definidos no deck
    grep -nE "let [[:alnum:]_-]+ *(\(|= *\(?[[:alnum:]_, .]*\)? *=>)" *.typ
    grep -nE "\.\.[[:alpha:]][[:alnum:]_-]*" *.typ
    # cores fora do tema
    grep -nE "rgb\(|luma\(|cmyk\(|oklch\(|oklab\(" *.typ
    grep -nE "(:|\+) *(black|gray|silver|white|navy|blue|aqua|teal|eastern|purple|fuchsia|maroon|red|orange|yellow|olive|green|lime)\b" *.typ
    # exercício: --- antes de #answer; pergunta fora de exercício ou exemplo
    awk '/^ *=+ /{ex = ($0 ~ /<exercise/); br = 0; t = FILENAME ":" FNR} ex && /^ *---/{br = 1} ex && /#answer/ && !br {print t ": #answer sem --- antes"}' *.typ
    awk '/^ *=+ /{ex = ($0 ~ /<exercise|<example/)} !ex && /\?/ && !/^ *=+ / && !/^ *\/\// {print FILENAME ":" FNR ": " $0}' *.typ
    grep -niE "alternativa|assinale|marque|verdadeiro ou falso|qual destes|vota" *.typ
    grep -nE "\([A-D]\)" *.typ
    # encontro, data, encerramento
    grep -niE "encontro|aula [0-9]|próxim[ao] (aula|encontro)|a seguir|obrigad[oa]|[0-9]{1,2}/[0-9]{1,2}" *.typ
    grep -n "ending-slide" *.typ
    # travessão no texto
    grep -n "—" *.typ | grep -vE "^[^:]+:[0-9]+: *//"
    # figuras
    grep -nE "@preview/(zap|lilaq|fletcher|cetz)" *.typ [COMUM]
    grep -nE "cetz\.canvas|image\(" *.typ

    ## Checklist
    T1. Compilação: código 0 e nenhum aviso no log; imports exatos
        @preview/touying:0.7.4 e @preview/touying-ufac-unofficial:0.3.0 (ou
        @local, com a 0.3.0 fora do Typst Universe: SKILL.md, "Antes de
        começar").
        BLOQUEIO no verificador.txt também é achado. Cada REVISAR dele recebe
        sua decisão: achado, ou verificação sem achado com o motivo.
    T2. Transbordo: páginas obtidas diferentes das esperadas, ou título
        repetido no mapa sem um --- que o explique, é página de continuação
        não planejada; ache a página. No PNG: texto encostado no rodapé,
        figura maior que o quadro, callout que pulou para a página seguinte
        deixando um buraco.
    T3. Sobreposição, no PNG: texto sobre figura, rótulo sobre a curva,
        rótulo que cruza a borda de uma caixa ou encosta na borda da página,
        elemento sobre o cabeçalho ou o rodapé.
    T4. Letra (regra 2): text(size:) ou set text(size:) menor que 1em,
        scale() sobre texto, inset ou margem apertados, ajudante que reduz a
        letra (também os do comum.typ e um show de legenda em .6em), e toda
        palavra da busca no PDF. Números e rótulos de gráfico: confira no PNG
        e no ajudante que os desenha. Não contam: rodapé, número da página,
        etiqueta da capa, "PARTE N", índices e limites de fórmulas. Um
        ajudante do curso que reduz a letra é um achado só, com as páginas;
        a correção é passar o tamanho no uso ou propor o ajuste no comum.typ.
    T5. Exercício e exemplo (regras 3 e 4): == Título <exercise> (ou
        #exercise-slide), enunciado, --- e #answer; == Título <example> com
        #solution, na mesma página se couber, senão depois de ---; #solution
        ou #answer fora de item; pergunta solta; questão de marcar.
    T6. Código explícito (regra 7): toda função definida nos arquivos do deck
        é achado. Ou é desnecessária (use o componente do tema ou o ajudante
        do curso, escrito no slide, mesmo que fique um pouco diferente), ou é
        grande ou um recurso que o tema não tem (estilo de diagrama, de
        gráfico, de circuito) e vai para o comum.typ. Também: componente do
        tema refeito à mão (uma "caixa" no lugar de emph-box), dicionário de
        argumentos espalhado (..mini), a mesma função em vários arquivos.
    T7. Callouts e destaques (regra 9): #caution só para erro a evitar, #tip
        para atalho, #remark só para retomar, #note para o secundário ou para
        um assunto adiante (pelo nome, nunca "próxima aula"), #example e
        #examples para exemplo curto; nenhum callout próprio. Destaque em
        item curto, em título ou em tópico. Travessão "—" no texto.
    T8. Figuras (regra 8): circuito só com zap (CeTZ desenhando resistor ou
        fonte, ou imagem de circuito, é achado); gráficos com lilaq pelos
        ajudantes do curso; diagramas de blocos com fletcher; desenhos com
        CeTZ; cores só colors.* (nada de rgb(), hexadecimal, luma() ou cor
        nomeada).
    T9. Estrutura (regras 5 e 6): Partes (=) e arquivos com nome de assunto;
        nada de "Encontro N", "Aula N", data de aula, "Resumo do encontro",
        "Próximo encontro", "(encontro N)", arquivo encontro-N.typ. A data de
        uma prova pode aparecer. Última página: "Fim!" com o meme, como
        #ending-slide(title: [Fim!])[#image("memes/meme.png", height: 12em)];
        sem subtítulo, "Obrigado!", contato nem o que vem na próxima aula.
    T10. Armadilhas do [PADROES] visíveis no PNG: ->, ~~, == ou $ crus; caixa
         azul acidental (parágrafo começando com >); texto à direita do slide
         de seção; #v(1fr) dentro de cols.

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
    - Regra: <regra do SKILL.md, padrão do tema ou item do checklist>
    - Evidência: <onde no PNG, a linha da fonte, a saída da busca ou do log>
    - Correção: <mudança concreta que respeita as regras>
    ## Verificações sem achado
    ## Não pude verificar
    ## Deixei de julgar
```

## 9. O corretor

Um só subagente, que recebe os achados consolidados e corrige o deck. Não é um dos revisores nem o orquestrador. Rodadas 1 e 2: o mesmo corretor, se der para retomá-lo; senão, um novo com o registro. Rodada 3: um corretor novo, com a frase "Um corretor anterior tentou 2 vezes; agora é com você. Leia o registro."

```text
Subagente (general-purpose):
  description: "Corrigir deck [DECK], rodada [N]"
  model: [MODELO_MAIS_CAPAZ]
  prompt: |
    Você corrige um deck de slides depois de uma revisão. Os revisores podem
    ter errado: confirme cada achado no PDF antes de mexer no deck.

    ## Material
    Achados consolidados (literais): [ACHADOS]
    Regras do professor (literais): [REGRAS]
    Plano de aula: [PLANO] · Sequência didática: [PEDAGOGIA]
    Padrões do tema: [PADROES] · Circuitos: [ZAP]
    Fontes: [PASTA_DECK] e [COMUM] · pacote: [P] (deck.pdf, png/, texto/, mapa.tsv)
    Registro: [REGISTRO] · relatório desta rodada (você escreve): [RELATORIO]

    ## Passo 1: confirmar, sem editar nada
    Para cada achado:
    - reescreva-o com suas palavras;
    - reproduza com evidência sua, nova: conteúdo, refaça a conta (a terceira,
      depois da do autor e da do revisor); leitura, abra o PNG e conte
      palavras e itens no texto da página; layout, olhe a página e a linha da
      fonte, recompilando em [TMP] se preciso;
    - dê o veredito: CONFIRMADO; NÃO CONFIRMADO, com a evidência contrária;
      ou CONFLITO, quando colide com uma regra ou com outro achado. Resolva o
      conflito pela ordem: regras do professor > plano aprovado > padrões do
      tema > sugestão do revisor, e escreva a decisão. Quase sempre a saída
      é dividir o slide.
    O mesmo defeito apontado por dois revisores é uma correção só, que cita
    os dois identificadores. Achado ambíguo: pare e devolva
    PRECISA_DE_CONTEXTO com todas as dúvidas, sem corrigir nada.

    ## Passo 2: corrigir só os confirmados
    Um por vez: primeiro os bloqueios, depois os importantes. Respeite as
    regras: o que não cabe vira dois ou mais slides (--- ou um == novo),
    nunca letra, inset ou margem menores, nem scale; pergunta vira
    <exercise> com --- e #answer; questão de marcar vira discursiva; caso
    resolvido vira <example>; circuito vai para o zap; função do deck sai
    (componente do tema escrito no slide) ou vira proposta para o comum.typ.
    Não edite o comum.typ nem o tema: escreva a proposta no relatório.
    Achado menor não se corrige agora: liste-o. Não mexa no que nenhum achado
    tocou.

    ## Passo 3: verificar cada correção
    Recompile (código 0, nenhum aviso), renderize as páginas afetadas e
    confira no PNG que o defeito sumiu: tentar não é corrigir. No fim, rode
    [VERIFICADOR] e monte o mapa página antiga -> página nova (dividir um
    slide desloca as seguintes).

    ## Retorno
    No relatório, por achado: veredito, evidência, mudança (arquivo.typ:linha),
    comando rodado, saída e páginas novas; depois as propostas para o
    comum.typ, os menores adiados e o mapa antigo -> novo. Para mim, em até
    15 linhas: Status (FEITO | FEITO_COM_RESSALVAS | PRECISA_DE_CONTEXTO |
    BLOQUEADO); confirmados / não confirmados / conflitos; a linha da
    compilação; o resultado do verificador; o caminho do relatório.
```

Antes da re-revisão, o orquestrador confere no relatório: comando, código 0, verificador sem bloqueio. Faltou: volta ao corretor. Depois monta o pacote `r<N+1>`.

## 10. Re-revisão com escopo

O revisor do achado (R1, R2 ou R3, com o material da seção 3) recebe os achados dele e o relatório do corretor. Modelo intermediário; achado de conta do R1, o mais capaz. O R3 roda sempre, nas páginas alteradas, mesmo sem achados próprios.

```text
Subagente (general-purpose):
  description: "Re-revisar [PAPEL], rodada [N]: [DECK]"
  model: [MODELO]
  prompt: |
    Você re-revisa um deck depois de uma rodada de correção, no papel de
    [PAPEL]. Dê um veredito para cada achado abaixo e olhe as páginas
    alteradas. Nada além disso.

    ## Material
    Seu checklist (o mesmo da revisão original): [CHECKLIST]
    Regras do professor (literais): [REGRAS]
    Achados sob verificação (literais): [ACHADOS]
    Relatório do corretor (vereditos, evidência, mudanças): [RELATORIO]
    Mapa página antiga -> nova: [MAPA_ANTIGO_NOVO]
    Pacote novo: [P] (e as fontes em [PASTA_DECK], se o seu papel as recebe)
    Páginas alteradas: [PAGINAS_ALTERADAS]

    ## Limites
    Somente leitura. Não despache subagentes. Não corrija.

    ## Para cada achado, na ordem recebida
    - RESOLVIDO: o defeito específico não existe mais; cite a página nova e
      a evidência. "Tentou" não é resolvido.
    - NÃO RESOLVIDO: o que ainda está lá.
    - Achado que o corretor deu como NÃO CONFIRMADO: MANTIDO, com evidência
      nova que responde à dele, ou RETIRADO, se a evidência dele está certa.

    ## Páginas alteradas
    Aplique seu checklist só a elas. Defeito que a correção criou é achado
    novo, no formato comum e com gravidade.

    ## Fora do escopo
    O que notar em páginas não alteradas vai nesta seção e não reabre a
    rodada; diga se é bloqueio.

    ## Formato do retorno
    ## Veredito da rodada: APROVADO | CORRIGIR
    ## Achados anteriores
    [<id>] RESOLVIDO | NÃO RESOLVIDO | MANTIDO | RETIRADO · p. <N> · <evidência>
    ## Achados novos
    ## Fora do escopo
    ## Não pude verificar
```

`APROVADO` só com todos RESOLVIDO ou RETIRADO e nenhum achado novo de bloqueio ou importante. Um bloqueio fora do escopo entra na rodada seguinte; o resto vai para o registro.

## 11. Teto, decisões e registro

- **Rodada 3 com achado aberto:** o orquestrador decide cada um: retirar (revisor errado, com a evidência), adiar (real, sem prejuízo à aula) ou levar ao professor. Decidir antes do teto, só para encerrar o laço, é pré-julgamento.
- **Bloqueio aberto** no teto: a aula não é entregue como pronta; vai ao professor como pendência.
- **O registro** (`[TMP]/revisao-<deck>/registro.md`) é o que sobrevive à compactação do contexto; confie nele, não na memória. Uma linha por evento:

```text
Rodada 1, revisão: R1 CORRIGIR (C1-C3), R2 CORRIGIR (L1-L5), R3 APROVADO
Rodada 1, corretor: 7 confirmados, 1 não confirmado (C2), 0 conflitos; páginas 92 -> 95; verificador sem bloqueio
Rodada 1, re-revisão: 7 resolvidos; C2 retirado; novo: T1 (p. 41)
Menor (adiado): L4 · p. 20 · "Sistemas por toda parte" · frase de 24 palavras
Decisão: <o que decidi>; <por quê>; <o que custa se eu estiver errado>
```

- **Na entrega** (SKILL.md, passo 7), o relatório ao professor traz: o último veredito de cada revisor, as decisões, os menores adiados, as propostas para o `comum.typ` e os candidatos a meme.

## 12. Placeholders

| Placeholder | Conteúdo |
|---|---|
| `[DECK]`, `[DISCIPLINA]`, `[N]` | nome do deck, da disciplina; número da rodada |
| `[MODELO_MAIS_CAPAZ]`, `[MODELO_INTERMEDIARIO]`, `[MODELO]` | modelo do subagente, sempre explícito (seção 1) |
| `[REGRAS]` | a seção "Regras do professor" do SKILL.md, colada literalmente |
| `[PLANO]` | o plano de aula aprovado (arquivo) |
| `[OBJETIVOS_E_PREREQUISITOS]` | só essas duas partes do plano, coladas (R2) |
| `[PEDAGOGIA]`, `[PADROES]`, `[ZAP]` | `references/pedagogia.md`, `references/padroes-do-tema.md`, `references/zap.md` |
| `[DECKS_ANTERIORES]` | PDFs ou `.typ` dos decks já dados no curso |
| `[PASTA_DECK]`, `[ENTRADA]`, `[RAIZ]`, `[COMUM]` | pasta do deck, arquivo de entrada, raiz do `--root` (no curso, a pasta acima do deck), `comum.typ` |
| `[TMP]`, `[P]` | pasta temporária da sessão; pacote da rodada (`[TMP]/revisao-<deck>/r<N>`) |
| `[VERIFICADOR]` | o passo 5 do SKILL.md sobre o PDF recém-compilado: `python3 scripts/verificar_deck.py [PASTA_DECK] <deck.pdf>` |
| `[ACHADOS]` | achados consolidados, literais |
| `[REGISTRO]`, `[RELATORIO]` | registro da revisão; relatório de correção da rodada |
| `[PAPEL]`, `[CHECKLIST]` | R1, R2 ou R3; a seção "Checklist" do prompt desse revisor |
| `[MAPA_ANTIGO_NOVO]`, `[PAGINAS_ALTERADAS]` | do relatório do corretor |
