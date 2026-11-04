/// Synopsis: after a cover in the style `"top"` (`kind: "course"`), the closing slide puts the logos on the left, where the cover put them; the contact comes from `config-info`, in Portuguese ("Obrigado!"), and the `"plain"` background goes to the closing slide too.
#import "../../common.typ": *
#show: ufac-theme.with(background: "plain", config-info(
  kind: "course",
  title: [MATLAB para Engenharia],
  short-title: [Curso de extensão],
  author: ([Ana Souza], [Bruno Lima]),
  contact: ([`ana@ufac.br`], [`bruno@ufac.br`]),
))

#title-slide()

== Um slide
Texto.

#ending-slide()
