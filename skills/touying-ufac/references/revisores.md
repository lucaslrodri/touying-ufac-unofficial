# Revisores

Três revisores independentes leem o deck em paralelo, depois do verificador mecânico. Um corretor confirma cada achado no PDF e só então corrige. A re-revisão olha só o que mudou. No máximo 3 rodadas. As regras do `SKILL.md` mandam em tudo, também nas correções que os revisores sugerem.

Esta página é o protocolo, o mesmo nos dois modos. O que cada revisor recebe, a tabela de gravidade e os prompts de R1, R2, R3 e do corretor estão na página do modo: `references/aula/revisores.md` ou `references/academico/revisores.md`. Cada prompt vai inteiro para um subagente, com os marcadores trocados pelos valores (seção 7 e a página do modo). Quem pediu o deck é o professor, na aula, e o autor do trabalho, no acadêmico.

## 1. Fluxo

```text
verificador sem bloqueio (SKILL.md, passo "Compilar e verificar")
  -> pacote de revisão r1 (seção 2)
  -> na MESMA mensagem, 3 subagentes: R1 conteúdo | R2 leitura | R3 tema e layout
  -> orquestrador junta os retornos, sem julgar, e grava no registro
       os 3 APROVADO -> entrega (passo "Entregar com evidência")
  -> corretor: confirma cada achado no PDF, corrige os confirmados, recompila, roda o verificador
  -> pacote r2 + re-revisão com escopo (seção 5):
       o revisor de cada achado aberto + R3 sempre, nas páginas alteradas
       tudo RESOLVIDO ou RETIRADO, nada novo de bloqueio ou importante -> entrega
       algo aberto -> nova rodada
  -> rodada 3 ainda aberta -> o orquestrador decide cada achado, registra e leva ao professor ou ao autor
```

- **Os revisores:** R1 é "conteúdo e contas" na aula e "fidelidade e conteúdo" no acadêmico; R2, leitura; R3, tema e layout.
- **Rodada** = um corretor + uma re-revisão. No máximo 3 por deck.
- **Os 3 rodam sempre**, também em deck curto e depois de correção pequena.
- **Paralelo:** as 3 chamadas de subagente na mesma resposta. Um só editor por vez: o corretor nunca roda junto com outro agente que edita.
- **Modelo explícito** em todo despacho: R1 e corretor no mais capaz disponível (uma conta errada na aula, ou um número diferente do texto no acadêmico, é o erro mais caro); R2, R3 e re-revisões num intermediário. Modelo omitido herda o da sessão.
- **Contexto construído, nunca herdado:** cada subagente recebe o prompt da página do modo e caminhos de arquivo. Nunca o histórico, o raciocínio ou o relatório de quem fez o deck, nem os achados de outro revisor.
- **Sem pré-julgamento:** nada de "não aponte X", "no máximo menor", "o plano escolheu", "é de propósito". Se quem fez o deck discorda, o corretor mostra a evidência e a re-revisão decide.
- **Papéis:** o orquestrador (a sessão principal) monta o pacote, despacha, junta, mantém o registro e decide no teto. Os revisores só leem. Só o corretor edita.
- **O corretor:** um só subagente por rodada, que não é revisor nem orquestrador. Rodadas 1 e 2: o mesmo corretor, se der para retomá-lo; senão, um novo com o registro. Rodada 3: um corretor novo, com a frase "Um corretor anterior tentou 2 vezes; agora é com você. Leia o registro." no início do prompt.
- **Antes da re-revisão,** o orquestrador confere no relatório do corretor: comando, código 0, verificador sem bloqueio. Faltou: volta ao corretor. Depois monta o pacote `r<N+1>`.

## 2. Pacote de revisão

Uma pasta por rodada, fora da pasta do curso ou do trabalho (na pasta temporária da sessão): `[TMP]/revisao-<deck>/r<N>/`. Os comandos abaixo montam a `r1`; nas rodadas seguintes, troque o `r1`. O registro fica em `[TMP]/revisao-<deck>/registro.md`.

| Arquivo | Conteúdo |
|---|---|
| `deck.pdf`, `compilacao.log` | compilação feita agora; a última linha do log é o código de saída |
| `png/p01.png`… | uma imagem por página, a 110 ppi (cerca de 1280 × 720, o tamanho de um projetor) |
| `texto/p01.txt`… | o texto de cada página (`pdftotext -layout`) |
| `mapa.tsv` | página, título do slide e `arquivo.typ:linha` (`?` na capa e no fim) |
| `verificador.txt` | a saída de `[VERIFICADOR]` sobre este `deck.pdf`: com `--modo`, e no acadêmico também com `--minutos` |
| `folha.png` | a folha de contato de `scripts/folha_de_contato.py` |

