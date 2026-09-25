# HES-SO summary

A [Typst](https://typst.app) template for compact HES-SO lesson summaries. It
lays out a two-column page with a light header and footer, and a few show
rules that trade prose formatting for density: bullet and term lists collapse
onto a single line instead of stacking.

## Starting a summary

```bash
typst init @local/hes-so-summary:1.0.0 my-summary
cd my-summary && typst compile summary.typ
```

That gives you `summary.typ`, a complete working example, and an empty
`assets/` folder for images and other files the summary pulls in. The layout is
resolved from the package, so there is nothing else to copy.

If the repository is not yet installed as Typst's `@local` namespace, run `just`
at the root of this repository first.

A summary can equally be a lone `.typ` file anywhere on disk:

```typst
#import "@local/hes-so-summary:1.0.0": *

#show: conf.with(
  title: [Ordonnancement temps réel],
  author: [Aubry Mangold],
  date: datetime.today().display("[day].[month].[year]"),
)
```

## `#conf`

| Parameter     | Use                                                  |
| ------------- | ----------------------------------------------------- |
| `title`       | document title, also shown in the running header        |
| `author`      | a single name or piece of content, shown in the header   |
| `institution` | accepted, but **not rendered** by this template           |
| `date`        | printed in the footer                                    |

`author` is singular content, not a dictionary — unlike `hes-so-report` and
`hes-so-notes`, this template has no notion of affiliation or email, and no
support for several authors.

## Show rules to know about

Written for density, not prose, so a few defaults differ from a plain Typst
document:

- `->` typed as plain text is replaced with the `$->$` arrow;
- a bullet list (`- …`) is flattened onto one line, joined by ` / `, instead of
  stacking one item per line;
- a term list (`/ term: …`) is flattened the same way, as `*term* description`
  pairs joined by ` • `;
- a heading is set flush left with a thin rule filling the rest of the line, in
  place of the usual heading spacing.

If you need an ordinary multi-line list, reach for `#enum` or wrap the items in
your own show rule rather than the bare `-`/`/` syntax this template rewrites.

## Maintaining the template

`template/` is what `typst init` copies; it is generated, never edited by hand.
After changing `summary.typ` in this folder, run:

```bash
just
```

That is all the `justfile` here does. It is maintainer tooling for this
repository; a summary itself needs nothing but `typst`.
