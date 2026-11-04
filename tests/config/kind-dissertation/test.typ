/// Synopsis: `kind: "dissertation"` in Spanish: the tag "Tesis de Maestría", the style `"top"`, the author and the advisors under labels in emphasis, and the closing slide ("¡Gracias!") with the logos on the left.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "es", config-info(
  kind: "dissertation",
  title: [Control predictivo de un microrred],
  course: [Programa de Posgrado en Ingeniería Eléctrica],
  author: [_Estudiante_ \ Nombre del Estudiante \ _Director_ \ Prof. Dr. Nombre del Director],
  date: datetime(year: 2026, month: 6, day: 15),
))

#title-slide()

#ending-slide()
