// HEIG-VD practical work handout.
//
// One source file produces two PDFs: the one handed to the students and the
// one with the answers. Everything wrapped in `#answer[…]` is dropped from the
// first and rendered in the second; the switch is the `solutions` parameter of
// `#conf`, driven at compile time by `--input solutions=true` (see the
// justfile). Pick the language with the `lang` parameter of `#conf`.
#import "@preview/colorful-boxes:1.4.3": *
#import "@preview/codelst:2.0.2": code-frame, lineref, sourcecode, sourcefile

// HEIG-VD red (Pantone 485 C), sampled from the official logotype.
#let heig-red = rgb("#E1251B")

/// Ink for external links: dark enough to stay legible in print.
#let heig-link = rgb("#1A5FB4")

// First-line indent of a body paragraph, shared by `#conf` and the boxes.
#let _indent = 1em

// Fixed strings, one table per language the template can be set to.
#let handout-labels = (
  fr: (
    banner: "CORRIGÉ",
    page: "1 sur 1",
    contents: "Table des matières",
    question: "Question",
    manipulation: "Manipulation",
    answer: "Réponse",
    professor: "Professeur",
    professor-f: "Professeure",
    assistant: "Assistant",
    assistant-f: "Assistante",
    point: "pt",
    points: "pts",
    info: "Information",
    tip: "Conseil",
    warning: "Attention",
    note: "Remarque",
  ),
  en: (
    banner: "SOLUTIONS",
    page: "1 of 1",
    contents: "Contents",
    question: "Question",
    manipulation: "Task",
    answer: "Answer",
    professor: "Professor",
    professor-f: "Professor",
    assistant: "Assistant",
    assistant-f: "Assistant",
    point: "pt",
    points: "pts",
    info: "Information",
    tip: "Tip",
    warning: "Warning",
    note: "Note",
  ),
)

// `#conf` publishes its settings here so that `#question`, `#answer` and the
// callouts, which live in the body, can read them back.
#let _solutions = state("heig-vd-handout:solutions", false)
#let _lang = state("heig-vd-handout:lang", "fr")
// One counter per kind, both reset by `#conf` at every level-1 heading, so a
// manipulation and a question may share a number the way they did on paper.
#let _question-nr = counter("heig-vd-handout:question")
#let _manipulation-nr = counter("heig-vd-handout:manipulation")
// Set by `#part` for the level-1 heading that immediately follows it.
#let _part-points = state("heig-vd-handout:part-points", none)

#let _label(key) = (
  handout-labels.at(_lang.get(), default: handout-labels.en).at(key)
)

// `3 pts` / `1 pt` from a number, anything else as given. Needs `context`.
#let _points-badge(points) = if _solutions.get() {
  if points == none {
    none
  } else if type(points) in (int, float) {
    let unit = if points > 1 { _label("points") } else { _label("point") }
    text(size: 0.9em)[#points #unit]
  } else {
    text(size: 0.9em)[#points]
  }
}

/// A paragraph set flush left, against the automatic indent.
///
/// The indent marks a new thought, so it is wrong in two places a show rule
/// cannot detect on its own — Typst cannot look ahead at what follows a
/// paragraph: the line introducing a list, and a closing line standing on its
/// own at the end of a section.
#let flush(body) = {
  set par(first-line-indent: 0pt)
  body
}

/// Whether the answers are being rendered. Only usable inside `context`.
#let is-solutions() = _solutions.get()

// Color per kind, taken from colorful-boxes' palette so the statements sit in
// the same range as the callouts.
#let _task-colors = (
  manipulation: box-colors.green,
  question: box-colors.gold,
)

// Shared rendering for `#question` and `#manipulation`: a framed block whose
// header carries the kind, the number and the points. Kept on one page: a
// statement split across a page break is easy to answer half of.
#let _task(kind, nr, points, body) = {
  nr.step()
  let palette = _task-colors.at(kind, default: (
    stroke: luma(60%),
    fill: luma(94%),
  ))
  block(
    width: 100%,
    above: 1.2em,
    below: 1em,
    stroke: 0.5pt + palette.stroke,
    radius: 2pt,
    clip: true,
    breakable: false,
    {
      // `below`/`above` zeroed: the default spacing between two sibling blocks
      // stacks on top of the insets and reads as a gap under the header.
      block(
        width: 100%,
        fill: palette.fill,
        inset: (x: 0.8em, y: 0.5em),
        below: 0pt,
        context {
          // `1.2` under a numbered level-1 heading, plain `2` without one.
          let section = counter(heading).get()
          let n = nr.get().first()
          let label = if section.len() > 0 and section.first() > 0 {
            numbering("1.1", section.first(), n)
          } else {
            numbering("1", n)
          }
          grid(
            columns: (1fr, auto),
            align: (left, right + horizon),
            smallcaps(strong[#_label(kind) #label]), _points-badge(points),
          )
        },
      )
      block(
        width: 100%,
        above: 0pt,
        inset: (x: 0.8em, top: 0.6em, bottom: 0.7em),
        body,
      )
    },
  )
}

/// A level-1 heading carrying a points total.
///
/// The total is rendered beside the title but is not part of the heading's
/// body, so the table of contents lists the part without it. A plain `=` still
/// works and simply has no total.
///
/// - points (none, int, float, content): shown at the right of the heading.
#let part(points: none, body) = {
  _part-points.update(points)
  heading(level: 1, body)
  _part-points.update(none)
}

