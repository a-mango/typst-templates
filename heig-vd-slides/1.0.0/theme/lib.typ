#import "@preview/touying:0.7.4": *

// Brand colours
// HEIG-VD official red is Pantone 485 C ≈ #E1251B (sampled from the official
// logotype). The red ramp is derived from that single hue so the tints stay
// on-brand; the charcoal/gray scale is HEIG-VD's neutral black/gray.
#let heig-red = rgb("#E1251B")

#let heig-colors = (
  red: heig-red,
  red-light: heig-red.lighten(20%),
  red-lighter: heig-red.lighten(45%),
  red-lightest: heig-red.lighten(82%),
  red-dark: heig-red.darken(15%),
  red-darker: heig-red.darken(32%),
  red-darkest: heig-red.darken(50%),
  charcoal: rgb("#282828"),
  charcoal-light: rgb("#4A4A4A"),
  charcoal-lighter: rgb("#6D6E71"),
  charcoal-lightest: rgb("#A7A7A7"),
  gray: rgb("#6D6E71"),
  gray-light: rgb("#A7A7A7"),
  gray-lighter: rgb("#D8D8D8"),
  gray-lightest: rgb("#EEEEEE"),
  gray-dark: rgb("#4A4A4A"),
  gray-darker: rgb("#2A2A2A"),
  gray-darkest: rgb("#151515"),
  white: rgb("#FFFFFF"),
  black: rgb("#000000"),
  bg-dark: rgb("#1A1A1A"),
  bg-light: rgb("#FFFFFF"),
)

/// Ink for accents (alert/highlight, external links). The brand red reaches
/// 4.7:1 on white but only 3.7:1 on the dark background, so dark decks use the
/// lighter tint (4.7:1 on #1A1A1A) to stay above WCAG AA for body text.
#let heig-accent-ink(mode) = if mode == "dark" { heig-colors.red-light } else { heig-colors.red }

#let heig-light-palette = config-colors(
  primary: heig-colors.red,
  primary-light: heig-colors.red-light,
  primary-lighter: heig-colors.red-lighter,
  primary-lightest: heig-colors.red-lightest,
  primary-dark: heig-colors.red-dark,
  primary-darker: heig-colors.red-darker,
  primary-darkest: heig-colors.red-darkest,
  secondary: heig-colors.charcoal,
  secondary-light: heig-colors.charcoal-light,
  secondary-lighter: heig-colors.charcoal-lightest,
  secondary-lightest: heig-colors.gray-lightest,
  secondary-dark: heig-colors.charcoal-light,
  secondary-darker: heig-colors.charcoal,
  secondary-darkest: heig-colors.charcoal,
  neutral: heig-colors.gray,
  neutral-light: heig-colors.gray-lighter,
  neutral-lighter: heig-colors.gray-lightest,
  neutral-lightest: heig-colors.white,
  neutral-dark: heig-colors.gray-dark,
  neutral-darker: heig-colors.charcoal,
  neutral-darkest: heig-colors.charcoal,
  tertiary: heig-colors.red-light,
  tertiary-light: heig-colors.red-lighter,
  tertiary-lighter: heig-colors.red-lightest,
  tertiary-lightest: heig-colors.white,
  tertiary-dark: heig-colors.red,
  tertiary-darker: heig-colors.red-dark,
  tertiary-darkest: heig-colors.red-darkest,
)

#let heig-dark-palette = config-colors(
  primary: heig-colors.red,
  primary-light: heig-colors.red-light,
  primary-lighter: heig-colors.red-lighter,
  primary-lightest: heig-colors.red-lightest,
  primary-dark: heig-colors.red-dark,
  primary-darker: heig-colors.red-darker,
  primary-darkest: heig-colors.red-darkest,
  secondary: heig-colors.gray-light,
  secondary-light: heig-colors.gray-lighter,
  secondary-lighter: heig-colors.gray-lightest,
  secondary-lightest: heig-colors.bg-dark,
  secondary-dark: heig-colors.gray,
  secondary-darker: heig-colors.charcoal,
  secondary-darkest: heig-colors.gray-dark,
  neutral: heig-colors.gray-light,
  neutral-light: heig-colors.gray-dark,
  neutral-lighter: heig-colors.charcoal,
  neutral-lightest: heig-colors.bg-dark,
  neutral-dark: heig-colors.gray-light,
  neutral-darker: heig-colors.gray-lighter,
  neutral-darkest: heig-colors.white,
  tertiary: heig-colors.red-light,
  tertiary-light: heig-colors.red-lighter,
  tertiary-lighter: heig-colors.red-lightest,
  tertiary-lightest: heig-colors.bg-dark,
  tertiary-dark: heig-colors.red,
  tertiary-darker: heig-colors.red-dark,
  tertiary-darkest: heig-colors.red-darkest,
)



