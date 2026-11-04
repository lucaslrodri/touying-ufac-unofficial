/// Synopsis: `config-info(logo: none)`: the cover, the section slide, the footer and the closing slide without logos, and `#info("logo")`, which gives nothing.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", test-info, config-info(logo: none))

#title-slide()

= A section
#placeholder()

== Without logos
The footer starts with the short title. Between the brackets, `#info("logo")` gives nothing: [#info("logo")].

#ending-slide()
