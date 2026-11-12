#!/bin/sh
# Downloads from the Iconify API the icons the theme ships, one JSON per collection in assets/icons/ (the format that
# src/icons.typ reads, the same as the `provide-icons` of the iconify package): only the icons the theme uses, not the
# whole collections. Run it again only when the list below changes; the files are committed.
#   octicon       Octicons (GitHub, MIT): the roles of the theme (callouts, question, example, file, terminal, contact)
#   ph            Phosphor (MIT), bold weight: code
#   devicon       Devicon (MIT): logos of languages of the code blocks (Python, MATLAB, R, Markdown, JavaScript,
#                 TypeScript)
#   simple-icons  Simple Icons (CC0): the Typst logo, in one colour
#   material-icon-theme  Material Icon Theme (MIT): the coloured terminal of the shell (bash, sh) and logos of
#                 languages (C, C++, Arduino, Rust, Fortran, Assembly, Verilog, LaTeX, HTML)
#   vscode-icons  VSCode Icons (MIT): the coloured log of the output of a program and the OpenSCAD logo
#   file-icons    File Icons (ISC): logos in one colour (Assembly x86, ARM and RISC-V, VHDL, SystemVerilog, Lean)
set -eu
cd "$(dirname "$0")/../assets/icons"

get() {
  curl -fsS -m 30 "https://api.iconify.design/$1.json?icons=$2" -o "$1.json"
  python3 -c "import json, sys; d = json.load(open('$1.json')); m = d.get('not_found', []);
print('$1:', len(d['icons']), 'icons' + (', missing: ' + ', '.join(m) if m else '')); sys.exit(1 if m else 0)"
}

get octicon "alert-16,light-bulb-16,info-16,note-16,history-16,pencil-16,beaker-16,file-code-16,terminal-16,mail-16"
get ph "code-bold"
get devicon "python,matlab,r,markdown,javascript,typescript"
get simple-icons "typst"
get material-icon-theme "console,c,cpp,arduino,rust,fortran,assembly,verilog,tex,html"
get vscode-icons "file-type-log,file-type-openscad"
get file-icons "assembly-intel,assembly-arm,assembly-riscv,vhdl,systemverilog,lean"
