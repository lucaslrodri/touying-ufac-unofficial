/// Synopsis: `ufac-theme(code-languages:)` with the dictionary of the codly-languages package and entries of the deck: a language of the package (`julia`) gets its logo at the height of the icons of the theme, one of the deck (`spice`) its name without an icon and another (`cobol`) an icon given as content; the languages of the theme keep their pills over those of the dictionary (`python`, named "Python 3" in it, and `m`, which the package has as Objective-C), and so does the output (`text`, named "Log" in it).
#import "../../common.typ": *
#import "@preview/codly-languages:0.1.10": codly-languages
#show: ufac-theme.with(
  lang: "en",
  test-info,
  code-languages: codly-languages + (
    spice: (name: "SPICE", icon: none),
    cobol: (name: "COBOL", icon: text(weight: "bold", fill: rgb("#CE422B"))[C]),
    python: (name: "Python 3", icon: none),
    text: (name: "Log", icon: "tip"),
  ),
)

== Languages of the deck
#cols[
  ```julia
  f(x) = 2x + 1
  ```
  ```spice
  R1 in out 1k
  ```
  ```cobol
  DISPLAY 'HI'.
  ```
][
  ```python
  print(375.0)
  ```
  ```m
  disp(375.0)
  ```
  ```text
  375.0
  ```
]
