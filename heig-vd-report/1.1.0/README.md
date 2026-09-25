# HEIG-VD report

A [Typst](https://typst.app) template for HEIG-VD course reports. It lays out
a title block, a running header with the HEIG-VD logo, and a footer carrying the
date and the page count.

## Starting a report

```bash
typst init @local/heig-vd-report:1.1.0 my-report
cd my-report && typst compile report.typ
```

That gives you `report.typ`, a complete working example, and an empty `assets/`
folder for images and other files the report pulls in. The layout and the logo
are resolved from the package, so there is nothing else to copy.

If the repository is not yet installed as Typst's `@local` namespace, run `just`
at the root of this repository first.

A report can equally be a lone `.typ` file anywhere on disk:

```typst
#import "@local/heig-vd-report:1.1.0": *

#show: conf.with(
  title: [Analyse d'un ordonnanceur temps réel],
  subtitle: [Systèmes embarqués avancés],
  date: datetime.today().display("[day].[month].[year]"),
  lang: "fr",
  authors: (
    name: "…",
    affiliation: "HEIG-VD",
    email: "…@heig-vd.ch",
  ),
)
```

## `#conf`

| Parameter   | Use                                                        |
| ----------- | ---------------------------------------------------------- |
| `title`     | document title, also shown in the running header           |
| `subtitle`  | line under the title                                       |
| `date`      | printed in the footer                                      |
| `authors`   | one dictionary, or an array of them for several authors    |
| `lang`      | `"fr"` (default) or `"en"`                                 |

An author is a dictionary of `name`, `affiliation` and `email`. A single one is
centered; several are laid out in up to three columns.

## Language

`lang: "fr"` (the default) or `"en"` sets the language Typst itself works in, so
hyphenation, quotation marks and Typst's own supplements follow it: a figure
caption reads `Tableau 1` in French and `Table 1` in English. It also picks the
page footer, `Page 1 sur 2` against `Page 1 of 2`. Any other value fails the
build rather than quietly leaving the document in the wrong language.

## Maintaining the template

`template/` is what `typst init` copies; it is generated, never edited by hand.
After changing `report.typ` in this folder, run:

```bash
just
```

That is all the `justfile` here does. It is maintainer tooling for this
repository; a report itself needs nothing but `typst`.