// Typography
// HEIG-VD's corporate typeface (Circular) is proprietary and not installed, so
// the deck defaults to Helvetica Neue for prose/headings — a clean Swiss
// grotesque that matches the institutional look — with Noto Sans as the backup
// on machines that lack it. Code blocks use a neutral monospace so that `raw`
// text stays aligned and legible.
// These are defaults: pass `fonts: (body: …, heading: …, mono: …)` to
// `heig-theme` to override any of them (a partial dict is fine).
// Each entry is a fallback chain so the deck degrades to a similar grotesque
// (instead of Typst's default serif) on machines missing the first choice.
#let heig-sans = ("Helvetica Neue", "Helvetica", "Noto Sans", "Liberation Sans", "Arial")
#let heig-fonts = (
  heading: heig-sans,
  body: heig-sans,
  mono: ("DejaVu Sans Mono", "Liberation Mono"),
  // Typst's default: New Computer Modern Math sets formulas better than any
  // sans math font, and the serif contrast reads as deliberate. Override with
  // `fonts: (math: "Fira Math")` for a fully grotesque deck.
  math: ("New Computer Modern Math",),
)



// Localization
// Fixed UI strings per supported language. The theme's `lang` option picks the
// set below AND becomes Typst's `text(lang: …)` (hyphenation, smart quotes).
// Unknown codes fall back to French.
#let heig-strings = (
  fr: (outline: [Sommaire], closing: [Merci !]),
  en: (outline: [Outline], closing: [Thank you!]),
)

#let heig-lang-strings(lang) = heig-strings.at(lang, default: heig-strings.fr)


// Assets
// The HEIG-VD logotype is a single mark in three colourways (red / black /
// white), each in a plain and a "baseline" variant (the latter carries the full
// school name "Haute École d'Ingénierie et de Gestion du Canton de Vaud").
// HES-SO is the parent institution shown on the title slide's partner row.
#let heig-assets(root: "../") = {
  let logo = root + "assets/logo/"
  (
    logo: (
      red: logo + "heig-logotype-red.svg",
      black: logo + "heig-logotype-black.svg",
      white: logo + "heig-logotype-white.svg",
      baseline-red: logo + "heig-logotype-baseline-red.svg",
      baseline-black: logo + "heig-logotype-baseline-black.svg",
      baseline-white: logo + "heig-logotype-baseline-white.svg",
    ),
    institutions: (
      hes-so: root + "assets/institutions/hes-so.png",
    ),
  )
}


#let accent-bar(self, width: 100%, height: 2pt) = block(
  width: width,
  height: height,
  fill: self.colors.primary,
)

/// 2pt progress bar placed along the bottom edge. `bg` is the slide's
/// background colour, used as the unfilled track so only the progress shows
/// (a hardcoded white track glares in dark mode). On the red primary
/// background the fill switches to white, since red-on-red would vanish.
#let heig-progress-bar(self, bg: auto) = {
  let bg = if bg == auto { self.colors.neutral-lightest } else { bg }
  let fill = if bg == self.colors.primary { white } else { self.colors.primary }
  place(bottom, components.progress-bar(height: 2pt, fill, bg))
}

/// HEIG-VD logotype, colour chosen from the slide's light/dark mode:
/// dark background → white mark, light background → red mark.
/// `baseline: true` uses the wide lockup that includes the full school name.
/// `alt: auto` derives the alt text from the variant; pass a string to override
/// it (alt text is what makes `--pdf-standard ua-1` pass).
#let heig-logo(mode: "light", assets, baseline: false, height: 1.5em, width: auto, alt: auto) = {
  let grp = assets.logo
  let path = if baseline {
    if mode == "dark" { grp.baseline-white } else { grp.baseline-red }
  } else {
    if mode == "dark" { grp.white } else { grp.red }
  }
  let alt = if alt != auto { alt } else if baseline {
    "Logotype HEIG-VD — Haute École d'Ingénierie et de Gestion du Canton de Vaud"
  } else {
    "Logotype HEIG-VD"
  }
  if width != auto { image(path, alt: alt, width: width) } else { image(path, alt: alt, height: height) }
}

