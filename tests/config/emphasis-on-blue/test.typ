/// Synopsis: bold and italic take the color of the text around them where it is not black, and an alert is yellow on blue: in the title of the cover (with the footer of the slides, from the title, on the closing slide), in a `===` pill, in the header of a table, in the badge of an exercise and on the closing slide; inside an alert, its bold and italic take its color. On a slide, bold and italic stay black, and in a light box bold takes the color of the box.
#import "../../common.typ": *
#show: ufac-theme.with(
  lang: "en",
  config-info(title: [The tides of _Atlantis_, *bold* and ~~alert~~], author: [Author Name]),
)

#title-slide()

== On a slide and in a box
Black *bold* and _italic_; #alert[an alert with *bold* and _italic_ inside].

#emph-box(color: colors.tertiary)[In a box, red *bold*, black _italic_ and #alert[an alert with *bold* and _italic_].]

=== A pill with _italic_, *bold* and ~~alert~~
#table(columns: 2, table.header([_italic_ and *bold*], [~~alert~~]), [a], [b])

== An exercise with _italic_, *bold* and ~~alert~~ <exercise>
The badge shows the title.

#ending-slide[Thanks, with _italic_ and *bold*][A ~~subtitle~~ with an alert][]
