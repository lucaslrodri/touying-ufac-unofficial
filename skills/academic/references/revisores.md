# Revisores

Três revisores independentes leem o deck em paralelo, depois do verificador mecânico. Um corretor confirma cada achado no PDF e só então corrige. A re-revisão olha só o que mudou. No máximo 3 rodadas. As regras do `SKILL.md` mandam em tudo, também nas correções que os revisores sugerem.

## 1. Fluxo

```text
verificador sem bloqueio (SKILL.md, passo 4)
  -> pacote de revisão r1 (seção 2)
  -> na MESMA mensagem, 3 subagentes: R1 fidelidade e conteúdo | R2 leitura | R3 tema e layout
  -> orquestrador junta os retornos, sem julgar, e grava no registro
       os 3 APROVADO -> entrega (passo 6)
  -> corretor: confirma cada achado no PDF, corrige os confirmados, recompila, roda o verificador
  -> pacote r2 + re-revisão com escopo:
       o revisor de cada achado aberto + R3 sempre, nas páginas alteradas
       tudo RESOLVIDO ou RETIRADO, nada novo de bloqueio ou importante -> entrega
       algo aberto -> nova rodada
  -> rodada 3 ainda aberta -> o orquestrador decide cada achado, registra e leva ao autor
```

- **Rodada** = um corretor + uma re-revisão. No máximo 3 por deck.
- **Os 3 rodam sempre**, também em deck curto e depois de correção pequena.
- **Paralelo:** as 3 chamadas de subagente na mesma resposta. Um só editor por vez: o corretor nunca roda junto com outro agente que edita.
- **Modelo explícito** em todo despacho: R1 e corretor no mais capaz disponível (um número diferente do texto é o erro mais caro numa defesa); R2, R3 e re-revisões num intermediário. Modelo omitido herda o da sessão.
- **Contexto construído, nunca herdado:** cada subagente recebe o prompt desta página e caminhos de arquivo. Nunca o histórico, o raciocínio ou o relatório do autor do deck, nem os achados de outro revisor.
- **Sem pré-julgamento:** nada de "não aponte X", "no máximo menor", "o plano escolheu", "é de propósito". Se o autor discorda, o corretor mostra a evidência e a re-revisão decide.
- **Papéis:** o orquestrador (a sessão principal) monta o pacote, despacha, junta, mantém o registro e decide no teto. Os revisores só leem. Só o corretor edita.

## 2. Pacote de revisão

Uma pasta por rodada, fora da pasta do trabalho (na pasta temporária da sessão): `[TMP]/revisao-<deck>/r<N>/`. Os comandos abaixo montam a `r1`; nas rodadas seguintes, troque o `r1`. O registro fica em `[TMP]/revisao-<deck>/registro.md`.

| Arquivo | Conteúdo |
|---|---|
| `deck.pdf`, `compilacao.log` | compilação feita agora; a última linha do log é o código de saída |
| `png/p01.png`… | uma imagem por página, a 110 ppi (cerca de 1280 × 720, o tamanho de um projetor) |
| `texto/p01.txt`… | o texto de cada página (`pdftotext -layout`) |
| `mapa.tsv` | página, título do slide e `arquivo.typ:linha` (`?` na capa e no fim) |
| `verificador.txt` | a saída de `scripts/verificar_deck.py` sobre este `deck.pdf`, com `--minutos` |
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
norm = lambda s: " ".join(re.sub(r"[^a-zà-ú0-9 ]", " ", s.lower()).split())
fonte = lambda l: norm(re.sub(r"\$[^$]*\$|<[\w-]*>\s*$", " ", l.lstrip(" =")))
heads = [(len(m.group(1)), fonte(l), f"{f.relative_to(pasta)}:{i}") for f in sorted(pasta.rglob("*.typ"))
         for i, l in enumerate(f.read_text().splitlines(), 1) if (m := re.match(r"\s*(={1,2}) ", l))]
