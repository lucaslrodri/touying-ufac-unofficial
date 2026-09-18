#import "../template.typ": *
#show: chapter

= Touying features <touying>

The theme sits on Touying and leaves its features alone. Animations work on every element of the theme: covered
content stays faintly visible under a veil in the page color.

#slide-example("pause", pages: (1, 2, 3))

#emph-box(color: colors.secondary)[
  Keep `#pause` and `#uncover`/`#only` in separate paragraphs: within one paragraph Touying reorders the covered
  part on the first subslide.
]

Available without any wrapper from the theme:

#table(
  columns: (auto, 1fr),
  table.header([Feature], [Functions]),
  [Animations], [`#pause`, `#meanwhile`, `#jump`, `#uncover`, `#only`, `#alternatives`, `#item-by-item`, `#effect`, `#touying-raw`],
  [Notes and handouts], [`#speaker-note` (it attaches to the previous slide), `#handout-only`, `config-common(handout: true)`],
  [Layout], [`#slide(composer: (1fr, 2fr))`, `#cols`, `components.adaptive-columns`, `components.full-width-block`, `utils.fit-to-width`, `utils.fit-to-height`],
  [Overflow], [`config-common(breakable: false, clip:, detect-overflow:)`],
  [Reuse], [`#touying-recall`, `touying-get-config`, `components.progressive-outline`],
)

Slides of other Touying themes that this one does not have: `outline-slide`, `focus-slide`, `ending-slide` and
`matrix-slide`.