/// Parent-institution mark (HES-SO) for the title slide. The HES-SO logo is a
/// fixed blue/gray colour mark, identical in light and dark mode — hence no
/// `mode` parameter, unlike `heig-logo`. The PNG ships with internal whitespace
/// padding, so the box is sized generously (1.5cm) for the visible mark to come
/// out at a legible size.
#let heig-institutions(assets, height: 1.5cm, alt: "Logo HES-SO") = {
  align(horizon, image(assets.institutions.hes-so, alt: alt, height: height))
}

/// `alert` method used by the theme: bold + primary colour (HEIG-VD red).
/// Flattens any nested `strong` so the extra weight doesn't stack past the
/// font's bold face.
#let heig-alert(self: none, body) = text(
  fill: heig-accent-ink(self.store.at("mode", default: "light")),
  weight: "bold",
  {
    show strong: it => it.body
    body
  },
)

/// Highlight words in bold + the deck's primary colour (HEIG-VD red), e.g.
/// `#highlight[mot]`. `hl` is a shorthand; `alert` is the underlying Touying
/// method. All three follow the active light/dark palette.
/// Note: this intentionally shadows Typst's built-in `highlight` (marker).
#let highlight = alert
#let hl = alert


// Callout boxes
/// Tinted box with a coloured left bar and an optional bold title.
///
/// `ink: auto` (the default) inherits the slide's text colour and `fill` is
/// meant to be a *translucent* tint: the same box then works on a light deck, a
/// dark deck and a `#focus-slide`, without the callout having to know the
/// theme's mode. That matters because these are plain functions with no access
/// to Touying's `self`, and wrapping them in `context` to read the mode would
/// break `#hl`/`#pause` inside them (Touying markers cannot cross a `context`).
#let callout(fill: none, bar: none, ink: auto, stroke: (:), title: none, title-ink: auto, body) = block(
  width: 100%,
  fill: fill,
  stroke: (left: 0.25em + bar) + stroke,
  inset: (x: 1em, y: 0.8em),
  radius: (top-right: 0.3em, bottom-right: 0.3em),
  {
    if ink != auto { set text(fill: ink) }
    if title != none {
      // `auto`: no `fill:` at all, so the title simply inherits the slide's ink
      // (reading `text.fill` would require a context, see above).
      block(below: 0.6em, if title-ink == auto {
        text(weight: "bold", title)
      } else {
        text(weight: "bold", fill: title-ink, title)
      })
    }
    body
  },
)

/// Neutral gray callout for remarks and definitions.
#let info(title: none, body) = callout(
  fill: heig-colors.gray.transparentize(88%),
  bar: heig-colors.gray,
  title: title,
  body,
)

/// Red callout for warnings and critical points. The title keeps the brand red
/// (sampled from the render: 3.7:1 over the light tint, 3.3:1 over the dark one
/// — above the 3:1 WCAG AA threshold for the 20pt bold it is rendered at); the
/// body inherits the slide's ink.
#let warning(title: none, body) = callout(
  fill: heig-red.transparentize(85%),
  bar: heig-colors.red,
  title: title,
  title-ink: heig-colors.red,
  body,
)

/// Outlined callout for examples and exercises.
#let example(title: none, body) = callout(
  fill: none,
  bar: heig-colors.gray,
  stroke: (
    top: 0.04em + heig-colors.gray.transparentize(55%),
    bottom: 0.04em + heig-colors.gray.transparentize(55%),
    right: 0.04em + heig-colors.gray.transparentize(55%),
  ),
  title: title,
  body,
)


// Slide layouts

