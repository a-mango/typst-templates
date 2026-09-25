# HES-SO presentation template

*En français : [README.fr.md](README.fr.md).*

A [Typst](https://typst.app) slide template (built on
[Touying](https://touying-typ.github.io/)) in HES-SO colours. Self-contained:
`typst` is the only requirement; an optional `justfile` automates the variants
(`just all`, `just handout`, `just pdfpc`, …).

## Starting a presentation

1. Copy the whole folder (`presentation.typ`, `theme/`, `assets/`).
2. Edit the **settings** at the top of `presentation.typ` (title, author,
   date, …), then the content below them.
3. Compile:

   ```bash
   typst compile presentation.typ            # → presentation.pdf
   typst watch presentation.typ              # live preview
   ```

### Alternative: `typst init` (local package, without copying the folder)

Install the template once as a local package by linking this folder into
Typst's package directory:

```bash
ln -s /path/to/hes-so-slides/1.0.0 \
  ~/.local/share/typst/packages/local/hes-so-slides/1.0.0
```

(Not needed if the whole
[typst-templates](https://github.com/a-mango/typst-templates) repository is
already linked as the `@local` namespace.)

Every new deck is then created with:

```bash
typst init @local/hes-so-slides:1.0.0 my-deck
```

The generated project contains only `presentation.typ` (which imports
`@local/hes-so-slides:1.0.0`) and the `justfile`; the theme and the logos are
resolved from the package. After any change to the root `presentation.typ`, run
`just template` to regenerate its copy in `template/` (only the import line
differs).

## Demo deck

`demo.typ` is a presentation that uses every feature of the template (both slide
families, columns, callouts, tables, code, maths, pauses and reveals, animated
diagram, full-page slides, palette, logotypes, pdfpc notes, how to present on
Linux, appendices) and recalls on each slide the command that produces it. It is
deliberately pinned to the **light** configuration.

```bash
just demo             # → demo.pdf
just demo-handout     # → demo-handout.pdf (without the pauses)
typst watch demo.typ  # live preview
```

The file is a living reference: it is independent of `presentation.typ` (the
starting point for a real presentation) and is not shipped inside the
`typst init` template.

## Dark variant

Set `mode = "dark"` in the settings, or at compile time:

```bash
typst compile --input mode=dark presentation.typ presentation-dark.pdf
```

Everything follows: the callouts (`#info`, `#warning`, `#example`) take their
dark tints, code blocks switch to the `theme/hes-so-dark.tmTheme` highlighting
theme (Typst's light theme drops to 3.4:1 of contrast on a dark ground), and the
accents (`#hl`, links, `*bold*`) use the light brand blue, the only one that
stays above the WCAG AA threshold on `#1A1A1A`.

## Handout (no pauses)

To hand out the slides without the progressive reveals (`#pause`, animated
diagrams), set `handout = true` in the settings, or build both variants side by
side:

```bash
typst compile presentation.typ presentation.pdf
typst compile --input handout=true presentation.typ presentation-handout.pdf
```

## Language

Set `lang = "fr"` in the settings (or `--input lang=fr` at compile time) to
switch to French: it sets the text language (hyphenation, quotation marks) and
translates the fixed titles (“Outline” → « Sommaire », “Thank you!” → « Merci ! »).
The `title:` parameter of `#outline-slide` and `message:` of `#closing-slide`
still allow a custom label.

## Speaker notes (pdfpc)

Add invisible notes to the slides with `#speaker-note[…]`, then export them for
[pdfpc](https://pdfpc.github.io/) (presenter console: current slide, next slide,
notes, timer):

```bash
just pdfpc        # or:
typst eval 'query(<pdfpc-file>).first().value' --in presentation.typ > presentation.pdfpc
pdfpc presentation.pdf    # picks up presentation.pdfpc automatically
```

## Appendices

Slides placed after `#show: appendix` (backup slides for questions) are excluded
from the outline, the page counter and the progress bar. Use
`#heading(depth: 1, outlined: false)[…]` rather than `=` so the title stays out
of the outline.

## Layout

| Element                                    | Use                                                                                                                                                              |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `= Title` followed by content              | blue-bar content slide                                                                                                                                            |
| `#slide(title: […], align: top)[…]`        | content slide called by hand (title and alignment of your choice; several bodies → columns)                                                                       |
| `= Title` followed by `== …`               | large section-divider slide                                                                                                                                      |
| `== Title`                                 | blue-bar content slide                                                                                                                                            |
| `#title-slide()`                           | title page (HES-SO logo)                                                                                                                                        |
| `#outline-slide()`                         | automatic outline (`=` headings); `levels: (1, 2)` to include sub-headings, `max-count:` for the number of columns (3 by default), `fit: false` to disable the automatic shrink |
| `#focus-slide[…]`                          | full-page slide on the blue ground                                                                                                                                |
| `#dark-focus-slide[…]`                     | full-page slide on a dark ground (even in light mode)                                                                                                            |
| `#dark-title-slide()`                      | dark variant of the title page                                                                                                                                   |
| `#closing-slide(contact: …)`               | closing slide (“Thank you!”, « Merci ! » under `lang: "fr"`)                                                                                                                                       |
| `#hl[word]` / `#highlight[word]`           | bold + HES-SO blue highlight                                                                                                                                         |
| `#cols(columns: (1fr, 1fr))[…][…]`         | columns                                                                                                                                                          |
| `#fletcher-diagram(…)`                     | animatable [fletcher](https://typst.app/universe/package/fletcher/) diagram: a `pause` between elements reveals them one step at a time (see the “Animated diagram” slide) |
| `#image-slide("photo.jpg", title: […])`    | full-screen image, title overlaid (also accepts content)                                                                                                         |
| `#info[…]` / `#warning[…]` / `#example[…]` | callouts (grey / blue / outlined), `title:` optional                                                                                                              |
| `#speaker-note[…]`                         | speaker note (invisible, exported through pdfpc)                                                                                                                 |
| `#show: appendix`                          | backup slides, outside the numbering                                                                                                                             |

Tables (`#table`), figure captions and external links are styled automatically
in the brand colours. As in every Touying theme, bold `*word*` is rendered like
`#hl` (bold + blue); to get a neutral bold back, pass
`config-common(show-strong-with-alert: false)` to `hes-so-theme`.

The theme deliberately sticks to the progress bar, the section dividers and the
outline: if you also want the per-section navigation bar of the
Metropolis/Dewdrop themes, Touying's `components.mini-slides` and
`components.progressive-outline` remain available from your `presentation.typ`.

An overlong outline no longer spills silently onto a second page:
`#outline-slide` spreads the entries over columns and then, if needed, shrinks
the type (floor at 0.6em).

## Visual identity

- Blue `#1B619A` and warm gray `#AA9F93` (`beige`, decoration only), sampled
  from the official HES-SO logotype.
- Typeface: **Helvetica Neue** (text/headings), with **Noto Sans** as the
  fallback on machines that lack it; a monospace for code and Typst's default
  maths serif (**New Computer Modern Math**) for formulas. Customisable through
  the `fonts` setting of `presentation.typ`, e.g. `#let fonts = (body: "Inter",
  heading: "Inter", mono: "JetBrains Mono", math: "Fira Math")` (every key is
  optional; the missing ones keep their default).
- HES-SO logos in `assets/logo/`, served by `hes-so-logo(mode: …, assets)`:
  `mode: "light"` gives the blue + warm gray mark, `"dark"` the white + warm gray
  one (the blue drops to 2.7:1 on a dark ground) and `"white"` the all-white one
  (blue header bar, closing slide).

## Accessibility (PDF/UA)

Typst tags PDFs by default; the template is built to pass PDF/UA-1 validation:

```bash
typst compile --pdf-standard ua-1 presentation.typ
```

The theme's logos already carry their alternative text. Giving one to **your**
images and equations is up to you — without it, validation fails:

```typ
#image("diagram.png", alt: "Three-layer system architecture")
#figure(rect(…), alt: "…", caption: [Diagram])
#math.equation(block: true, alt: "Sum of the integers from 1 to n", $sum_(i=1)^n i$)
```

(Without `--pdf-standard ua-1`, a missing `alt` raises no error: the PDF stays
tagged, simply not conformant.)
