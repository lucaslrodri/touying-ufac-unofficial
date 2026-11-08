#!/usr/bin/env python3
"""Verificador mecânico de um deck de trabalho acadêmico feito com o tema touying-ufac-unofficial.

Lê os .typ da pasta do deck (fora de comentários e de blocos de código) e o PDF compilado, e aponta o que
fere as regras da skill touying-ufac-academic. Só biblioteca padrão; chama pdftotext, pdfinfo e typst.

Uso: python3 verificar_deck.py <pasta-com-os-.typ> <deck.pdf> [--minutos N] [--json]
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
Verificações: CÓDIGO (gravidade) e o que dispara.

Nos .typ da pasta, fora de comentários e de blocos de código:
- LETRA_REDUZIDA (BLOQUEIO): text(size:) ou set text(size:) menor que 1em (ou que o corpo, em pt); scale()
  sobre texto. scale() sobre figura: REVISAR.
- TRAVESSAO (BLOQUEIO): "—" no texto, ou "---" no meio de uma linha (o Typst o troca por "—").
- TITULO_GENERICO (REVISAR): título "==" que só nomeia a parte ou a peça ("Resultados", "Discussão",
  "Tabela 2", "Figura 3", "Gráfico"): o título de um resultado diz o achado.
- GRAFICO_COMO_IMAGEM (AVISO): image() de um arquivo com nome de gráfico ("grafico", "plot", "chart",
  "curva", "resultado", "fig"): refaça com lilaq a partir dos dados, ou confira a letra no PNG.
- ENCERRAMENTO (REVISAR): deck sem #ending-slide; slide depois do encerramento sem #show: appendix antes
  dele. Encerramento sem contato (#info("contact")): AVISO.
- COR_FORA_DO_TEMA (REVISAR): rgb(), luma(), cmyk() ou "#hexadecimal".
- FUNCOES_NO_DECK (REVISAR): mais de --max-funcoes funções definidas (#let f(..) ou let f = (..) =>); lista
  todas.
- ARGUMENTOS_ESPALHADOS (REVISAR): dicionário de argumentos definido no deck e espalhado com ..nome.
- CIRCUITO_SEM_ZAP (REVISAR): resistor, capacitor ou indutor num cetz.canvas; sem import do zap, também uma
  função de desenho de circuito (des-circuito-rc()) ou image() de "circuito".
- TEMPO (REVISAR): com --minutos N, mais de 1,2 × N slides de conteúdo; menos de 0,5 × N é AVISO. Slide de
  conteúdo: cada "==" e cada "---" entre a capa e o #ending-slide, a partir do arquivo principal e dos
  #include da pasta, menos Roteiro, Agradecimentos, Referências e Créditos das imagens. As seções "=", as
  pausas e a reserva (depois do encerramento) não contam.
- ESPACO_APERTADO (REVISAR): set par(leading:), set page(margin:), set table(inset:) ou v(-..).

No PDF, página a página. O rodapé (as linhas que se repetem em mais de 80% das páginas e o que fica abaixo
delas) não conta; o título (a faixa de cima) não conta como palavra.
- DENSIDADE: mais de --max-palavras (40) palavras de texto é REVISAR; mais de --bloqueio-palavras (60) é
  BLOQUEIO. Palavra é um token com 2 ou mais letras latinas: fórmulas e números não contam. As páginas de
  Referências não contam.
- LETRA_PEQUENA (REVISAR): texto com corpo (altura da caixa no pdftotext -bbox) abaixo de --limiar (0,8) do
  corpo do tema (--corpo, 22 pt). Uma linha por tamanho, com as páginas e os trechos. Não contam: a capa, as
  etiquetas #tag (0,6 do corpo, em maiúsculas), as legendas de figura (0,6 do corpo, pelo tema, se o deck tem
  caption:), o "PARTE N" das seções, os índices de texto colados ao símbolo, a matemática (𝑥, 𝜑, cos, Re) e o
  código (raw) dos .typ. O 0,8 pega os rótulos a 17 pt (0,77), como o "sem atrito" da linha de base.
- NUMEROS_PEQUENOS (AVISO): números soltos (eixos de gráfico, marcas) abaixo do limiar, numa linha só.
  Índices e limites da matemática (0,7 e 0,5 do corpo) não contam.
- TEXTO_NA_BORDA (REVISAR): texto a menos de --borda (12 pt) da borda lateral da página.

Compilação (com typst, a menos que se passe --sem-compilar):
- COMPILACAO (BLOQUEIO): o arquivo principal não compila com --root.
- PDF_DESATUALIZADO (BLOQUEIO): o PDF dado não bate com a compilação de agora (páginas ou texto).
- AVISO_DO_TYPST (AVISO): aviso do compilador; fonte desconhecida: REVISAR.

Código de saída: 0 sem bloqueio; 1 com bloqueio (ou com REVISAR, se --falhar-em revisar); 2 verificação
incompleta (ferramenta ausente, pasta sem .typ, PDF ilegível, argumentos errados).

O que o script não vê fica com os revisores: número diferente do texto do trabalho, afirmação maior que o
resultado, figura de terceiros sem fonte, sigla sem definição.

Exemplos, na pasta da apresentação (o deck em defesa/, compilado com a raiz na própria pasta):
  python3 verificar_deck.py defesa defesa/defesa.pdf --minutos 20
  python3 verificar_deck.py defesa defesa/defesa.pdf --minutos 20 --json > verificacao.json
  python3 verificar_deck.py slides slides/defesa.pdf --root .. --falhar-em revisar
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


class Fonte:
    def __init__(self, caminho):
        self.caminho = caminho
        self.nome = os.path.basename(caminho)
        with open(caminho, encoding="utf-8") as f:
            self.bruto = f.read()
        codigos = []
        self.texto = limpar(self.bruto, codigos)
        self.codigo = "\x00".join(c for c in codigos if c)
        self.inicios = [0] + [m.end() for m in re.finditer("\n", self.texto)]
        self.linhas = self.texto.split("\n")
        self.linhas_brutas = self.bruto.split("\n")

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


# ---------------------------------------------------------------------------------------------------------------
# Verificações nos fontes
# ---------------------------------------------------------------------------------------------------------------


def verificar_letra(fonte, ach, corpo):
    t = fonte.texto
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
            ach.add("BLOQUEIO", "LETRA_REDUZIDA", fonte.onde(ln, True),
                    f"{forma} reduz a letra a {num(rel)} do corpo. Quebre o slide ou tire o conteúdo; "
                    "nunca diminua a letra.", fonte.trecho(ln))
    for ini, args, blocos, fim in chamadas(t, r"scale"):
        corpo_scale = args + " ".join(blocos)
        ln = fonte.linha(ini)
        figura = re.search(r"image\(|canvas|diagram|circuit|grafico|lq\.|plot|fig-|des-", corpo_scale)
        if figura:
            ach.add("REVISAR", "LETRA_REDUZIDA", fonte.onde(ln, True),
                    "scale() sobre uma figura: os rótulos e números diminuem junto. Dê o tamanho na figura.",
                    fonte.trecho(ln))
        else:
            ach.add("BLOQUEIO", "LETRA_REDUZIDA", fonte.onde(ln, True),
                    "scale() sobre texto diminui a letra. Quebre o slide.", fonte.trecho(ln))


def verificar_travessao(fonte, ach):
    for ln, linha in enumerate(fonte.linhas, 1):
        if "—" in linha:
            ach.add("BLOQUEIO", "TRAVESSAO", fonte.onde(ln, True),
                    "Travessão no texto: o tema pode quebrar a página nele. Use dois-pontos, vírgula ou "
                    "parênteses.", fonte.trecho(ln))
        elif linha.strip() != "---" and re.search(r"(?<![-\w])---(?![-\w])", linha):
            ach.add("BLOQUEIO", "TRAVESSAO", fonte.onde(ln, True),
                    '"---" no meio da linha vira travessão. Só use "---" sozinho na linha, para quebrar a página.',
                    fonte.trecho(ln))


RE_TITULO_GENERICO = re.compile(
    r"^(resultados?|discuss[ãa]o|resultados e discuss[ãa]o|an[áa]lise|(tabela|figura|gr[áa]fico|quadro)(\s+\d+)?)"
    r"(\s*\((cont\.?|continua[çc][ãa]o)\))?$", re.I)


def verificar_titulos(fonte, slides, ach):
    for s in slides:
        if s.nivel == 2 and RE_TITULO_GENERICO.match(s.titulo.strip()):
            ach.add("REVISAR", "TITULO_GENERICO", fonte.onde(s.ini, True),
                    f'Título "{s.titulo}" só nomeia a parte ou a peça. O título de um resultado diz o achado '
                    '("O filtro de Kalman fica a menos de 1% da referência").', fonte.trecho(s.ini))


RE_IMAGEM_GRAFICO = re.compile(r'image\(\s*"([^"]*(?:grafico|gráfico|plot|chart|curva|resultado|fig)[^"]*)"', re.I)


def verificar_graficos(fonte, ach):
    for m in RE_IMAGEM_GRAFICO.finditer(fonte.texto):
        ln = fonte.linha(m.start())
        ach.add("AVISO", "GRAFICO_COMO_IMAGEM", fonte.onde(ln, True),
                f'image("{m.group(1)}") parece um gráfico exportado: refaça com lilaq a partir dos dados, ou '
                "confira no PNG que os números e os rótulos ficam no tamanho do corpo.", fonte.trecho(ln))


RE_APENDICE = re.compile(r"show\s*:\s*appendix\b")


def verificar_encerramento(fontes, ach):
    encerramentos = []
    for f in fontes:
        for ini, args, blocos, fim in chamadas(f.texto, r"ending-slide"):
            encerramentos.append((f, ini, args, blocos, fim))
    if not encerramentos:
        ach.add("REVISAR", "ENCERRAMENTO", "deck",
                'Sem #ending-slide. O encerramento vem depois das Referências: '
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


RE_COR = re.compile(r'(?<![\w.-])(rgb|luma|cmyk)\s*\(|"#[0-9A-Fa-f]{3,8}"')


def verificar_cores(fonte, ach):
    for ln, linha in enumerate(fonte.linhas, 1):
        m = RE_COR.search(linha)
        if m:
            ach.add("REVISAR", "COR_FORA_DO_TEMA", fonte.onde(ln, True),
                    "Cor fixa: use só as do tema (colors.primary, colors.secondary-dark, ...).", fonte.trecho(ln))


RE_FUNCAO = re.compile(r"(?<![\w.-])let\s+([A-Za-z_][\w-]*)\s*\(")
RE_LAMBDA = re.compile(r"(?<![\w.-])let\s+([A-Za-z_][\w-]*)\s*=\s*(\([^()]*\)|[A-Za-z_][\w-]*)\s*=>")
RE_DICIONARIO = re.compile(r"(?<![\w.-])let\s+([A-Za-z_][\w-]*)\s*=\s*\(\s*[A-Za-z_][\w-]*\s*:")


def verificar_funcoes(fontes, ach, maximo):
    defs = []
    dicionarios = []
    for f in fontes:
        for rx in (RE_FUNCAO, RE_LAMBDA):
            for m in rx.finditer(f.texto):
                defs.append((m.group(1), f, f.linha(m.start())))
        for m in RE_DICIONARIO.finditer(f.texto):
            dicionarios.append((m.group(1), f, f.linha(m.start())))
    defs.sort(key=lambda d: (d[1].nome, d[2]))
    if len(defs) > maximo:
        cont = collections.Counter(d[0] for d in defs)
        itens = []
        for nome, f, ln in defs:
            extra = f" (definida {cont[nome]}x)" if cont[nome] > 1 else ""
            itens.append(f"{nome} {f.nome}:{ln}{extra}")
        ach.add("REVISAR", "FUNCOES_NO_DECK", "deck",
                f"{len(defs)} funções definidas no deck (limite {maximo}). Use os componentes do tema e os "
                "ajudantes do comum.typ escritos no slide; função só para código grande ou recurso que o tema "
                "não tem, e no comum.typ ao lado do deck. Funções: " + "; ".join(itens) + ".")
    por_nome = collections.defaultdict(list)
    for nome, f, ln in dicionarios:
        por_nome[nome].append((f, ln))
    for nome, lugares in por_nome.items():
        usos = sum(len(re.findall(r"(?<![\w-])\.\." + re.escape(nome) + r"(?![\w-])", g.texto)) for g in fontes)
        if usos:
            f, ln = lugares[0]
            onde = ", ".join(f"{g.nome}:{l}" for g, l in lugares[:6]) + (" ..." if len(lugares) > 6 else "")
            ach.add("REVISAR", "ARGUMENTOS_ESPALHADOS", onde,
                    f"Dicionário de argumentos {nome} definido {len(lugares)}x e espalhado {usos}x com ..{nome}. "
                    "Escreva os argumentos no próprio slide.", f.trecho(ln))


RE_COMPONENTE = re.compile(r"resistor|capacitor|indutor|inductor|bobina", re.I)
RE_DESENHO_CIRCUITO = re.compile(r"(?<![\w.-])([\w-]*(?:circuito|resistor|capacitor|indutor)[\w-]*)\(", re.I)
ZAP_COMPONENTES = {"resistor", "capacitor", "inductor", "isource", "vsource", "wire"}


def verificar_circuitos(fontes, ach):
    tem_zap = any(re.search(r"@preview/zap:", f.texto) for f in fontes)
    for f in fontes:
        zap_spans = [(ini, fim) for ini, args, blocos, fim in chamadas(f.texto, r"zap\.circuit|circuit")]
        dentro_zap = lambda pos: any(a <= pos < b for a, b in zap_spans)
        vistos = set()
        for ini, args, blocos, fim in chamadas(f.texto, r"cetz\.canvas|canvas"):
            if dentro_zap(ini):
                continue
            corpo = args + " ".join(blocos)
            m = RE_COMPONENTE.search(corpo)
            if m:
                ln = f.linha(ini)
                vistos.add(ln)
                ach.add("REVISAR", "CIRCUITO_SEM_ZAP", f.onde(ln, True),
                        f'"{m.group(0)}" num cetz.canvas: circuito se desenha com o zap '
                        '(#import "@preview/zap:0.6.0").', f.trecho(ln))
        if tem_zap:
            continue
        for m in RE_DESENHO_CIRCUITO.finditer(f.texto):
            nome = m.group(1)
            ln = f.linha(m.start())
            if dentro_zap(m.start()) or ln in vistos or nome.lower() in ZAP_COMPONENTES and dentro_zap(m.start()):
                continue
            if f.texto[max(0, m.start() - 4) : m.start()].endswith("let "):
                continue
            vistos.add(ln)
            ach.add("REVISAR", "CIRCUITO_SEM_ZAP", f.onde(ln, True),
                    f"{nome}(): circuito fora do zap e o deck não importa o zap.", f.trecho(ln))
        for m in re.finditer(r'image\(\s*"[^"]*circuito[^"]*"', f.texto, re.I):
            ln = f.linha(m.start())
            ach.add("REVISAR", "CIRCUITO_SEM_ZAP", f.onde(ln, True),
                    "Circuito como imagem: desenhe com o zap.", f.trecho(ln))


RE_QUEBRA = re.compile(r"^\s*(---|#pagebreak\(\))\s*$")
RE_INCLUDE = re.compile(r'#include\s+"([^"]+)"')
FORA_DO_TEMPO = re.compile(r"^(roteiro|sum[áa]rio|agradecimentos?|refer[êe]ncias|bibliografia|cr[ée]ditos.*)$", re.I)


def linhas_expandidas(caminho, fontes, vistos=None):
    """As linhas limpas de um arquivo, com cada #include "x.typ" da pasta trocado pelas linhas dele."""
    por_caminho = {f.caminho: f for f in fontes}
    vistos = set() if vistos is None else vistos
    f = por_caminho.get(caminho)
    if f is None or caminho in vistos:
        return []
    vistos.add(caminho)
    out = []
    for ln, t in enumerate(f.linhas, 1):
        m = RE_INCLUDE.search(t)
        if m:
            alvo = os.path.normpath(os.path.join(os.path.dirname(caminho), m.group(1)))
            out.extend(linhas_expandidas(alvo, fontes, vistos))
        else:
            out.append(t)
    return out