/// Standard content slide with red header bar. `align: auto` follows the deck's
/// default (`config-store(align: …)`, `horizon`); pass e.g. `align: top + left`
/// to align a single slide differently.
#let slide(
  title: auto,
  align: auto,
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  let header-fn(self) = {
    set std.align(top)
    show: components.cell.with(fill: self.colors.primary, inset: 1em)
    set std.align(horizon)
    set text(fill: white, weight: "medium", size: 1.1em)
    components.left-and-right(
      if title != auto {
        utils.fit-to-width(grow: false, 100%, title)
      } else {
        utils.call-or-display(self, self.store.header)
      },
      utils.call-or-display(self, self.store.header-right),
    )
  }
  let footer-fn(self) = {
    set std.align(bottom)
    set text(size: 0.75em)
    pad(
      0.5em,
      components.left-and-right(
        text(fill: self.colors.neutral-darker.lighten(40%), utils.call-or-display(self, self.store.footer)),
        text(fill: self.colors.neutral-darker, utils.call-or-display(self, self.store.footer-right)),
      ),
    )
    if self.store.footer-progress {
      heig-progress-bar(self)
    }
  }
  let self = utils.merge-dicts(
    self,
    config-page(fill: self.colors.neutral-lightest, header: header-fn, footer: footer-fn),
  )
  let slide-align = if align == auto { self.store.align } else { align }
  let new-setting = body => {
    show: std.align.with(slide-align)
    set text(fill: self.colors.neutral-darkest)
    show: setting
    body
  }
  touying-slide(
    self: self,
    config: config,
    repeat: repeat,
    setting: new-setting,
    composer: composer,
    ..bodies,
  )
})


#let title-slide(
  config: (:),
  ..args,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-page(
      fill: self.colors.neutral-lightest,
      margin: (top: 1.5em, bottom: 1.5em, x: 2em),
      footer: self => {
        if self.store.footer-progress {
          heig-progress-bar(self)
        }
      },
    ),
    config,
  )
  let info = self.info + args.named()
  let mode = self.store.at("mode", default: "light")
  let assets = self.store.at("assets", default: none)
  // Centered hero: full HEIG-VD lockup (with school name) + title + meta.
  let hero = align(horizon + center, block(
    width: 100%,
    inset: (x: 2em),
    {
      if assets != none {
        heig-logo(mode: mode, assets, baseline: true, width: 58%)
        v(1.2em)
      }
      text(size: 1.4em, weight: "medium", info.title)
      if info.subtitle != none {
        linebreak()
        text(size: 0.9em, fill: self.colors.primary, info.subtitle)
      }
      v(0.5em)
      align(center, accent-bar(self, width: 36%, height: 3pt))
      v(0.5em)
      set text(size: 0.8em, fill: self.colors.neutral-darker)
      if info.author != none {
        block(spacing: 0.8em, info.author)
      }
      let meta = (
        if info.date != none { utils.display-info-date(self) },
        if info.institution != none { info.institution },
      ).filter(x => x != none)
      if meta.len() > 0 {
        block(spacing: 0.6em, meta.join([ · ]))
      }
      if info.contact != none {
        block(spacing: 0.6em, info.contact)
      }
    },
  ))
  let body = {
    set text(fill: self.colors.neutral-darkest)
    // Hero fills the slide; the HES-SO partner mark sits in its own bottom row.
    grid(
      rows: (1fr, auto),
      row-gutter: 0.5em,
      hero,
      if assets != none {
        align(center + bottom, heig-institutions(assets))
      } else { [] },
    )
  }
  touying-slide(self: self, body)
})


