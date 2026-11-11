/// Synopsis: the speaker notes on a second screen, on the right (`config-common(show-notes-on-second-screen: right)`): the page is twice as wide, the slide on the left and its notes on the right. The cover and the closing slide keep their bubbles on the slide, and the box of a question and its footer fit the slide, as an ordinary slide does.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", test-info, config-common(show-notes-on-second-screen: right))

#title-slide()

== A slide
The notes of this slide are on the right.
#speaker-note[The notes of the slide.]

== A question <question>
The box and its footer fit the slide.
#speaker-note[The notes of the question.]

#ending-slide()
