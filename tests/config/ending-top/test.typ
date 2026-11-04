/// Synopsis: after a cover in the style `"top"` (`kind: "course"`), the closing slide in Portuguese ("Obrigado!"), without logos at the top (they are in its footer) and without the contact of `config-info`, which a second one puts in the body with `#deck-info("contact")`; with the `"plain"` background of the cover.
#import "../../common.typ": *
#show: ufac-theme.with(background: "plain", config-info(
  kind: "course",
  title: [Fotografia para Iniciantes],
  short-title: [Curso de extensão],
  author: ([Nome do Primeiro Autor], [Nome do Segundo Autor]),
  contact: ([`primeiro.autor@example.com`], [`segundo.autor@example.com`]),
))

#title-slide()

== Um slide
Texto.

#ending-slide()

#ending-slide(subtitle: [Dúvidas?])[#deck-info("contact")]