/// Automatic agenda/summary slide. Lists deck headings via Typst's `outline`, so
/// it stays in sync as sections are added. `levels` chooses which heading levels
/// appear (default: `=`); all selected levels are flattened into one numbered
/// list. Pass e.g. `levels: (1, 2)` to also list `==` sub-sections.
/// `title: auto` follows the deck language (Sommaire / Outline).
/// `max-count` caps how many columns the list may use (Touying's default is 3);
/// raise it for a deck with many sections. `fit: true` (the default) then
/// shrinks the whole list until it fits, so a long agenda can never silently
/// spill onto a second page; set `fit: false` to get the raw behaviour back.
#let outline-slide(
  config: (:),
  title: auto,
  levels: (1,),
  max-count: 3,
  fit: true,
) = touying-slide-wrapper(self => {
  let title = if title == auto {
    heig-lang-strings(self.store.at("lang", default: "fr")).outline
  } else { title }
  self = utils.merge-dicts(
    self,
    config-page(
      fill: self.colors.neutral-lightest,
      footer: self => {
        if self.store.footer-progress {
          heig-progress-bar(self)
        }
      },
    ),
    config,
  )
  let body = {
    set text(fill: self.colors.neutral-darkest)
    set std.align(horizon)
    // Title + accent bar, passed as adaptive-columns' `start` so its height is
    // subtracted when deciding how many columns the list needs (otherwise long
    // agendas overflow the bottom of the slide instead of wrapping into columns).
    let header = {
      stack(
        dir: ttb,
        spacing: 0.8em,
        text(size: 1.4em, weight: "bold", title),
        accent-bar(self, width: 100%, height: 3pt),
      )
      v(0.7em)
    }
    // Numbered list, flat — every selected heading level is shown as a top-level
    // entry, no indentation, no trailing page numbers/leaders.
    let entry-num = counter("heig-outline-entry")
    entry-num.update(0)
    show outline.entry: it => block(
      above: 0.8em,
      below: 0em,
      {
        entry-num.step()
        set text(size: 1.1em)
        link(
          it.element.location(),
          context [#text(fill: self.colors.primary)[#entry-num.display(). ]#text(fill: self.colors.neutral-darkest, it.body())],
        )
      },
    )
    let target = levels.map(l => heading.where(level: l)).reduce((a, b) => a.or(b))
    let list = outline(title: none, target: target)
    let gutter = 6%
    // Touying's `adaptive-columns` measures the list at full slide width, which
    // ignores the extra lines an entry gains once it is squeezed into a column:
    // long agendas therefore spill onto a second page without any warning.
    // Measuring at the real column width instead makes the choice reliable, and
    // leaves a last resort — shrinking the type — when even `max-count` columns
    // are not enough.
    layout(size => {
      let free = size.height - measure(header).height
      // Height of the list once flowed at the width of one of `n` columns.
      let column-height(n) = {
        let w = (size.width - (n - 1) * gutter * size.width) / n
        measure(block(width: w, list)).height / n
      }
      // The estimate above assumes perfectly balanced columns; the real layout
      // can be one entry taller. 12% of slack covers that (measured: a 22-entry
      // agenda came out 3% over an estimate that said it fit).
      let slack = 1.12
      let n = max-count
      for candidate in range(1, max-count + 1) {
        if column-height(candidate) * slack <= free {
          n = candidate
          break
        }
      }
      let body = if n == 1 { list } else { columns(n, gutter: gutter, list) }
      // Last resort when even `max-count` columns overflow: shrink the type,
      // with a 0.6em floor so the agenda never becomes unreadable.
      let overflow = column-height(n) * slack / free
      if fit and overflow > 1 {
        body = text(size: calc.max(0.6, 1 / overflow) * 1em, body)
      }
      header
      body
    })
  }
  touying-slide(self: self, body)
})


#let new-section-slide(
  config: (:),
  level: 1,
  numbered: true,
  body,
) = touying-slide-wrapper(self => {
  let slide-body = {
    set std.align(horizon)
    show: pad.with(20%)
    set text(size: 1.5em)
    stack(
      dir: ttb,
      spacing: 1em,
      text(self.colors.neutral-darkest, utils.display-current-heading(
        level: level,
        numbered: numbered,
        style: auto,
      )),
      accent-bar(self, width: 100%, height: 3pt),
    )
    text(self.colors.neutral-dark, body)
  }
  self = utils.merge-dicts(
    self,
    config-page(
      fill: self.colors.neutral-lightest,
      footer: self => {
        set std.align(bottom)
        set text(size: 0.75em)
        pad(0.5em, components.left-and-right(
          text(fill: self.colors.neutral-darker.lighten(40%), utils.call-or-display(self, self.store.footer)),
          text(fill: self.colors.neutral-darker, utils.call-or-display(self, self.store.footer-right)),
        ))
        if self.store.footer-progress {
          heig-progress-bar(self)
        }
      },
    ),
  )
  touying-slide(self: self, config: config, slide-body)
})


