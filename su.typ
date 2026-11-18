/**
 * @file    su.typ
 * @brief   Touying theme ported from the SU Beamer template:
 *          https://github.com/dariotrinchero/beamer/tree/beamer-final
 * @author  Dario Trinchero (dario.trinchero@pm.me)
 * @date    3 August 2025
 *
 * Created according to: https://touying-typ.github.io/docs/build-your-own-theme/
 *
 * Usage (as per https://typst.app/docs/tutorial/making-a-template/):
 * -------------------------------------------------------------------------------------------------
 * #import "su.typ": *
 * #show: su-theme.with(
 *   aspect-ratio: "4-3",                         // or "16-9"
 *   section-image: image("graphics/sec-bg.pdf"), // optional graphic on section slides
 *   config-info(
 *     title: [Title],
 *     short-title: [Title for footer],
 *     subtitle: [Subtitle],
 *     author: [Author],
 *     short-author: [Shown top-right of title slide],
 *     pdf-title: [Title for PDF reader],         // optional; defaults to "title – subtitle"
 *     institution: [Institution],
 *     logo: image("graphics/su-logo.pdf"),
 *   ),
 * )
 *
 * #title-slide()
 * #outline-slide()
 * = Section            // section slide
 * == Slide title       // regular slide; use #slide(subtitle: ..)[..] directly after for subtitle
 * #show: backmatter    // disable active slide indicator from here on
 * #bibliography-slide(bibliography("references.bib"))
 * -------------------------------------------------------------------------------------------------
 */


#import "@preview/touying:0.6.1": *
#import "@preview/fletcher:0.5.8" as fletcher: node, edge, cetz

/***************************************************************************************************
 * CeTZ & Fletcher bindings for Touying
 **************************************************************************************************/

#let cetz-canvas = touying-reducer.with(
  reduce: cetz.canvas,
  cover: cetz.draw.hide.with(bounds: true)
)
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

/***************************************************************************************************
 * Color definitions
 **************************************************************************************************/

#let colors = (
  // Corporate colors
  su-maroon: rgb(97,34,59),
  su-gold: rgb(183,153,98),
  su-orange: rgb(220,68,5),
  su-wine-red: rgb(166,10,61),
  su-soil: rgb(100,51,53),
  su-sea-green: rgb(130,204,174),

  // Basic neutral colors
  charcoal: rgb(44,42,41),
  light-grey: rgb(230,230,230),

  // Faculty colors
  agri-green: rgb(101,141,27),
  arts-orange: rgb(255,158,27),
  econ-sky-blue: rgb(44,204,211),
  edu-blue: rgb(34,61,113),
  eng-yellow: rgb(235,169,0),
  law-red: rgb(191,13,62),
  med-teal: rgb(0,95,97),
  milit-salmon: rgb(229,106,84),
  sci-red: rgb(210,39,48),
  theo-purple: rgb(92,6,140),
)

/***************************************************************************************************
 * Dimensions & font sizes
 **************************************************************************************************/

// Beamer paper sizes
#let paper-sizes = (
  "4-3": (width: 128mm, height: 96mm),
  "16-9": (width: 160mm, height: 90mm),
)

// LaTeX font sizes for 10pt base (Beamer `smaller` option)
#let sizes = (
  tiny: 5pt,
  scriptsize: 7pt,
  footnotesize: 8pt,
  small: 9pt,
  normalsize: 10pt,
  large: 12pt,
  Large: 14.4pt,
  LARGE: 17.28pt,
  huge: 20.74pt,
  Huge: 24.88pt,
)

#let header-height = 0.9cm
#let footer-height = 10pt

// Space between header & body, and extra space for top-aligned slides (as in Beamer `[t]` frames)
#let body-top-skip = 7.7pt
#let top-skip = 6.2pt

// Fill above & below body of vertically centered slides; as Beamer's `\beamer@frametopskip` &
// `\beamer@framebottomskip`, so that any `v(1fr)` in the body shares space in the same proportion
#let center-fill = (above: 1fr, below: 1.5fr)

// Convert length to CeTZ canvas units (1cm), so TikZ coordinates can be copied verbatim
#let cm(len) = len / 1cm

/***************************************************************************************************
 * Custom commands
 **************************************************************************************************/

#let col(color: colors.edu-blue, it) = { text(fill: color, it) }
#let emp(color: colors.milit-salmon, it) = { smallcaps(col(color: color, it)) }