xml = subprocess.run(["pdftotext", "-bbox", pdf, "-"], capture_output=True, text=True).stdout
for p, pg in enumerate(xml.split("<page ")[1:], 1):
    ws = [(float(a), float(b) - float(a), w) for a, b, w in
          re.findall(r'yMin="([\d.]+)" xMax="[\d.]+" yMax="([\d.]+)">(.*?)</word>', pg)]
    big = [w for y, h, w in ws if h > 40]
    top = [(y, w) for y, h, w in ws if y < 60 and h > 21.5]
    titulo = " ".join(big or [w for y, w in top if y == min(top)[0]] if top or big else [])
    nivel = 1 if "PARTE" in (w for y, h, w in ws) else 2  # a página de uma Parte (=) ou de um slide (==)
    linha = next((loc for n, t, loc in heads if n == nivel and norm(titulo) and t == norm(titulo)), "?")
    print(p, titulo, linha, sep="\t")
EOF
```

O mesmo título em páginas seguidas é continuação, por `---` ou por transbordo; o R3 separa uma do outro.

## 3. Quem recebe o quê

| Material | R1 fidelidade | R2 leitura | R3 tema | Corretor |
|---|---|---|---|---|
| regras (seção "Regras" do SKILL.md, literal) | sim | sim | sim | sim |
| plano da apresentação aprovado | sim | só a mensagem central e o público | não | sim |
| texto do trabalho, dados e `.bib` | sim | **não** | não | sim |
| parecer da qualificação (se houver) | sim | não | não | sim |
| `references/estrutura.md` | sim | não | não | sim |
| fontes `.typ` do deck e o `comum.typ` | sim | **não** | sim | sim |
| `deck.pdf`, `png/`, `texto/`, `mapa.tsv` | sim | sim | sim | sim |
| `compilacao.log`, `verificador.txt`, `folha.png` | não | não | sim | sim |
| `references/padroes-do-tema.md`, `references/zap.md` | não | não | sim | sim |
| achados consolidados | não | não | não | sim |

Nenhum recebe: o histórico da sessão, o relatório ou as justificativas de quem fez o deck, os achados dos outros revisores (exceto na re-revisão), qualquer instrução de "não apontar".

## 4. Formato comum do retorno

Os 3 revisores devolvem o mesmo formato, para o corretor juntar e deduplicar.

```text
## Veredito: APROVADO | CORRIGIR
<n> bloqueios, <n> importantes, <n> menores

## Achados

### [F1] Bloqueio · p. 11 · "O filtro de Kalman fica a menos de 1% da referência" · defesa.typ:96
- Regra: <regra N do SKILL.md, item do plano ou do checklist (ex.: "F2")>
- Evidência: <o que se vê, se mede ou se lê no texto, com a página; outra pessoa consegue refazer>
- Correção: <mudança concreta que respeita as regras>

## Verificações sem achado
- <o que foi conferido, onde e como; ex.: "p. 9 a 13: os 7 números conferidos com a Tabela 4.2 do texto">

## Não pude verificar
- <o que ficou de fora, por quê, e o que o orquestrador deve conferir> (ou "nada")