/// Section heading (`= …`) renderer used in receive-body mode: Touying hands us
/// the content that directly follows the heading, up to the first `==`.
///   - empty body → the heading is immediately followed by `==` sub-slides (a
///     multi-slide section) → render the big centered section-divider slide.
///   - non-empty body → the heading carries its own content (a single slide) →
///     render a normal red-header content slide, like a `==` slide.
/// This gives "1 slide → light style, N slides → divider" automatically.
#let smart-section(body) = touying-slide-wrapper(self => {
  let empty = body == none or body == []
  let wrapper = if empty { new-section-slide(none) } else { slide(body) }
  (wrapper.value.fn)(self)
})


#let focus-slide(
  config: (:),
  align: horizon + center,
  body,
) = touying-slide-wrapper(self => {
  let footer-fn(self) = {
    heig-progress-bar(self, bg: self.colors.primary)
  }
  self = utils.merge-dicts(
    self,
    config-page(fill: self.colors.primary, margin: 2em, footer: footer-fn),
  )
  set text(fill: white, size: 1.5em)
  touying-slide(self: self, config: config, std.align(align, body))
})


#let dark-focus-slide(
  config: (:),
  align: horizon + center,
  body,
) = touying-slide-wrapper(self => {
  let footer-fn(self) = {
    heig-progress-bar(self, bg: heig-colors.bg-dark)
  }
  self = utils.merge-dicts(
    self,
    config-page(fill: heig-colors.bg-dark, margin: 2em, footer: footer-fn),
  )
  set text(fill: heig-colors.white, size: 1.5em)
  touying-slide(self: self, config: config, std.align(align, body))
})


/// Full-bleed image slide. `img` is a file path (string) or any content (it is
/// stretched to cover the whole page). An optional `title` is overlaid in a
/// translucent band along the bottom edge.
#let image-slide(
  img,
  title: none,
  config: (:),
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-page(fill: self.colors.neutral-lightest, margin: 0em, header: none, footer: none),
  )
  let visual = if type(img) == str {
    image(img, width: 100%, height: 100%, fit: "cover")
  } else {
    block(width: 100%, height: 100%, img)
  }
  let body = {
    place(top + left, visual)
    if title != none {
      place(bottom, block(
        width: 100%,
        fill: rgb(0, 0, 0, 55%),
        inset: (x: 1.5em, y: 0.9em),
        align(left + horizon, text(fill: white, size: 1.3em, weight: "medium", title)),
      ))
    }
  }
  touying-slide(self: self, config: config, body)
})


/// Closing slide on the red background. `message: auto` follows the deck
/// language (Merci ! / Thank you!).
#let closing-slide(
  config: (:),
  message: auto,
  contact: none,
) = touying-slide-wrapper(self => {
  let message = if message == auto {
    heig-lang-strings(self.store.at("lang", default: "fr")).closing
  } else { message }
  self = utils.merge-dicts(
    self,
    config-page(fill: self.colors.primary),
  )
  let footer-fn(self) = {
    heig-progress-bar(self, bg: self.colors.primary)
  }
  // The closing slide is always on the red primary background, so the mark must
  // be the white logo regardless of the deck's light/dark mode.
  let assets = self.store.at("assets", default: none)
  let logo = if assets != none { heig-logo(mode: "dark", assets, height: 1.6em) } else {
    utils.call-or-display(self, self.info.logo)
  }
  // Wrap everything in a single aligned element — passing a bare set-rule + joined
  // content as the touying body drops the first element (the message).
  let body = align(horizon + center, {
    show strong: it => it.body
    set text(fill: white)
    text(size: 2em, weight: "bold", message)
    if contact != none {
      v(1em)
      text(size: 0.9em, contact)
    }
    v(2em)
    box(logo)
  })
  self = utils.merge-dicts(self, config-page(footer: footer-fn))
  touying-slide(self: self, config: config, body)
})


#let dark-title-slide(
  config: (:),
  ..args,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-page(
      fill: heig-colors.bg-dark,
      footer: self => {
        heig-progress-bar(self, bg: heig-colors.bg-dark)
      },
    ),
    config,
  )
  let info = self.info + args.named()
  let body = {
    set text(fill: heig-colors.white)
    set std.align(horizon)
    block(
      width: 100%,
      inset: 2em,
      {
        components.left-and-right(
          {
            text(size: 1.3em, weight: "medium", fill: heig-colors.white, info.title)
            if info.subtitle != none {
              linebreak()
              text(size: 0.9em, fill: heig-colors.red, info.subtitle)
            }
          },
          text(2em, utils.call-or-display(self, info.logo)),
        )
        accent-bar(self, height: 3pt)
        set text(size: 0.85em, fill: heig-colors.gray-lighter)
        if info.author != none {
          block(spacing: 1em, info.author)
        }
        if info.date != none {
          block(spacing: 0.5em, utils.display-info-date(self))
        }
        if info.institution != none {
          block(spacing: 0.5em, info.institution)
        }
      },
    )
  }
  touying-slide(self: self, body)
})