```sh
P=[TMP]/revisao-<deck>/r1; mkdir -p "$P/png" "$P/texto"
typst compile --root [RAIZ] [ENTRADA] "$P/deck.pdf" > "$P/compilacao.log" 2>&1; echo "código de saída: $?" >> "$P/compilacao.log"
typst compile --root [RAIZ] --ppi 110 [ENTRADA] "$P/png/p{0p}.png"
n=$(pdfinfo "$P/deck.pdf" | awk '/^Pages:/ {print $2}')
for i in $(seq 1 "$n"); do pdftotext -layout -f "$i" -l "$i" "$P/deck.pdf" "$P/texto/p$(printf "%0${#n}d" "$i").txt"; done
```

O mapa lê o título de cada página pela posição e pelo tamanho da letra e procura o `=` ou `==` igual nos `.typ` da pasta do deck e das subpastas dela. A página com "PARTE" é de uma Parte (`=`); as outras, de um slide (`==`). O rótulo que o tema põe no título de um exemplo ou de uma questão ("Exemplo 2.1 — ", "Questão 2.2 — ") sai antes da busca.

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
    titulo = re.sub(r"^(Exemplo|Questão) [\d.]+ — ", "", titulo)  # o rótulo de <example> e de <question>
    nivel = 1 if "PARTE" in (w for y, h, w in ws) else 2  # a página de uma Parte (=) ou de um slide (==)
    linha = next((loc for n, t, loc in heads if n == nivel and norm(titulo) and t == norm(titulo)), "?")
    print(p, titulo, linha, sep="\t")
EOF
```

O mesmo título em páginas seguidas é continuação, por `---` ou por transbordo; o R3 separa uma do outro.

## 3. Formato do retorno

Os 3 revisores devolvem o mesmo formato, para o corretor juntar e deduplicar. O prompt de cada um acrescenta as seções do papel dele.

```text
## Veredito: APROVADO | CORRIGIR
<n> bloqueios, <n> importantes, <n> menores

## Achados

### [C1] Importante · p. 14 · "Um triângulo feito de rampas" · slide-03.typ:335
- Regra: <regra N, regra Aula N ou regra Acadêmico N do SKILL.md, item do plano ou do checklist (ex.: "C5")>
- Evidência: <o que se vê, se mede, se calcula ou se lê no texto do trabalho; outra pessoa consegue refazer>
- Correção: <mudança concreta que respeita as regras>

## Verificações sem achado
- <o que foi conferido, onde e como; ex.: "p. 5 a 15: refiz as 7 contas; gráficos das p. 5, 6 e 11 em 3 pontos">

## Não pude verificar
- <o que ficou de fora, por quê, e o que o orquestrador deve conferir> (ou "nada")

## Deixei de julgar
- <o que vi e deixei de lado por ser papel de outro revisor ou estar fora do material, com o motivo> (ou "nada")
```

- **Prefixos:** `C` (conteúdo e contas, na aula) ou `F` (fidelidade e conteúdo, no acadêmico) para o R1; `L` (leitura) para o R2; `T` (tema e layout) para o R3. Numerados em sequência.
- **Regras pelo nome do SKILL.md:** "regra 3" é uma das regras comuns; "regra Aula 2" e "regra Acadêmico 4" são regras do modo.
- **Localização tripla:** página do `deck.pdf`, título do slide e `arquivo.typ:linha` (do mapa, com o caminho a partir da pasta do deck, como `figures/graphs/soc.typ:12`). A página sozinha não basta: dividir um slide desloca as seguintes.
- **Um achado por defeito.** O mesmo defeito com a mesma origem (uma função, um padrão repetido) é um achado só, com a lista de páginas.
- **Direto ao ponto:** começa pelo veredito, sem narrar o processo. `APROVADO` só sem bloqueio nem importante.
- **A correção nunca viola uma regra.** Não cabe: dividir em 2 ou mais slides, dizendo onde cortar e o título de cada um, ou, no acadêmico, levar à reserva; nunca diminuir a letra, o `inset` ou a margem, nem `scale`. Na aula, questão de marcar: a versão discursiva; pergunta solta: uma `<question>` com `#answer`, ou sai do slide. No acadêmico, número divergente: o valor do texto, com a página.
- **"Parece certo" não é verificação.** Cada linha de "Verificações sem achado" diz o que foi conferido e como.

## 4. Gravidade

A página do modo diz quando cada gravidade vale. Em todo deck:

| Gravidade | Na rodada? |
|---|---|
| **Bloqueio** | sim, primeiro |
| **Importante** | sim |
| **Menor** | não: vai para o registro e para o relatório ao professor ou ao autor |

- Violação de regra, das comuns ou do modo, nunca é menor.
- Justificativa de quem fez o deck (no código, no plano, no slide) nunca rebaixa a gravidade.
- Na dúvida entre duas, a mais alta, com a dúvida dita na evidência.

