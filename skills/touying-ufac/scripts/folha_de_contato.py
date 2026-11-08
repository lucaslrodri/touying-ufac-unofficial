#!/usr/bin/env python3
"""Folha de contato de um deck: todas as páginas do PDF em miniatura, com o número de cada uma.

Gera um .typ na hora e o compila pela entrada padrão (typst compile --root <pasta do pdf> - saida.pdf), com as
páginas do PDF como imagens. Só biblioteca padrão; chama pdfinfo e typst.

Uso: python3 folha_de_contato.py <deck.pdf> [--colunas 6 --linhas 6] [--png]
"""
import argparse
import os
import re
import shutil
import subprocess
import sys

EXEMPLOS = """\
Saída: <deck>-folhas.pdf ao lado do PDF, uma folha por grupo de colunas × linhas páginas (36 por padrão). Com
--png, também <deck>-folhas-1.png, <deck>-folhas-2.png... (uma por folha). O número embaixo de cada miniatura é
a página do PDF, a mesma do rodapé do slide mais 1 (a capa não tem número).

Código de saída: 0 gerou; 2 não gerou (PDF ilegível, typst ou pdfinfo ausente, erro na compilação).

Exemplos (vale para os dois modos, aula e acadêmico):
  python3 folha_de_contato.py slide-02/slide-02.pdf
  python3 folha_de_contato.py slide-02/slide-02.pdf --colunas 4 --linhas 4 --png --ppi 110
  python3 folha_de_contato.py defesa/deck.pdf
  python3 folha_de_contato.py defesa/deck.pdf --saida /tmp/revisao/folha.pdf --png
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
        print(f"folha_de_contato.py: erro nos argumentos: {message}", file=sys.stderr)
        sys.exit(2)


def falhar(msg):
    print(f"Folha de contato não gerada: {msg}", file=sys.stderr)
    sys.exit(2)


def paginas_do_pdf(pdf):
    r = subprocess.run(["pdfinfo", pdf], capture_output=True, text=True)
    paginas = re.search(r"^Pages:\s+(\d+)", r.stdout, re.M)
    if r.returncode != 0 or not paginas:
        falhar(f"pdfinfo não leu {pdf}: {r.stderr.strip()}")
    return int(paginas.group(1))


def texto_typst(s):
    """Uma string do Typst, com aspas e barras escapadas."""
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


def fonte_da_folha(nome_pdf, titulo, paginas, colunas, linhas, largura_cm):
    """O .typ da folha: uma grade de colunas × linhas por página, com o número de cada página do deck."""
    por_folha = colunas * linhas
    return f"""\
#let arquivo = {texto_typst("/" + nome_pdf)}
#let total = {paginas}
#let colunas = {colunas}
#let por-folha = {por_folha}
#let folhas = calc.ceil(total / por-folha)
#set page(width: {largura_cm}cm, height: auto, margin: 1cm, fill: white)
#set text(font: "New Computer Modern Sans", size: 14pt)
#for f in range(folhas) {{
  let primeira = f * por-folha + 1
  let ultima = calc.min(total, primeira + por-folha - 1)
  block(below: .6em, text(weight: "bold", {texto_typst(titulo)}) + h(1fr)
    + [páginas #primeira a #ultima de #total · folha #(f + 1) de #folhas])
  grid(
    columns: (1fr,) * colunas,
    column-gutter: .5cm,
    row-gutter: .45cm,
    ..range(primeira, ultima + 1).map(p => stack(
      spacing: .15cm,
      box(stroke: .6pt + gray, image(arquivo, page: p, width: 100%)),
      align(center, text(weight: "bold", str(p))),
    )),
  )
  if f < folhas - 1 {{ pagebreak() }}
}}
"""


def main():
    ap = Analisador(
        prog="folha_de_contato.py",
        description="Monta a folha de contato de um deck: todas as páginas do PDF em miniatura, numeradas, para "
        "olhar o deck inteiro de uma vez (quebras, páginas quase vazias, slides densos).",
        epilog=EXEMPLOS,
        formatter_class=Formatador,
        add_help=False,
    )
    ap._positionals.title = "argumentos"
    ap._optionals.title = "opções"
    ap.add_argument("pdf", help="o PDF do deck")
    ap.add_argument("-h", "--help", action="help", help="mostra esta ajuda e sai")
    ap.add_argument("--colunas", type=int, default=6, metavar="N", help="miniaturas por linha (padrão: 6)")
    ap.add_argument("--linhas", type=int, default=6, metavar="N", help="linhas por folha (padrão: 6)")
    ap.add_argument("--png", action="store_true", help="gera também um PNG por folha")
    ap.add_argument("--ppi", type=int, default=72, metavar="N",
                    help="resolução dos PNGs (padrão: 72, cerca de 1300 px de largura com 6 colunas)")
    ap.add_argument("--largura", type=float, default=46, metavar="CM",
                    help="largura da folha em cm (padrão: 46; a altura acompanha as linhas)")
    ap.add_argument("--saida", metavar="ARQUIVO.pdf", help="o PDF da folha (padrão: <deck>-folhas.pdf ao lado do deck)")
    args = ap.parse_args()

    if args.colunas < 1 or args.linhas < 1:
        falhar("--colunas e --linhas têm de ser 1 ou mais")
    for prog in ("typst", "pdfinfo"):
        if not shutil.which(prog):
            falhar(f"não achei o programa {prog} no PATH")
    pdf = os.path.abspath(args.pdf)
    if not os.path.isfile(pdf):
        falhar(f"o PDF {args.pdf} não existe")
    pasta, nome = os.path.split(pdf)
    base = os.path.splitext(nome)[0]
    saida = os.path.abspath(args.saida) if args.saida else os.path.join(pasta, base + "-folhas.pdf")
    if os.path.abspath(saida) == pdf:
        falhar("a saída não pode ser o próprio deck")

    paginas = paginas_do_pdf(pdf)
    fonte = fonte_da_folha(nome, nome, paginas, args.colunas, args.linhas, args.largura)

    alvos = [(saida, [])]
    if args.png:
        alvos.append((os.path.splitext(saida)[0] + "-{p}.png", ["--format", "png", "--ppi", str(args.ppi)]))
    for destino, extra in alvos:
        cmd = ["typst", "compile", "--root", pasta, *extra, "-", destino]
        r = subprocess.run(cmd, input=fonte, capture_output=True, text=True)
        if r.returncode != 0:
            falhar(f"typst compile falhou: {r.stderr.strip()}")

    folhas = -(-paginas // (args.colunas * args.linhas))
    print(f"{paginas} páginas em {folhas} folha(s): {saida}")
    if args.png:
        modelo = os.path.splitext(saida)[0]
        print("PNGs: " + ", ".join(f"{modelo}-{i}.png" for i in range(1, folhas + 1)))


if __name__ == "__main__":
    main()
