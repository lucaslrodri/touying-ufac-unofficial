/// Synopsis: a `#pause` inside the boxes that take it: an `emph-box` without a title (the veil in the page color over the covered line, the box itself visible), a `#quote-box` and a column of `#cols` (the pauses count across the columns, in reading order: the second column waits for the first); the visible lines are left alone. Inside a box with a badge Touying stops instead (`tests/errors/pause-in-badge.typ`). The documented limits: a `#pause` between the lines of a `>` box shows the box whole and holds back only what follows it; quotations separated by blank lines are revealed one per step; Touying's `#item-by-item` shows every item from the first step.
#import "../../common.typ": *
#show: setup
#include "body.typ"
