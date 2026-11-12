/// Synopsis: `lang: "es"`: Spanish names Ejercicio/Ejemplo/Parte, `text.lang` = es, Spanish smart quotes. The shared body (config/lang-body.typ) also checks the titles of the callouts (`#example` in the style "bar", `#examples` in both), the word of the solution and the pills of the output and of the console.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "es", test-info)
#include "../lang-body.typ"
