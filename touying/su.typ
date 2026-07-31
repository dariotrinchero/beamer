/**
 * @file    su.typ
 * @brief   Touying template mimicking SU Beamer template: https://github.com/dariotrinchero/beamer
 * @author  Dario Trinchero (dario.trinchero@pm.me)
 * @date    3 August 2025
 *
 * Created according to: https://touying-typ.github.io/docs/build-your-own-theme/
 *
 * Usage (as per https://typst.app/docs/tutorial/making-a-template/):
 * -------------------------------------------------------------------------------------------------
 * #import "su.typ": su-theme, cetz-canvas, fletcher-diagram
 * #show: su-theme.with(
 *   // TODO
 * )
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
 * Custom commands
 **************************************************************************************************/

#let col(color: colors.edu-blue, it) = { text(fill: color, it) }
#let emp(color: colors.milit-salmon, it) = { smallcaps(col(color: color, it)) }

/***************************************************************************************************
 * Basic layout & document style
 **************************************************************************************************/

#let fonts(it) = {
  set text(font: "Libertinus Sans", size: 20pt)
  show raw: set text(font: "Libertinus Mono")
  show math.equation: set text(font: "Libertinus Math") // cf. "TeX Gyre Pagella Math"
  show smallcaps: set text(font: "Libertinus Sans")
  it
}

/***************************************************************************************************
 * Outline
 **************************************************************************************************/

#let outlines(it) = {
  set heading(numbering: "1")
  set outline(title: none, indent: 2em, depth: 2)

  show outline.entry: it => {
    set block(above: 0.7em)
    set block(above: 1.5em) if it.level == 1

    link(it.element.location(), it.indented(
      gap: 0.5em,
      {
        if it.level == 1 {
          box(move(dy: 1pt, rect(
            fill: colors.edu-blue,
            width: 16pt,
            height: 16pt,
            inset: 0em,
            align(center + horizon, text(fill: white, weight: "bold", size: 16pt, it.prefix()))
          )))
        } else {
          box(move(dy: -3pt, rect(
            fill: colors.edu-blue,
            width: 8pt,
            height: 8pt,
          )))
        }
      },
      if it.level == 1 { emp(it.body()) } else { it.body() }
    ))
  }
  it
}

/***************************************************************************************************
 * Theorem environments
 **************************************************************************************************/

#import "@preview/theorion:0.4.0": *
#import cosmos.clouds: *

#let theorem-env(it) = {
  show: show-theorion
  // TODO add more styling here

  it
}


/***************************************************************************************************
 * Main public API
 **************************************************************************************************/

#let su-theme(
  aspect-ratio: "4-3",
  ..args,
  it
) = {
  show: fonts
  show: theorem-env
  show: outlines

  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      margin: (top: 4em, bottom: 1.5em, x: 2em),
    ),
    config-common(slide-fn: slide),
    config-colors( // TODO is this helpful at all?
      primary: colors.su-maroon,
      primary-light: colors.su-wine-red,
      secondary: colors.milit-salmon,
      tertiary: colors.edu-blue,
      neutral-lightest: rgb("#ffffff"),
      neutral-dark: colors.su-soil,
      neutral-darkest: colors.charcoal,
    ),
    config-methods(
      alert: (self: none, it) => text(fill: self.colors.tertiary, it) // TODO this is annoying
    ),
    config-store(
      title: none,
      footer: none,
    ),
    ..args,
  )

  it
}