## Deixei de julgar
- <o que vi e deixei de lado por ser papel de outro revisor ou estar fora do material, com o motivo> (ou "nada")
```

- **Prefixos:** `F` (fidelidade e conteúdo), `L` (leitura), `T` (tema e layout), numerados em sequência.
- **Localização tripla:** página do `deck.pdf`, título do slide e `arquivo.typ:linha` (do mapa). A página sozinha não basta: dividir um slide desloca as seguintes.
- **Um achado por defeito.** O mesmo defeito com a mesma origem (um ajudante, um padrão repetido) é um achado só, com a lista de páginas.
- **Direto ao ponto:** começa pelo veredito, sem narrar o processo. `APROVADO` só sem bloqueio nem importante.
- **A correção nunca viola uma regra.** Não cabe: dividir em 2 ou mais slides, dizendo onde cortar e o título de cada um, ou levar à reserva; nunca diminuir a letra, o `inset` ou a margem, nem `scale`. Número divergente: o valor do texto, com a página.
- **"Parece certo" não é verificação.** Cada linha de "Verificações sem achado" diz o que foi conferido e como.

## 5. Gravidade

| Gravidade | Quando | Na rodada? |
|---|---|---|
| **Bloqueio** | a banca vê um erro: número, unidade, equação, tabela ou gráfico diferente do texto ou dos dados; afirmação que o trabalho não sustenta; resultado principal sem slide; texto cortado, coberto ou fora da página; deck que não compila | sim, primeiro |
| **Importante** | qualquer das 10 regras violada; objetivo específico sem conclusão; figura ou dado de terceiros sem fonte; sigla, símbolo ou métrica antes da definição; título de resultado sem o achado; mais de uma ideia no slide; mais de ~40 palavras ou 5 itens; tempo acima do previsto; página de continuação não planejada; sobreposição; aviso de compilação | sim |
| **Menor** | polimento: uma palavra melhor, alinhamento fino, quebra de linha feia sem perda | não: vai para o registro e para o relatório ao autor |

- Violação de regra nunca é menor.
- Justificativa de quem fez o deck (no código, no plano, no slide) nunca rebaixa a gravidade.
- Na dúvida entre duas, a mais alta, com a dúvida dita na evidência.

## 6. R1: fidelidade e conteúdo

Recebe: regras, plano aprovado, texto do trabalho, dados, `.bib`, parecer da qualificação, `estrutura.md`, fontes, PDF, PNGs, texto e mapa. Não recebe: relatório do autor do deck, log, verificador, achados dos outros.

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
    Regras (literais): [REGRAS]
    Plano da apresentação aprovado: [PLANO]
    Sequência e tempo: [ESTRUTURA]

    ## Material
    Texto do trabalho: [TEXTO] · dados: [DADOS] · bibliografia: [BIB]
    Parecer da qualificação (se houver): [PARECER]
    Fontes: [PASTA_DECK] (o deck e os arquivos que ele inclui)
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
        a legenda. Se o gráfico é gerado no .typ, leia o arquivo de dados que
        ele carrega. Na evidência: os pontos, o valor esperado e o lido.
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
    F6. Fontes. Toda figura, dado, equação ou frase de outro trabalho tem a
        citação no slide; toda citação está no slide de Referências e no
        .bib, com autor e ano iguais aos do texto. Sem fonte: importante.
    F7. Argumento (regra 4). Ordem: contexto e lacuna, objetivo, método,
        resultados, conclusões. A revisão de literatura não ocupa o deck; uma
        Parte que só existe porque o texto tem o capítulo: importante.
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
    conclusão, fonte faltando, afirmação exagerada, argumento fora de ordem.
    Menor: polimento. Violação de regra nunca é menor. Justificativa escrita
    por quem fez o deck não rebaixa a gravidade.

    ## Formato do retorno
    Comece pelo veredito. Use exatamente:
    ## Veredito: APROVADO | CORRIGIR
    <n> bloqueios, <n> importantes, <n> menores
    ## Achados
    ### [F<n>] <Gravidade> · p. <N> · "<título>" · <arquivo.typ:linha>
    - Regra: <regra do SKILL.md, item do plano ou do checklist>
    - Evidência: <o slide e o texto, com a página; ou os pontos do gráfico>
    - Correção: <mudança concreta que respeita as regras>
    ## Objetivos -> conclusões
    <objetivo> -> p. <resultado>, p. <conclusão>
    ## Perguntas sem resposta
    ## Verificações sem achado
    ## Não pude verificar
    ## Deixei de julgar
```

## 7. R2: leitura

