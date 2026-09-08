// Demonstration of the HEIG-VD presentation template: this deck uses every
// feature of the theme and, on each slide, names the command that produces it.
// Compile: typst compile demo.typ   (or `just demo`, live preview: typst watch demo.typ)
//
// The demo is deliberately pinned to the LIGHT configuration (`mode = "light"`).
// The other variants (dark, French) are driven from `presentation.typ`; the
// "Deck settings" slide sums them up.
#import "theme/lib.typ": *
#import "@preview/touying:0.7.4": *
#import "@preview/fletcher:0.5.8" as fletcher: edge, node

// Touying reducer: allows `pause` inside a fletcher diagram, hiding
// not-yet-shown elements via `fletcher.hide`.
#let fletcher-diagram = touying-reducer.with(
  reduce: fletcher.diagram,
  cover: fletcher.hide,
)

// Demo settings.
#let title = [Template demonstration]
#let subtitle = [A tour of the HEIG-VD theme]
#let author = "First Last"
#let date = datetime(year: 2026, month: 9, day: 2)  // fixed date: reproducible PDF
#let institution = [HEIG-VD]
#let contact = [first.last\@heig-vd.ch]
#let format = "16-9"
#let mode = "light"
#let lang = "en"
#let handout = sys.inputs.at("handout", default: "false") == "true"
#let fonts = (:)
#let assets = heig-assets()

#set document(title: title, author: author, date: date)

#show: heig-theme.with(
  mode: mode,
  lang: lang,
  handout: handout,
  assets: assets,
  aspect-ratio: format,
  fonts: fonts,
  config-info(
    title: title,
    subtitle: subtitle,
    author: author,
    date: date,
    institution: institution,
    logo: heig-logo(mode: mode, assets),
  ),
)

// Helper used by this demo only (the theme does not provide it): colour swatch.
#let swatch(name, col, ink: white) = block(
  width: 100%,
  height: 2.6em,
  fill: col,
  radius: 0.25em,
  stroke: 0.04em + heig-colors.gray-lighter,
  inset: 0.35em,
  align(bottom + left, text(size: 0.45em, fill: ink, raw(name))),
)

// Content.

#title-slide()

#outline-slide()

= Introduction

This demo deck walks through #hl[everything] the template can do: each slide
shows one feature and recalls the command behind it.

- Layouts, rich content, animations, visual identity.
- `#hl[…]`, `#highlight[…]` or plain `*bold*`: the red brand accent.
- A #link("https://touying-typ.github.io/")[Touying] theme in HEIG-VD colours.

#pause

Content placed directly under a `=` produces this red-bar slide, and `#pause`
reveals the rest step by step.

#speaker-note[
  Reminder: speaker notes are invisible here and are exported for pdfpc with
  `just demo-pdfpc` (`just pdfpc` for your own deck).
]

= Layout

== Slide families

#cols(columns: (1fr, 1fr), gutter: 1.5em, align: top)[
  *From headings*

  - `= Title` + content → red-bar slide.
  - `= Title` + `== …` → large section divider (the slide before this one).
  - `== Title` → content slide; the header picks up the current heading.
][
  *By explicit call*

  - `#slide(title: [Title])[…]` to set the header by hand.
  - `#slide(align: top + left)[…]` to re-frame a single slide (the deck is
    centred by default).
  - Several bodies → automatic columns: `#slide[left][right]`.
  - `#title-slide()`, `#outline-slide()`, `#closing-slide()` for the fixed slides.
]

#slide(title: [Explicitly called slide])[
  This slide comes from `#slide(title: [Explicitly called slide])[…]`: the same
  layout as a `==` slide, but with a hand-picked title.
][
  Two bodies passed to `#slide` are laid out in equal columns, with no grid to
  write.
]

== Columns

`#cols` takes as many bodies as you like, and one width per column.

#cols(columns: (2fr, 1fr, 1fr), gutter: 1.2em, align: top)[
  *2fr* — the wide column holds the main text, a figure or a block of code.
][
  *1fr* — a side column.
][
  *1fr* — notes, key figures, a caption.
]

