#!/usr/bin/env python3
"""Verificador mecânico de um deck feito com o tema touying-ufac-unofficial, nos dois modos da skill touying-ufac.

Lê os .typ do deck, fora de comentários e de blocos de código, e o PDF compilado, e aponta o que fere as regras da
skill: as comuns e as do modo. Os .typ lidos são os do nível de cima da pasta do deck (os slides), o header.typ, os
de figures/ (em todas as subpastas) e, na aula, o common.typ da pasta da disciplina (a pasta acima da do deck). Só
biblioteca padrão; chama pdftotext, pdfinfo e typst.

Uso: python3 verificar_deck.py --modo {aula,academico} <pasta-do-deck> <deck.pdf> [--minutos N] [--json]

--modo é obrigatório, e o script nunca adivinha o modo (só avisa se ele não bate com o kind do config-info):
  aula       um deck de aula (kind "lecture"). A raiz da compilação é a pasta da disciplina, acima da do deck.
  academico  a apresentação de um trabalho (kind "tcc", "dissertation", "thesis", "coursework" ou "talk"); aceita
             também "acadêmico". A raiz da compilação é a própria pasta do deck. Só neste modo vale --minutos N,
             que confere o número de slides de conteúdo com o tempo.
--min-caracteres-funcao N (padrão: 50, umas três linhas): o corpo mínimo, em caracteres sem espaço, de uma função do header.typ, de
  figures/ ou do common.typ; uma função menor que isso, ou um apelido de função, sai como FUNCAO_PEQUENA.
"""
import argparse
import bisect
import collections
import html
import json
import os
import re
import shutil
import statistics
import subprocess
import sys
import tempfile
import unicodedata

GRAVIDADES = ("BLOQUEIO", "REVISAR", "AVISO")

AJUDA = """\
Modos: --modo aula ou --modo academico (ou acadêmico), obrigatório. As verificações sem modo marcado valem nos
dois; [aula] e [acadêmico] marcam as de um modo só.

Arquivos lidos, fora de comentários e de blocos de código: os .typ do nível de cima da pasta do deck (os slides),
o header.typ, figures/**/*.typ e, na aula, o ../common.typ da pasta da disciplina (ou o ../comum.typ, se só ele
existir). Os locais dos achados são relativos à pasta do deck: slide-01.typ:40, figures/graphs/soc.typ:12,
../common.typ:30.

Verificações: CÓDIGO (gravidade) e o que dispara.

Modo e pastas:
- MODO_E_KIND (AVISO): o --modo não bate com o kind do config-info ("lecture" é aula; "tcc", "dissertation",
  "thesis", "coursework" e "talk" são acadêmico).
- NOME_DO_COMMON (AVISO) [aula]: a pasta da disciplina tem comum.typ e não common.typ: renomeie.
- COMMON_NO_ACADEMICO (REVISAR) [acadêmico]: há common.typ ou comum.typ na pasta do deck, ou um .typ importa um
  deles. No acadêmico não há common.typ: as funções grandes vão para o header.typ.
- FIGURA_SEM_TIPO (AVISO): .typ direto em figures/, ou numa subpasta que não é graphs/, diagrams/, drawings/ ou
  circuits/.
- CAMINHO_FORA_DO_LUGAR (AVISO): image() fora de assets/; csv(), json(), read(), yaml(), toml() ou xml() fora de
  data/ ou assets/ (na aula, também o data/ da disciplina); na aula, common.typ dentro da pasta do deck.

Letra e espaço:
- LETRA_REDUZIDA (BLOQUEIO): text(size:) ou set text(size:) menor que 1em (ou que o corpo, em pt); scale() sobre
  texto; função com um parâmetro de tamanho menor que 1em usado em size:. REVISAR: scale() sobre uma figura ou num
  arquivo de figures/, e o que estiver no common.typ (passe o tamanho no uso ou proponha ao professor ajustá-lo).
- TRAVESSAO (BLOQUEIO; REVISAR no common.typ): "—" no texto, ou "---" no meio de uma linha (o Typst o troca
  por "—").
- COR_FORA_DO_TEMA (REVISAR): rgb(), luma(), cmyk() ou "#hexadecimal".
- ESPACO_APERTADO (REVISAR): set par(leading:), set page(margin:), set table(inset:) ou v(-..).

Funções (regra 3, explícito é melhor que implícito):
- FUNCAO_NO_DECK (REVISAR): função num arquivo de slide: #let f(..), let f = (..) =>, let f = g.with(..) ou apelido
  de função (#let a = b). O código vai no slide; função só se grande, no header.typ (ou no common.typ, na aula).
- FUNCAO_PEQUENA (AVISO): função do header.typ, de figures/ ou do common.typ com corpo de
  menos de --min-caracteres-funcao (50) caracteres sem espaço, g.with(..) curto ou apelido de função. Só informa: o
  agente não cria função pequena, e a do usuário fica.
- FUNCAO_USADA_UMA_VEZ (AVISO): função do header.typ ou de figures/ usada no máximo uma vez nos arquivos lidos.
- ARGUMENTOS_ESPALHADOS (REVISAR): dicionário de argumentos (ou um apelido dele) espalhado com ..nome.

Figuras (regra 4):
- FIGURA_NO_DECK (REVISAR): lq.diagram(, diagram( do fletcher, cetz.canvas( ou zap.circuit( num arquivo de slide:
  a figura vai para figures/<tipo>/<nome>.typ e entra no slide com include. AVISO, um só, com a contagem: chamadas,
  nos slides, de funções do header.typ ou do common.typ que montam figura (como grafico()).
- CIRCUITO_SEM_ZAP (REVISAR): resistor, capacitor ou indutor num cetz.canvas; arquivo de figures/circuits/
  desenhado sem o zap; sem import do zap, também uma função de desenho de circuito (des-circuito-rc()) ou image()
  de "circuito".
- GRAFICO_COMO_IMAGEM (AVISO): image() de um arquivo com nome de gráfico ("grafico", "plot", "chart", "curva",
  "resultado", "fig"): refaça com lilaq a partir dos dados, ou confira a letra no PNG.

Créditos e referências (regra 7):
- FONTE_NA_LEGENDA (REVISAR): caption: com "Fonte:", "Adaptado de", "Redesenhado", "Extraído", @chave ou cite();
  "Fonte:" no texto de um slide.
- CREDITO_DE_DESENHO (AVISO): "redesenhado", "adaptado de" ou "seguem as Figuras" em qualquer arquivo do deck:
  desenho próprio, ou refeito, não leva crédito.
- CREDITOS (AVISO): imagem raster em assets/ e nenhum slide "Créditos das imagens"; ou esse slide não é o último
  "==" antes do #ending-slide.
- REFERENCIA_NA_AULA (REVISAR) [aula]: bibliography(), cite() ou @x em que x não é rótulo do deck (@example-pulso,
  com <example-pulso> num título, não conta).
- CITACAO_NO_SLIDE (REVISAR) [acadêmico]: @x (x não é rótulo do deck) ou cite() fora do slide "Referências".
  Strings, e-mails e @preview/... não contam.
- REFERENCIAS [acadêmico]: REVISAR sem #bibliography, com mais de um, ou com ele fora do slide "Referências";
  BLOQUEIO sem full: true.

Slides:
- EXERCICIO_SEM_QUEBRA (REVISAR): slide <exercise> sem "---" antes do #answer.
- EXERCICIO_SEM_RESPOSTA (REVISAR): slide <exercise> sem #answer.
- EXEMPLO_SEM_SOLUCAO (AVISO): slide <example> sem #solution.
- QUESTAO_DE_MARCAR (BLOQUEIO) [aula]: "(A)" e "(B)" no mesmo slide, "verdadeiro ou falso", "assinale",
  "alternativa", opcoes(). "Qual destes", "votação" e numeração "(A)": REVISAR.
- PERGUNTA_FORA_DE_EXERCICIO (BLOQUEIO) [aula]: título "==" terminado em "?" sem <exercise> nem <example>.
- AQUECIMENTO (BLOQUEIO) [aula]: "aquecimento" num título.
- QUESTAO_EM_SLIDE_COMUM (REVISAR) [aula]: enunciado ("Calcule", "Esboce", "Escreva", "Pense"...) no começo de uma
  linha de um slide comum. Uma pergunta "?" no corpo dele: AVISO.
- ORGANIZACAO_POR_ENCONTRO (BLOQUEIO) [aula]: "Encontro N", "Aula N", "Próximo encontro", "Próxima aula", "Resumo do
  encontro", "(encontro", data dd/mm num título "=" ou "==", arquivo encontro-N.typ ou aula-N.typ.
- MENCAO_A_ENCONTRO (AVISO) [aula]: outra menção a "encontro" ou a "aula anterior".
- TITULO_GENERICO (REVISAR) [acadêmico]: título "==" que só nomeia a parte ou a peça ("Resultados", "Discussão",
  "Tabela 2", "Figura 3", "Gráfico"): o título de um resultado diz o achado.
- ENCERRAMENTO (REVISAR):
  [aula] "Obrigado", "Próxima" ou "A seguir" no ending-slide; deck sem "Fim!". Sem image() no ending-slide (o
  meme): AVISO.
  [acadêmico] deck sem #ending-slide; slide depois do encerramento sem #show: appendix antes dele. Encerramento
  sem contato (#info("contact")): AVISO.
- TEMPO (REVISAR) [acadêmico]: com --minutos N, mais de 1,2 × N slides de conteúdo; menos de 0,5 × N é AVISO. Slide
  de conteúdo: cada "==" e cada "---" entre a capa e o #ending-slide, a partir do arquivo principal e dos #include
  da pasta, menos Roteiro, Agradecimentos, Referências e Créditos das imagens. As seções "=", as pausas e a reserva
  (depois do encerramento) não contam.

No PDF, página a página. O rodapé (as linhas que se repetem em mais de 80% das páginas e o que fica abaixo
delas) não conta; o título (a faixa de cima) não conta como palavra.
- DENSIDADE: mais de --max-palavras (40) palavras de texto é REVISAR; mais de --bloqueio-palavras (60) é
  BLOQUEIO. Palavra é um token com 2 ou mais letras latinas: fórmulas e números não contam. As páginas "Créditos
  das imagens" e, no acadêmico, as de Referências não contam.
- LETRA_PEQUENA (REVISAR): texto com corpo (altura da caixa no pdftotext -bbox) abaixo de --limiar (0,8) do
  corpo do tema (--corpo, 22 pt). Uma linha por tamanho, com as páginas e os trechos. Não contam: a capa, as
  etiquetas #tag (0,6 do corpo, em maiúsculas), as legendas de figura (0,6 do corpo, pelo tema, se o deck tem
  caption:), o "PARTE N" das seções, os índices de texto colados ao símbolo, a matemática (𝑥, 𝜑, cos, Re) e o
  código (raw) dos .typ. O 0,8 pega os rótulos a 17 pt (0,77), como o "sem atrito" da linha de base.
- NUMEROS_PEQUENOS (AVISO): números soltos (eixos de gráfico, marcas) abaixo do limiar, numa linha só.
  Índices e limites da matemática (0,7 e 0,5 do corpo) não contam.
- TEXTO_NA_BORDA (REVISAR): texto a menos de --borda (12 pt) da borda lateral da página.
- REFERENCIAS_VAZIAS (BLOQUEIO) [acadêmico]: página "Referências" com menos de 3 palavras.

Compilação (com typst, a menos que se passe --sem-compilar). A raiz padrão é, na aula, a pasta acima da do deck
(a da disciplina) e, no acadêmico, a própria pasta do deck; --root troca.
- COMPILACAO (BLOQUEIO): o arquivo principal não compila com a raiz.
- PDF_DESATUALIZADO (BLOQUEIO): o PDF dado não bate com a compilação de agora (páginas ou texto).
- AVISO_DO_TYPST (AVISO): aviso do compilador; fonte desconhecida: REVISAR.

Código de saída: 0 sem bloqueio; 1 com bloqueio (ou com REVISAR, se --falhar-em revisar); 2 verificação
incompleta (ferramenta ausente, pasta sem .typ, PDF ilegível, argumentos errados ou sem --modo).

O que o script não vê fica com os revisores. Na aula: conteúdo fora do lugar, exemplo resolvido num slide comum,
contas. No acadêmico: número diferente do texto do trabalho, afirmação maior que o resultado, sigla sem definição.
Uma pergunta retórica no título de um slide comum da aula é bloqueio de propósito: troque por uma afirmação.

Exemplos.
Aula, na pasta da disciplina (o deck em slide-02/, compilado com a raiz na pasta da disciplina):
  python3 verificar_deck.py --modo aula slide-02 slide-02/slide-02.pdf
  python3 verificar_deck.py --modo aula slide-02 slide-02/slide-02.pdf --json > verificacao.json
  python3 verificar_deck.py --modo aula experimentos/x experimentos/x/deck.pdf --root ../.. --falhar-em revisar
Acadêmico, na pasta acima da apresentação (o deck em defesa/, compilado com a raiz nela):
  python3 verificar_deck.py --modo academico defesa defesa/deck.pdf --minutos 20
  python3 verificar_deck.py --modo academico defesa defesa/deck.pdf --minutos 20 --json > verificacao.json
"""


class Formatador(argparse.RawDescriptionHelpFormatter):
    def add_usage(self, usage, actions, groups, prefix=None):
        return super().add_usage(usage, actions, groups, "uso: " if prefix is None else prefix)