// Bold exclamation point
#let bang = col(color: colors.sci-red, strong[!])

// Inline horizontally-padded arrows
#let becomes = $quad arrow.r.long quad$
#let becomes-rev = $quad arrow.l.long quad$

// Font Awesome 4 icon, as used by the LaTeX `fontawesome` package (requires `FontAwesome` font;
// see https://fontawesome.com/v4/cheatsheet/ for codes)
#let fa-icon(code) = text(font: "FontAwesome", code)

/***************************************************************************************************
 * Basic layout & document style
 **************************************************************************************************/

#let title-font = "Libertinus Serif"

#let fonts(it) = {
  set text(font: "Libertinus Sans", size: sizes.normalsize, fill: colors.charcoal)
  show raw: set text(font: "Libertinus Mono")
  show math.equation: set text(font: "Libertinus Math") // cf. "TeX Gyre Pagella Math"
  show smallcaps: set text(font: "Libertinus Sans")

  // Line pitch of 1.2em (as LaTeX \baselineskip) & no extra space between paragraphs (\parskip=0)
  set par(leading: 0.55em, spacing: 0.55em)
  it
}

// Style of titles (title slide, section slides)
#let title-text(size: sizes.huge, it) = {
  set text(font: title-font, size: size, weight: "bold", fill: colors.su-maroon)
  show smallcaps: set text(font: title-font)

  // Match pdfLaTeX, whose Libertine small caps have narrower interword space & tight line pitch;
  // paragraph breaks give a larger gap (cf. `\\[0.1em]` in the Beamer title)
  set text(spacing: 65%)
  set par(leading: 0.25em, spacing: 0.65em)
  smallcaps(it)
}

/***************************************************************************************************
 * Lists
 **************************************************************************************************/

// List geometry (as in Beamer): body indented 2em per level, labels right-aligned before body
#let list-indent = 20pt
#let label-sep = 5.7pt

// Marker for itemize, sitting on baseline (cf. Beamer `rectangles` inner theme)
#let list-marker(color: colors.edu-blue, size: 3.8pt) = box(square(size: size, fill: color))

// Marker for enumerate; number (integer or content) in a filled square, slightly below baseline
#let enum-marker(color: colors.edu-blue, size: 6.3pt, n) = box(
  move(dy: 1.5pt, rect(
    fill: color,
    width: size,
    height: size,
    inset: 0pt,
    align(center + horizon, text(fill: white, size: sizes.tiny, [#n]))
  ))
)

// Right-align label in space before list body
#let list-label(it) = box(width: list-indent - label-sep, align(right, it))

// Nesting depth of lists, used to shrink nested lists (as Beamer does)
#let list-depth = state("su-list-depth", 0)

#let lists(color: colors.edu-blue, it) = {
  set list(
    indent: 0pt,
    body-indent: label-sep,
    marker: (
      list-label(list-marker(color: color)),
      list-label(list-marker(color: color, size: 3.4pt)),
    )
  )
  set enum(
    indent: 0pt,
    body-indent: label-sep,
    number-align: end + horizon,
    numbering: n => list-label(enum-marker(color: color, n)),
  )
  set list(spacing: 7.3pt)
  set enum(spacing: 7.3pt)

  // Font size & spacing by depth (as in Beamer): \normalsize, \small, then \footnotesize; nested
  // lists are tighter, with extra space around each list
  show selector(list).or(enum): it => {
    list-depth.update(d => d + 1)
    context {
      let depth = list-depth.get()
      set text(size: (sizes.normalsize, sizes.small).at(depth - 1, default: sizes.footnotesize))
      set list(spacing: 3.3pt) // applies to lists nested within this one
      set enum(spacing: 3.3pt)
      let around = if depth == 1 { 8.5pt } else { 6.7pt }
      block(above: around, below: around, it)
    }
    list-depth.update(d => d - 1)
  }
  it
}

/***************************************************************************************************
 * Outline
 **************************************************************************************************/

#let outlines(it) = {
  set heading(numbering: "1")
  set outline(title: none, indent: list-indent, depth: 2)

  show outline.entry: it => {
    set block(above: 0.7em)
    set block(above: 1.5em) if it.level == 1

    link(it.element.location(), it.indented(
      gap: label-sep,
      if it.level == 1 {
        list-label(enum-marker(it.prefix()))
      } else {
        list-label(list-marker(size: 3.4pt))
      },
      if it.level == 1 { emp(it.body()) } else { it.body() }
    ))
  }
  it
}

