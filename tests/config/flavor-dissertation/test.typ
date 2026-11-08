/// Synopsis: `flavor: "dissertation"` in Spanish: the tag "Tesis de Maestría", the layout `"top"`, the author and the advisors under labels in emphasis, and the closing slide ("¡Gracias!") with the logos on the left; the `institution`, given here, does not appear on the cover (it is for `#info`).
#import "../../common.typ": *
#show: ufac-theme.with(lang: "es", config-info(
  flavor: "dissertation",
  title: [Historia de los mapas antiguos de la Amazonia],
  course: [Programa de Posgrado en Historia],
  author: [_Estudiante_ \ Nombre del Estudiante \ _Director_ \ Prof. Dr. Nombre del Director],
  date: datetime(year: 2026, month: 6, day: 15),
  institution: (auto, [Programa de Posgrado en Historia]),
))

#title-slide()

#ending-slide()