TRADUCOES = [
    (r"the following arguments are required: (.*)", r"faltam os argumentos: \1"),
    (r"unrecognized arguments: (.*)", r"argumentos desconhecidos: \1"),
    (r"argument (\S+): invalid (\w+) value: (.*)", r"argumento \1: valor inválido: \3"),
    (r"argument (\S+): invalid choice: (.*?) \(choose from (.*)\)", r"argumento \1: escolha inválida \2; use \3"),
    (r"argument (\S+): expected one argument", r"argumento \1: falta o valor"),
]


class Analisador(argparse.ArgumentParser):
    def error(self, message):
        for padrao, troca in TRADUCOES:
            message = re.sub(padrao, troca, message)
        self.print_usage(sys.stderr)
        print(f"verificar_deck.py: erro nos argumentos: {message}", file=sys.stderr)
        sys.exit(2)


class Incompleta(Exception):
    """A verificação não pôde ser feita (código de saída 2)."""


MODOS = {"aula": "aula", "academico": "academico", "acadêmico": "academico"}
NOME_DO_MODO = {"aula": "aula", "academico": "acadêmico"}
KINDS = {"lecture": "aula", "tcc": "academico", "dissertation": "academico", "thesis": "academico",
         "coursework": "academico", "talk": "academico"}
TIPOS_DE_FIGURA = ("graphs", "diagrams", "drawings", "circuits")
NOMES_DO_COMMON = ("common.typ", "comum.typ")
EXTENSOES_RASTER = (".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp", ".tif", ".tiff")


# ---------------------------------------------------------------------------------------------------------------
# Achados
# ---------------------------------------------------------------------------------------------------------------


class Achados:
    def __init__(self):
        self.lista = []

    def add(self, gravidade, codigo, onde, mensagem, trecho=""):
        assert gravidade in GRAVIDADES
        trecho = re.sub(r"\s+", " ", trecho).strip()
        if len(trecho) > 90:
            trecho = trecho[:87] + "..."
        self.lista.append(dict(gravidade=gravidade, codigo=codigo, onde=onde, mensagem=mensagem, trecho=trecho))

    def contagem(self):
        c = collections.Counter(a["gravidade"] for a in self.lista)
        return {g: c.get(g, 0) for g in GRAVIDADES}


def num(x, casas=2):
    """Número com vírgula decimal."""
    return f"{x:.{casas}f}".replace(".", ",")


# ---------------------------------------------------------------------------------------------------------------
# Fontes .typ: limpeza de comentários e de raw, linhas, chamadas
# ---------------------------------------------------------------------------------------------------------------


def apagar(segmento):
    """Troca tudo menos as quebras de linha por espaços (preserva posições e números de linha)."""
    return re.sub(r"[^\n]", " ", segmento)


def limpar(fonte, codigos=None):
    """Tira comentários (// e /* */) e blocos de código (`..`, ```..```), preservando as posições. O texto de cada
    bloco de código, sem espaços e sem a linguagem, vai para a lista `codigos`."""
    out = []
    i, n = 0, len(fonte)
    em_string = False
    while i < n:
        c = fonte[i]
        if em_string:
            if c == "\\" and i + 1 < n and fonte[i + 1] != "\n":
                out.append(fonte[i : i + 2])
                i += 2
                continue
            out.append(c)
            if c in '"\n':
                em_string = False
            i += 1
            continue
        if fonte.startswith("//", i) and not fonte[max(0, i - 6) : i].endswith(("http:", "https:")):
            j = fonte.find("\n", i)
            j = n if j < 0 else j
            out.append(" " * (j - i))
            i = j
            continue
        if fonte.startswith("/*", i):
            prof, j = 0, i
            while j < n:
                if fonte.startswith("/*", j):
                    prof += 1
                    j += 2
                elif fonte.startswith("*/", j):
                    prof -= 1
                    j += 2
                    if prof == 0:
                        break
                else:
                    j += 1
            out.append(apagar(fonte[i:j]))
            i = j
            continue
        if c == "`":
            k = len(re.match(r"`+", fonte[i:]).group())
            if k == 2:
                out.append("  ")
                i += 2
                continue
            fim = fonte.find("`" * k, i + k)
            fim = n if fim < 0 else fim + k
            if codigos is not None:
                corpo = fonte[i + k : fim - k]
                if k >= 3:
                    corpo = corpo.split("\n", 1)[1] if "\n" in corpo else ""  # tira a linguagem
                codigos.append(re.sub(r"\s+", "", corpo))
            out.append(apagar(fonte[i:fim]))
            i = fim
            continue
        if c == "\\" and i + 1 < n:
            out.append(fonte[i : i + 2])
            i += 2
            continue
        if c == '"':
            em_string = True
        out.append(c)
        i += 1
    return "".join(out)


RE_STRING = re.compile(r'"(?:[^"\\\n]|\\.)*"?')


def apagar_strings(texto):
    """O texto limpo com o conteúdo das strings apagado (as aspas ficam), para achar @chave fora de "@preview/..."."""
    return RE_STRING.sub(lambda m: '"' + apagar(m.group()[1:]), texto)


class Fonte:
    """Um .typ lido. `nome` é o caminho relativo à pasta do deck; `papel` é "slide" (os .typ do nível de cima),
    "header" (o header.typ), "figura" (figures/**) ou "common" (o common.typ da disciplina, na aula)."""

    def __init__(self, caminho, nome, papel):
        self.caminho = caminho
        self.nome = nome
        self.base = os.path.basename(caminho)
        self.papel = papel
        with open(caminho, encoding="utf-8", errors="replace") as f:
            self.bruto = f.read()
        codigos = []
        self.texto = limpar(self.bruto, codigos)
        self.sem_strings = apagar_strings(self.texto)
        self.codigo = "\x00".join(c for c in codigos if c)
        self.inicios = [0] + [m.end() for m in re.finditer("\n", self.texto)]
        self.linhas = self.texto.split("\n")
        self.linhas_brutas = self.bruto.split("\n")
        self.linhas_com_fonte = set()  # linhas já apontadas por FONTE_NA_LEGENDA

    def linha(self, pos):
        return bisect.bisect_right(self.inicios, pos)

    def onde(self, pos_ou_linha, eh_linha=False):
        ln = pos_ou_linha if eh_linha else self.linha(pos_ou_linha)
        return f"{self.nome}:{ln}"

    def trecho(self, ln):
        return self.linhas_brutas[ln - 1].strip() if 0 < ln <= len(self.linhas_brutas) else ""


def fechar(texto, i, abre="(", fecha=")"):
    """Com texto[i] == abre, devolve o índice logo depois do fecha correspondente."""
    prof, j, n, em_str = 0, i, len(texto), False
    while j < n:
        c = texto[j]
        if em_str:
            if c == "\\":
                j += 2
                continue
            if c in '"\n':
                em_str = False
        elif c == '"':
            em_str = True
        elif c == abre:
            prof += 1
        elif c == fecha:
            prof -= 1
            if prof == 0:
                return j + 1
        j += 1
    return n


RE_ELSE = re.compile(r"[ \t]*else\b")
RE_IGUAL = re.compile(r"[ \t]*=(?!=)")


def fim_da_expressao(texto, i, paradas="\n;"):
    """Fim de uma expressão que começa em texto[i]: o primeiro caractere de `paradas` fora de parênteses, colchetes,
    chaves e strings, ou o fecha de um parêntese de fora. Um "else" na linha seguinte continua a expressão."""
    prof, j, n, em_str = 0, i, len(texto), False
    while j < n:
        c = texto[j]
        if em_str:
            if c == "\\":
                j += 2
                continue
            if c in '"\n':
                em_str = False
        elif c == '"':
            em_str = True
        elif c in "([{":
            prof += 1
        elif c in ")]}":
            if prof == 0:
                return j
            prof -= 1
        elif prof == 0 and c in paradas:
            if c == "\n" and RE_ELSE.match(texto, j + 1):
                j += 1
                continue
            return j
        j += 1
    return n


def chamadas(texto, nome_regex):
    """Cada chamada `nome(..)[..]..`: (início, argumentos entre parênteses, blocos de conteúdo, fim)."""
    for m in re.finditer(r"(?<![\w.-])(?:" + nome_regex + r")(?=[(\[])", texto):
        j = m.end()
        args = ""
        if j < len(texto) and texto[j] == "(":
            k = fechar(texto, j)
            args = texto[j + 1 : k - 1]
            j = k
        blocos = []
        while j < len(texto) and texto[j] == "[":
            k = fechar(texto, j, "[", "]")
            blocos.append(texto[j + 1 : k - 1])
            j = k
        yield m.start(), args, blocos, j


def dividir_args(s):
    partes, prof, atual, em_str, i = [], 0, [], False, 0
    while i < len(s):
        c = s[i]
        if em_str:
            atual.append(c)
            if c == "\\" and i + 1 < len(s):
                atual.append(s[i + 1])
                i += 2
                continue
            if c == '"':
                em_str = False
        elif c == '"':
            em_str = True
            atual.append(c)
        elif c in "([{":
            prof += 1
            atual.append(c)
        elif c in ")]}":
            prof -= 1
            atual.append(c)
        elif c == "," and prof == 0:
            partes.append("".join(atual))
            atual = []
        else:
            atual.append(c)
        i += 1
    if "".join(atual).strip():
        partes.append("".join(atual))
    return [p.strip() for p in partes]


RE_TAMANHO = re.compile(r"^([0-9]*\.?[0-9]+)\s*(em|pt)$")


def tamanho_relativo(valor, corpo):
    m = RE_TAMANHO.match(valor.strip())
    if not m:
        return None
    v = float(m.group(1))
    return v if m.group(2) == "em" else v / corpo


RE_TITULO = re.compile(r"^[ \t]*(=+)[ \t]+(.*?)[ \t]*$")
RE_ROTULO = re.compile(r"<([\w:.-]+)>\s*$")
RE_TITULO_CREDITOS = re.compile(r"^cr[ée]ditos\b", re.I)
RE_TITULO_REFERENCIAS = re.compile(r"^(refer[êe]ncias|bibliografia|references)\b", re.I)
RE_ENCERRAMENTO = re.compile(r"(?<![\w.-])ending-slide\s*[(\[]")


class Slide:
    def __init__(self, fonte, nivel, titulo, rotulo, ini, fim):
        self.fonte, self.nivel, self.titulo, self.rotulo = fonte, nivel, titulo, rotulo
        self.ini, self.fim = ini, fim  # linhas (1-based), fim exclusivo

    @property
    def tipo(self):
        r = self.rotulo or ""
        if r == "exercise" or r.startswith("exercise-"):
            return "exercicio"
        if r == "example" or r.startswith("example-"):
            return "exemplo"
        return "comum"

    def linhas(self):
        return [(ln, self.fonte.linhas[ln - 1]) for ln in range(self.ini, self.fim)]

    def texto(self):
        return "\n".join(t for _, t in self.linhas())


def slides_da_fonte(fonte):
    """Divide o arquivo pelos títulos "=" e "==" (os "===" ficam dentro do slide)."""
    marcos = []
    for ln, t in enumerate(fonte.linhas, 1):
        m = RE_TITULO.match(t)
        if m and len(m.group(1)) <= 2:
            titulo = m.group(2)
            rot = RE_ROTULO.search(titulo)
            rotulo = rot.group(1) if rot else None
            if rot:
                titulo = titulo[: rot.start()].rstrip()
            marcos.append((ln, len(m.group(1)), titulo, rotulo))
    slides = []
    for k, (ln, nivel, titulo, rotulo) in enumerate(marcos):
        fim = marcos[k + 1][0] if k + 1 < len(marcos) else len(fonte.linhas) + 1
        slides.append(Slide(fonte, nivel, titulo, rotulo, ln, fim))
    return slides


def slide_da_linha(slides, ln):
    return next((s for s in slides if s.ini <= ln < s.fim), None)


def eh_slide_de(slides, ln, rx):
    s = slide_da_linha(slides, ln)
    return bool(s and rx.match(s.titulo.strip()))


# ---------------------------------------------------------------------------------------------------------------
# Leitura dos arquivos do deck
# ---------------------------------------------------------------------------------------------------------------


def ler_fontes(pasta, modo, ach):
    """Os .typ do deck: os do nível de cima (slides; o header.typ à parte), figures/** e, na aula, o common.typ da
    pasta da disciplina."""
    fontes = []
    for n in sorted(os.listdir(pasta)):
        caminho = os.path.join(pasta, n)
        if not n.endswith(".typ") or not os.path.isfile(caminho):
            continue
        papel = "slide"
        if n == "header.typ":
            papel = "header"
        elif n in NOMES_DO_COMMON:
            papel = "header"  # lido como as funções do próprio deck
            if modo == "academico":
                ach.add("REVISAR", "COMMON_NO_ACADEMICO", n,
                        f"{n} na pasta da apresentação: no acadêmico não há common.typ. As funções grandes vão "
                        "para o header.typ; o resto, escrito no slide.")
            else:
                ach.add("AVISO", "CAMINHO_FORA_DO_LUGAR", n,
                        f"{n} dentro da pasta do deck: o common.typ fica na pasta da disciplina, acima da do deck; "
                        "as funções grandes só deste deck vão para o header.typ.")
        fontes.append(Fonte(caminho, n, papel))
    figuras = os.path.join(pasta, "figures")
    if os.path.isdir(figuras):
        for raiz, dirs, arqs in os.walk(figuras):
            dirs.sort()
            for n in sorted(arqs):
                if n.endswith(".typ"):
                    caminho = os.path.join(raiz, n)
                    fontes.append(Fonte(caminho, os.path.relpath(caminho, pasta).replace(os.sep, "/"), "figura"))
    if modo == "aula":
        pai = os.path.dirname(pasta)
        common, comum = os.path.join(pai, "common.typ"), os.path.join(pai, "comum.typ")
        if os.path.isfile(common):
            fontes.append(Fonte(common, "../common.typ", "common"))
        elif os.path.isfile(comum):
            fontes.append(Fonte(comum, "../comum.typ", "common"))
            ach.add("AVISO", "NOME_DO_COMMON", "../comum.typ",
                    "A pasta da disciplina tem comum.typ: renomeie para common.typ, e troque os #import dele nos "
                    "decks e nas figuras.")
    return fontes