/***************************************************************************************************
 * Blocks & theorem environments
 **************************************************************************************************/

// Block with colored title (cf. Beamer blocks with `beaver` color theme)
#let titled-block(
  title: none,
  color: colors.edu-blue,
  title-gap: 0.72em,
  body-style: it => it,
  body
) = block(
  width: 100%,
  above: 3.7pt,
  below: 3.7pt,
  inset: (top: 6pt, bottom: 3pt), // as Beamer's \medskip before & \smallskip after (not collapsed)
  {
    if title != none {
      block(below: title-gap, text(font: title-font, size: sizes.large, fill: color, title))
    }
    body-style(body)
  }
)

// Title as "Name (title)" or just "Name"
#let env-title(name, title) = if title == none { name } else [#name (#title)]

#let definition(title: none, body) = titled-block(
  title: env-title[Definition][#title],
  body
)
#let example(title: none, body) = titled-block(
  title: env-title[Example][#title],
  color: colors.agri-green,
  body
)
#let theorem(title: none, name: [Theorem], body) = titled-block(
  title: env-title(name, title),
  body-style: emph,
  body
)
#let lemma = theorem.with(name: [Lemma])
#let corollary = theorem.with(name: [Corollary])

#let proof(title: [Proof.], body) = titled-block(
  title: title,
  title-gap: 0.5em,
  [#body #h(1fr) #box(square(size: 0.6em, stroke: 0.5pt + colors.edu-blue))]
)

// Block for general notes; lists inside also get note color
#let note(title: none, body) = titled-block(
  title: title,
  color: colors.theo-purple,
  body-style: lists.with(color: colors.theo-purple),
  body
)

#let alert-block(title: none, body) = titled-block(title: title, color: colors.sci-red, body)

/***************************************************************************************************
 * Header & footer
 **************************************************************************************************/

// Frame title bar with progress wheel, mirroring the TikZ in `beamerthemesu.sty`
#let frame-header(self, title: none, subtitle: none) = align(top, context {
  let f = utils.slide-counter.get().first()
  let t = utils.last-slide-counter.final().first()
  let w = cm(self.store.paper.width)

  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    rect((0, 0), (w, cm(header-height)), fill: white, stroke: none)

    // Helper variables
    let r = 0.30 // radius of slide wheel
    let c = (0.5, 0.45) // center of slide wheel
    let ring(from, to, color) = if t > 0 and from < to {
      arc(
        c,
        anchor: "origin",
        start: 90deg - 360deg * from / t,
        stop: 90deg - 360deg * to / t,
        radius: r,
        stroke: (paint: color, thickness: 2pt),
      )
    }

    // Progress segments & slide count
    rect((0, 0), (1, 0.9), fill: colors.su-maroon, stroke: none)
    ring(f, t, colors.su-gold) // remaining slides
    if f > 0 and self.store.active-slide {
      ring(f - 1, f, colors.su-orange) // active slide segment
    }
    for j in range(t + 1) {
      if t == 0 { break }
      let angle = 90deg - 360deg * j / t
      line(c, (rel: (angle, r + 0.05), to: c), stroke: (paint: colors.su-maroon, thickness: 0.4pt))
    }
    content(c, text(fill: white, size: sizes.tiny)[#text(size: sizes.scriptsize)[#f]/#t])

    // Frame title & subtitle
    let title-style = text.with(fill: colors.su-maroon, size: sizes.large, weight: "bold")
    let subtitle-style = text.with(fill: colors.charcoal, size: sizes.scriptsize, style: "italic")

    let x = 1.15 + cm(5.3pt) // TikZ node inner sep shifts text right
    if subtitle == none {
      content((x, 0.33), anchor: "base-west", title-style(title))
    } else {
      content((x, 0.48), anchor: "base-west", title-style(title))
      content((x, 0.2), anchor: "base-west", subtitle-style(subtitle))
    }

    // Logo, top right
    if self.info.logo != none {
      content(
        (w - cm(11pt), -cm(2pt) + cm(4.8pt)), // TikZ node inner sep shifts image up
        anchor: "south",
        { set image(height: 0.7cm); self.info.logo }
      )
    }
  })
})

