#!/bin/sh
# Downloads from the Iconify API the icons the theme ships, one JSON per collection in assets/icons/ (the format that
# src/icons.typ reads, the same as the `provide-icons` of the iconify package): only the icons the theme uses, not the
# whole collections. Run it again only when the list below changes; the files are committed.
#   octicon       Octicons (GitHub, MIT): the roles of the theme (callouts, exercise, example, file, terminal, contact)
#   ph            Phosphor (MIT), bold weight: the output of a program and code
#   devicon       Devicon (MIT): the logos of the languages of the code blocks
#   simple-icons  Simple Icons (CC0): the Typst logo
set -eu
cd "$(dirname "$0")/../assets/icons"

get() {
  curl -fsS -m 30 "https://api.iconify.design/$1.json?icons=$2" -o "$1.json"
  python3 -c "import json, sys; d = json.load(open('$1.json')); m = d.get('not_found', []);
print('$1:', len(d['icons']), 'icons' + (', missing: ' + ', '.join(m) if m else '')); sys.exit(1 if m else 0)"
}

get octicon "alert-16,light-bulb-16,info-16,note-16,history-16,pencil-16,beaker-16,file-code-16,terminal-16,mail-16"
get ph "article-bold,code-bold"
get devicon "python,matlab"
get simple-icons "typst"
