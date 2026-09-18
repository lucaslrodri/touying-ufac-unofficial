// touying-ufac manual (PDF). The content lives in `chapters/`, one file per chapter, so that the same sources can
// later feed a website (one page per chapter). Build with `sh docs/build.sh`, which also renders the slide examples.
#import "template.typ": *

#show: project.with(
  title: package.name,
  subtitle: package.description,
  authors: ("Lucas Lima Rodrigues",),
  abstract: [
    A #link("https://touying-typ.github.io/")[Touying] theme for lecture slides, following the visual identity of
    the #link("https://www.ufac.br/")[Federal University of Acre]. Slides are written with headings and a few
    Markdown-like shorthands for boxes, quotations, arrow lists and emphases. This manual is set with the rules of
    the theme itself.
  ],
  url: package.repository,
  date: datetime.today().display("[month repr:long] [day], [year]"),
  version: package.version,
)

#include "chapters/01-quick-start.typ"
#include "chapters/02-slides.typ"
#include "chapters/03-inline.typ"
#include "chapters/04-lists.typ"
#include "chapters/05-boxes.typ"
#include "chapters/06-columns.typ"
#include "chapters/07-colors.typ"
#include "chapters/08-elements.typ"
#include "chapters/09-touying.typ"
#include "chapters/10-index.typ"