// Foot line with author & short title
#let frame-footer(self) = {
  set align(bottom)
  set text(size: sizes.tiny)

  grid(
    columns: (25%, 1fr),
    rows: footer-height,
    fill: (colors.su-maroon, colors.light-grey),
    align: (right + horizon, left + horizon),
    inset: (left: 4pt, right: 2pt),
    text(fill: white, self.info.author),
    text(fill: colors.charcoal, utils.call-or-display(self, self.store.short-title)),
  )
}

/***************************************************************************************************
 * Slides
 **************************************************************************************************/

// Regular slide; title defaults to current level-2 heading
#let slide(
  title: auto,
  subtitle: none,
  align: auto,
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  if align != auto {
    self.store.align = align
  }
  let title = if title == auto {
    utils.display-current-heading(level: 2, numbered: false)
  } else {
    title
  }
  let self = utils.merge-dicts(
    self,
    config-page(
      header: self => frame-header(self, title: title, subtitle: subtitle),
      footer: frame-footer,
    ),
  )
  // Vertical alignment via fill space (rather than `align`) so that, as in Beamer, any `v(1fr)` in
  // the body shares space with that above & below the body
  let (above, below) = if self.store.align.y == top {
    (top-skip, 1fr)
  } else if self.store.align.y == bottom {
    (1fr, 0pt)
  } else {
    (center-fill.above, center-fill.below)
  }
  let new-setting = body => {
    show: setting
    if self.store.align.x != none { set std.align(self.store.align.x) }
    v(above)
    body
    v(below)
  }
  touying-slide(self: self, config: config, repeat: repeat, setting: new-setting, composer: composer, ..bodies)
})

//--------------------------------------------------------------------------------------------------

// Title slide (no header or footer, not counted)
#let title-slide(config: (:), ..args) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config,
    config-common(freeze-slide-counter: true),
    config-page(header: none, footer: none, margin: (x: 1cm, top: 0.9cm + 2.4pt, bottom: 1.2cm + 2.3pt)),
  )
  let info = self.info + args.named()

  let body = {
    // Author
    text(size: sizes.large, info.author)
    h(1fr)
    text(size: sizes.footnotesize, info.at("short-author", default: none))
    v(2.2 * sizes.large + 2.5pt) // \vspace{2.2em} in author font, plus TeX \lineskip etc.

    // Title card
    block(above: 0pt, layout(size => cetz.canvas(length: 1cm, {
      import cetz.draw: *

      let w = cm(size.width)
      let cap-height = cm(measure(title-text[H]).height) // to place title by first baseline
      let h = 4.5 // title card height
      let corner = 0.1 // radius of rounded corners (1mm)

      // Polyline a-b-c with rounded corner at b (cf. TikZ `rounded corners`)
      let bracket(a, b, c) = {
        import cetz.vector: add, sub, scale, norm
        let toward(p, q, dist) = add(p, scale(norm(sub(q, p)), dist))
        let (a1, c1) = (toward(b, a, corner), toward(b, c, corner))
        let k = 0.5523 // control point distance for cubic approximation of quarter circle
        merge-path(
          stroke: (paint: colors.su-gold, thickness: 3pt),
          {
            line(a, a1)
            bezier(a1, c1, toward(a1, b, k * corner), toward(c1, b, k * corner))
            line(c1, c)
          }
        )
      }

      rect((0, 0), (w, h), stroke: none)
      bracket((0, 3.0), (0, h), (3, h))
      bracket((w, 1.5), (w, 0), (w - 3, 0))
      let x = cm(8pt + 4.3pt) // TikZ node inner sep shifts text right
      content((x, 3.4 + cap-height), anchor: "north-west", title-text(info.title))
      content(
        (x, 0.6), // Beamer original prepends blank line to subtitle; this matches that
        anchor: "base-west",
        text(size: sizes.large, fill: colors.charcoal, info.subtitle)
      )

      // Logo, top right
      if info.logo != none {
        content(
          (w - cm(21pt), cm(80pt) + cm(3.6pt)), // TikZ node inner sep shifts image up
          anchor: "south",
          { set image(height: 35pt); info.logo }
        )
      }
    })))

    // Date & institute; icon & text share a baseline (cf. Beamer description list)
    v(1fr)
    set text(size: sizes.scriptsize)
    let icon-line(code, body) = {
      box(width: 6.3pt, align(center, text(fill: colors.su-soil, fa-icon(code))))
      h(5.2pt)
      body
    }
    pad(left: 4.8pt, stack(
      spacing: 4.8pt,
      icon-line("\u{f041}", info.institution), // map-marker
      icon-line("\u{f073}", utils.display-info-date(self)), // calendar
    ))
  }
  touying-slide(self: self, body)
})

