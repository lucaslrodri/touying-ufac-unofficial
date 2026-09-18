#import "../template.typ": *
#show: chapter

= Columns <columns>

#reference("components", "cols")

```example
#cols[Left][Middle][Right]
```

Touying's `side-by-side` (no divider) is still available, and `#slide(composer: (1fr, 2fr))[..][..]` lays out the
bodies of a whole slide.
