// Body of the `sections/section` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
// Section slides only (`= Part`), one after the other, without content slides between them: the image on the right
// comes from the content right after the `=` (`receive-body-for-new-section-slide-fn: true`); an image fits in the frame of 12em × 66% (sections/section-figures).
#import "../../common.typ": *

= Section with an image
#placeholder(label: [section figure])

= Section with a \ line break in the title
#placeholder()

= Section with \ `#pad(right:)`
#pad(right: 1.8em)[#placeholder(width: 10em)]   // a pad adds to the margin of the page

= Section with a real image
#image("../../logo.svg")

= Section without image
