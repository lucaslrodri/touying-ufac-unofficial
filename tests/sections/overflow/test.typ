/// Synopsis: `===` repeats on pages created by automatic overflow (no `---`), replacement by a new `===`, `---` continuation that overflows, and `#pause`; a callout in the style `"bar"` that does not fit goes whole to the next page, and one with the badge continues there; an `emph-box` with a title and an icon that goes to the next page keeps its badge whole (its white title and icon ran below the fill). The long code blocks are in `sections/overflow-code`.
#import "../../common.typ": *
#show: setup
#include "body.typ"
