/// Synopsis: `lang: "es"`: Spanish names Pregunta/Ejemplo/Parte, `text.lang` = es, Spanish smart quotes. The shared body (config/lang-body.typ) also checks the titles of the callouts (`#example` in the style "bar", `#examples` in both), the word of the solution, the pills of the output and of the console, and the initials of the bookmarks of the PDF.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "es", test-info)
#include "../lang-body.typ"
