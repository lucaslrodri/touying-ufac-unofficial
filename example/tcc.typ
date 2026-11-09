// Example deck of the touying-ufac-unofficial theme: the defense of an undergraduate thesis (`flavor: "tcc"`), with
// the student and the advisors under their labels, the cover style "gradient" and the tag of the work on the cover.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *

#show: ufac-theme.with(
  lang: "en",
  cover-style: "gradient",
  config-info(
    flavor: "tcc",
    title: [Recognizing bird songs in city parks],
    course: [Bachelor's in Biology],
    author: [_Student_ \ Student Name \ _Advisor_ \ Prof. Dr. Advisor Name \ _Co-advisor_ \ Prof. Dr. Co-advisor Name],
    date: [December 2026],
    contact: [`student.name@example.com`],
  ),
)

#title-slide()

= Introduction

== The problem
-> City parks are full of birds, heard more often than seen
-> Telling the songs apart by ear takes years of practice
-> A phone can record them, and a program can name the species

#cols(divider: true)[
  #tag[goal]

  Name the species from a short recording.
][
  #tag(color: colors.quaternary)[result]

  A classifier evaluated on 300 recordings.
]

= Method

== The recordings
#table(columns: 3, table.header([Set], [Recordings], [Accuracy]),
  [Training], [1200], [--],
  [Validation], [300], [0.88],
  [Test], [300], [0.86],
)

#note[The accuracy is the share of recordings named right (0 to 1).]

= Conclusion

== Contributions
- A set of 1800 labeled recordings of 25 species
- A classifier with an accuracy of 0.86 on the test set
- The code, open

#ending-slide[Thank you!][Questions?][#info("contact")]