/// A numbered question — something the students write an answer to.
///
/// The number lives here rather than in `#answer`, so it counts the same in
/// both PDFs whatever the answers do. It restarts at every level-1 heading and
/// is prefixed by that heading's number.
///
/// - points (none, int, float, content): shown on the right of the header.
#let question(points: none, body) = _task(
  "question",
  _question-nr,
  points,
  body,
)

/// A numbered manipulation — something the students do rather than answer.
/// Counted separately from `#question`.
///
/// - points (none, int, float, content): shown on the right of the header.
#let manipulation(points: none, body) = _task(
  "manipulation",
  _manipulation-nr,
  points,
  body,
)

/// The answer to a question.
///
/// Rendered in the solutions build, dropped entirely from the student one —
/// dropped, not hidden, so no trace of it reaches the student PDF.
///
/// Dropping the block also drops the counter updates it contains, so a figure
/// or a heading placed inside it would be numbered in the solutions version
/// only and the two PDFs would disagree: keep numbered elements in the
/// question.
///
/// - title (auto, none, content): box title; `none` removes the title bar.
/// - boxed (bool): `false` renders the answer as plain content.
#let answer(title: auto, boxed: true, body) = context {
  if _solutions.get() {
    if boxed {
      colorbox(
        title: if title == auto { _label("answer") } else { title },
        color: "green",
        width: 100%,
        body,
      )
    } else {
      body
    }
  }
}

// Callouts, on top of colorful-boxes. Named so they do not shadow the package's
// own `colorbox`, `outline-colorbox`, `slanted-colorbox`, `stickybox`, …, which
// stay available for anything these four do not cover.
#let _callout(color, key, title, body) = context colorbox(
  title: if title == auto { _label(key) } else { title },
  color: color,
  width: 100%,
  body,
)

/// Neutral aside: context, reminder, reference.
#let info(title: auto, body) = _callout("blue", "info", title, body)

/// Advice that makes the exercise easier.
#let tip(title: auto, body) = _callout("teal", "tip", title, body)

/// Something that will cost the students time if they miss it.
#let warning(title: auto, body) = _callout("red", "warning", title, body)

/// Secondary remark.
#let note(title: auto, body) = _callout("gray", "note", title, body)

