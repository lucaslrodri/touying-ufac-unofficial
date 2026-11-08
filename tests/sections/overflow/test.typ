/// Synopsis: `===` repeats on pages created by automatic overflow (no `---`), replacement by a new `===`, `---` continuation that overflows, and `#pause`; a callout in the style `"bar"` that does not fit goes whole to the next page, and one with the badge continues there; an `emph-box` with a title and an icon that goes to the next page keeps its badge whole (its white title and icon ran below the fill). Covered content that reaches the next page after a `#pause` converges: the chunk at the bottom of the page is hidden, the same room as when veiled (the document did not converge, with a quotation box hidden smaller than veiled). The long code blocks are in `sections/overflow-code`.
#import "../../common.typ": *
#show: setup
#include "body.typ"
