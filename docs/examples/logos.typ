#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#show: ufac-theme.with(
  lang: "en",
  config-info(
    logo: (auto, color => text(size: 0.5em, weight: "bold", fill: color)[LAB]),
    title: [Neural Networks],
    short-title: [PPGEE016],
    subtitle: [Training and evaluation],
    author: [Prof. Author Name],
  ),
)

#title-slide()

== Results
The logos are in the footer, after the UFAC one.