#v(0.8em)

#info[
  `#cols(columns: (2fr, 1fr, 1fr), gutter: 1.2em)[…][…][…]`; add `align: top` to
  align the columns by the top rather than the middle.
]

== Callouts

#cols(columns: (1fr, 1fr), gutter: 1.2em, align: top)[
  #info(title: [Info])[Remark or definition.]
  #warning(title: [Warning])[Critical point.]
  #example(title: [Example])[Exercise or illustration.]
][
  #text(size: 0.85em)[The `title:` parameter is optional:]
  #info[`#info` with no title.]
  #warning[`#warning` with no title.]
  #example[`#example` with no title.]
]

== Tables and figures

#cols(columns: (1.1fr, 1fr), gutter: 1.5em, align: top)[
  #figure(
    table(
      columns: (auto, 1fr, auto),
      table.header[Year][Programme][Students],
      [2024], [Computer science], [120],
      [2025], [Computer science], [135],
      [2026], [Computer science], [142],
    ),
    caption: [Swiss style: red rule under the header, no vertical rules.],
  )
][
  #figure(
    rect(
      width: 100%,
      height: 4.2em,
      radius: 0.3em,
      fill: heig-colors.red-lightest,
      stroke: 0.05em + heig-colors.red,
      align(center + horizon, text(fill: heig-colors.red-darker)[Any figure]),
    ),
    alt: "Red demonstration frame standing in for a figure",
    caption: [Captions are greyed down and scaled automatically.],
  )
]

Plain Typst `#table` and `#figure` are styled by the theme: nothing to configure.

== Code and maths

#cols(columns: (1fr, 1fr), gutter: 1.5em, align: top)[
  ```python
  def fibonacci(n):
      a, b = 0, 1
      for _ in range(n):
          a, b = b, a + b
      return a
  ```

  Inline code: `git switch -c demo`.
][
  A block formula, with its alternative text for accessibility:

  #math.equation(
    block: true,
    alt: "Sum of the integers from 1 to n equals n times n plus 1 over 2",
    $sum_(i = 1)^n i = (n (n + 1)) / 2$,
  )

  and inline: #math.equation(alt: "big O of n log n", $cal(O)(n log n)$).
]

= Animations

== Pauses

`#pause` splits the slide into successive subslides.

#pause

This paragraph shows up second.

#pause

Then this one, on the same slide.

#v(0.6em)

#info[
  `--input handout=true` (or `handout = true`) ignores every pause and produces
  one page per slide, for handing out.
]

== Targeted reveals

Beyond `#pause`, Touying can target specific subslides.

#v(0.5em)

#cols(columns: (1fr, 1fr), gutter: 1.5em, align: top)[
  - `#uncover("2-")`: #uncover("2-")[reserves the space, then reveals.]
  - `#only("3")`: #only("3")[only exists on subslide 3.]
][
  `#alternatives` swaps one piece of content for another:

  #v(0.4em)
  #align(center, text(
    size: 1.4em,
    fill: heig-colors.red,
    weight: "bold",
    alternatives[One][Two][Three],
  ))
]

== Animated diagram

With `#fletcher-diagram`, a `pause` placed between the elements of a
#link("https://typst.app/universe/package/fletcher/")[fletcher] diagram reveals
them one step at a time:

#v(0.8em)
#align(center, fletcher-diagram(
  node-stroke: 0.08em + heig-colors.red,
  edge-stroke: 0.06em + heig-colors.gray,
  node-corner-radius: 0.3em,
  node-inset: 0.7em,
  spacing: (4.5em, 3em),
  node((0, 0), [Idea]),
  pause,
  edge((0, 0), (1, 0), "-|>", [write]),
  node((1, 0), [Slides]),
  pause,
  edge((1, 0), (2, 0), "-|>", [rehearse]),
  node((2, 0), [Talk]),
  pause,
  edge((2, 0), (0, 0), "-|>", [feedback], bend: 40deg),
))

= Full-page slides

== Three variants

