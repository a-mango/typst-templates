// HES-SO course report.
//
// Pick the language with the `lang` parameter of `#conf`. It sets the text
// language Typst itself works in, which drives hyphenation, quotation marks and
// its own supplements (`Tableau`/`Table`, `Figure`), and it picks the fixed
// strings below.

// Fixed strings, one table per language the template can be set to.
#let report-labels = (
  fr: (page: "1 sur 1"),
  en: (page: "1 of 1"),
)

/// Lay out a report.
///
/// - title (content, str, none): shown on the title block and in the header.
/// - subtitle (content, str, none): line under the title.
/// - authors (dictionary, array): one author, or an array of them. Each is a
///   dictionary with a `name`, an `affiliation` and an `email`.
/// - date (content, str, none): shown in the page footer.
/// - lang (str): "fr" or "en"; sets the text language and the fixed strings.
#let conf(
  title: none,
  subtitle: none,
  authors: (),
  date: none,
  lang: "fr",
  content,
) = {
  // A typo would otherwise pass silently and leave the document in the wrong
  // language.
  assert(
    lang in report-labels,
    message: "unknown language \"" + lang + "\", expected one of ("
      + report-labels.keys().join(", ") + ")",
  )
  let labels = report-labels.at(lang)

  // Before `set page`: the header and the footer inherit the text styles in
  // effect where the page is set up, so a later `set text` would leave them
  // hyphenating and quoting in the wrong language.
  set text(lang: lang)
  set par(justify: true)

  set page(
    header: grid(
      columns: (1fr, 1fr),
      row-gutter: 5pt,
      align: (left, right),
      image("logo.svg", height: 20pt), align(horizon, title),
      grid.cell(colspan: 2)[ #line(length: 100%, stroke: 0.5pt) ],
    ),
    footer: context [
      #line(length: 100%, stroke: 0.5pt)
      #date
      #h(1fr)
      Page #counter(page).display(labels.page, both: true)
    ],
  )

  align(center, text(17pt, title))
  align(center, text(15pt, subtitle))
  linebreak()

  if type(authors) == dictionary {
    // Handle single author case
    grid(
      columns: (1fr,),
      align: center,
      row-gutter: 24pt,
      [
        #authors.name \
        #authors.affiliation \
        #link("mailto:" + authors.email)
      ],
    )
  } else {
    // Handle multiple authors case
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      align: center,
      row-gutter: 24pt,
      ..authors.map(author => [
        #author.name \
        #author.affiliation \
        #link("mailto:" + author.email)
      ])
    )
  }

  show heading: it => [
    #set par(leading: 2em, spacing: 1.5em)
    #it.body
  ]

  v(1em)
  set align(left)
  content
}
