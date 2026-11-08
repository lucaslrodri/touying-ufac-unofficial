/// Synopsis: what must NOT become a shorthand (and an em dash next to markup kept on the page by a `#block[ ]`), and boxes with an empty content (a callout in both styles, an `emph-box` with a title); a `---` in a sentence, which Touying takes for a page break (three pages), then `--` and a typed `—` with no markup right after it, which keep the slide whole, and a plain `#[ ]` around `Text — *bold*`, which does not (two pages).
#import "../../common.typ": *
#show: setup
#include "body.typ"
