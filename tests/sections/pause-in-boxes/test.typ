/// Synopsis: a `#pause` inside the boxes that take it: an `emph-box` without a title or an icon (the veil in the page color over the covered line, the box itself visible), a `#quote-box` and a column of `#cols` (the pauses count across the columns, in reading order: the second column waits for the first); the visible lines are left alone. Inside an `emph-box` with a title or an icon, a callout with `style: "badge"`, an `eq-box`, a `#tag` or the header of a table Touying stops instead (`tests/errors/`). The documented limits are in `sections/pause-limits`.
#import "../../common.typ": *
#show: setup
#include "body.typ"