## 5. Re-revisão com escopo

O revisor do achado (R1, R2 ou R3, com o material que a página do modo lhe dá em "Quem recebe o quê") recebe os achados dele e o relatório do corretor. Modelo intermediário; achado de conta (aula) ou de número (acadêmico) do R1, o mais capaz. O R3 roda sempre, nas páginas alteradas, mesmo sem achados próprios.

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
    Pacote novo: [P]
    O resto do seu material, o mesmo da revisão original: [MATERIAL_DO_PAPEL]
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
    novo, no formato do retorno e com gravidade.

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

## 6. Teto, decisões e registro

- **Rodada 3 com achado aberto:** o orquestrador decide cada um: retirar (revisor errado, com a evidência), adiar (real, sem prejuízo à aula ou à apresentação) ou levar ao professor ou ao autor. Decidir antes do teto, só para encerrar o laço, é pré-julgamento.
- **Bloqueio aberto** no teto: o deck não é entregue como pronto; vai ao professor ou ao autor como pendência.
- **O registro** (`[TMP]/revisao-<deck>/registro.md`) é o que sobrevive à compactação do contexto; confie nele, não na memória. Uma linha por evento. No acadêmico, os achados do R1 são `F`, e o texto e os dados que divergem entre si viram "Pendência ao autor":

```text
Rodada 1, revisão: R1 CORRIGIR (C1-C3), R2 CORRIGIR (L1-L5), R3 APROVADO
Rodada 1, corretor: 7 confirmados, 1 não confirmado (C2), 0 conflitos; páginas 92 -> 95; verificador sem bloqueio
Rodada 1, re-revisão: 7 resolvidos; C2 retirado; novo: T1 (p. 41)
Menor (adiado): L4 · p. 20 · "Sistemas por toda parte" · frase de 24 palavras
Pendência ao autor: a Tabela 4.2 dá 0,6% e o data/soc.csv dá 0,7% (p. 41)
Decisão: <o que decidi>; <por quê>; <o que custa se eu estiver errado>
```

- **Na entrega** (SKILL.md, passo "Entregar com evidência"), o relatório traz o último veredito de cada revisor, as decisões e os menores adiados. Na aula, também as propostas ao professor para as funções do `header.typ` que vieram de outros decks e os candidatos a meme; no acadêmico, as pendências ao autor e as perguntas da banca sem resposta no deck.

## 7. Marcadores

Os marcadores que valem nos dois modos. Os de cada modo (a disciplina, o trabalho, o texto, os dados) estão na página do modo.

| Marcador | Conteúdo |
|---|---|
| `[DECK]`, `[N]` | nome do deck; número da rodada |
| `[MODELO_MAIS_CAPAZ]`, `[MODELO_INTERMEDIARIO]`, `[MODELO]` | modelo do subagente, sempre explícito (seção 1) |
| `[REGRAS]` | a seção "Regras comuns" do SKILL.md mais a seção das regras do modo ("Regras da aula" ou "Regras do acadêmico"), coladas literalmente |
| `[PLANO]` | o plano aprovado (arquivo): o plano de aula ou o plano da apresentação |
| `[PADROES]`, `[ZAP]` | `references/padroes-do-tema.md`, `references/zap.md` |
| `[PASTA_DECK]` | a pasta do deck, com o `header.typ`, `figures/` e `assets/` (no acadêmico, também `data/` e o `referencias.bib`) |
| `[ENTRADA]`, `[RAIZ]` | o caminho do arquivo de entrada (o `slide-NN.typ` na aula, o `deck.typ` no acadêmico); a raiz do `--root` (na aula, a pasta da disciplina, acima do deck; no acadêmico, a pasta do deck) |
| `[TMP]`, `[P]` | pasta temporária da sessão; pacote da rodada (`[TMP]/revisao-<deck>/r<N>`) |
| `[VERIFICADOR]` | o passo "Compilar e verificar" do SKILL.md sobre o PDF recém-compilado: na aula, `python3 scripts/verificar_deck.py --modo aula [PASTA_DECK] <deck.pdf>`; no acadêmico, `python3 scripts/verificar_deck.py --modo academico [PASTA_DECK] <deck.pdf> --minutos <N>` |
| `[ACHADOS]` | achados consolidados, literais |
| `[REGISTRO]`, `[RELATORIO]` | registro da revisão; relatório de correção da rodada |
| `[PAPEL]`, `[CHECKLIST]` | R1, R2 ou R3; a seção "Checklist" do prompt desse revisor |
| `[MATERIAL_DO_PAPEL]` | o que esse revisor recebe em "Quem recebe o quê", na página do modo, menos o pacote antigo |
| `[MAPA_ANTIGO_NOVO]`, `[PAGINAS_ALTERADAS]` | do relatório do corretor |
