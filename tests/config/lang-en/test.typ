/// Synopsis: `lang: "en"`: English names Question/Example/Part, `text.lang` = en, no region. The shared body (config/lang-body.typ) also checks the smart quotes, the titles of the callouts (`#example` in the style "bar", `#examples` in both), the word of the solution and the pills of the output and of the console.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", test-info)
#include "../lang-body.typ"
