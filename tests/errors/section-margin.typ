// error: new-section-slide: margin is auto (the page margin) or a length
// The margin of the section slides is checked when the slide is laid out.
#import "@preview/touying:0.7.4": *
#import "@preview/touying-ufac-unofficial:0.3.0": *
#show: ufac-theme.with(lang: "en", config-common(new-section-slide-fn: new-section-slide.with(margin: "x")))

= A section
