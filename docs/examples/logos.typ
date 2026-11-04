#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#show: ufac-theme.with(
  lang: "en",
  config-info(
    logo: (auto, color => text(
      size: .5em, fill: color,
      weight: "bold")[LAB]),
    subject: [Ocean Science],
    subject-code: [OCE110],
    unit-title: [Waves],
    author: [Prof. Author Name],
  ),
)

#title-slide()

== Results
The logos are in the footer,
after the UFAC one.