# ---------------------------------------------------------------------------------------------------------------
# Verificações comuns nos fontes
# ---------------------------------------------------------------------------------------------------------------


RE_DEF_FUNCAO = re.compile(r"(?<![\w.-])let\s+([A-Za-z_][\w-]*)\s*\(")


def verificar_letra(fonte, ach, corpo):
    t = fonte.texto
    no_common = fonte.papel == "common"
    grav = "REVISAR" if no_common else "BLOQUEIO"
    conselho = ("Função do common.typ: passe o tamanho no uso, ou proponha ao professor ajustá-la."
                if no_common else "Quebre o slide ou tire o conteúdo; nunca diminua a letra.")
    for ini, args, blocos, fim in chamadas(t, r"text"):
        partes = dividir_args(args)
        valor = None
        for p in partes:
            m = re.match(r"^size\s*:\s*(.+)$", p, re.S)
            if m:
                valor = m.group(1)
        if valor is None and partes and RE_TAMANHO.match(partes[0]):
            valor = partes[0]
        if valor is None:
            continue
        rel = tamanho_relativo(valor, corpo)
        if rel is not None and rel < 0.995:
            eh_set = t[max(0, ini - 4) : ini] == "set "
            forma = "set text(size: …)" if eh_set else "text(size: …)"
            ln = fonte.linha(ini)
            ach.add(grav, "LETRA_REDUZIDA", fonte.onde(ln, True),
                    f"{forma} reduz a letra a {num(rel)} do corpo. {conselho}", fonte.trecho(ln))
    for ini, args, blocos, fim in chamadas(t, r"scale"):
        corpo_scale = args + " ".join(blocos)
        ln = fonte.linha(ini)
        figura = re.search(r"image\(|canvas|diagram|circuit|grafico|lq\.|plot|fig-|des-", corpo_scale)
        if figura or fonte.papel in ("figura", "common"):
            ach.add("REVISAR", "LETRA_REDUZIDA", fonte.onde(ln, True),
                    "scale() sobre uma figura: os rótulos e números diminuem junto. Dê o tamanho na figura.",
                    fonte.trecho(ln))
        else:
            ach.add("BLOQUEIO", "LETRA_REDUZIDA", fonte.onde(ln, True),
                    "scale() sobre texto diminui a letra. Quebre o slide.", fonte.trecho(ln))
    # função com um parâmetro de tamanho menor que 1em, usado em size: (lista-creditos(tamanho: .6em))
    for m in RE_DEF_FUNCAO.finditer(t):
        abre = m.end() - 1
        k = fechar(t, abre)
        igual = RE_IGUAL.match(t, k)
        if not igual:
            continue
        ini_corpo = igual.end()
        corpo_f = t[ini_corpo : fim_da_expressao(t, ini_corpo)]
        for p in dividir_args(t[abre + 1 : k - 1]):
            pm = re.match(r"^([A-Za-z_][\w-]*)\s*:\s*(.+)$", p, re.S)
            if not pm:
                continue
            rel = tamanho_relativo(pm.group(2), corpo)
            if rel is not None and rel < 0.995 and re.search(
                    r"(?<![\w-])size\s*:\s*" + re.escape(pm.group(1)) + r"(?![\w-])", corpo_f):
                ln = fonte.linha(m.start())
                ach.add(grav, "LETRA_REDUZIDA", fonte.onde(ln, True),
                        f"{m.group(1)}() reduz a letra: o parâmetro {pm.group(1)} vale {pm.group(2).strip()} por "
                        f"padrão e vai para size:. {conselho}", fonte.trecho(ln))


def verificar_travessao(fonte, ach):
    grav = "REVISAR" if fonte.papel == "common" else "BLOQUEIO"
    extra = " No common.typ: proponha ao professor." if fonte.papel == "common" else ""
    for ln, linha in enumerate(fonte.linhas, 1):
        if "—" in linha:
            ach.add(grav, "TRAVESSAO", fonte.onde(ln, True),
                    "Travessão no texto: o tema pode quebrar a página nele. Use dois-pontos, vírgula ou "
                    "parênteses." + extra, fonte.trecho(ln))
        elif linha.strip() != "---" and re.search(r"(?<![-\w])---(?![-\w])", linha):
            ach.add(grav, "TRAVESSAO", fonte.onde(ln, True),
                    '"---" no meio da linha vira travessão. Só use "---" sozinho na linha, para quebrar a página.'
                    + extra, fonte.trecho(ln))


RE_COR = re.compile(r'(?<![\w.-])(rgb|luma|cmyk)\s*\(|"#[0-9A-Fa-f]{3,8}"')


def verificar_cores(fonte, ach):
    for ln, linha in enumerate(fonte.linhas, 1):
        m = RE_COR.search(linha)
        if m:
            ach.add("REVISAR", "COR_FORA_DO_TEMA", fonte.onde(ln, True),
                    "Cor fixa: use só as do tema (colors.primary, colors.secondary-dark, ...).", fonte.trecho(ln))


RE_APERTO = [
    (re.compile(r"set\s+par\s*\([^)]*leading\s*:"), "set par(leading: …)"),
    (re.compile(r"set\s+page\s*\([^)]*margin\s*:"), "set page(margin: …)"),
    (re.compile(r"set\s+table\s*\([^)]*inset\s*:"), "set table(inset: …)"),
    (re.compile(r"(?<![\w.-])v\(\s*-\s*[\d.]+\s*(em|pt|cm|mm|%)"), "v(-…)"),
]


def verificar_aperto(fonte, ach):
    for ln, linha in enumerate(fonte.linhas, 1):
        for rx, nome in RE_APERTO:
            if rx.search(linha):
                ach.add("REVISAR", "ESPACO_APERTADO", fonte.onde(ln, True),
                        f"{nome}: espaço apertado para caber. Quebre o slide.", fonte.trecho(ln))
                break


RE_IMAGEM_GRAFICO = re.compile(r'image\(\s*"([^"]*(?:grafico|gráfico|plot|chart|curva|resultado|fig)[^"]*)"', re.I)


def verificar_graficos(fonte, ach):
    for m in RE_IMAGEM_GRAFICO.finditer(fonte.texto):
        ln = fonte.linha(m.start())
        ach.add("AVISO", "GRAFICO_COMO_IMAGEM", fonte.onde(ln, True),
                f'image("{m.group(1)}") parece um gráfico exportado: refaça com lilaq a partir dos dados, ou '
                "confira no PNG que os números e os rótulos ficam no tamanho do corpo.", fonte.trecho(ln))


RE_LEITURA = r"image|csv|json|read|yaml|toml|xml"
RE_NOME_CHAMADA = re.compile(r"[\w-]+")


def verificar_caminhos(fonte, ach, pasta, raiz, modo):
    """image() fora de assets/; csv(), json(), read() (e yaml, toml, xml) fora de data/ ou assets/."""
    pai = os.path.dirname(pasta)
    lugares_imagem = [os.path.join(pasta, "assets")] + ([os.path.join(pai, "assets")] if modo == "aula" else [])
    lugares_dados = [os.path.join(pasta, "data"), os.path.join(pasta, "assets")] + (
        [os.path.join(pai, "data")] if modo == "aula" else [])
    for ini, args, blocos, fim in chamadas(fonte.texto, RE_LEITURA):
        funcao = RE_NOME_CHAMADA.match(fonte.texto, ini).group()
        m = re.match(r'\s*"((?:[^"\\\n]|\\.)*)"', args)
        if not m or not m.group(1) or "://" in m.group(1):
            continue  # caminho calculado, vazio ou URL
        caminho = m.group(1)
        if caminho.startswith("/"):
            absoluto = os.path.normpath(os.path.join(raiz, caminho.lstrip("/")))
        else:
            absoluto = os.path.normpath(os.path.join(os.path.dirname(fonte.caminho), caminho))
        lugares = lugares_imagem if funcao == "image" else lugares_dados
        if any(absoluto == l or absoluto.startswith(l + os.sep) for l in lugares):
            continue
        ln = fonte.linha(ini)
        if funcao == "image":
            msg = (f'image("{caminho}") fora de assets/: as imagens prontas (fotos, capturas, o meme) ficam em '
                   "assets/, e uma figura feita em Typst, em figures/<tipo>/.")
        else:
            msg = (f'{funcao}("{caminho}") fora de data/ ou assets/: os dados (CSV e JSON) ficam em data/'
                   + (", ao lado do deck ou na pasta da disciplina." if modo == "aula" else "."))
        ach.add("AVISO", "CAMINHO_FORA_DO_LUGAR", fonte.onde(ln, True), msg, fonte.trecho(ln))


def verificar_tipos_de_figura(fontes, ach):
    for f in fontes:
        if f.papel != "figura":
            continue
        partes = f.nome.split("/")
        if len(partes) == 2:
            ach.add("AVISO", "FIGURA_SEM_TIPO", f.nome,
                    "Figura direto em figures/: ponha-a na subpasta do tipo, figures/graphs/ (lilaq), diagrams/ "
                    "(fletcher), drawings/ (CeTZ) ou circuits/ (zap).")
        elif partes[1] not in TIPOS_DE_FIGURA:
            ach.add("AVISO", "FIGURA_SEM_TIPO", f.nome,
                    f"figures/{partes[1]}/ não é um tipo de figura: use graphs/ (lilaq), diagrams/ (fletcher), "
                    "drawings/ (CeTZ) ou circuits/ (zap).")


# ---------------------------------------------------------------------------------------------------------------
# Rótulos, citações e créditos
# ---------------------------------------------------------------------------------------------------------------


RE_ROTULO_DEF = re.compile(r"<([\w][\w:.-]*)>")
RE_REF = re.compile(r"(?<![\w.@/\\-])@([\w][\w:.-]*)")


def rotulos_do_deck(fontes):
    """Os rótulos definidos no deck: <nome> depois de um título, de uma equação ou de uma figura. Um <nome> logo
    depois de "(", ",", ":" ou "=" é um valor (cite(<x>), name: <x>, edge(<a>, <b>)), não uma definição."""
    rotulos = set()
    for f in fontes:
        for m in RE_ROTULO_DEF.finditer(f.texto):
            antes = f.texto[max(0, m.start() - 40) : m.start()].rstrip()
            if not antes.endswith(("(", ",", ":", "=")):
                rotulos.add(m.group(1))
    return rotulos


def referencias(fonte, rotulos):
    """Cada @chave fora de strings que não é rótulo do deck: (posição, chave). E-mails e @preview/... não
    contam."""
    t = fonte.sem_strings
    for m in RE_REF.finditer(t):
        if t[m.end() : m.end() + 1] == "/":
            continue  # @preview/pacote
        chave = m.group(1).rstrip(".:")
        if chave and chave not in rotulos:
            yield m.start(), chave


RE_CREDITO_NA_LEGENDA = re.compile(
    r"(?i:\bfonte\s*:)|\bFonte\s+(?:própria|d[oa]s?\s+autor)|(?i:\badaptad[oa]s?\s+d[eoa]s?\b)|(?i:\bredesenhad)"
    r"|\bExtra[íi]d[oa]")


def verificar_legendas(fonte, ach, rotulos, slides):
    """FONTE_NA_LEGENDA: crédito, @chave ou cite() no caption:; "Fonte:" no texto de um slide."""
    t = fonte.texto
    refs = list(referencias(fonte, rotulos))
    for m in re.finditer(r"(?<![\w-])caption\s*:\s*", t):
        fim = fim_da_expressao(t, m.end(), paradas=",")
        valor = t[m.end() : fim]
        sem = fonte.sem_strings[m.end() : fim]
        motivo = None
        c = RE_CREDITO_NA_LEGENDA.search(valor)
        if c:
            motivo = f'"{c.group(0).strip()}"'
        elif re.search(r"(?<![\w.-])cite\s*\(", sem):
            motivo = "cite()"
        else:
            r = next((ch for p, ch in refs if m.end() <= p < fim), None)
            if r:
                motivo = f"@{r}"
        if motivo:
            ln = fonte.linha(m.start())
            fonte.linhas_com_fonte.add(ln)
            ach.add("REVISAR", "FONTE_NA_LEGENDA", fonte.onde(ln, True),
                    f"{motivo} na legenda: sem fonte na legenda. Crédito só de imagem tirada inteira de fora, no "
                    'slide "Créditos das imagens", no fim; desenho próprio ou refeito não leva crédito.',
                    fonte.trecho(ln))
    if fonte.papel != "slide":
        return
    for ln, linha in enumerate(fonte.linhas, 1):
        if ln in fonte.linhas_com_fonte or not re.search(r"\bFonte\s*:", linha):
            continue
        if eh_slide_de(slides, ln, RE_TITULO_CREDITOS):
            continue
        fonte.linhas_com_fonte.add(ln)
        ach.add("REVISAR", "FONTE_NA_LEGENDA", fonte.onde(ln, True),
                '"Fonte:" no slide: crédito só de imagem tirada inteira de fora, no slide "Créditos das imagens", '
                "no fim.", fonte.trecho(ln))