- `#focus-slide[…]`: HEIG-VD red background, for one strong idea.
- `#dark-focus-slide[…]`: dark background, even inside a light deck.
- `#image-slide(img, title: […])`: full-screen image (a file path or any
  content), with the title overlaid.

#v(0.6em)

#example[None of them has a header, all keep the progress bar; the next three slides are examples.]

#focus-slide[One idea worth keeping]

#dark-focus-slide[
  `#dark-focus-slide`: the dark breath of a light deck.
]

#image-slide(
  rect(
    width: 100%,
    height: 100%,
    fill: gradient.linear(
      angle: 45deg,
      heig-colors.red-darkest,
      heig-colors.red,
    ),
  ),
  title: [`#image-slide`: full-screen image, title overlaid],
)

= Visual identity

== Colours

The `heig-colors` dictionary exposes the whole palette; the official red is
#hl[Pantone 485 C] (`#E1251B`).

#v(0.6em)

#grid(
  columns: 7,
  gutter: 0.4em,
  swatch("red-lightest", heig-colors.red-lightest, ink: heig-colors.charcoal),
  swatch("red-lighter", heig-colors.red-lighter, ink: heig-colors.charcoal),
  swatch("red-light", heig-colors.red-light, ink: heig-colors.charcoal),
  swatch("red", heig-colors.red),
  swatch("red-dark", heig-colors.red-dark),
  swatch("red-darker", heig-colors.red-darker),
  swatch("red-darkest", heig-colors.red-darkest),
)
#v(0.4em)
#grid(
  columns: 7,
  gutter: 0.4em,
  swatch("gray-lightest", heig-colors.gray-lightest, ink: heig-colors.charcoal),
  swatch("gray-lighter", heig-colors.gray-lighter, ink: heig-colors.charcoal),
  swatch("gray-light", heig-colors.gray-light, ink: heig-colors.charcoal),
  swatch("gray", heig-colors.gray),
  swatch("charcoal-light", heig-colors.charcoal-light),
  swatch("charcoal", heig-colors.charcoal),
  swatch("bg-dark", heig-colors.bg-dark),
)

== Logotypes

#cols(columns: (1fr, 1fr), gutter: 1.5em, align: top)[
  *The mark alone*

  #box(heig-logo(mode: "light", assets, height: 1.5em))
  #h(1.2em)
  #box(image(
    "assets/logo/heig-logotype-black.svg",
    alt: "Black HEIG-VD logotype",
    height: 1.5em,
  ))
  #h(1.2em)
  #box(block(
    fill: heig-colors.bg-dark,
    inset: 0.5em,
    radius: 0.25em,
    heig-logo(mode: "dark", assets, height: 1.5em),
  ))

  #text(size: 0.75em)[`heig-logo(mode: "light" / "dark", assets)`, and the black
    one straight from `assets/logo/`.]

  *The full lockup*

  #heig-logo(mode: "light", assets, baseline: true, width: 62%)

  #text(size: 0.75em)[`baseline: true` adds the school's full name.]
][
  *Parent institution*

  #heig-institutions(assets, height: 1.7cm)

  #text(size: 0.75em)[`heig-institutions(assets)`: the HES-SO mark from the
    title slide.]

  #v(0.6em)
  #info[Six SVG files (red, black, white — with and without the signature) in
    `assets/logo/`.]
]

== Typography

#cols(columns: (1fr, 1fr), gutter: 1.5em, align: top)[
  #text(size: 1.3em, weight: "bold")[Headings — Helvetica Neue]

  Body text — Helvetica Neue, a Swiss grotesque close to the brand.

  `Code — DejaVu Sans Mono`

  Maths — New Computer Modern

  Each family is a fallback chain (Helvetica Neue, then Noto Sans): the deck
  stays readable on a machine without the first choice.
][
  Swap them through the `fonts` setting (every key is optional):

  ```typ
  #let fonts = (
    body: "Inter",
    heading: "Inter",
    mono: "JetBrains Mono",
    math: "Fira Math",
  )
  ```
]

= Configuration

== Deck settings

