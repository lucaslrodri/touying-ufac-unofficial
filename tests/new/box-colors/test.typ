/// Synopsis: inside a box, what has no style of its own takes the color of the box: the `===`/`====` subtitle pills, bold, highlight, inline code, links, icons, markers and arrows; in `emph-box` (default, colored, with a title), in the callouts (`"bar"` and `"badge"`), in the boxes of the questions and examples, in boxes inside boxes (each keeps its color) and in the light cells of a table. `#alert` takes the color of the box too, also inside an equation box (`eq-box`), where it takes the color of the box around the equation, not that of the `eq-box`. A box in a light color is in `new/light-colors`.
#import "../../common.typ": *
#show: setup
#include "body.typ"