RE_CREDITO_DE_DESENHO = re.compile(
    r"\bredesenhad\w*|\badaptad[oa]s?\s+d[eoa]s?\b|\bseguem?\s+as?\s+figuras?\b", re.I)


def verificar_credito_de_desenho(fonte, ach):
    for ln, linha in enumerate(fonte.linhas, 1):
        if ln in fonte.linhas_com_fonte:
            continue
        m = RE_CREDITO_DE_DESENHO.search(linha)
        if m:
            ach.add("AVISO", "CREDITO_DE_DESENHO", fonte.onde(ln, True),
                    f'"{m.group(0)}": desenho do autor, ou refeito a partir de outro trabalho, não leva crédito. '
                    "Crédito só de imagem tirada inteira de fora (foto, captura, capa, meme).", fonte.trecho(ln))


def imagens_raster(pasta):
    assets = os.path.join(pasta, "assets")
    achadas = []
    if os.path.isdir(assets):
        for raiz, dirs, arqs in os.walk(assets):
            dirs.sort()
            for n in sorted(arqs):
                if n.lower().endswith(EXTENSOES_RASTER):
                    achadas.append(os.path.relpath(os.path.join(raiz, n), pasta).replace(os.sep, "/"))
    return achadas


def verificar_creditos(pasta, linhas, ach):
    """CREDITOS: imagem raster em assets/ sem slide "Créditos das imagens"; o slide de créditos não é o último "=="
    antes do #ending-slide."""
    titulos, fim, creditos_depois = [], None, None
    for f, ln, t in linhas:
        m = RE_TITULO.match(t)
        titulo = RE_ROTULO.sub("", m.group(2)).strip() if m else ""
        if fim is None and RE_ENCERRAMENTO.search(t):
            fim = (f, ln)
        elif m and len(m.group(1)) == 2:
            if fim is None:
                titulos.append((f, ln, titulo))
            elif creditos_depois is None and RE_TITULO_CREDITOS.match(titulo):
                creditos_depois = (f, ln)
    creditos = [x for x in titulos if RE_TITULO_CREDITOS.match(x[2])]
    if creditos:
        f, ln, _ = creditos[-1]
        if fim is not None and titulos[-1] is not creditos[-1]:
            ultimo = titulos[-1]
            ach.add("AVISO", "CREDITOS", f.onde(ln, True),
                    f'O slide de créditos não é o último antes do encerramento: depois dele vem "{ultimo[2]}" '
                    f"({ultimo[0].onde(ultimo[1], True)}). Os créditos das imagens ficam no fim, logo antes do "
                    "#ending-slide.", f.trecho(ln))
        return
    if creditos_depois:
        f, ln = creditos_depois
        ach.add("AVISO", "CREDITOS", f.onde(ln, True),
                'O slide "Créditos das imagens" vem depois do #ending-slide: ponha-o logo antes do encerramento.',
                f.trecho(ln))
        return
    rasters = imagens_raster(pasta)
    if rasters:
        lista = ", ".join(rasters[:6]) + (f" e mais {len(rasters) - 6}" if len(rasters) > 6 else "")
        ach.add("AVISO", "CREDITOS", "deck",
                f'Imagens em assets/ ({lista}) e nenhum slide "Créditos das imagens". Toda imagem tirada inteira de '
                "fora (foto, captura, capa, meme) tem crédito nesse slide, no fim, antes do #ending-slide.")


# ---------------------------------------------------------------------------------------------------------------
# Funções, figuras e circuitos
# ---------------------------------------------------------------------------------------------------------------


NOME = r"[A-Za-z_][\w-]*"
RE_DEF_LAMBDA = re.compile(r"(?<![\w.-])let\s+(" + NOME + r")\s*=\s*(\([^()]*\)|" + NOME + r")\s*=>")
RE_DEF_WITH = re.compile(r"(?<![\w.-])let\s+(" + NOME + r")\s*=\s*(" + NOME + r"(?:\." + NOME + r")*)\.with\s*\(")
RE_DEF_APELIDO = re.compile(
    r"(?<![\w.-])let\s+(" + NOME + r")\s*=\s*(" + NOME + r"(?:\." + NOME + r")*)(?=[ \t]*(?:\n|;|$))")
RE_DICIONARIO = re.compile(r"(?<![\w.-])let\s+(" + NOME + r")\s*=\s*\(\s*" + NOME + r"\s*:")
MODULOS = {"lq", "lilaq", "cetz", "fletcher", "zap", "math", "calc", "tiptoe", "zero", "deck", "std"}
FIGURAS_NO_SLIDE = [
    (re.compile(r"(?<![\w.-])(?:lq|lilaq)\.diagram\s*\("), "lq.diagram(", "graphs"),
    (re.compile(r"(?<![\w.-])(?:fletcher\.)?diagram\s*\("), "diagram( do fletcher", "diagrams"),
    (re.compile(r"(?<![\w.-])(?:cetz\.)?canvas\s*\("), "cetz.canvas(", "drawings"),
    (re.compile(r"(?<![\w.-])(?:zap\.)?circuit\s*\("), "zap.circuit(", "circuits"),
]


class Definicao:
    """Um #let achado pelo regex `m` (o grupo 1 é o nome): função, apelido ou dicionário."""

    def __init__(self, m, fonte, tipo, corpo, alvo=None):
        self.nome, self.pos, self.pos_nome = m.group(1), m.start(), m.start(1)
        self.fonte, self.tipo, self.corpo, self.alvo = fonte, tipo, corpo, alvo
        self.ln = fonte.linha(self.pos)
        inicio_da_linha = fonte.texto.rfind("\n", 0, self.pos) + 1
        self.topo = bool(re.fullmatch(r"[ \t]*#", fonte.texto[inicio_da_linha : self.pos]))  # #let no nível de cima
        self.tamanho = len(re.sub(r"\s+", "", corpo))


def definicoes(fonte):
    """As funções (#let f(..) =, let f = (..) =>, let f = g.with(..)), os apelidos (#let a = b) e os dicionários
    (#let d = (k: ..)) de um arquivo."""
    t = fonte.texto
    funcoes, apelidos, dicionarios = [], [], []
    for m in RE_DEF_FUNCAO.finditer(t):
        k = fechar(t, m.end() - 1)
        igual = RE_IGUAL.match(t, k)
        if igual:
            ini = igual.end()
            funcoes.append(Definicao(m, fonte, "funcao", t[ini : fim_da_expressao(t, ini)]))
    lambdas = set()
    for m in RE_DEF_LAMBDA.finditer(t):
        lambdas.add(m.start())
        ini = m.end()
        funcoes.append(Definicao(m, fonte, "lambda", t[ini : fim_da_expressao(t, ini)]))
    for m in RE_DEF_WITH.finditer(t):
        ini = m.start(2)
        funcoes.append(Definicao(m, fonte, "with", t[ini : fim_da_expressao(t, ini)], alvo=m.group(2)))
    for m in RE_DEF_APELIDO.finditer(t):
        apelidos.append(Definicao(m, fonte, "apelido", m.group(2), alvo=m.group(2)))
    for m in RE_DICIONARIO.finditer(t):
        if m.start() not in lambdas:
            dicionarios.append(Definicao(m, fonte, "dicionario", ""))
    funcoes.sort(key=lambda d: d.pos)
    return funcoes, apelidos, dicionarios


RE_IMPORT = re.compile(r"[ \t]*#?import\b")


def usos(nome, fontes, excluir=None):
    """Onde o nome aparece nos arquivos (chamada, valor ou ..nome), fora das linhas de #import e da própria
    definição: [(fonte, posição)]. Um "x.nome" (campo de outro objeto) não conta."""
    rx = re.compile(r"(?<![\w-])" + re.escape(nome) + r"(?![\w-])")
    achados = []
    for f in fontes:
        t = f.sem_strings
        for m in rx.finditer(t):
            p = m.start()
            if excluir and (f, p) == excluir:
                continue
            if p >= 1 and t[p - 1] == "." and not (p >= 2 and t[p - 2] == "."):
                continue
            if RE_IMPORT.match(t, t.rfind("\n", 0, p) + 1):
                continue
            achados.append((f, p))
    return achados


def verificar_funcoes(fontes, ach, min_caracteres, modo):
    """FUNCAO_NO_DECK, FUNCAO_PEQUENA, FUNCAO_USADA_UMA_VEZ, ARGUMENTOS_ESPALHADOS e o AVISO de FIGURA_NO_DECK das
    funções do header.typ e do common.typ que montam figura."""
    funcoes, apelidos, dicionarios = [], [], []
    for f in fontes:
        fu, ap, di = definicoes(f)
        funcoes += fu
        apelidos += ap
        dicionarios += di
    nomes_de_funcao = {d.nome for d in funcoes}
    # apelido de função: o alvo é uma função dos arquivos lidos ou de um pacote (lq.plot)
    apelidos_de_funcao = []
    for a in apelidos:
        raiz = a.alvo.split(".")[0]
        if a.alvo in nomes_de_funcao or ("." in a.alvo and raiz in MODULOS):
            apelidos_de_funcao.append(a)
    nomes_de_funcao |= {a.nome for a in apelidos_de_funcao}
    onde_vai = "no header.typ"
    if modo == "aula":
        onde_vai += " (ou no common.typ da disciplina, se vários decks a usam)"

    # FUNCAO_NO_DECK: qualquer função ou apelido de função num arquivo de slide
    for d in sorted(funcoes + apelidos_de_funcao, key=lambda d: (d.fonte.nome, d.pos)):
        if d.fonte.papel != "slide":
            continue
        forma = {"funcao": f"{d.nome}(..)", "lambda": f"{d.nome} = (..) =>", "with": f"{d.nome} = {d.alvo}.with(..)",
                 "apelido": f"{d.nome} = {d.alvo}"}[d.tipo]
        ach.add("REVISAR", "FUNCAO_NO_DECK", d.fonte.onde(d.ln, True),
                f"Função definida no arquivo do slide ({forma}). Escreva o código no próprio slide, com os "
                f"componentes do tema; função só se o código é grande, e {onde_vai}.", d.fonte.trecho(d.ln))

    # FUNCAO_PEQUENA: função curta, g.with(..) curto ou apelido de função no header, nas figuras ou no common
    for d in sorted(funcoes + apelidos_de_funcao, key=lambda d: (d.fonte.nome, d.pos)):
        if d.fonte.papel == "slide" or not d.topo:
            continue
        no_common = d.fonte.papel == "common"
        grav = "AVISO"
        extra = " No common.typ: é da disciplina, fica." if no_common else ""
        if d.tipo == "apelido":
            msg = f"Apelido de função ({d.nome} = {d.alvo}): use {d.alvo} direto."
        elif d.tipo == "with":
            if d.tamanho >= min_caracteres:
                continue
            msg = (f"{d.nome} = {d.alvo}.with(..) muda pouco o {d.alvo}: escreva os argumentos no uso.")
        else:
            if d.tamanho >= min_caracteres:
                continue
            msg = (f"Função {d.nome} com {d.tamanho} caracteres no corpo (menos de {min_caracteres}): função curta "
                   "esconde o que o slide faz. Se foi o agente quem a criou, escreva o código onde é usado; se é do "
                   "usuário, fica.")
        ach.add(grav, "FUNCAO_PEQUENA", d.fonte.onde(d.ln, True), msg + extra, d.fonte.trecho(d.ln))

    # FUNCAO_USADA_UMA_VEZ: função do header ou de figura usada no máximo uma vez
    for d in sorted(funcoes + apelidos_de_funcao, key=lambda d: (d.fonte.nome, d.pos)):
        if d.fonte.papel not in ("header", "figura") or not d.topo:
            continue
        k = len(usos(d.nome, fontes, excluir=(d.fonte, d.pos_nome)))
        if k <= 1:
            quanto = "não é usada" if k == 0 else "é usada uma vez só"
            monta_figura = any(rx.search(d.corpo) for rx, _, _ in FIGURAS_NO_SLIDE)
            dica = ("a figura vai direto no arquivo dela, sem função, e entra no slide com include"
                    if monta_figura else "escreva o código onde é usado")
            ach.add("AVISO", "FUNCAO_USADA_UMA_VEZ", d.fonte.onde(d.ln, True),
                    f"A função {d.nome} {quanto}: {dica}.", d.fonte.trecho(d.ln))

    # ARGUMENTOS_ESPALHADOS: dicionário (ou apelido de dicionário) espalhado com ..nome
    nomes_dic = {d.nome for d in dicionarios}
    mudou = True
    while mudou:
        mudou = False
        for a in apelidos:
            if a.alvo in nomes_dic and a.nome not in nomes_dic:
                dicionarios.append(a)
                nomes_dic.add(a.nome)
                mudou = True
    por_nome = collections.defaultdict(list)
    for d in dicionarios:
        por_nome[d.nome].append(d)
    for nome, lugares in por_nome.items():
        espalhados = [(f, p) for f in fontes
                      for p in (m.start() for m in re.finditer(r"(?<![\w-])\.\." + re.escape(nome) + r"(?![\w-])",
                                                               f.texto))]
        if espalhados:
            d = lugares[0]
            onde = ", ".join(x.fonte.onde(x.ln, True) for x in lugares[:6]) + (" ..." if len(lugares) > 6 else "")
            usos_em = ", ".join(sorted({f.onde(p) for f, p in espalhados})[:4])
            usos_em += " ..." if len(espalhados) > 4 else ""
            ach.add("REVISAR", "ARGUMENTOS_ESPALHADOS", onde,
                    f"Dicionário de argumentos {nome} definido {len(lugares)}x e espalhado {len(espalhados)}x com "
                    f"..{nome} ({usos_em}). Escreva os argumentos no próprio uso.", d.fonte.trecho(d.ln))

    # FIGURA_NO_DECK (AVISO): chamadas, nos slides, de funções do header ou do common que montam figura
    candidatas = [d for d in funcoes if d.fonte.papel in ("header", "common")]
    montam = {d.nome for d in candidatas if any(rx.search(d.corpo) for rx, _, _ in FIGURAS_NO_SLIDE)}
    mudou = True
    while mudou:
        mudou = False
        for d in candidatas:
            if d.nome not in montam and any(re.search(r"(?<![\w.-])" + re.escape(n) + r"\s*\(", d.corpo)
                                            for n in montam):
                montam.add(d.nome)
                mudou = True
    for a in apelidos_de_funcao:
        if a.fonte.papel in ("header", "common") and a.alvo in montam:
            montam.add(a.nome)
    slides = [f for f in fontes if f.papel == "slide"]
    contagem, primeiras = collections.Counter(), []
    for n in sorted(montam):
        rx = re.compile(r"(?<![\w.-])" + re.escape(n) + r"\s*\(")
        for f in slides:
            for m in rx.finditer(f.texto):
                contagem[n] += 1
                primeiras.append((f.nome, f.linha(m.start()), f))
    if contagem:
        primeiras.sort(key=lambda x: (x[0], x[1]))
        onde = ", ".join(f"{n}:{ln}" for n, ln, _ in primeiras[:5]) + (" ..." if len(primeiras) > 5 else "")
        lista = ", ".join(f"{n} {k}x" for n, k in contagem.most_common())
        ach.add("AVISO", "FIGURA_NO_DECK", onde,
                f"{sum(contagem.values())} chamadas, nos slides, de funções do header.typ ou do common.typ que "
                f"montam figura ({lista}). Cada figura vai para um arquivo em figures/<tipo>/<nome>.typ e entra no "
                "slide com include.")


