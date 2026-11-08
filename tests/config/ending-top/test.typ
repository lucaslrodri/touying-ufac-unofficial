/// Synopsis: after a cover in the layout `"top"` (`title-slide(cover-layout: "top")`, with the label "Ministrantes"), the closing slide in Portuguese ("Obrigado!"), without logos at the top (they are in its footer) and without the contact of `config-info`, which a second one puts in the body with `#info("contact")`; with the cover style `"plain"`.
#import "../../common.typ": *
#show: ufac-theme.with(cover-style: "plain", config-info(
  title: [Fotografia para Iniciantes],
  short-title: [Curso de extensão],
  author: ([Nome do Primeiro Autor], [Nome do Segundo Autor]),
  contact: ([`primeiro.autor@example.com`], [`segundo.autor@example.com`]),
))

#title-slide(cover-layout: "top", author-label: [Ministrantes])

== Um slide
Texto.

#ending-slide()

#ending-slide(subtitle: [Dúvidas?])[#info("contact")]