#let heig-theme(
  aspect-ratio: "16-9",
  mode: "light",
  lang: "fr",
  handout: false,
  assets: none,
  fonts: (:),
  header: self => utils.display-current-heading(
    setting: utils.fit-to-width.with(grow: false, 100%),
    depth: self.slide-level,
  ),
  header-right: auto,
  footer: none,
  // Page counter, hidden on appendix slides (they sit past the frozen total).
  footer-right: self => if self.at("appendix", default: false) { none } else {
    context utils.slide-counter.display() + " / " + utils.last-slide-number
  },
  footer-progress: true,
  ..args,
  body,
) = {
  let palette = if mode == "dark" { heig-dark-palette } else { heig-light-palette }
  let fonts = heig-fonts + fonts

  // Header bar is always the red primary colour → always use the white logo there,
  // independent of the deck's light/dark mode.
  let header-right = if header-right == auto {
    self => if assets != none { heig-logo(mode: "dark", assets) } else { self.info.logo }
  } else { header-right }

  set text(size: 20pt, lang: lang)
  set text(font: fonts.body)
  show heading: set text(font: fonts.heading, weight: "bold")
  show math.equation: set text(font: fonts.math)
  show raw: set text(font: fonts.mono, size: 1.05em)
  // Typst's built-in highlighting theme is tuned for a white page: on the dark
  // background its keyword blue drops to 3.4:1 and its string red to 3.7:1,
  // both under WCAG AA. The bundled dark theme keeps every token above 7:1.
  set raw(theme: if mode == "dark" { "heig-dark.tmTheme" } else { auto })

  // Content defaults: Swiss-style tables (no vertical rules, bold header over
  // a red rule), discreet gray figure captions, external links in HEIG red
  // (internal links, e.g. outline entries, keep their own colour).
  let rule-color = if mode == "dark" { heig-colors.gray-dark } else { heig-colors.gray-lighter }
  // `align: bottom` (vertical only, horizontal stays `start`): cells inherit the
  // slide's `horizon` alignment otherwise, and a cell mixing prose with `raw`
  // gets a taller line box than a `raw`-only one, so their baselines end up
  // 3pt apart. Aligning on the bottom edge puts every row back on one baseline
  // (measured: 0.000pt of drift). Multi-line cells then align on their last
  // line, which is the usual behaviour for bottom-aligned tables.
  set table(
    stroke: (x, y) => (bottom: if y == 0 { 0.08em + heig-colors.red } else { 0.04em + rule-color }),
    inset: (x: 0.8em, y: 0.5em),
    align: bottom,
  )
  show table.cell.where(y: 0): set text(weight: "bold")
  show figure.caption: set text(
    size: 0.8em,
    fill: if mode == "dark" { heig-colors.gray-light } else { heig-colors.gray },
  )
  show link: it => if type(it.dest) == str { text(fill: heig-accent-ink(mode), it) } else { it }

  show: touying-slides.with(
    config-page(
      ..utils.page-args-from-aspect-ratio(aspect-ratio),
      header-ascent: 30%,
      footer-descent: 30%,
      margin: (top: 3em, bottom: 1.5em, x: 2em),
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: smart-section,
      // Hand the section body to `smart-section` so it can choose divider vs content.
      receive-body-for-new-section-slide-fn: true,
      // ISO 8601, the standard date format in Switzerland.
      datetime-format: "[year]-[month]-[day]",
      // true: ignore all pauses, one page per slide (deck meant for sharing).
      handout: handout,
    ),
    config-methods(alert: heig-alert),
    palette,
    config-store(
      align: horizon,
      mode: mode,
      lang: lang,
      assets: assets,
      header: header,
      header-right: header-right,
      footer: footer,
      footer-right: footer-right,
      footer-progress: footer-progress,
    ),
    ..args,
  )
  body
}
