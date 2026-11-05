/// Synopsis: `lang: "en"`: English names Exercise/Example/Part, `text.lang` = en, no region. The shared body (config/lang-body.typ) also checks the smart quotes, the titles of the callouts (`#example` in the style "bar", `#examples` in both), the word of the solution and the pill of the output.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", test-info)
#include "../lang-body.typ"
