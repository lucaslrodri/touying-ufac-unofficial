// Example deck of the touying-ufac-unofficial theme: the defence of a final paper (`kind: "tcc"`), with the student, the
// advisor and the co-advisor written as free content, the plain background and the tag of the work on the cover.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *

#show: ufac-theme.with(
  lang: "en",
  background: "plain",
  config-info(
    kind: "tcc",
    title: [Recognising bird songs in city parks],
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

#callout("info")[The accuracy is the share of recordings named right, from 0 to 1.]

= Conclusion

== Contributions
- A set of 1800 labelled recordings of 25 species
- A classifier with an accuracy of 0.86 on the test set
- The code, open

#ending-slide[Thank you!][Questions?]
