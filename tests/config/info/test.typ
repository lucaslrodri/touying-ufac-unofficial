/// Synopsis: `#info(key)` anywhere (text, `emph-box`, table, `cols`): every key, the logos with a height and in white, the function form; the date as a `datetime` in full, the institution (`auto` and an array) and the contact.
#import "../../common.typ": *
#show: ufac-theme.with(lang: "en", test-info, config-info(
  date: datetime(year: 2026, month: 3, day: 9),
  institution: (auto, [PPGEE]),
  contact: ([`author@ufac.br`], [`ufac.br/author`]),
))

== `#info` in the text
- `title`: #info("title"); `short-title`: #info("short-title")
- `subtitle`: #info("subtitle"); `short-subtitle`: #info("short-subtitle")
- `author`: #info("author"); `date`: #info("date")
- `institution`: #info("institution")
- `contact`: #info("contact")
- `logo`: #info("logo")

The logos 2em high: #info("logo", height: 2em)

== `#info` in boxes and tables
#cols[
  #emph-box(title: [#info("short-title")])[#info("title"), by #info("author") (#info("date")).]
  #box(fill: colors.primary, inset: .5em, info("logo", height: 1.5em, white: true))
][
  #table(columns: 2, table.header([Key], [Value]),
    [`title`], info("title"),
    [`date`], info("date"),
    [`institution`], info("institution"),
  )
]
The function form: #info(i => [#i.short-title — #i.title, #i.authors.len() author(s), #i.institutions.len() institutions]).