def verificar_figuras_no_slide(fonte, ach):
    """FIGURA_NO_DECK: lq.diagram(, diagram( do fletcher, cetz.canvas( ou zap.circuit( escrito no arquivo do slide."""
    vistas = set()
    for rx, nome, tipo in FIGURAS_NO_SLIDE:
        for m in rx.finditer(fonte.texto):
            ln = fonte.linha(m.start())
            if ln in vistas:
                continue
            vistas.add(ln)
            ach.add("REVISAR", "FIGURA_NO_DECK", fonte.onde(ln, True),
                    f"{nome} no arquivo do slide: a figura vai para figures/{tipo}/<nome>.typ e entra no slide com "
                    f'#align(center, include "figures/{tipo}/<nome>.typ") ou #figure(include .., caption: [..]).',
                    fonte.trecho(ln))


RE_COMPONENTE = re.compile(r"resistor|capacitor|indutor|inductor|bobina", re.I)
RE_DESENHO_CIRCUITO = re.compile(r"(?<![\w.-])([\w-]*(?:circuito|resistor|capacitor|indutor)[\w-]*)\(", re.I)
ZAP_COMPONENTES = {"resistor", "capacitor", "inductor", "isource", "vsource", "wire"}
RE_USA_ZAP = re.compile(r"@preview/zap:|(?<![\w.-])zap\.|(?<![\w.-])circuit\s*\(")
RE_USA_CETZ = re.compile(r"(?<![\w.-])cetz\.|(?<![\w.-])canvas\s*\(")


def verificar_circuitos(fontes, ach):
    tem_zap = any(re.search(r"@preview/zap:", f.texto) for f in fontes)
    for f in fontes:
        so_um = f.papel != "slide"  # num arquivo de figura, do header ou do common, um achado basta
        zap_spans = [(ini, fim) for ini, args, blocos, fim in chamadas(f.texto, r"zap\.circuit|circuit")]
        dentro_zap = lambda pos: any(a <= pos < b for a, b in zap_spans)
        achados = []
        vistos = set()
        for ini, args, blocos, fim in chamadas(f.texto, r"cetz\.canvas|canvas"):
            if dentro_zap(ini):
                continue
            corpo = args + " ".join(blocos)
            m = RE_COMPONENTE.search(corpo)
            if m:
                ln = f.linha(ini)
                vistos.add(ln)
                achados.append((ln, f'"{m.group(0)}" num cetz.canvas: circuito se desenha com o zap '
                                    '(#import "@preview/zap:0.6.0").'))
        if f.papel == "figura" and f.nome.startswith("figures/circuits/") and not achados:
            m = None if RE_USA_ZAP.search(f.texto) else RE_USA_CETZ.search(f.texto)
            if m:
                ln = f.linha(m.start())
                vistos.add(ln)
                achados.append((ln, "Circuito em figures/circuits/ desenhado com CeTZ, sem o zap: refaça com o zap "
                                    "(o estilo e os exemplos estão em templates/circuitos/)."))
        if not tem_zap:
            for m in RE_DESENHO_CIRCUITO.finditer(f.texto):
                nome = m.group(1)
                ln = f.linha(m.start())
                if dentro_zap(m.start()) or ln in vistos or nome.lower() in ZAP_COMPONENTES and dentro_zap(m.start()):
                    continue
                if f.texto[max(0, m.start() - 4) : m.start()].endswith("let "):
                    continue
                vistos.add(ln)
                achados.append((ln, f"{nome}(): circuito fora do zap e o deck não importa o zap."))
            for m in re.finditer(r'image\(\s*"[^"]*circuito[^"]*"', f.texto, re.I):
                achados.append((f.linha(m.start()), "Circuito como imagem: desenhe com o zap."))
        achados.sort()
        for ln, msg in achados[:1] if so_um else achados:
            ach.add("REVISAR", "CIRCUITO_SEM_ZAP", f.onde(ln, True), msg, f.trecho(ln))


# ---------------------------------------------------------------------------------------------------------------
# Slides: exercícios e exemplos (os dois modos)
# ---------------------------------------------------------------------------------------------------------------


RE_ANSWER = re.compile(r"^\s*#answer\b")
RE_SOLUTION = re.compile(r"^\s*#solution\b")
RE_QUEBRA = re.compile(r"^\s*(---|#pagebreak\(\))\s*$")


def verificar_exercicios(fonte, slides, ach):
    for s in slides:
        if s.nivel != 2:
            continue
        linhas = s.linhas()
        if s.tipo == "exercicio":
            resp = next((ln for ln, t in linhas if RE_ANSWER.match(t)), None)
            if resp is None:
                ach.add("REVISAR", "EXERCICIO_SEM_RESPOSTA", fonte.onde(s.ini, True),
                        "Exercício sem #answer: a resposta conferida vem depois de ---.", fonte.trecho(s.ini))
            elif not any(RE_QUEBRA.match(t) for ln, t in linhas if ln < resp):
                ach.add("REVISAR", "EXERCICIO_SEM_QUEBRA", fonte.onde(resp, True),
                        "No exercício, a resposta vem depois de ---, na página seguinte.", fonte.trecho(s.ini))
        elif s.tipo == "exemplo":
            if not any(RE_SOLUTION.match(t) for _, t in linhas):
                ach.add("AVISO", "EXEMPLO_SEM_SOLUCAO", fonte.onde(s.ini, True),
                        "Exemplo sem #solution.", fonte.trecho(s.ini))
    for ini, args, blocos, fim in chamadas(fonte.texto, r"exercise-slide"):
        corpo = "\n".join(blocos)
        ln = fonte.linha(ini)
        if "#answer" not in corpo:
            ach.add("REVISAR", "EXERCICIO_SEM_RESPOSTA", fonte.onde(ln, True), "Exercício sem #answer.",
                    fonte.trecho(ln))
        else:
            antes = corpo[: corpo.index("#answer")]
            if not re.search(r"(?m)^\s*(---|#pagebreak\(\))\s*$", antes):
                ach.add("REVISAR", "EXERCICIO_SEM_QUEBRA", fonte.onde(ln, True),
                        "No exercício, a resposta vem depois de ---.", fonte.trecho(ln))


RE_KIND = re.compile(r'(?<![\w-])kind\s*:\s*"([\w-]+)"')


def verificar_modo_e_kind(slides_f, modo, ach):
    for f in slides_f:
        m = RE_KIND.search(f.texto)
        if not m:
            continue
        do_kind = KINDS.get(m.group(1))
        if do_kind and do_kind != modo:
            ln = f.linha(m.start())
            ach.add("AVISO", "MODO_E_KIND", f.onde(ln, True),
                    f'kind: "{m.group(1)}" é do modo {NOME_DO_MODO[do_kind]}, e a verificação rodou com --modo '
                    f"{modo}. Confira o modo (as regras de cada um são outras) ou o kind do config-info.",
                    f.trecho(ln))
        return


# ---------------------------------------------------------------------------------------------------------------
# Modo aula
# ---------------------------------------------------------------------------------------------------------------


MARCAR_BLOQUEIO = [
    (re.compile(r"verdadeiro\s+ou\s+falso", re.I), '"verdadeiro ou falso"'),
    (re.compile(r"\bassinale\b", re.I), '"assinale"'),
    (re.compile(r"\balternativas?\b", re.I), '"alternativa"'),
    (re.compile(r"(?<![\w-])opcoes\s*\("), "opcoes()"),
]
MARCAR_REVISAR = [
    (re.compile(r"\bqual\s+(dest[ea]s|das\s+opç|dos\s+itens)", re.I), '"qual destes"'),
    (re.compile(r"\bvota[çc][ãa]o\b", re.I), '"votação"'),
    (re.compile(r'numbering\s*:\s*"\(?A[).]?\)?"'), 'numeração "(A)"'),
]


def verificar_questoes(fonte, slides, ach):
    for ln, linha in enumerate(fonte.linhas, 1):
        nomes = [nome for rx, nome in MARCAR_BLOQUEIO if rx.search(linha)]
        if nomes:
            ach.add("BLOQUEIO", "QUESTAO_DE_MARCAR", fonte.onde(ln, True),
                    f"{', '.join(nomes)}: questão de marcar. Reescreva como exercício discursivo (<exercise>, "
                    "enunciado, --- e #answer com o desenvolvimento).", fonte.trecho(ln))
            continue
        nomes = [nome for rx, nome in MARCAR_REVISAR if rx.search(linha)]
        if nomes:
            ach.add("REVISAR", "QUESTAO_DE_MARCAR", fonte.onde(ln, True),
                    f"{', '.join(nomes)}: parece questão de escolha. Só vale a discursiva.", fonte.trecho(ln))
    for s in slides:
        txt = s.texto()
        if "(A)" in txt and "(B)" in txt:
            ln = next(l for l, t in s.linhas() if "(A)" in t)
            ach.add("BLOQUEIO", "QUESTAO_DE_MARCAR", fonte.onde(ln, True),
                    f'"(A)" e "(B)" no slide "{s.titulo}": alternativas de marcar. Reescreva como exercício '
                    "discursivo.", fonte.trecho(ln))


def verificar_titulos_aula(fonte, slides, ach):
    for s in slides:
        if s.nivel == 2 and s.titulo.endswith("?") and s.tipo == "comum":
            ach.add("BLOQUEIO", "PERGUNTA_FORA_DE_EXERCICIO", fonte.onde(s.ini, True),
                    "Título em pergunta num slide comum. Toda questão é <exercise> com #answer; senão, "
                    "troque o título por uma afirmação.", fonte.trecho(s.ini))
        if re.search(r"aquecimento", s.titulo, re.I):
            ach.add("BLOQUEIO", "AQUECIMENTO", fonte.onde(s.ini, True),
                    'Não há "aquecimento": antes do assunto vem um exemplo introdutório (<example>); '
                    "a prática é exercício (<exercise>).", fonte.trecho(s.ini))


VERBOS_DE_QUESTAO = (
    r"(Calcule|Esboce|Mostre|Determine|Escreva|Desenhe|Encontre|Resolva|Obtenha|Prove|Demonstre|Justifique|"
    r"Explique|Classifique|Verifique|Identifique|Expresse|Simplifique|Ache|Diga|Compare|Faça|Pense|Tente|Discuta|"
    r"Decida|Indique|Reconheça|Responda|Preveja)\b"
)
RE_ENUNCIADO = re.compile(r"^\s*(?:[-+]|->|\d+\.|\[)?\s*" + VERBOS_DE_QUESTAO)


def verificar_questao_em_slide_comum(fonte, slides, ach):
    """Enunciado (verbo no imperativo no começo da linha) ou pergunta no corpo de um slide comum."""
    em_item = set()  # linhas dentro de #exercise-slide(..)[..] e #example-slide(..)[..]
    for ini, args, blocos, fim in chamadas(fonte.texto, r"exercise-slide|example-slide"):
        em_item.update(range(fonte.linha(ini), fonte.linha(fim) + 1))
    for s in slides:
        if s.nivel != 2 or s.tipo != "comum":
            continue
        corpo = [(ln, t) for ln, t in s.linhas()[1:] if ln not in em_item and not RE_TITULO.match(t)]
        enunciados = [(ln, t) for ln, t in corpo if RE_ENUNCIADO.search(t)]
        if enunciados:
            ln = enunciados[0][0]
            ach.add("REVISAR", "QUESTAO_EM_SLIDE_COMUM", fonte.onde(ln, True),
                    f'Enunciado no slide comum "{s.titulo}" ({len(enunciados)} linha(s)). Questão para o aluno é '
                    "<exercise> com --- e #answer; caso resolvido pelo professor é <example> com #solution.",
                    fonte.trecho(ln))
            continue
        perguntas = [(ln, t) for ln, t in corpo if "?" in t]
        if perguntas:
            ln = perguntas[0][0]
            ach.add("AVISO", "QUESTAO_EM_SLIDE_COMUM", fonte.onde(ln, True),
                    f'Pergunta no corpo do slide comum "{s.titulo}": se é para a turma responder, vira <exercise>.',
                    fonte.trecho(ln))


