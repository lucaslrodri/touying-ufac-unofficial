/// Synopsis: the speaker notes on a second screen, below (`config-common(show-notes-on-second-screen: bottom)`): the page is twice as tall, the slide on top and its notes below. The cover and the closing slide keep their bubbles on the slide, the figure of a section fits the frame of the slide (66% of its height), and the box of a question and its footer fit the slide.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", test-info, config-common(show-notes-on-second-screen: bottom))

#title-slide()

= A section
#image("../../logo.svg")
#speaker-note[The notes of the section.]

== A question <question>
The box and its footer fit the slide.
#speaker-note[The notes of the question.]

#ending-slide()