//--------------------------------------------------------------------------------------------------

// Section slide (inactive, not counted); generated automatically for level-1 headings
#let new-section-slide(config: (:), body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-store(active-slide: false),
    config-page(
      header: self => frame-header(self),
      footer: frame-footer,
    ),
  )

  let slide-body = {
    set std.align(center)
    v(center-fill.above + 1fr) // `\vfill` around content of Beamer section frame
    stack(
      title-text[
        #set text(top-edge: "ascender") // as TeX line box
        #utils.display-current-heading-number(level: 1, numbering: "1.")~#utils.display-current-heading(
          level: 1,
          numbered: false,
        )
      ],
      if self.store.section-image != none {
        v(1.5em + 1.5pt) // `\vspace{1.5em}` plus TeX `\lineskip` etc.
        block(width: 55%, { set image(width: 100%); self.store.section-image })
      },
      v(1em),
    )
    body
    v(center-fill.below + 1fr)
  }
  touying-slide(self: self, config: config, slide-body)
})

//--------------------------------------------------------------------------------------------------

// Outline slide (not counted)
#let outline-slide(title: [Talk Outline], config: (:)) = slide(
  title: title,
  config: utils.merge-dicts(config, config-common(freeze-slide-counter: true)),
  outline(),
)

//--------------------------------------------------------------------------------------------------

// Bibliography slide (not counted, top-aligned); pass e.g. `bibliography("references.bib")`
#let bibliography-slide(title: [References], config: (:), bib) = slide(
  title: title,
  align: top,
  config: utils.merge-dicts(config, config-common(freeze-slide-counter: true)),
  {
    set text(size: sizes.small)
    v(3.3pt) // as top spacing of apacite bibliography list
    set bibliography(title: none, style: "apa")
    show bibliography: set par(hanging-indent: 25pt, spacing: 0.55em)
    bib
  },
)

//--------------------------------------------------------------------------------------------------

// Disable active slide indicator for remaining slides (use as `#show: backmatter`)
#let backmatter(it) = touying-set-config(config-store(active-slide: false), it)

/***************************************************************************************************
 * PDF metadata
 **************************************************************************************************/

// Plain text of content, with line & paragraph breaks as spaces
#let plain-text(it) = {
  if it == none { "" }
  else if type(it) == str { it }
  else if it.has("text") { plain-text(it.text) }
  else if it.has("children") { it.children.map(plain-text).sum(default: "") }
  else if it.has("body") { plain-text(it.body) }
  else if it.has("child") { plain-text(it.child) }
  else if it.func() in ([ ].func(), linebreak, parbreak) { " " }
  else { "" }
}

// PDF title: `pdf-title` from info if given, else "title – subtitle" (as hyperref does for Beamer)
#let pdf-title(info) = {
  let title = info.at("pdf-title", default: auto)
  if title == auto {
    title = plain-text(info.title)
    if info.subtitle != none { title += " – " + plain-text(info.subtitle) }
  }
  plain-text(title).replace(regex("\s+"), " ").trim()
}

/***************************************************************************************************
 * Main public API
 **************************************************************************************************/

#let su-theme(
  aspect-ratio: "4-3",
  align: horizon,
  section-image: none,
  short-title: self => if self.info.short-title == auto { self.info.title } else { self.info.short-title },
  ..args,
  it
) = {
  let paper = paper-sizes.at(aspect-ratio)

  show: fonts
  show: lists
  show: outlines

  show: touying-slides.with(
    config-page(
      width: paper.width,
      height: paper.height,
      margin: (top: header-height + body-top-skip, bottom: footer-height + 4.8pt, x: 1cm),
      header-ascent: 0em,
      footer-descent: 0em,
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
      datetime-format: "[month repr:long] [year]",
    ),
    config-info(date: datetime.today()),
    config-colors(
      primary: colors.su-maroon,
      secondary: colors.su-gold,
      tertiary: colors.edu-blue,
      neutral-lightest: white,
      neutral-darkest: colors.charcoal,
    ),
    config-methods(
      init: (self: none, body) => {
        set document(title: pdf-title(self.info))
        body
      },
      alert: (self: none, it) => text(fill: colors.sci-red, it),
    ),
    config-store(
      paper: paper,
      align: align,
      section-image: section-image,
      short-title: short-title,
      active-slide: true,
    ),
    ..args,
  )

  it
}
