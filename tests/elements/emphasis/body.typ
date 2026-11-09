// Body of the `elements/emphasis` test: included by test.typ (Tytanic) and by /tests.typ (the catalogue).
#import "../../common.typ": *

== Inline emphasis
#[
#set text(size: .75em)
#table(columns: (auto, auto, 1fr), [Syntax], [Color], [Result],
  [`*bold*` / `#strong[..]`], [neutral-darkest], [Text with black *bold* and #strong[strong]],
  [`_italic_` / `#emph[..]`], [neutral-darkest], [Text with _italic_, #emph[emph] and *_bold italic_*],
  [`#alert[..]`, `#primary[..]` or `~~..~~`], [primary], [Text with blue #alert[alert], #primary[primary] and ~~shortcut~~; #alert[with _italic_ and `raw` inside] (the shorthand only takes plain text)],
  [`#secondary[..]`], [secondary], [Text with #secondary[yellow emphasis]],
  [`#tertiary[..]`], [tertiary], [#tertiary[Label:] tag at the start of the sentence, and #tertiary[red warning] in the middle],
  [`#quaternary[..]`], [quaternary], [Text with #quaternary[green emphasis] and #quaternary[$y = 1$] with math],
  [`#underline[..]` or `~..~`], [secondary (stroke)], [Text with #underline[strong underline (pgjy)] and ~shortcut~, color unchanged; #alert[#underline[with alert]], *#underline[bold]*; Fig.~1 and Tab.~2 stay spaces],
)
]

---

=== Inside `emph-box`, `*bold*` takes the box color
#cols[#emph-box(color: colors.quaternary)[Green box with *green bold* and #underline[green underline]. #alert[alert] takes the green of the box, #tertiary[tertiary] keeps its red and #primary[primary] its blue.]][#emph-box(color: colors.tertiary)[Red box with *red bold*, _black italic_ and #underline(stroke: .14em + colors.secondary)[explicit stroke equal to the default, so still red].]]
Outside the box, bold is *black* again and the #underline[underline, yellow]. `#alert` is still #alert[blue].


=== Inside a pill: white *bold*, yellow ~~alert~~ and #primary[primary], dark `raw`
Normal text below the pill.
