#import "@preview/colorful-boxes:1.4.3": box-colors, colorbox
#import "@preview/showybox:2.0.3": showybox

// The frame every box shares: thin and square-cornered, set in one place.
#let frame-radius = 0pt
#let frame-stroke = 0.5pt

#let cbox = (title: none, color: "default", body) => colorbox(
  title: title,
  color: color,
  radius: frame-radius,
  stroke: frame-stroke,
  width: 100%,
  body,
)

#let BOX = body => cbox(body)

#let BOXED = (title, body) => cbox(title: title, body)

#let TODO = content => cbox(title: "TODO", color: "blue", content)

#let WARN = body => cbox(title: "ATTENTION", color: "red", body)

#let INFO = body => cbox(color: "green", body)

#let RED = body => cbox(title: "ATTENTION", color: "red", body)

#let GREEN = body => cbox(color: "green", body)

#let example = (title: "Exemple", body) => cbox(title: title, color: "purple", body)

// Numbered mathematical environments. `kind` names the environment, `ctr` counts
// it and `name` is the optional parenthetical. The header spans the box: kind
// and name flush left, number flush right. Call it directly to add another kind.
#let mathbox = (kind, color, ctr, name, body) => {
  let palette = box-colors.at(color, default: box-colors.default)
  ctr.step()
  showybox(
    title: context {
      [#kind]
      if name != none [ (#name)]
      h(1fr)
      [#ctr.get().first()]
    },
    breakable: true,
    frame: (
      title-color: palette.stroke,
      body-color: palette.fill,
      border-color: palette.stroke,
      radius: frame-radius,
      thickness: frame-stroke,
      body-inset: 8pt,
    ),
    title-style: (
      color: white,
      weight: "bold",
      sep-thickness: frame-stroke,
      boxed-style: none,
    ),
    body-style: (align: left, color: black),
    width: 100%,
    body,
  )
}

// Exported so a document can restart a sequence: `#theorem-counter.update(0)`.
#let theorem-counter = counter("theorem")
#let definition-counter = counter("definition")

#let theorem = (name: none, body) => mathbox("Théorème", "indigo", theorem-counter, name, body)

#let definition = (name: none, body) => mathbox("Définition", "teal", definition-counter, name, body)

#let def = definition

// Inline highlights. `highlight()` paints behind text runs only, so an inline
// equation inside one lands in an unpainted gap and, inheriting the white fill,
// turns invisible. Each equation gets the same background, sized by a zero-width
// strut. Both the band and the strut pin the same text edges on purpose: the
// defaults of `highlight` and of `text` do not agree, which leaves a notch above
// every equation. Change one edge and you must change the other.
#let hl = (paint, content) => {
  let strut = box(width: 0pt, hide(text(top-edge: "ascender", bottom-edge: "descender")[X]))
  show math.equation.where(block: false): it => box(
    fill: paint,
    { strut; text(fill: white, it) },
  )
  highlight(
    fill: paint,
    extent: 2pt,
    top-edge: "ascender",
    bottom-edge: "descender",
    text(fill: white, content),
  )
}

#let todo = content => box(
  inset: 0.5em,
  fill: blue,
  text(
    [*TODO*: #content],
    fill: white,
  ),
)

#let red = content => hl(rgb("#ff4136"), content)

#let green = content => hl(green, content)

#let blue = content => hl(blue, content)

#let arr = $->$