Recebe: regras, a mensagem central e o público do plano, PNGs, texto por página e mapa (só para localizar). Não recebe: as fontes `.typ`, o texto do trabalho, o plano detalhado, o relatório do autor do deck. Julga o que se vê, não a intenção de quem escreveu.

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
    Regras (literais): [REGRAS]
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
    L2. Pouco texto: conte as palavras de texto (sem título, rodapé,
        fórmulas e referências) e os itens. Mais de ~40 palavras ou de 5
        itens: achado. Vale também para tabela (regra 1).
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
        curvas que você não distingue (regra 5).
    L7. Destaques: realce ou negrito colorido em item curto, em título ou em
        quase tudo do slide (regra 9).
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
    - Regra: <regra do SKILL.md ou item do checklist>
    - Evidência: <o texto citado e as contagens, ou a dúvida de quem assiste>
    - Correção: <onde cortar e o título de cada slide novo, ou a frase reescrita>
    ## Títulos por Parte
    PARTE <N> "<nome>": <título 1> / <título 2> / ...
    ## Mensagem que levei
    ## Verificações sem achado
    ## Não pude verificar
    ## Deixei de julgar
```

## 8. R3: tema e layout

Recebe: regras, `padroes-do-tema.md`, `zap.md`, fontes e `comum.typ`, log, verificador, PDF, PNGs, folha e mapa. Não recebe: plano, texto do trabalho, relatório do autor do deck, justificativas de layout.

```text
Subagente (general-purpose):
  description: "Revisar tema e layout: [DECK]"
  model: [MODELO_INTERMEDIARIO]
  prompt: |
    Você mantém o tema Typst touying-ufac-unofficial e revisa um deck que o
    usa. Sua pergunta é uma só: o deck segue as regras e os padrões do tema,
    e nada transborda, se sobrepõe ou encolhe? Números e argumento são de
    outros revisores.

    ## Padrões e regras
    Regras (literais): [REGRAS]
    Padrões do tema (sintaxe, componentes, armadilhas): [PADROES]
    Circuitos: [ZAP]

    ## Material
    Fontes: [PASTA_DECK] e [COMUM]
    Compilação feita agora: [P]/compilacao.log (última linha: código de saída)
    Verificador mecânico: [P]/verificador.txt (é uma alegação: confira)
    PDF: [P]/deck.pdf · páginas: [P]/png/ · folha: [P]/folha.png
    Texto por página: [P]/texto/ · mapa: [P]/mapa.tsv

    ## Limites
    Somente leitura no deck e no trabalho; para compilar, use [TMP]. Não
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
    # títulos de resultado sem o achado
    grep -niE "^ *== *(resultados?|discuss[ãa]o|tabela|figura|gr[áa]fico|quadro)( [0-9]+)? *$" *.typ
    # figuras como imagem, citações, referências
    grep -nE "image\(" *.typ
    grep -nE "@preview/(zap|lilaq|fletcher|cetz)" *.typ [COMUM]
    grep -nE "bibliography\(|cite\(" *.typ
    # encerramento e reserva
    grep -nE "ending-slide|show: *appendix" *.typ
    # travessão no texto
    grep -n "—" *.typ | grep -vE "^[^:]+:[0-9]+: *//"

    ## Checklist
    T1. Compilação: código 0 e nenhum aviso no log (citação sem entrada no
        .bib também avisa); imports exatos @preview/touying:0.7.4 e
        @local/touying-ufac-unofficial:0.3.0. BLOQUEIO no verificador.txt
        também é achado. Cada REVISAR dele recebe sua decisão: achado, ou
        verificação sem achado com o motivo.
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
        scale() sobre texto, inset ou margem apertados, show figure.caption
        no deck, e toda palavra da busca no PDF. Figura colada como imagem:
        confira no PNG os números e rótulos dela. Não contam: rodapé, número
        da página, etiqueta da capa, "PARTE N", legenda de figura (0.6em,
        do tema), índices e limites de fórmulas.
    T5. Código explícito (regra 7): toda função definida nos arquivos do deck
        é achado. Ou é desnecessária (use o componente do tema, escrito no
        slide), ou é grande ou um recurso que o tema não tem (estilo de
        diagrama, de gráfico, de circuito) e vai para o comum.typ. Também:
        componente do tema refeito à mão (uma "caixa" no lugar de emph-box),
        dicionário de argumentos espalhado (..mini). A leitura dos dados
        (csv(..) num #let) não conta.
    T6. Callouts e destaques (regra 9): #caution para limitação ou cuidado,
        #tip para atalho, #remark só para retomar, #note para o secundário
        ou o próximo passo, #example e #examples para exemplo curto; nenhum
        callout próprio. Destaque em item curto, em título ou em tópico.
        Travessão "—" no texto.
    T7. Figuras (regra 8): gráfico com lilaq lendo os dados (gráfico colado
        como imagem é achado, com a letra conferida no PNG); circuito só com
        zap; diagrama de blocos e fluxo do método com fletcher; desenhos com
        CeTZ; cores só colors.* (nada de rgb(), hexadecimal, luma() ou cor
        nomeada); eixos com grandeza e unidade.
    T8. Citações (regra 3): uma #bibliography só, no slide "Referências", com
        title: none e o estilo associacao-brasileira-de-normas-tecnicas;
        nenhuma citação crua ("@chave" visível no PNG); figura de terceiros
        com a fonte na legenda; foto de terceiros no slide "Créditos das
        imagens".
    T9. Estrutura e encerramento (regras 4 e 10): Partes (=) com nome de
        etapa do argumento; depois das Conclusões, Agradecimentos,
        Referências e #ending-slide[Obrigado!][Perguntas?][#info("contact")];
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
    ter errado: confirme cada achado no PDF e no texto do trabalho antes de
    mexer no deck.

    ## Material
    Achados consolidados (literais): [ACHADOS]
    Regras (literais): [REGRAS]
    Plano: [PLANO] · Sequência e tempo: [ESTRUTURA]
    Texto do trabalho: [TEXTO] · dados: [DADOS] · bibliografia: [BIB]
    Padrões do tema: [PADROES] · Circuitos: [ZAP]
    Fontes: [PASTA_DECK] e [COMUM] · pacote: [P] (deck.pdf, png/, texto/, mapa.tsv)
    Registro: [REGISTRO] · relatório desta rodada (você escreve): [RELATORIO]

    ## Passo 1: confirmar, sem editar nada
    Para cada achado:
    - reescreva-o com suas palavras;
    - reproduza com evidência sua, nova: número, ache-o você no texto e nos
      dados; gráfico, leia os dados; leitura, abra o PNG e conte palavras e
      itens no texto da página; layout, olhe a página e a linha da fonte,
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
    os dados; circuito vai para o zap; função do deck sai (componente do tema
    escrito no slide) ou vira proposta para o comum.typ. Não edite o texto do
    trabalho, os dados, o comum.typ nem o tema: escreva a proposta no
    relatório. Achado menor não se corrige agora: liste-o. Não mexa no que
    nenhum achado tocou.

    ## Passo 3: verificar cada correção
    Recompile (código 0, nenhum aviso), renderize as páginas afetadas e
    confira no PNG que o defeito sumiu: tentar não é corrigir. No fim, rode
    [VERIFICADOR] e monte o mapa página antiga -> página nova (dividir um
    slide desloca as seguintes).

    ## Retorno
    No relatório, por achado: veredito, evidência, mudança (arquivo.typ:linha),
    comando rodado, saída e páginas novas; depois as pendências ao autor, as
    propostas para o comum.typ, os menores adiados e o mapa antigo -> novo.
    Para mim, em até 15 linhas: Status (FEITO | FEITO_COM_RESSALVAS |
    PRECISA_DE_CONTEXTO | BLOQUEADO); confirmados / não confirmados /
    conflitos; a linha da compilação; o resultado do verificador; o caminho
    do relatório.
```

Antes da re-revisão, o orquestrador confere no relatório: comando, código 0, verificador sem bloqueio. Faltou: volta ao corretor. Depois monta o pacote `r<N+1>`.

## 10. Re-revisão com escopo

O revisor do achado (R1, R2 ou R3, com o material da seção 3) recebe os achados dele e o relatório do corretor. Modelo intermediário; achado de número do R1, o mais capaz. O R3 roda sempre, nas páginas alteradas, mesmo sem achados próprios.

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
    Regras (literais): [REGRAS]
    Achados sob verificação (literais): [ACHADOS]
    Relatório do corretor (vereditos, evidência, mudanças): [RELATORIO]
    Mapa página antiga -> nova: [MAPA_ANTIGO_NOVO]
    Pacote novo: [P] (e as fontes, o texto e os dados, se o seu papel os recebe)
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

- **Rodada 3 com achado aberto:** o orquestrador decide cada um: retirar (revisor errado, com a evidência), adiar (real, sem prejuízo à apresentação) ou levar ao autor. Decidir antes do teto, só para encerrar o laço, é pré-julgamento.
- **Bloqueio aberto** no teto: a apresentação não é entregue como pronta; vai ao autor como pendência.
- **O registro** (`[TMP]/revisao-<deck>/registro.md`) é o que sobrevive à compactação do contexto; confie nele, não na memória. Uma linha por evento:

```text
Rodada 1, revisão: R1 CORRIGIR (F1-F3), R2 CORRIGIR (L1-L4), R3 APROVADO
Rodada 1, corretor: 6 confirmados, 1 não confirmado (F2), 0 conflitos; páginas 18 -> 20; verificador sem bloqueio
Rodada 1, re-revisão: 6 resolvidos; F2 retirado; novo: T1 (p. 12)
Menor (adiado): L3 · p. 6 · "Contar a corrente acumula erro" · frase de 23 palavras
Pendência ao autor: a Tabela 4.2 dá 0,6% e o dados/soc.csv dá 0,7% (p. 41)
Decisão: <o que decidi>; <por quê>; <o que custa se eu estiver errado>
```

- **Na entrega** (SKILL.md, passo 6), o relatório ao autor traz: o último veredito de cada revisor, as decisões, as pendências, os menores adiados, as propostas para o `comum.typ` e as perguntas da banca sem resposta no deck.

## 12. Placeholders

| Placeholder | Conteúdo |
|---|---|
| `[DECK]`, `[TRABALHO]`, `[AREA]`, `[N]` | nome do deck; o tipo de trabalho ("um TCC", "uma dissertação"); a área; número da rodada |
| `[MODELO_MAIS_CAPAZ]`, `[MODELO_INTERMEDIARIO]`, `[MODELO]` | modelo do subagente, sempre explícito (seção 1) |
| `[REGRAS]` | a seção "Regras" do SKILL.md, colada literalmente |
| `[PLANO]` | o plano da apresentação aprovado (arquivo) |
| `[MENSAGEM_E_PUBLICO]` | só a mensagem central e o público do plano, colados (R2) |
| `[TEXTO]`, `[DADOS]`, `[BIB]`, `[PARECER]` | o texto do trabalho, a pasta dos dados, o `.bib`, o parecer da qualificação ("não houve") |
| `[ESTRUTURA]`, `[PADROES]`, `[ZAP]` | `references/estrutura.md`, `references/padroes-do-tema.md`, `references/zap.md` |
| `[PASTA_DECK]`, `[ENTRADA]`, `[RAIZ]`, `[COMUM]` | pasta do deck, arquivo de entrada, raiz do `--root` (a pasta do deck, a menos que ele leia arquivos de fora), `comum.typ` ("não há") |
| `[TMP]`, `[P]` | pasta temporária da sessão; pacote da rodada (`[TMP]/revisao-<deck>/r<N>`) |
| `[VERIFICADOR]` | o passo 4 do SKILL.md sobre o PDF recém-compilado: `python3 scripts/verificar_deck.py [PASTA_DECK] <deck.pdf> --minutos <N>` |
| `[ACHADOS]` | achados consolidados, literais |
| `[REGISTRO]`, `[RELATORIO]` | registro da revisão; relatório de correção da rodada |
| `[PAPEL]`, `[CHECKLIST]` | R1, R2 ou R3; a seção "Checklist" do prompt desse revisor |
| `[MAPA_ANTIGO_NOVO]`, `[PAGINAS_ALTERADAS]` | do relatório do corretor |
