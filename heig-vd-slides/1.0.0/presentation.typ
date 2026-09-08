// HEIG-VD presentation template. Copy the whole folder, then edit this file.
// Compile: typst compile presentation.typ   (live preview: typst watch)
// Variants: --input mode=dark, --input lang=fr, --input handout=true
#import "theme/lib.typ": *
#import "@preview/touying:0.7.4": *
#import "@preview/fletcher:0.5.8" as fletcher: node, edge

// Touying reducer: allows `pause` inside a fletcher diagram, hiding
// not-yet-shown elements via `fletcher.hide`.
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

// Settings (edit these).
#let title        = [Presentation title]
#let subtitle     = [Subtitle or course name]      // set to `none` to hide
#let author       = "First Last"                   // string: also used for the PDF metadata
#let date         = datetime.today()               // or e.g. datetime(year: 2026, month: 6, day: 9)
#let institution  = [HEIG-VD]                       // set to `none` to hide
#let contact      = [first.last\@heig-vd.ch]       // shown on the closing slide (escape the @)
#let format       = "16-9"                          // "16-9", "16-10" or "4-3"
#let mode         = "light"                         // "light" or "dark"
#let lang         = "en"                            // "en" or "fr": text language + fixed titles
#let handout      = false                           // true: no pauses, one page per slide (for sharing)
#let fonts        = (:)                             // e.g. (body: "Inter", mono: "JetBrains Mono", math: "Fira Math")

// Compile-time --input flags override the variables above.
#let mode = sys.inputs.at("mode", default: mode)
#let lang = sys.inputs.at("lang", default: lang)
#let handout = sys.inputs.at("handout", default: repr(handout)) == "true"
#let assets = heig-assets()  // paths relative to the theme/ folder

// PDF metadata (document properties of the exported file).
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

// Content starts here.

#title-slide()

// Lists level-1 (`=`) headings only.
#outline-slide()

// `=` directly followed by content → red-bar content slide.
// `=` followed by `==` sub-headings → section-divider slide, then sub-slides.
// Highlight in bold + HEIG-VD red: #highlight[word] or #hl[word].
// Explicit slide: #slide(title: [Title], align: top + left)[…] (slides are
// vertically centered by default; several bodies are laid out as columns).

= Introduction

A "short" section: content placed directly under the `=` produces a red-bar
slide.

- The official HEIG-VD red is #hl[Pantone 485 C].
- `#pause` reveals the content step by step.

#pause

This content appears after the pause.

= Main part

== First subsection

A `=` heading followed by `==` sub-headings produces a large section divider,
and each `==` then becomes a content slide.

#cols(columns: (1fr, 1fr), gutter: 1em)[
  Left column: text, lists, equations.
][
  Right column: figures, tables, code.
]

== Code example

```python
def fibonacci(n):
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a
```

== Table and callouts

// Speaker notes are invisible on the slides; export them with `just pdfpc`.
#speaker-note[A note for the speaker, visible only in the pdfpc export.]

#cols(columns: (1fr, 1fr), gutter: 1.5em)[
  #figure(
    table(
      columns: (auto, 1fr),
      table.header[Year][Students],
      [2024], [120],
      [2025], [135],
      [2026], [142],
    ),
    caption: [Tables follow the brand guidelines.],
  )
][
  #info(title: [Info])[Neutral callout: `#info`, plus `#warning` and `#example`.]
  #v(0.5em)
  #warning(title: [Warning])[Red callout for a critical point.]
]

== Animated diagram

With `#fletcher-diagram`, a `pause` placed between the elements of a
#link("https://typst.app/universe/package/fletcher/")[fletcher] diagram reveals
them one step at a time:

#v(1em)
#align(center, fletcher-diagram(
  // Red outline, no fill, gray arrows: legible in light and dark mode.
  node-stroke: 0.08em + heig-colors.red,
  edge-stroke: 0.06em + heig-colors.gray,
  node-corner-radius: 0.3em,
  node-inset: 0.8em,
  spacing: (4em, 3em),
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

#focus-slide[One idea worth keeping]

// Pass a file path instead, e.g. #image-slide("assets/photo.jpg", title: [...]).
#image-slide(
  rect(width: 100%, height: 100%, fill: gradient.linear(angle: 45deg, heig-colors.red-darkest, heig-colors.red)),
  title: [`#image-slide`: full-screen image, title overlaid],
)

= Conclusion

- Recap of the key points.
- Outlook and next steps.

#closing-slide(contact: contact)

// Backup slides: excluded from the outline, slide count and progress bar.
#show: appendix

#heading(depth: 1, outlined: false)[Appendix]

A backup slide for questions: after `#show: appendix`, the numbering and the
progress bar stop at the closing slide.