ENCONTRO_BLOQUEIO = [
    re.compile(r"\b(encontro|aula)s?\s+(n[º°o.]\s*)?\d+", re.I),
    re.compile(r"\bpr[óo]xim[oa]s?\s+(encontro|aula)", re.I),
    re.compile(r"\bresumo\s+d[oa]s?\s+(encontro|aula)", re.I),
    re.compile(r"\(\s*encontro", re.I),
]
ENCONTRO_AVISO = re.compile(r"\bencontros?\b|\baula\s+(passada|anterior)\b|\búltima\s+aula\b", re.I)
RE_DATA = re.compile(r"(?<![\d/])\d{1,2}/\d{1,2}(/\d{2,4})?(?![\d/])")


def verificar_encontros(fonte, ach):
    for ln, linha in enumerate(fonte.linhas, 1):
        achou = False
        for rx in ENCONTRO_BLOQUEIO:
            m = rx.search(linha)
            if m:
                ach.add("BLOQUEIO", "ORGANIZACAO_POR_ENCONTRO", fonte.onde(ln, True),
                        f'"{m.group(0)}": o deck se organiza pelo assunto, nunca por encontro ou aula. '
                        "Retome pelo nome do conceito.", fonte.trecho(ln))
                achou = True
                break
        mt = RE_TITULO.match(linha)
        if mt and len(mt.group(1)) <= 2 and RE_DATA.search(mt.group(2)):
            ach.add("BLOQUEIO", "ORGANIZACAO_POR_ENCONTRO", fonte.onde(ln, True),
                    "Data num título: o título é o assunto. A data da prova, se aparecer, vai no corpo.",
                    fonte.trecho(ln))
            achou = True
        if not achou and ENCONTRO_AVISO.search(linha) and not re.search(r"#?include\b", linha):
            ach.add("AVISO", "MENCAO_A_ENCONTRO", fonte.onde(ln, True),
                    "Menção a encontro ou aula: confira que não organiza nem retoma por encontro.",
                    fonte.trecho(ln))


def verificar_arquivos(fontes, ach):
    for f in fontes:
        if re.fullmatch(r"(encontro|aula)-?\d+\.typ", f.base, re.I):
            ach.add("BLOQUEIO", "ORGANIZACAO_POR_ENCONTRO", f.nome,
                    "Arquivo por encontro ou aula. Um arquivo por assunto (energia-e-potencia.typ).")


def verificar_encerramento_aula(fontes, ach):
    encerramentos = []
    for f in fontes:
        for ini, args, blocos, fim in chamadas(f.texto, r"ending-slide"):
            encerramentos.append((f, ini, args, blocos))
    if not encerramentos:
        ach.add("REVISAR", "ENCERRAMENTO", "deck",
                'Sem #ending-slide. O último slide é "Fim!" com um meme escolhido pelo professor.')
        return
    for f, ini, args, blocos in encerramentos:
        tudo = args + " " + " ".join(blocos)
        ln = f.linha(ini)
        problemas = []
        if not tudo.strip() or re.search(r"obrigad", tudo, re.I):
            problemas.append('diz "Obrigado!" (o #ending-slide vazio também)')
        if re.search(r"pr[óo]xim|a seguir", tudo, re.I):
            problemas.append("diz o que vem depois")
        if "Fim!" not in tudo:
            problemas.append('não diz "Fim!"')
        sem_meme = "image(" not in tudo and "foto(" not in tudo
        if problemas:
            ach.add("REVISAR", "ENCERRAMENTO", f.onde(ln, True),
                    "O encerramento " + ", ".join(problemas) + (", e não tem o meme" if sem_meme else "")
                    + ". Use #ending-slide[Fim!][#image(..)] com o meme que o professor escolher.", f.trecho(ln))
        elif sem_meme:
            ach.add("AVISO", "ENCERRAMENTO", f.onde(ln, True),
                    "Encerramento sem image(): falta o meme (candidatos com link e crédito, o professor escolhe).",
                    f.trecho(ln))


def verificar_referencias_aula(fonte, ach, rotulos):
    """REFERENCIA_NA_AULA: bibliography(), cite() ou @chave que não é rótulo do deck."""
    for ini, args, blocos, fim in chamadas(fonte.sem_strings, r"bibliography|cite"):
        ln = fonte.linha(ini)
        nome = "bibliography()" if fonte.sem_strings.startswith("bibliography", ini) else "cite()"
        ach.add("REVISAR", "REFERENCIA_NA_AULA", fonte.onde(ln, True),
                f"{nome} na aula: a aula não tem referência bibliográfica. A bibliografia é fonte do conteúdo, "
                "não entra nos slides.", fonte.trecho(ln))
    for p, chave in referencias(fonte, rotulos):
        ln = fonte.linha(p)
        ach.add("REVISAR", "REFERENCIA_NA_AULA", fonte.onde(ln, True),
                f"@{chave} não é rótulo do deck: parece citação, e a aula não tem referência bibliográfica.",
                fonte.trecho(ln))


# ---------------------------------------------------------------------------------------------------------------
# Modo acadêmico
# ---------------------------------------------------------------------------------------------------------------


RE_TITULO_GENERICO = re.compile(
    r"^(resultados?|discuss[ãa]o|resultados e discuss[ãa]o|an[áa]lise|(tabela|figura|gr[áa]fico|quadro)(\s+\d+)?)"
    r"(\s*\((cont\.?|continua[çc][ãa]o)\))?$", re.I)


def verificar_titulos_academico(fonte, slides, ach):
    for s in slides:
        if s.nivel == 2 and RE_TITULO_GENERICO.match(s.titulo.strip()):
            ach.add("REVISAR", "TITULO_GENERICO", fonte.onde(s.ini, True),
                    f'Título "{s.titulo}" só nomeia a parte ou a peça. O título de um resultado diz o achado '
                    '("O filtro de Kalman fica a menos de 1% da referência").', fonte.trecho(s.ini))


RE_APENDICE = re.compile(r"show\s*:\s*appendix\b")


def verificar_encerramento_academico(fontes, ach):
    encerramentos = []
    for f in fontes:
        for ini, args, blocos, fim in chamadas(f.texto, r"ending-slide"):
            encerramentos.append((f, ini, args, blocos, fim))
    if not encerramentos:
        ach.add("REVISAR", "ENCERRAMENTO", "deck",
                'Sem #ending-slide. O encerramento vem depois das Referências e dos Créditos das imagens: '
                '#ending-slide[Obrigado!][Perguntas?][#info("contact")].')
        return
    for f, ini, args, blocos, fim in encerramentos:
        tudo = args + " " + " ".join(blocos)
        ln = f.linha(ini)
        if not re.search(r"contact|contato", tudo, re.I):
            ach.add("AVISO", "ENCERRAMENTO", f.onde(ln, True),
                    'Encerramento sem contato: #info("contact"), com o contact do config-info.', f.trecho(ln))
        depois = f.texto[fim:]
        m = re.search(r"(?m)^[ \t]*={1,2}[ \t]+\S", depois)
        if m and not RE_APENDICE.search(depois[: m.start()]):
            lt = f.linha(fim + m.start())
            ach.add("REVISAR", "ENCERRAMENTO", f.onde(lt, True),
                    "Slide depois do encerramento sem #show: appendix antes dele: a reserva fica sem marca e o total "
                    "do Touying a conta. Ponha #show: appendix logo depois do #ending-slide.", f.trecho(lt))


def verificar_citacoes(fonte, slides, ach, rotulos):
    """CITACAO_NO_SLIDE: @chave (não rótulo do deck) ou cite() fora do slide "Referências"."""
    for ini, args, blocos, fim in chamadas(fonte.sem_strings, r"cite"):
        ln = fonte.linha(ini)
        if not eh_slide_de(slides, ln, RE_TITULO_REFERENCIAS):
            ach.add("REVISAR", "CITACAO_NO_SLIDE", fonte.onde(ln, True),
                    'cite() no slide: a obra entra só no slide "Referências", no fim, listada com '
                    "#bibliography(.., full: true).", fonte.trecho(ln))
    for p, chave in referencias(fonte, rotulos):
        ln = fonte.linha(p)
        if not eh_slide_de(slides, ln, RE_TITULO_REFERENCIAS):
            ach.add("REVISAR", "CITACAO_NO_SLIDE", fonte.onde(ln, True),
                    f'@{chave} no slide: sem @chave nos slides; a obra entra só no slide "Referências", no fim, '
                    "listada com #bibliography(.., full: true).", fonte.trecho(ln))


def verificar_bibliografia(fontes, ach):
    """REFERENCIAS: um #bibliography só, no slide "Referências", com full: true."""
    achadas = []
    for f in fontes:
        slides = slides_da_fonte(f) if f.papel == "slide" else []
        for ini, args, blocos, fim in chamadas(f.texto, r"bibliography"):
            ln = f.linha(ini)
            achadas.append((f, ln, args, eh_slide_de(slides, ln, RE_TITULO_REFERENCIAS)))
    if not achadas:
        ach.add("REVISAR", "REFERENCIAS", "deck",
                'Sem #bibliography. O slide "Referências", no fim, lista o referencias.bib inteiro: '
                '#bibliography("referencias.bib", full: true, ..), com só as obras da apresentação no .bib.')
        return
    if len(achadas) > 1:
        ach.add("REVISAR", "REFERENCIAS", ", ".join(f.onde(ln, True) for f, ln, _, _ in achadas),
                f"{len(achadas)} #bibliography no deck: um só, no slide \"Referências\".")
    for f, ln, args, no_slide in achadas:
        if not no_slide:
            ach.add("REVISAR", "REFERENCIAS", f.onde(ln, True),
                    '#bibliography fora do slide "Referências": ele fica no slide "== Referências", no fim, antes '
                    'dos "Créditos das imagens" e do encerramento.', f.trecho(ln))
        if not re.search(r"(?<![\w-])full\s*:\s*true\b", args):
            ach.add("BLOQUEIO", "REFERENCIAS", f.onde(ln, True),
                    "#bibliography sem full: true: sem @chave nos slides, a lista sai vazia. Use "
                    '#bibliography("referencias.bib", full: true, ..), com só as obras da apresentação no .bib.',
                    f.trecho(ln))


RE_IMPORTA_COMMON = re.compile(r'(?<![\w.-])(?:import|include)\s+"([^"]*(?:common|comum)\.typ)"')


def verificar_common_importado(fontes, ach):
    """COMMON_NO_ACADEMICO: um achado só, com os arquivos que importam um common.typ ou comum.typ."""
    importam = [(f, f.linha(m.start()), m.group(1)) for f in fontes for m in RE_IMPORTA_COMMON.finditer(f.texto)]
    if not importam:
        return
    f, ln, alvo = importam[0]
    onde = ", ".join(g.onde(l, True) for g, l, _ in importam[:5]) + (" ..." if len(importam) > 5 else "")
    ach.add("REVISAR", "COMMON_NO_ACADEMICO", onde,
            f'{len(importam)} arquivo(s) importam "{alvo}": no acadêmico não há common.typ. As funções grandes '
            "vão para o header.typ da apresentação; o resto, escrito no slide ou no arquivo da figura.",
            f.trecho(ln))


RE_INCLUDE = re.compile(r'#include\s+"([^"]+)"')
FORA_DO_TEMPO = re.compile(r"^(roteiro|sum[áa]rio|agradecimentos?|refer[êe]ncias|bibliografia|cr[ée]ditos.*)$", re.I)


def linhas_expandidas(caminho, por_caminho, vistos=None):
    """As linhas limpas de um arquivo de slide, (fonte, linha, texto), com cada #include "x.typ" de outro arquivo
    de slide trocado pelas linhas dele."""
    vistos = set() if vistos is None else vistos
    f = por_caminho.get(caminho)
    if f is None or caminho in vistos:
        return []
    vistos.add(caminho)
    out = []
    for ln, t in enumerate(f.linhas, 1):
        m = RE_INCLUDE.search(t)
        alvo = os.path.normpath(os.path.join(os.path.dirname(caminho), m.group(1))) if m else None
        if alvo in por_caminho:
            out.extend(linhas_expandidas(alvo, por_caminho, vistos))
        else:
            out.append((f, ln, t))
    return out


def ordem_dos_slides(slides_f, principal):
    """As linhas dos arquivos de slide na ordem do deck: a partir do principal, ou, sem ele, dos arquivos que
    nenhum outro inclui."""
    por_caminho = {f.caminho: f for f in slides_f}
    if principal in por_caminho:
        return linhas_expandidas(principal, por_caminho)
    incluidos = set()
    for f in slides_f:
        for m in RE_INCLUDE.finditer(f.texto):
            incluidos.add(os.path.normpath(os.path.join(os.path.dirname(f.caminho), m.group(1))))
    out, vistos = [], set()
    for f in slides_f:
        if f.caminho not in incluidos:
            out.extend(linhas_expandidas(f.caminho, por_caminho, vistos))
    return out