#cols(columns: (1.1fr, 1fr), gutter: 1.5em, align: top)[
  #table(
    columns: (auto, 1fr),
    table.header[Setting][Values],
    [`format`], [`"16-9"`, `"16-10"`, `"4-3"`],
    [`mode`], [`"light"`, `"dark"`],
    [`lang`], [`"fr"`, `"en"`],
    [`handout`], [`true`: no pauses],
    [`fonts`], [`(body:, mono:, …)`],
  )
][
  The same settings can be forced at compile time, leaving the file untouched:

  ```bash
  typst compile --input mode=dark \
    demo.typ demo-dark.pdf
  ```

  #v(0.4em)
  Same for `lang=fr` or `handout=true`.
  For your own deck, `just all` builds
  all four variants in one go.
]

== Speaker notes

#speaker-note[
  This note does not show up on the slide: it is meant for the pdfpc console.
  Ideal for a script or for timing cues.
]

`#speaker-note[…]` adds an invisible note to any slide.

#v(0.5em)

```bash
just demo-pdfpc       # → demo.pdfpc
pdfpc demo.pdf        # presenter console
```

For your own deck the recipe is called `just pdfpc`.

#v(0.5em)

#info[The progress bar, the page counter and the header are handled by the
  theme; they can be switched off with `footer-progress`, `footer` and `header`.]

== Presenting on Linux

#cols(columns: (1fr, 1fr), gutter: 1.5em, align: top)[
  *pdfpc* — the presenter console: current and next slide, notes, timer.

  ```bash
  pdfpc demo.pdf        # two screens
  pdfpc -d 45 demo.pdf  # timer
  pdfpc -s demo.pdf     # swap screens
  pdfpc -S demo.pdf     # one screen
  pdfpc -W demo.pdf     # Wayland
  ```
][
  *Without a console*, any full-screen reader will do:

  - `okular --presentation demo.pdf`
  - `zathura --mode=presentation` (or #raw("F5"))
  - Papers / Evince (GNOME): #raw("F5")
  - Impressive: transitions and spotlight

  #v(0.4em)
  #info[Keep `demo.pdfpc` next to the PDF: that is where pdfpc reads the notes.]
]

#outline-slide(title: [Detailed outline], levels: (1, 2))

= Conclusion

- One file to edit, everything else follows the brand automatically.
- Backup slides live after `#show: appendix`, outside the numbering.
- Everything is documented in the template's `README.md`.
- The PDF validates as PDF/UA-1 (`typst compile --pdf-standard ua-1`) as long as
  your images and equations carry an `alt`.

#closing-slide(contact: contact, message: [Any questions?])

// Backup slides: excluded from the outline, the slide count and the progress bar.
#show: appendix

#heading(depth: 1, outlined: false)[Appendix — cheat sheet]

#cols(columns: (1fr, 1fr), gutter: 1.5em, align: top)[
  #set text(size: 0.8em)
  - `#slide(title:, align:)` — explicit slide
  - `#title-slide()` — title page
  - `#dark-title-slide()` — dark variant
  - `#outline-slide(title:, levels:, max-count:)` — outline
  - `#focus-slide[…]` — full-page red
  - `#dark-focus-slide[…]` — full-page dark
  - `#image-slide(img, title:)` — full-screen image
  - `#closing-slide(contact:, message:)` — closing
][
  #set text(size: 0.8em)
  - `#hl[…]` / `#highlight[…]` — bold red
  - `#cols(columns: …)[…][…]` — columns
  - `#info`, `#warning`, `#example` — callouts
  - `#pause`, `#uncover`, `#only`, `#alternatives`
  - `#fletcher-diagram(…)` — animatable diagram
  - `#speaker-note[…]` — pdfpc note
  - `#show: appendix` — backup slides
]

#heading(depth: 1, outlined: false)[Appendix — dark title slide]

`#dark-title-slide()` reuses the deck's information on a dark background; pass
it the white logotype so it stands out:
`logo: heig-logo(mode: "dark", assets)`.

#dark-title-slide(logo: heig-logo(mode: "dark", assets))
