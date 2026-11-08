/// Synopsis: inside a box, what has no style of its own takes the color of the box: the `===`/`====` subtitle pills, bold, highlight, inline code, links, icons, markers and arrows; in `emph-box` (default, colored, with a title), in the callouts (`"bar"` and `"badge"`), in the boxes of the exercises and examples, in boxes inside boxes (each keeps its color) and in the light cells of a table. `#alert` takes the color of the box too, and works inside a badge, a tag and a table header, where Touying's stopped the compilation.
#import "../../common.typ": *
#show: setup
#include "body.typ"
