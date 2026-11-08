#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
// --- example ---
#show: ufac-theme.with(
  lang: "en",
  config-info(
    flavor: "coursework",
    subject: [Introduction to Economics],
    subject-code: [ECO101],
    unit-title: [The price of a cup of
      coffee in four cities],
    author: [
      _Students_ \
      First Student, Second Student \
      _Teacher_ \
      Prof. Dr. Teacher Name
    ],
    semester: [2026.1],
  ),
)

#title-slide()

#title-slide(header-right: [Group 3])
