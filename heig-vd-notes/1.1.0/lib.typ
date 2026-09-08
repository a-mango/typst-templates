#let conf(title: none, authors: (), date: none, content) = {
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
      Page #counter(page).display("1 sur 1", both: true)
    ],
  )

  set align(center)
  text(17pt, title)

  let count = authors.len()
  let ncols = calc.min(count, 3)
  grid(columns: (1fr,) * ncols, row-gutter: 24pt, ..authors.map(author => [
      #author.name \
      #author.affiliation \
      #link("mailto:" + author.email)
    ]))
  set heading(numbering: "1.1.")

  set align(left)

  content
}
