// Body of the `sections/section` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
// Section slides only (`= Part`), one after the other, without content slides between them: the image on the right
// comes from the content right after the `=` (`receive-body-for-new-section-slide-fn: true`) and gets `width: 12em, height: 66%`.
#import "../../common.typ": *

= Section with an image
#placeholder(label: [section figure])

= Section with a \ line break in the title
#placeholder()

= Section with \ `#pad(right:)`
#pad(right: 1.8em)[#placeholder(width: 10em)]   // right margin: wrap the image in pad(right:)

= Section with a real image
#image("../../logo.svg")

= Section without image
