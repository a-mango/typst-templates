#let conf(title: none, authors: (), date: none, content) = {
  set par(justify: true)
  show figure: set block(inset: (top: 0.5em, bottom: 1em))

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

  show heading: it => it.body

  set align(left)
  content
}

#let BOX = body => rect(
  stroke: black,
  width: 100%,
  inset: 1em,
  body,
)

#let TODO = body => grid(
  stroke: blue,
  inset: 1em,
  rows: (auto, auto),
  grid.cell[*TODO*], body,
)

#let WARN = body => grid(
  stroke: red,
  inset: 1em,
  rows: (auto, auto),
  grid.cell[*ATTENTION*], body,
)

#let INFO = body => grid(
  stroke: green,
  inset: 1em,
  columns: 1fr,
  body,
)

#let RED = body => grid(
  stroke: red,
  inset: 1em,
  rows: (auto, auto),
  grid.cell[*ATTENTION*], body,
)

#let GREEN = body => grid(
  stroke: green,
  inset: 1em,
  rows: (auto, auto),
  grid.cell[*ATTENTION*], body,
)

#let red = content => text(content, fill: red)
#let green = content => text(content, fill: green)

#let pro = body => {
  [text(fill: green)[*⊕*] #body]
}

#let con = body => {
  [#text(fill: red)[*⊖*] #body]
}

