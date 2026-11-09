/// Synopsis: long footers with colored emphases: the cut with "…" does not go inside an emphasis, whose color depends on where it is, so it is kept or left out whole. On the left, `#tertiary[Tides]` fits and is kept, red, right before the "…", and the long word after it is left out; on the right, `#quaternary[Lab 4]` is kept, green, before the authors cut with "…". The same on a slide, in the footer of an exercise and on the closing slide (where both turn yellow, as on the blue); a label too long to fit is left out whole in `config/footer-long-emphasis-out`. `config/footer-long-content` cuts bold, emphasis and links between their words.
#import "../../common.typ": *
#show: ufac-theme.with(
  lang: "en",
  test-info,
  footer-left: [Ocean Science • #tertiary[Tides] • oceanographic-instrumentation-and-measurement-of-the-western-atlantic-currents • 2026],
  footer-right: [#quaternary[Lab 4] • First Author, Second Author, Third Author and Fourth Author],
)

== A footer with colored emphases
The red "Tides" and the green "Lab 4" fit and are kept whole, right before the "…".

== An exercise <exercise>
The same footer in the box of the exercise.

#ending-slide()
