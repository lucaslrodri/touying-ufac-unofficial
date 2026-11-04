/// Synopsis: a slide whose content is only a shorthand (`-> item`, `> box`, `"quote"`), also with `#pause` and in `slide(composer:)`: the shorthand is rewritten (since Typst 0.12 a lone text in a container is not a paragraph, and the `show par` of the theme did not run).
#import "../../common.typ": *
#show: setup
#include "body.typ"
