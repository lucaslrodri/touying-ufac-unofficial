/// Synopsis: a long footer with a colored emphasis (`#tertiary`) that does not fit: the cut with "…" does not go inside the emphasis, whose color depends on where it is, so it is kept or left out whole, here left out ("OCEAN SCIENCE…"); `config/footer-long-content` cuts bold, emphasis and links between their words.
#import "../../common.typ": *
#show: ufac-theme.with(
  lang: "en",
  test-info,
  footer-left: [Ocean Science • #tertiary[a long red label on the tides, the waves and the currents of the western Atlantic] • 2026],
)

== A footer with a colored emphasis
The red label does not fit, so the footer keeps "Ocean Science" and the "…".