def contar_slides_de_conteudo(principal, fontes):
    """Slides de conteúdo entre a capa e o #ending-slide: cada "==" e cada "---" (ou #pagebreak()), menos os de
    estrutura (Roteiro, Agradecimentos, Referências, Créditos). As seções "=" e as pausas não contam."""
    n, fora = 0, True
    for t in linhas_expandidas(principal, fontes):
        if re.search(r"(?<![\w.-])ending-slide\s*[(\[]", t):
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
        if re.match(r"(refer[êe]ncias|bibliografia|references)\b", titulo, re.I):
            pass  # a lista de referências é longa por natureza
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
                + resto + ". Leve o texto para o corpo do slide, ou passe o tamanho no uso do ajudante.")
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
        cand = [f for f in fontes if f.nome == os.path.basename(escolhido) or f.caminho == os.path.abspath(escolhido)]
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
        if os.path.splitext(f.nome)[0] == base:
            return f.caminho
    raise Incompleta("não sei qual .typ é o principal; passe --principal ARQUIVO.typ")


def verificar_compilacao(principal, root, pdf, n_paginas, ach):
    with tempfile.TemporaryDirectory() as tmp:
        saida = os.path.join(tmp, "deck.pdf")
        cmd = ["typst", "compile", "--root", root, "--diagnostic-format", "short", principal, saida]
        r = rodar(cmd, cwd=os.path.dirname(principal), timeout=900)
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
            ach.add(grav, "AVISO_DO_TYPST", l.split(": warning: ", 1)[0].replace(os.path.dirname(principal) + "/", ""),
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
        description="Verifica um deck de trabalho acadêmico touying-ufac contra as regras da skill "
        "touying-ufac-academic: os .typ da pasta e o PDF compilado. Saída em tabela por gravidade (BLOQUEIO, "
        "REVISAR, AVISO).",
        epilog=AJUDA,
        formatter_class=Formatador,
        add_help=False,
    )
    ap._positionals.title = "argumentos"
    ap._optionals.title = "opções"
    ap.add_argument("pasta", help="pasta com os .typ do deck (não entra nas subpastas)")
    ap.add_argument("pdf", help="o PDF compilado do deck")
    ap.add_argument("-h", "--help", action="help", help="mostra esta ajuda e sai")
    ap.add_argument("--json", action="store_true", help="saída em JSON (achados, resumo e palavras por página)")
    ap.add_argument("--root", metavar="PASTA", help="raiz do typst compile (padrão: a própria pasta do deck)")
    ap.add_argument("--principal", metavar="ARQUIVO.typ", help="o .typ principal (padrão: o que tem #show: ufac-theme)")
    ap.add_argument("--sem-compilar", action="store_true", help="não compila; só lê os .typ e o PDF dado")
    ap.add_argument("--minutos", type=int, metavar="N", help="tempo da apresentação, para a verificação TEMPO")
    ap.add_argument("--corpo", type=float, default=22.0, metavar="PT", help="corpo do tema em pt (padrão: 22)")
    ap.add_argument("--limiar", type=float, default=0.8, metavar="FRAÇÃO",
                    help="fração do corpo abaixo da qual o texto é letra pequena (padrão: 0.8)")
    ap.add_argument("--max-palavras", type=int, default=40, metavar="N", help="palavras por página acima das quais é REVISAR (padrão: 40)")
    ap.add_argument("--bloqueio-palavras", type=int, default=60, metavar="N",
                    help="palavras por página acima das quais é BLOQUEIO (padrão: 60)")
    ap.add_argument("--max-funcoes", type=int, default=3, metavar="N", help="funções definidas no deck antes de REVISAR (padrão: 3)")
    ap.add_argument("--borda", type=float, default=12.0, metavar="PT",
                    help="distância em pt da borda lateral abaixo da qual o texto sai como TEXTO_NA_BORDA (padrão: 12)")
    ap.add_argument("--incluir-capa", action="store_true", help="mede a letra também na capa (página 1)")
    ap.add_argument("--falhar-em", choices=("bloqueio", "revisar"), default="bloqueio",
                    help="gravidade que dá código de saída 1 (padrão: bloqueio)")
    ap.add_argument("--limite", type=int, default=25, metavar="N",
                    help="achados por código na tabela; 0 mostra todos (padrão: 25; o JSON traz todos)")
    ap.add_argument("--paginas", action="store_true", help="imprime também as palavras de texto de cada página")
    args = ap.parse_args()

    ach = Achados()
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
        nomes = sorted(n for n in os.listdir(pasta) if n.endswith(".typ"))
        if not nomes:
            raise Incompleta(f"a pasta {args.pasta} não tem .typ")
        fontes = [Fonte(os.path.join(pasta, n)) for n in nomes]

        for f in fontes:
            slides = slides_da_fonte(f)
            verificar_letra(f, ach, args.corpo)
            verificar_travessao(f, ach)
            verificar_titulos(f, slides, ach)
            verificar_graficos(f, ach)
            verificar_cores(f, ach)
            verificar_aperto(f, ach)
        verificar_encerramento(fontes, ach)
        verificar_funcoes(fontes, ach, args.max_funcoes)
        verificar_circuitos(fontes, ach)

        principal = None
        if not args.sem_compilar or args.minutos:
            principal = achar_principal(fontes, pdf, args.principal)
        n_conteudo = contar_slides_de_conteudo(principal, fontes) if principal else None
        verificar_tempo(n_conteudo, args.minutos, ach)

        n_paginas = paginas_do_pdf(pdf)
        paginas = ler_paginas(pdf)
        if len(paginas) != n_paginas:
            raise Incompleta(f"pdftotext leu {len(paginas)} páginas, pdfinfo diz {n_paginas}")
        tem_legenda = any(re.search(r"caption\s*:", f.texto) for f in fontes)
        resumo = verificar_pdf(paginas, ach, args, "\x00".join(f.codigo for f in fontes if f.codigo), tem_legenda)

        if not args.sem_compilar:
            root = os.path.abspath(args.root) if args.root else pasta
            verificar_compilacao(principal, root, pdf, n_paginas, ach)
    except Incompleta as e:
        print(f"Verificação incompleta: {e}", file=sys.stderr)
        sys.exit(2)
    except subprocess.TimeoutExpired:
        print("Verificação incompleta: a compilação passou de 15 minutos", file=sys.stderr)
        sys.exit(2)

    ordem = {g: i for i, g in enumerate(GRAVIDADES)}
    ach.lista.sort(key=lambda a: ordem[a["gravidade"]])
    cont = ach.contagem()
    falha = cont["BLOQUEIO"] > 0 or (args.falhar_em == "revisar" and cont["REVISAR"] > 0)
    codigo = 1 if falha else 0

    if args.json:
        print(json.dumps(dict(pasta=pasta, pdf=pdf, paginas=n_paginas, slides_de_conteudo=n_conteudo,
                              minutos=args.minutos, resumo=cont, codigo_de_saida=codigo, achados=ach.lista,
                              palavras_por_pagina=resumo), ensure_ascii=False, indent=1))
    else:
        imprimir_tabela(ach, f"Verificação de {os.path.basename(pdf)} ({n_paginas} páginas, {len(fontes)} .typ)",
                        args.limite)
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
