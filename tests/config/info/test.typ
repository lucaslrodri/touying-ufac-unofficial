/// Synopsis: `#deck-info(key)` anywhere (text, `emph-box`, table, `cols`): every key, the logos with a height and in white, the function form; the date as a `datetime` in full, the institution (`auto` and an array) and the contact.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", test-info, config-info(
  date: datetime(year: 2026, month: 3, day: 9),
  institution: (auto, [Graduate Program]),
  contact: ([`author@example.com`], [`example.com/author`]),
))

== `#deck-info` in the text
- `title`: #deck-info("title"); `short-title`: #deck-info("short-title")
- `subtitle`: #deck-info("subtitle"); `short-subtitle`: #deck-info("short-subtitle")
- `author`: #deck-info("author"); `date`: #deck-info("date")
- `institution`: #deck-info("institution")
- `contact`: #deck-info("contact")
- `logo`: #deck-info("logo")

The logos 2em high: #deck-info("logo", height: 2em)

== `#deck-info` in boxes and tables
#cols[
  #emph-box(title: [#deck-info("short-title")])[#deck-info("title"), by #deck-info("author") (#deck-info("date")).]
  #box(fill: colors.primary, inset: .5em, deck-info("logo", height: 1.5em, white: true))
][
  #table(columns: 2, table.header([Key], [Value]),
    [`title`], deck-info("title"),
    [`date`], deck-info("date"),
    [`institution`], deck-info("institution"),
  )
]
The function form: #deck-info(i => [#i.short-title — #i.title, #i.authors.len() author(s), #i.institutions.len() institutions]).
