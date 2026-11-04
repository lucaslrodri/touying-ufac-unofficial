// touying-ufac-unofficial 0.3.0 — package entry point. Everything is re-exported, in this order, so that later names
// shadow earlier ones: the palette (`colors`), the UFAC logo (`ufac-logo`, `ufac-logo-image`), the icons
// (`theme-icons`, `provide-icons`), the components (`emph-box`, `eq-box`, `quote-box`, `cols`, `arrows`, `icon`,
// `primary`/`secondary`/`tertiary`/`quaternary`, `outline` — the deck's, which shadows Typst's), the code
// (`code-languages`, `codly-ufac-theme`, `ufac-syntax`) and the slide functions (`ufac-theme`, `title-slide`, `slide`,
// `new-section-slide`, `exercise-slide`, `example-slide`).
// Names starting with `_` are internal. Decks should also import `@preview/touying:0.7.4` themselves, as in the template.
#import "constants.typ": *
#import "utils.typ": *
#import "icons.typ": *
#import "components.typ": *
#import "code.typ": *
#import "ufac.typ": *