/// Handout layout.
///
/// - title (content, str): shown on the first page and in the page header.
/// - subtitle (content, str, none): course or lab series.
/// - institution (content, str, none): school or department, set above the
///   title.
/// - outline (bool): set a table of contents after the title block.
/// - outline-depth (int, none): deepest heading level it lists.
/// - authors (dictionary, array): a single author, or an array of them; each is
///   a dictionary with a `name` and, optionally, a `role`, a `gender`, an
///   `affiliation` and an `email`. `role` is `"professor"` or `"assistant"` for
///   the translated label, or any string or content to be used as given;
///   `gender` is `"f"` or `"m"` and picks the French form of that label.
/// - date (content, str, none): shown in the page footer.
/// - lang (str): "fr" or "en"; sets the text language and the fixed strings.
/// - solutions (auto, bool): `auto` takes the value of `--input solutions=true`
///   (absent means `false`); an explicit boolean overrides the command line.
/// - numbering (str, none): heading numbering pattern.
#let conf(
  title: none,
  subtitle: none,
  institution: none,
  outline: false,
  outline-depth: 2,
  authors: (),
  date: none,
  lang: "fr",
  solutions: auto,
  numbering: "1.1",
  content,
) = {
  // `--input` values are always strings, and only "true" turns the answers on.
  let show-solutions = if solutions == auto {
    sys.inputs.at("solutions", default: "false") == "true"
  } else {
    solutions
  }
  // A typo would otherwise pass silently and hand out a PDF whose fixed strings
  // are in the wrong language.
  assert(
    lang in handout-labels,
    message: "unknown language \""
      + lang
      + "\", expected one of ("
      + handout-labels.keys().join(", ")
      + ")",
  )
  let labels = handout-labels.at(lang)

  // Read back by `#question`, `#answer` and the callouts further down the
  // document. The header and the footer use `show-solutions`/`labels` directly
  // instead: a state read at a page boundary would be ambiguous.
  _solutions.update(show-solutions)
  _lang.update(lang)

  set text(lang: lang, hyphenate: true)
  set par(justify: true)
  // Only outgoing links are tinted: an outline entry is a link too, and a blue
  // underlined table of contents is not what anyone means by "style the links".
  show link: it => if type(it.dest) == str {
    underline(text(fill: heig-link, it))
  } else {
    it
  }
  set heading(numbering: numbering)

  set page(
    header: {
      set par(first-line-indent: 0pt)
      grid(
        columns: (1fr, 1fr),
        row-gutter: 5pt,
        align: (left, right),
        image("logo.svg", height: 20pt),
        align(horizon)[
          #title
          #if show-solutions [
            #h(0.5em) #text(fill: heig-red, weight: "bold", labels.banner)
          ]
        ],
        grid.cell(colspan: 2)[ #line(length: 100%, stroke: 0.5pt) ],
      )
    },
    footer: {
      // Without this the date starts one indent in, away from the rule above it.
      set par(first-line-indent: 0pt)
      context [
        #line(length: 100%, stroke: 0.5pt)
        #date
        #h(1fr)
        Page #counter(page).display(labels.page, both: true)
      ]
    },
  )

  if institution != none {
    align(center, text(12pt, institution))
  }
  align(center, text(17pt, title))
  align(center, text(15pt, subtitle))
  if show-solutions {
    align(center, text(12pt, fill: heig-red, weight: "bold", labels.banner))
  }
  linebreak()

  // `name` is the only required field: a cover that lists a teaching team
  // without addresses is as valid as one with them. `role` takes "professor" or
  // "assistant" for the translated label, declined by `gender`, or any string or
  // content of your own for a title the two keys do not cover.
  let author-role(role, gender) = {
    assert(
      gender in (none, "f", "m"),
      message: "unknown gender \""
        + repr(gender)
        + "\", expected \"f\" or \"m\"",
    )
    if role in ("professor", "assistant") {
      // French declines both titles; English has one form, so both keys match.
      labels.at(if gender == "f" { role + "-f" } else { role })
    } else {
      role
    }
  }

  let author-card(author) = {
    let lines = ()
    if "role" in author {
      let role = author-role(author.role, author.at("gender", default: none))
      lines.push(text(size: 0.9em, fill: luma(35%), role))
    }
    lines.push(author.name)
    if "affiliation" in author { lines.push(author.affiliation) }
    if "email" in author { lines.push(link("mailto:" + author.email)) }
    lines.join(linebreak())
  }

  if type(authors) == dictionary {
    // Handle single author case
    grid(
      columns: (1fr,),
      align: center,
      row-gutter: 24pt,
      author-card(authors),
    )
  } else {
    // Handle multiple authors case
    let ncols = calc.min(authors.len(), 3)
    grid(
      columns: (1fr,) * ncols,
      align: center,
      row-gutter: 24pt,
      ..authors.map(author-card)
    )
  }

  show heading: set block(above: 1.4em, below: 0.8em)
  show heading.where(level: 1): it => {
    _question-nr.update(0)
    _manipulation-nr.update(0)
    context {
      let total = _part-points.get()
      if total == none {
        it
      } else {
        grid(
          columns: (1fr, auto),
          align: (left, right + horizon),
          it, _points-badge(total),
        )
      }
    }
  }
  // Fenced code blocks get codelst's frame and line numbers. Call `#sourcecode`
  // by hand for a block that wants different options (`numbering: none` on a
  // one-liner, `highlighted: (3, 4)`, `showrange:` on an excerpt).
  show raw.where(block: true): it => sourcecode(it)

  v(1em)
  set align(left)
  // Body typography, set here rather than above so the centered title block is
  // left alone: a first line set in from the margin, and lists stepped in from
  // the text so they read as a unit rather than as more paragraphs.
  // French academic setting: the indent, not a blank line, marks a new
  // paragraph, so paragraphs are spaced exactly one leading apart and run on.
  // `all: false` keeps the opening paragraph of a section or a box flush, and
  // indents the ones that follow it.
  set par(
    leading: 0.65em,
    spacing: 0.65em,
    first-line-indent: (amount: _indent, all: false),
  )
  set list(indent: _indent)
  set enum(indent: _indent)

  // `outline` the parameter shadows `outline` the element, hence `std`.
  if outline {
    std.outline(title: labels.contents, depth: outline-depth)
  }

  content
}
