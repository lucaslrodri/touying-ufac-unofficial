#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#show: ufac-theme.with(
  lang: "en",
  logos: (auto, color => text(size: 0.5em, weight: "bold", fill: color)[LAB]),
  config-info(
    subject: [Neural Networks],
    title: [Training and evaluation],
    author: [Prof. Author Name],
    subject-code: [PPGEE016],
  ),
)

#title-slide()

== Results
The logos are in the footer, after the UFAC one.