def contar_slides_de_conteudo(linhas):
    """Slides de conteúdo entre a capa e o #ending-slide: cada "==" e cada "---" (ou #pagebreak()), menos os de
    estrutura (Roteiro, Agradecimentos, Referências, Créditos). As seções "=" e as pausas não contam."""
    n, fora = 0, True
    for _, _, t in linhas:
        if RE_ENCERRAMENTO.search(t):
            break
        m = RE_TITULO.match(t)
        if m and len(m.group(1)) == 2:
            fora = bool(FORA_DO_TEMPO.match(RE_ROTULO.sub("", m.group(2)).strip()))
            n += 0 if fora else 1
        elif m and len(m.group(1)) == 1:
            fora = True  # a página da Parte, e a figura dela até o próximo ==
        elif RE_QUEBRA.match(t) and not fora:
            n += 1
    return n


def verificar_tempo(n, minutos, ach):
    if not minutos:
        return
    if n > 1.2 * minutos:
        ach.add("REVISAR", "TEMPO", "deck",
                f"{n} slides de conteúdo para {minutos} minutos (alvo: cerca de um por minuto, até "
                f"{int(1.2 * minutos)}). Leve o excedente para a reserva, depois do #show: appendix.")
    elif n < 0.5 * minutos:
        ach.add("AVISO", "TEMPO", "deck",
                f"{n} slides de conteúdo para {minutos} minutos: confira se algum slide junta mais de uma ideia.")


# ---------------------------------------------------------------------------------------------------------------
# PDF
# ---------------------------------------------------------------------------------------------------------------


def rodar(cmd, **kw):
    try:
        return subprocess.run(cmd, capture_output=True, text=True, **kw)
    except FileNotFoundError:
        raise Incompleta(f"não achei o programa {cmd[0]}")


def paginas_do_pdf(pdf):
    r = rodar(["pdfinfo", pdf])
    m = re.search(r"^Pages:\s+(\d+)", r.stdout, re.M)
    if r.returncode != 0 or not m:
        raise Incompleta(f"pdfinfo não leu {pdf}: {r.stderr.strip()}")
    return int(m.group(1))


RE_PAGINA = re.compile(r'<page width="([\d.]+)" height="([\d.]+)">(.*?)</page>', re.S)
RE_LINHA = re.compile(r'<line xMin="([\d.]+)" yMin="([\d.]+)" xMax="([\d.]+)" yMax="([\d.]+)">(.*?)</line>', re.S)
RE_PALAVRA = re.compile(r'<word xMin="([\d.]+)" yMin="([\d.]+)" xMax="([\d.]+)" yMax="([\d.]+)">(.*?)</word>', re.S)


def ler_paginas(pdf):
    r = rodar(["pdftotext", "-bbox-layout", pdf, "-"])
    if r.returncode != 0:
        raise Incompleta(f"pdftotext não leu {pdf}: {r.stderr.strip()}")
    paginas = []
    for pg in RE_PAGINA.finditer(r.stdout):
        largura, altura = float(pg.group(1)), float(pg.group(2))
        linhas = []
        for ln in RE_LINHA.finditer(pg.group(3)):
            palavras = [
                dict(x0=float(w.group(1)), y0=float(w.group(2)), x1=float(w.group(3)), y1=float(w.group(4)),
                     t=html.unescape(w.group(5)))
                for w in RE_PALAVRA.finditer(ln.group(5))
            ]
            if palavras:
                linhas.append(dict(y0=float(ln.group(2)), y1=float(ln.group(4)), palavras=palavras,
                                   texto=" ".join(p["t"] for p in palavras)))
        paginas.append(dict(largura=largura, altura=altura, linhas=linhas))
    return paginas


def latina(c):
    if not c.isalpha():
        return False
    nome = unicodedata.name(c, "")
    return nome.startswith("LATIN") and "MATHEMATICAL" not in nome


OPERADORES = {"sen", "cos", "tg", "tan", "sec", "Re", "Im", "exp", "log", "ln", "lim", "max", "min", "sup", "inf",
              "det", "mod", "arg", "senh", "cosh", "tgh"}


def eh_matematica(t):
    """Token com letras matemáticas Unicode (𝑥, 𝜑) ou um operador (cos, Re): não é texto corrido."""
    if any("MATHEMATICAL" in unicodedata.name(c, "") or "GREEK" in unicodedata.name(c, "") for c in t):
        return True
    return re.sub(r"[^\w]", "", t) in OPERADORES


def eh_palavra(t):
    return sum(latina(c) for c in t) >= 2 and not eh_matematica(t)


def eh_numero(t):
    return bool(re.fullmatch(r"[−+\-]?[\d.,]*\d[\d.,]*", t))


def normal(t):
    return re.sub(r"\s+", " ", t).strip()


def colado(w, palavras):
    """Índice ou expoente: o número encosta na palavra anterior da linha (P_1, x^2), não é número de eixo."""
    return any(-4 <= w["x0"] - o["x1"] < 1.5 and o["x0"] < w["x0"] for o in palavras if o is not w)


def marcar_rodape(paginas):
    """Linhas que se repetem em mais de 80% das páginas (o rodapé) e o topo da faixa do rodapé em cada página."""
    n = len(paginas)
    repetidas = set()
    if n >= 5:
        cont = collections.Counter()
        for pg in paginas:
            cont.update({normal(l["texto"]) for l in pg["linhas"] if not eh_numero(normal(l["texto"]))})
        repetidas = {t for t, c in cont.items() if c > 0.8 * n and t}
    topos = []
    for pg in paginas:
        ys = [l["y0"] for l in pg["linhas"] if normal(l["texto"]) in repetidas and l["y0"] > 0.6 * pg["altura"]]
        pg["rodape"] = min(ys) - 4 if ys else None
        if ys:
            topos.append(pg["rodape"])
    padrao = statistics.median(topos) if topos else None
    for pg in paginas:
        if pg["rodape"] is None:
            pg["rodape"] = padrao if padrao is not None else pg["altura"] * 0.915
    return repetidas


LINGUAGENS = {"Typst", "Python", "MATLAB", "C", "C++", "Shell", "Bash", "Assembly", "Rust", "Java", "JavaScript",
              "Octave", "Arduino", "VHDL", "Verilog", "Text", "Saída"}


def verificar_pdf(paginas, ach, args, codigo="", tem_legenda=False):
    repetidas = marcar_rodape(paginas)
    corpo = args.corpo
    limite = args.limiar * corpo
    resumo = []
    numeros_pequenos = collections.defaultdict(list)
    pequenas_por_tamanho = collections.defaultdict(list)  # altura -> [(página, trecho)]
    for p, pg in enumerate(paginas, 1):
        topo_titulo = 0.135 * pg["altura"]
        palavras = 0
        titulo = grande = ""
        frases = []  # [linha, altura, [palavras]]
        numeros_da_pagina = []
        na_borda = []
        for li, l in enumerate(pg["linhas"]):
            if normal(l["texto"]) in repetidas:
                continue
            linha_parte = l["palavras"][0]["t"] == "PARTE"
            for w in l["palavras"]:
                if w["y0"] >= pg["rodape"]:
                    continue
                t = w["t"]
                h = w["y1"] - w["y0"]
                if min(w["x0"], pg["largura"] - w["x1"]) < args.borda:
                    na_borda.append(t)
                if w["y1"] <= topo_titulo:
                    if len(titulo) < 60 and t not in ("—", "–"):
                        titulo = (titulo + " " + t).strip()
                    continue
                if h >= 1.4 * corpo:  # título de seção, do encerramento, número em destaque
                    if not titulo and len(grande) < 60:
                        grande = (grande + " " + t).strip()
                    continue
                if eh_palavra(t):
                    palavras += 1
                if (p == 1 and not args.incluir_capa) or h >= limite - 0.05:
                    continue
                letras = [c for c in t if c.isalpha()]
                if letras and all(c.isupper() for c in letras) and abs(h - 0.6 * corpo) < 0.45:
                    continue  # #tag do tema
                if linha_parte and abs(h - 0.7 * corpo) < 0.45:
                    continue  # "PARTE N" da seção
                if tem_legenda and abs(h - 0.6 * corpo) < 0.15:
                    continue  # legenda de figura, a 0,6 do corpo pelo tema
                indice = any(abs(h - f * corpo) < 0.25 for f in (0.7, 0.5))  # tamanhos de índice na matemática
                if indice and colado(w, l["palavras"]):
                    continue  # índice de texto colado ao símbolo: o "est" de SoC_"est", o "out" de V_"out"
                if eh_numero(t) and not indice and not colado(w, l["palavras"]):
                    numeros_da_pagina.append(round(h, 1))
                # trecho: palavras seguidas, na mesma linha e no mesmo tamanho
                if frases and frases[-1][0] == li and abs(frases[-1][1] - h) < 0.3:
                    frases[-1][2].append(t)
                else:
                    frases.append([li, h, [t]])
        titulo = titulo or grande
        resumo.append(dict(pagina=p, palavras=palavras, titulo=titulo))
        onde = f"p. {p}"
        rotulo = f' ("{titulo}")' if titulo else ""
        eh_referencias = bool(RE_TITULO_REFERENCIAS.match(titulo))
        if args.modo == "academico" and eh_referencias and palavras < 3:
            ach.add("BLOQUEIO", "REFERENCIAS_VAZIAS", onde,
                    f"A página de Referências tem {palavras} palavra(s): a lista saiu vazia. Use "
                    '#bibliography("referencias.bib", full: true, ..), com as obras da apresentação no .bib.')
        if RE_TITULO_CREDITOS.match(titulo) or (args.modo == "academico" and eh_referencias):
            pass  # os créditos e a lista de referências são longos por natureza
        elif palavras > args.bloqueio_palavras:
            ach.add("BLOQUEIO", "DENSIDADE", onde,
                    f"{palavras} palavras de texto{rotulo}; bloqueio acima de {args.bloqueio_palavras}. Quebre em 2 "
                    "ou mais slides.")
        elif palavras > args.max_palavras:
            ach.add("REVISAR", "DENSIDADE", onde,
                    f"{palavras} palavras de texto{rotulo}; alvo: até {args.max_palavras}. Quebre o slide ou enxugue.")
        tem_codigo = False
        for _, h, ws in frases:
            if codigo and (re.sub(r"\s+", "", " ".join(ws)) in codigo or (len(ws) == 1 and ws[0] in LINGUAGENS)):
                tem_codigo = True
                continue
            if any(eh_palavra(w) for w in ws):
                trecho = " ".join(ws)
                pequenas_por_tamanho[round(h, 1)].append((p, trecho if len(trecho) <= 50 else trecho[:47] + "..."))
        if not tem_codigo:
            for h in numeros_da_pagina:
                numeros_pequenos[h].append(p)
        if na_borda:
            ach.add("REVISAR", "TEXTO_NA_BORDA", onde,
                    f"Texto a menos de {num(args.borda, 0)} pt da borda da página{rotulo}: "
                    + ", ".join(f'"{t}"' for t in na_borda[:5]) + ". O projetor pode cortar; afaste da borda.")
    for h in sorted(pequenas_por_tamanho):
        itens = pequenas_por_tamanho[h]
        pags = sorted({p for p, _ in itens})
        exemplos = []
        for pg_ in pags[:8]:
            trechos = [t for p, t in itens if p == pg_]
            exemplos.append(f'p. {pg_} "' + '", "'.join(trechos[:2]) + '"' + (" ..." if len(trechos) > 2 else ""))
        resto = f"; e as p. {', '.join(map(str, pags[8:]))}" if len(pags) > 8 else ""
        ach.add("REVISAR", "LETRA_PEQUENA", f"p. {', '.join(map(str, pags[:12]))}" + (" ..." if len(pags) > 12 else ""),
                f"Texto a {num(h, 1)} pt ({num(h / corpo)} do corpo) em {len(pags)} página(s): " + "; ".join(exemplos)
                + resto + ". Leve o texto para o corpo do slide, ou passe o tamanho no uso da função.")
    if numeros_pequenos:
        paginas_n = sorted({p for ps in numeros_pequenos.values() for p in ps})
        tamanhos = sorted(numeros_pequenos, key=lambda h: -len(numeros_pequenos[h]))[:3]
        lista = ", ".join(str(p) for p in paginas_n[:20]) + (f" e mais {len(paginas_n) - 20}" if len(paginas_n) > 20 else "")
        ach.add("AVISO", "NUMEROS_PEQUENOS", f"{len(paginas_n)} páginas",
                f"Números (eixos de gráfico, marcas) a {', '.join(num(h, 1) + ' pt' for h in tamanhos)}, abaixo de "
                f"{num(args.limiar)} do corpo, nas p. {lista}. Confira no PNG se ficam legíveis do fundo da sala.")
    return resumo


# ---------------------------------------------------------------------------------------------------------------
# Compilação
# ---------------------------------------------------------------------------------------------------------------


def achar_principal(fontes, pdf, escolhido):
    if escolhido:
        cand = [f for f in fontes if f.nome == escolhido or f.base == os.path.basename(escolhido)
                or f.caminho == os.path.abspath(escolhido)]
        if not cand:
            caminho = os.path.abspath(escolhido)
            if not os.path.isfile(caminho):
                raise Incompleta(f"não achei o arquivo principal {escolhido}")
            return caminho
        return cand[0].caminho
    cand = [f for f in fontes if re.search(r"show\s*:\s*ufac-theme", f.texto)]
    if len(cand) == 1:
        return cand[0].caminho
    base = os.path.splitext(os.path.basename(pdf))[0]
    for f in cand or fontes:
        if os.path.splitext(f.base)[0] == base:
            return f.caminho
    raise Incompleta("não sei qual .typ é o principal; passe --principal ARQUIVO.typ")


