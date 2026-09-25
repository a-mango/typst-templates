# HEIG-VD practical work handout

A [Typst](https://typst.app) template for practical work (TP) handouts, in
HEIG-VD colors. One source file produces two PDFs:

| File                    | Built by                | Contents                                                        |
| ----------------------- | ----------------------- | --------------------------------------------------------------- |
| `handout.pdf`           | `just` / `just student` | what you hand to the students                                    |
| `handout-solutions.pdf` | `just solutions`        | the same, with the answers, and `CORRIGÉ` stamped in the header  |

## Starting a handout

```bash
typst init @local/heig-vd-handout:1.0.0 tp3
cd tp3 && just
```

That gives you `handout.typ` (a complete working example) and the `justfile`.
The template itself, the logo and the callouts are resolved from the package, so
there is nothing else to copy.

If the repository is not yet linked as Typst's `@local` namespace:

```bash
ln -s /path/to/heig-vd-handout/1.0.0 \
  ~/.local/share/typst/packages/local/heig-vd-handout/1.0.0
```

A handout can equally be a lone `.typ` file anywhere on disk:

```typst
#import "@local/heig-vd-handout:1.0.0": *

#show: conf.with(
  title: [TP 3 — Allocation dynamique],
  subtitle: [Programmation système],
  date: datetime.today().display("[day].[month].[year]"),
  authors: (name: "…", affiliation: "HEIG-VD", email: "…@heig-vd.ch"),
)
```

`institution:` is set above the title; leave it out to omit it. `outline: true`
adds a table of contents after the title block, with a heading translated by
`lang` and `outline-depth:` (2 by default) fixing how deep it goes.

`name` is the only field an author needs. `affiliation` and `email` are
optional, and so is `role`: pass `"professor"` or `"assistant"` for a label
translated with `lang`, or any text of your own for a title those two do not
cover. `gender:` is `"f"` or `"m"` and declines the French form — *Professeure*,
*Assistante* — while English has a single form for both. The role is set above
the name, in smaller gray type.

Outgoing links are set in blue and underlined. Internal references, including
the entries of the table of contents, keep the text color, so a `#outline()`
does not come out blue. Body text is justified and hyphenated in the document's
language, and lists are stepped in from it.

Paragraphs are set the French academic way: a first-line indent marks the new
paragraph, so there is no blank line between them and consecutive paragraphs run
on. The indent is applied automatically except where it would be wrong:

| Situation | Indent |
| --- | --- |
| A paragraph between two other paragraphs | yes, automatically |
| A paragraph opening a section, a part or a box | no, automatically |
| The line introducing a list | no — wrap it in `#flush[…]` |
| A closing line standing alone at the end | no — wrap it in `#flush[…]` |

The last two need marking because a Typst show rule cannot look ahead at what
follows a paragraph, so nothing in the template can tell that a list is coming.

## Questions and answers

Two macros carry the whole handout. `#question` numbers the question and shows
it in both PDFs; `#answer` is **dropped** from the student one — dropped, not
hidden, so no trace of it reaches their PDF, as `pdftotext handout.pdf` will
confirm. `#manipulation` is `#question`'s twin for what the students *do*
rather than answer, counted separately.

```typst
== Taille des types

#question[
  Quelle est la valeur affichée par ce programme sur une machine x86-64 ?

  ```c
  printf("%zu\n", sizeof(struct { char c; int i; }));
  ```
]

#answer[
  Le résultat est *8* : le compilateur insère trois octets de rembourrage
  après le `char`.
]
```

Both counters restart at every level-1 heading and carry that heading's number,
so the first two items of part 2 are `Manipulation 2.1` and `Question 2.1`.
Manipulations are tinted green and questions gold, and neither box is allowed to
break across a page, so a statement is always read whole.
Either takes `points:` — a number renders as `3 pts` / `1 pt`, content is
shown as given, and `none` (the default) leaves the header bare. `#part` does
the same for a part's total: `#part(points: 12)[Structure du code]` replaces
`= Structure du code` and sets the total beside the title, without putting it in
the heading's body, so the table of contents lists the part on its own. `#answer`
takes `title:` for a box label of your own (`none` removes the title bar) and
`boxed: false` to render the answer as plain content.

### What must not go inside an `#answer`

Because the block is dropped rather than hidden, anything inside it that
advances a counter advances it **in the solutions version only**, and the two
PDFs stop agreeing on their numbering:

```typst
#answer[ #figure(rect[…], caption: [answer]) ]   // ← don't
#figure(rect[…], caption: [question])            // "Fig. 2" for the students,
                                                 // "Fig. 3" in the corrigé
```

So keep figures, numbered equations, numbered tables and headings in the
question, and put only the answer in the box. The question number itself is
safe: it is stepped by `#question`, which both PDFs render. A `<label>` inside
an `#answer` referenced from student-visible text is the harmless case: the
student build refuses to compile with `label <…> does not exist in the
document`.

## The solutions switch

It is the `solutions` parameter of `#conf`:

- `solutions: auto` (the default) follows `--input solutions=true` on the
  command line — this is what the justfile drives, and only the exact string
  `true` turns the answers on;
- `solutions: true` or `false` in the file overrides the command line, which is
  handy while drafting a corrigé but is the one way to hand out the answers by
  accident. `just check` catches it.

## Language

`lang: "fr"` (the default) or `"en"` on `#conf` sets the text language and the
template's own strings: `Question`, `Réponse`/`Answer`, the callout titles, the
`CORRIGÉ`/`SOLUTIONS` banner and the `Page 1 sur 2` / `Page 1 of 2` footer. A
handout is written in one language; anything else fails the build rather than
quietly mixing the two.

## `just` targets

```
just               # handout.pdf — the student version (default)
just solutions     # handout-solutions.pdf
just all           # both
just watch         # live preview of the student version
just watch-solutions
just check         # refuses a handout.pdf that carries answers (needs poppler-utils)
just verify        # just all, then just check
just clean
```

Run `just check` before handing the PDF out: it fails if `handout.pdf` carries
the banner, i.e. if the file about to reach the students holds the answers. It
reads the PDF sitting on disk and does not rebuild it, so a stale file left over
from an earlier `solutions: true` is caught too; `just verify` is the
rebuild-then-check pass. It also prints the size of both versions; equal sizes
only warn, since that is the normal state while the answers are still unwritten.

## What the template gives you

| Function                                      | Use                                                                  |
| --------------------------------------------- | -------------------------------------------------------------------- |
| `#conf(…)`                                     | page layout, title block, optional outline, headings                  |
| `#part(points: …)[…]`                          | a level-1 heading with a points total, kept out of the outline        |
| `#question(points: …)[…]`                      | a numbered question (gold), in both PDFs                              |
| `#manipulation(points: …)[…]`                  | a numbered manipulation (green), counted separately                   |
| `#answer(title: …, boxed: …)[…]`               | its answer: green box in the corrigé, nothing in the handout           |
| `#info[…]` `#tip[…]` `#warning[…]` `#note[…]`  | callouts (blue / teal / red / gray), `title:` optional                |
| `#flush[…]`                                    | a paragraph set flush left, against the automatic indent              |
| `#is-solutions()`                              | the switch itself, inside a `context` block                           |
| `#heig-red`                                    | the brand red (Pantone 485 C)                                         |

The callouts are thin wrappers over
[colorful-boxes](https://typst.app/universe/package/colorful-boxes/), which is
re-exported whole: `#colorbox`, `#colorbox-rounded`, `#outline-colorbox`,
`#slanted-colorbox`, `#stickybox` and `#box-colors` are available for anything
the four do not cover. Code blocks go through
[codelst](https://typst.app/universe/package/codelst/); call `#sourcecode` by
hand to change a block's options, and note that `#sourcefile` wants a file's
*contents* rather than its path — `#sourcefile(read("main.c"), file: "main.c")`.

## Maintaining the template

`template/` is what `typst init` copies; it is generated, never edited by hand.
After changing `handout.typ` or the `justfile` in this folder, run:

```bash
just template
```

`handout.typ` already imports the package by name, so it is copied over as is;
the `justfile` is copied without its packaging section.
