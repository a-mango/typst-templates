#import "@preview/wrap-it:0.1.1": wrap-content
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#let conf(title: none, authors: (), date: none, language: "en", content) = {
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

  // Plugins
  show: codly-init.with()
  codly(languages: codly-languages)

  show quote.where(block: true): block.with(stroke: (
    left: 1pt + gray,
    rest: none,
  ))

  show raw.where(block: false): r => {
    highlight(
      fill: rgb("#D3D3D3"),
      extent: 0.1em,
      top-edge: 1em,
      bottom-edge: -0.3em,
      r,
    )
  }

  set text(lang: language, size: 1em)

  // Content
  content
}