def verificar_compilacao(principal, root, pasta, pdf, n_paginas, ach):
    with tempfile.TemporaryDirectory() as tmp:
        saida = os.path.join(tmp, "deck.pdf")
        cmd = ["typst", "compile", "--root", root, "--diagnostic-format", "short", principal, saida]
        r = rodar(cmd, cwd=pasta, timeout=900)
        diagnosticos = [l for l in r.stderr.splitlines() if re.search(r": (error|warning): ", l)]
        nome = os.path.basename(principal)
        if r.returncode != 0 or not os.path.exists(saida):
            erros = [l for l in diagnosticos if ": error: " in l] or r.stderr.strip().splitlines()[:3]
            ach.add("BLOQUEIO", "COMPILACAO", nome,
                    f"Não compila (typst compile --root {root}): " + " | ".join(erros[:3])
                    + ". Se for caminho fora da raiz, passe --root.")
            return
        vistos = set()
        for l in diagnosticos:
            if ": warning: " not in l:
                continue
            msg = l.split(": warning: ", 1)[1]
            if msg in vistos:
                continue
            vistos.add(msg)
            grav = "REVISAR" if re.search(r"font", msg, re.I) else "AVISO"
            ach.add(grav, "AVISO_DO_TYPST", l.split(": warning: ", 1)[0].replace(pasta + os.sep, ""),
                    f"Aviso do Typst: {msg}")
        novas = paginas_do_pdf(saida)
        if novas != n_paginas:
            ach.add("BLOQUEIO", "PDF_DESATUALIZADO", os.path.basename(pdf),
                    f"O PDF tem {n_paginas} páginas e a compilação de agora dá {novas}. Recompile antes de verificar.")
            return
        a = rodar(["pdftotext", pdf, "-"]).stdout
        b = rodar(["pdftotext", saida, "-"]).stdout
        if a != b:
            ach.add("BLOQUEIO", "PDF_DESATUALIZADO", os.path.basename(pdf),
                    "O texto do PDF difere da compilação de agora. Recompile antes de verificar.")


# ---------------------------------------------------------------------------------------------------------------
# Saída
# ---------------------------------------------------------------------------------------------------------------


def celula(s):
    return s.replace("|", "\\|").replace("\n", " ")


def imprimir_tabela(ach, titulo, limite):
    print(f"# {titulo}\n")
    for g in GRAVIDADES:
        itens = [a for a in ach.lista if a["gravidade"] == g]
        print(f"## {g} ({len(itens)})\n")
        if not itens:
            print("Nada.\n")
            continue
        print("| Código | Onde | Achado | Trecho |")
        print("|---|---|---|---|")
        por_codigo = collections.Counter()
        omitidos = collections.Counter()
        for a in itens:
            por_codigo[a["codigo"]] += 1
            if limite and por_codigo[a["codigo"]] > limite:
                omitidos[a["codigo"]] += 1
                continue
            trecho = f"`{celula(a['trecho'])}`" if a["trecho"] else ""
            print(f"| {a['codigo']} | {celula(a['onde'])} | {celula(a['mensagem'])} | {trecho} |")
        print()
        for cod, k in omitidos.items():
            print(f"(mais {k} achados {cod} omitidos; use --limite 0 ou --json para ver todos)\n")


def main():
    ap = Analisador(
        prog="verificar_deck.py",
        description="Verifica um deck touying-ufac contra as regras da skill touying-ufac, no modo dado (aula ou "
        "acadêmico): os .typ do deck (slides, header.typ, figures/ e, na aula, o common.typ da disciplina) e o PDF "
        "compilado. Saída em tabela por gravidade (BLOQUEIO, REVISAR, AVISO).",
        epilog=AJUDA,
        formatter_class=Formatador,
        add_help=False,
    )
    ap._positionals.title = "argumentos"
    ap._optionals.title = "opções"
    ap.add_argument("pasta", help="pasta do deck: os .typ dela (os slides e o header.typ) e a subpasta figures/")
    ap.add_argument("pdf", help="o PDF compilado do deck")
    ap.add_argument("-h", "--help", action="help", help="mostra esta ajuda e sai")
    ap.add_argument("--modo", choices=tuple(MODOS), metavar="{aula,academico}",
                    help="obrigatório: aula (kind \"lecture\") ou academico, também acadêmico (kind \"tcc\", "
                    "\"dissertation\", \"thesis\", \"coursework\" ou \"talk\"); o script nunca adivinha o modo")
    ap.add_argument("--json", action="store_true", help="saída em JSON (achados, resumo e palavras por página)")
    ap.add_argument("--root", metavar="PASTA",
                    help="raiz do typst compile (padrão: na aula, a pasta acima da do deck, a da disciplina; no "
                    "acadêmico, a própria pasta do deck)")
    ap.add_argument("--principal", metavar="ARQUIVO.typ", help="o .typ principal (padrão: o que tem #show: ufac-theme)")
    ap.add_argument("--sem-compilar", action="store_true", help="não compila; só lê os .typ e o PDF dado")
    ap.add_argument("--minutos", type=int, metavar="N",
                    help="só no modo acadêmico: tempo da apresentação, para a verificação TEMPO")
    ap.add_argument("--min-caracteres-funcao", type=int, default=50, metavar="N",
                    help="corpo mínimo, em caracteres sem espaço, de uma função do header.typ, de figures/ ou do "
                    "common.typ; abaixo disso, FUNCAO_PEQUENA (padrão: 50, umas três linhas)")
    ap.add_argument("--corpo", type=float, default=22.0, metavar="PT", help="corpo do tema em pt (padrão: 22)")
    ap.add_argument("--limiar", type=float, default=0.8, metavar="FRAÇÃO",
                    help="fração do corpo abaixo da qual o texto é letra pequena (padrão: 0.8)")
    ap.add_argument("--max-palavras", type=int, default=40, metavar="N", help="palavras por página acima das quais é REVISAR (padrão: 40)")
    ap.add_argument("--bloqueio-palavras", type=int, default=60, metavar="N",
                    help="palavras por página acima das quais é BLOQUEIO (padrão: 60)")
    ap.add_argument("--borda", type=float, default=12.0, metavar="PT",
                    help="distância em pt da borda lateral abaixo da qual o texto sai como TEXTO_NA_BORDA (padrão: 12)")
    ap.add_argument("--incluir-capa", action="store_true", help="mede a letra também na capa (página 1)")
    ap.add_argument("--falhar-em", choices=("bloqueio", "revisar"), default="bloqueio",
                    help="gravidade que dá código de saída 1 (padrão: bloqueio)")
    ap.add_argument("--limite", type=int, default=25, metavar="N",
                    help="achados por código na tabela; 0 mostra todos (padrão: 25; o JSON traz todos)")
    ap.add_argument("--paginas", action="store_true", help="imprime também as palavras de texto de cada página")
    args = ap.parse_args()
    if args.modo is None:
        ap.error("falta --modo aula ou --modo academico. O script não adivinha o modo: veja o kind do config-info "
                 '("lecture" é aula; "tcc", "dissertation", "thesis", "coursework" e "talk" são acadêmico).')
    args.modo = MODOS[args.modo]
    if args.modo == "aula" and args.minutos is not None:
        ap.error("--minutos só vale com --modo academico: a aula não tem tempo de apresentação para conferir.")

    ach = Achados()
    modo = args.modo
    try:
        pasta = os.path.abspath(args.pasta)
        pdf = os.path.abspath(args.pdf)
        if not os.path.isdir(pasta):
            raise Incompleta(f"a pasta {args.pasta} não existe")
        if not os.path.isfile(pdf):
            raise Incompleta(f"o PDF {args.pdf} não existe")
        for prog in ("pdftotext", "pdfinfo") + (() if args.sem_compilar else ("typst",)):
            if not shutil.which(prog):
                raise Incompleta(f"não achei o programa {prog} no PATH")
        fontes = ler_fontes(pasta, modo, ach)
        slides_f = [f for f in fontes if f.papel == "slide"]
        if not slides_f:
            raise Incompleta(f"a pasta {args.pasta} não tem .typ de slide")
        deck = [f for f in fontes if f.papel != "common"]
        raiz = os.path.abspath(args.root) if args.root else (os.path.dirname(pasta) if modo == "aula" else pasta)
        rotulos = rotulos_do_deck(fontes)

        verificar_modo_e_kind(slides_f, modo, ach)
        for f in fontes:
            slides = slides_da_fonte(f) if f.papel == "slide" else []
            verificar_letra(f, ach, args.corpo)
            verificar_travessao(f, ach)
            verificar_cores(f, ach)
            verificar_aperto(f, ach)
            verificar_graficos(f, ach)
            verificar_caminhos(f, ach, pasta, raiz, modo)
            verificar_legendas(f, ach, rotulos, slides)
            if f.papel == "common":
                continue
            verificar_credito_de_desenho(f, ach)
            if f.papel == "slide":
                verificar_exercicios(f, slides, ach)
                verificar_figuras_no_slide(f, ach)
            if modo == "aula":
                verificar_questoes(f, slides, ach)
                verificar_titulos_aula(f, slides, ach)
                verificar_questao_em_slide_comum(f, slides, ach)
                verificar_encontros(f, ach)
                verificar_referencias_aula(f, ach, rotulos)
            else:
                verificar_titulos_academico(f, slides, ach)
                verificar_citacoes(f, slides, ach, rotulos)
        verificar_tipos_de_figura(fontes, ach)
        verificar_funcoes(fontes, ach, args.min_caracteres_funcao, modo)
        verificar_circuitos(fontes, ach)
        if modo == "aula":
            verificar_arquivos(slides_f, ach)
            verificar_encerramento_aula(slides_f, ach)
        else:
            verificar_encerramento_academico(slides_f, ach)
            verificar_bibliografia(deck, ach)
            verificar_common_importado(deck, ach)

        principal = None
        if not args.sem_compilar or args.minutos:
            principal = achar_principal(slides_f, pdf, args.principal)
        else:
            try:
                principal = achar_principal(slides_f, pdf, args.principal)
            except Incompleta:
                principal = None  # só para a ordem dos slides; sem ele, a ordem dos arquivos
        linhas = ordem_dos_slides(slides_f, principal)
        verificar_creditos(pasta, linhas, ach)
        n_conteudo = None
        if modo == "academico" and principal:
            n_conteudo = contar_slides_de_conteudo(linhas)
            verificar_tempo(n_conteudo, args.minutos, ach)

        n_paginas = paginas_do_pdf(pdf)
        paginas = ler_paginas(pdf)
        if len(paginas) != n_paginas:
            raise Incompleta(f"pdftotext leu {len(paginas)} páginas, pdfinfo diz {n_paginas}")
        if not paginas:
            raise Incompleta(f"o PDF {args.pdf} não tem páginas")
        tem_legenda = any(re.search(r"caption\s*:", f.texto) for f in fontes)
        resumo = verificar_pdf(paginas, ach, args, "\x00".join(f.codigo for f in fontes if f.codigo), tem_legenda)

        if not args.sem_compilar:
            verificar_compilacao(principal, raiz, pasta, pdf, n_paginas, ach)
    except Incompleta as e:
        print(f"Verificação incompleta: {e}", file=sys.stderr)
        sys.exit(2)
    except subprocess.TimeoutExpired:
        print("Verificação incompleta: a compilação passou de 15 minutos", file=sys.stderr)
        sys.exit(2)
    except OSError as e:
        print(f"Verificação incompleta: {e}", file=sys.stderr)
        sys.exit(2)

    ordem = {g: i for i, g in enumerate(GRAVIDADES)}
    ach.lista.sort(key=lambda a: ordem[a["gravidade"]])
    cont = ach.contagem()
    falha = cont["BLOQUEIO"] > 0 or (args.falhar_em == "revisar" and cont["REVISAR"] > 0)
    codigo = 1 if falha else 0

    if args.json:
        dados = dict(modo=modo, pasta=pasta, pdf=pdf, paginas=n_paginas, arquivos=[f.nome for f in fontes])
        if modo == "academico":
            dados.update(slides_de_conteudo=n_conteudo, minutos=args.minutos)
        dados.update(resumo=cont, codigo_de_saida=codigo, achados=ach.lista, palavras_por_pagina=resumo)
        print(json.dumps(dados, ensure_ascii=False, indent=1))
    else:
        imprimir_tabela(ach, f"Verificação de {os.path.basename(pdf)}, modo {NOME_DO_MODO[modo]} ({n_paginas} "
                        f"páginas, {len(fontes)} .typ)", args.limite)
        if args.paginas:
            print("## Palavras de texto por página\n")
            print("| Página | Palavras | Título |")
            print("|---|---|---|")
            for r in resumo:
                print(f"| {r['pagina']} | {r['palavras']} | {celula(r['titulo'])} |")
            print()
        dens = sorted(r["palavras"] for r in resumo)
        print(f"Palavras de texto por página: mediana {num(statistics.median(dens), 0)}, máximo {dens[-1]}.")
        if n_conteudo is not None:
            print(f"Slides de conteúdo: {n_conteudo}" + (f" para {args.minutos} minutos." if args.minutos else "."))
        print(f"Resultado: {cont['BLOQUEIO']} BLOQUEIO, {cont['REVISAR']} REVISAR, {cont['AVISO']} AVISO. "
              f"Código de saída {codigo}." + (" Corrija os bloqueios e rode de novo." if cont["BLOQUEIO"] else ""))
    sys.exit(codigo)


if __name__ == "__main__":
    main()
