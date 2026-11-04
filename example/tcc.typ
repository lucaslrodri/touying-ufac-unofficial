// Example deck of the touying-ufac-unofficial theme: the defence of a final paper (`kind: "tcc"`), with the student, the
// advisor and the co-advisor written as free content, the plain background and the tag of the work on the cover.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *

#show: ufac-theme.with(
  lang: "en",
  background: "plain",
  config-info(
    kind: "tcc",
    title: [Detecting dental implants in panoramic radiographs],
    course: [Bachelor's in Electrical Engineering],
    author: [_Student_ \ Student Name \ _Advisor_ \ Prof. Dr. Advisor Name \ _Co-advisor_ \ Prof. Dr. Co-advisor Name],
    date: [December 2026],
    contact: [`student.name@example.com`],
  ),
)

#title-slide()

= Introduction

== The problem
-> A panoramic radiograph shows the whole dental arch
-> Finding the implants by hand is slow
-> A neural network can mark them with oriented boxes

#cols(divider: true)[
  #tag[goal]

  Detect and count the implants.
][
  #tag(color: colors.quaternary)[result]

  A detector evaluated on 120 images.
]

= Method

== The network
#table(columns: 3, table.header([Stage], [Images], [mAP]),
  [Training], [480], [--],
  [Validation], [120], [0.91],
  [Test], [120], [0.89],
)

#callout("info")[The mAP measures the quality of the boxes, from 0 to 1.]

= Conclusion

== Contributions
- A set of 720 annotated radiographs
- A detector with a mAP of 0.89 on the test set
- The code, open

#ending-slide[Thank you!][Questions?]
