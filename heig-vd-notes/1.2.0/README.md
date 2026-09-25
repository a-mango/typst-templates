# HEIG-VD notes

A [Typst](https://typst.app) template for personal HEIG-VD course notes. It
lays out a running header with the HEIG-VD logo and the title, a footer with
the date and page count, code highlighting via
[codly](https://typst.app/universe/package/codly/), and a few compact show
rules meant for fast note-taking rather than a polished document.

## Starting a set of notes

```bash
typst init @local/heig-vd-notes:1.2.0 my-notes
cd my-notes && typst compile notes.typ
```

That gives you `notes.typ`, a complete working example, and an empty `assets/`
folder for images and other files the notes pull in. The layout and the logo
are resolved from the package, so there is nothing else to copy.

If the repository is not yet installed as Typst's `@local` namespace, run `just`
at the root of this repository first.

Notes can equally be a lone `.typ` file anywhere on disk:

```typst
#import "@local/heig-vd-notes:1.2.0": *

#show: conf.with(
  title: [Ordonnancement temps réel],
  date: datetime.today().display("[day].[month].[year]"),
  authors: (
    (name: "…", affiliation: "HEIG-VD", email: "…@heig-vd.ch"),
  ),
)
```

## `#conf`

| Parameter  | Use                                                     |
| ---------- | -------------------------------------------------------- |
| `title`    | document title, also shown in the running header          |
| `date`     | printed in the footer                                     |
| `authors`  | **always an array**, even for a single author              |
| `language` | Typst's own text language, e.g. `"fr"` (default) or `"en"` |

`authors` is passed straight to `.map()`, so a single author must still be
wrapped in an array — `(( name: …, affiliation: …, email: … ),)` — not a bare
dictionary. Up to three authors are laid out side by side.

`language` sets hyphenation, quotation marks and Typst's own supplements, the
same as the `lang` parameter elsewhere in this repository. The footer's page
count, `Page 1 sur 2`, is a fixed French string and does not follow it.

## What the template gives you

Beyond `#conf`, importing the package re-exports:

- [codly](https://typst.app/universe/package/codly/) and
  [codly-languages](https://typst.app/universe/package/codly-languages/),
  already initialized — fenced code blocks are numbered and colored by
  language out of the box;
- [wrap-it](https://typst.app/universe/package/wrap-it/)'s `#wrap-content`, to
  flow text around a figure;
- a block quote style (a plain left rule) and inline code highlighted with a
  light gray background.

## Maintaining the template

`template/` is what `typst init` copies; it is generated, never edited by hand.
After changing `notes.typ` in this folder, run:

```bash
just
```

That is all the `justfile` here does. It is maintainer tooling for this
repository; notes themselves need nothing but `typst`.
