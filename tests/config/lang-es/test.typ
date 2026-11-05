/// Synopsis: `lang: "es"`: Spanish names Ejercicio/Ejemplo/Parte, `text.lang` = es, Spanish smart quotes. The shared body (config/lang-body.typ) also checks the titles of the callouts (`#example` and `#examples` included, in both styles), the word of the solution and the pill of the output.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "es", test-info)
#include "../lang-body.typ"
