/// Synopsis: on a dark background bold and italic are white, an alert is yellow and a highlight yellow with blue text: in the title of the cover (bold, italic and alert; the footer of the slides takes the title, in blue, and of the closing slide, in white), in a `===` pill, in the header of a table and in a dark cell, in the badge of an exercise (on red) and on the closing slide (highlight in its body). Inside an alert, its bold and italic take its color. On a slide, bold and italic stay black, and in a light box bold takes the color of the box.
#import "../../common.typ": *
#show: ufac-theme.with(
  lang: "en",
  config-info(title: [The tides of _Atlantis_, *bold* and ~~alert~~], author: [Author Name]),
)

#title-slide()

== On a slide and in a box
Black *bold* and _italic_; #alert[an alert with *bold* and _italic_ inside].

#emph-box(color: colors.tertiary)[In a box, red *bold*, black _italic_ and #alert[an alert with *bold* and _italic_].]

=== A pill with _italic_, *bold*, ~~alert~~ and ==highlight==
#table(columns: 2, table.header([_italic_ and *bold*], [~~alert~~ and ==highlight==]), [a], table.cell(fill: colors.primary)[a dark cell, *bold* and ==highlight==])

== An exercise with _italic_, *bold*, ~~alert~~ and ==highlight== <exercise>
The badge shows the title.

#ending-slide[Thanks, with _italic_ and *bold*][A ~~subtitle~~ with an alert][A ==highlight== on blue]
