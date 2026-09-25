#let conf(title: none, author: none, institution: none, date: none, content) = {
  set page(columns: 2)
  set page(margin: (y: 12mm, x: 8mm))
  set columns(gutter: 8pt)
  set par(justify: true)

  set document(title: title)

  set page(
    header: [
      #title
      #h(1fr)
      #author
      #line(length: 100%, stroke: 0.5pt)
    ],
    footer: context [
      #line(length: 100%, stroke: 0.5pt)
      #date
      #h(1fr)
      #counter(page).display("1/1", both: true)
    ],
  )

  show "->": $->$
  show list: it => {
    it.children.map(child => child.body).join(" / ")
  }
  show terms: it => {
    it.children.map(child => [*#child.term* #child.description]).join(" • ")
  }
  show heading: it => {
    grid(
      inset: 0em,
      columns: (auto, 1fr),
      align: horizon + right,
      text[#it], line(length: 99%, stroke: 0.1pt),
    )
  }

  content
}
