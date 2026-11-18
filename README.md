[![Build & release](https://github.com/dariotrinchero/beamer/actions/workflows/compile_release.yaml/badge.svg)](https://github.com/dariotrinchero/beamer/actions/workflows/compile_release.yaml)

# Presentation Template

This repo contains the template from which I create presentations in [Typst](https://typst.app)
using [Touying](https://touying-typ.github.io), including theme, color palette, and fonts. It was
ported from Beamer; the last Beamer version is tagged
[`beamer-final`](https://github.com/dariotrinchero/beamer/tree/beamer-final).

## Compiled output & screenshots

The compiled template is available alongside as a GitHub **release**. Here are some screenshots
showing off the basic layout and some key features:

<p float="left">
<img src="https://github.com/dariotrinchero/beamer/releases/download/latest/presentation-1.png" width="70%">
<img src="https://github.com/dariotrinchero/beamer/releases/download/latest/presentation-3.png" width="70%">
<img src="https://github.com/dariotrinchero/beamer/releases/download/latest/presentation-5.png" width="70%">
</p>

## Getting started

### Dependencies

- [Typst](https://github.com/typst/typst) (tested with 0.15.1)

Typst packages (Touying, Fletcher) are fetched automatically on first compile. Fonts are bundled
in `fonts/`.

### Overview of setup

1. Download this repo.
1. Install Typst.
1. Test compilation by running `typst compile --font-path fonts presentation.typ` in root dir.
1. Customize slides in `presentation.typ`.
1. Customize references in `references.bib`.
1. Optionally customize fonts, colors, logo, etc, in `su.typ`.

To start a presentation elsewhere, copy `su.typ`, `graphics/`, `presentation.typ`, and
optionally `references.bib` and `fonts/`, if the fonts are not installed locally.

### Compilation

Typst needs `--font-path fonts` (or `TYPST_FONT_PATHS=fonts`) to find the bundled fonts:

- `typst compile --font-path fonts presentation.typ`: build presentation
- `typst watch --font-path fonts presentation.typ`: watch files & recompile on changes

## Coming from Beamer

Most-used Beamer constructs and their equivalents here. Overlays & columns come from
[Touying](https://touying-typ.github.io/docs/intro); the rest is defined in `su.typ`.

| Beamer                                    | Typst                                                             |
|-------------------------------------------|-------------------------------------------------------------------|
| `\documentclass[aspectratio=169]{beamer}` | `su-theme.with(aspect-ratio: "16-9", ..)`                         |
| `handout` class option                    | `config-common(handout: true)` in `su-theme.with(..)`             |
| `\titlepage`                              | `#title-slide()`                                                  |
| outline frame                             | `#outline-slide()` (generated from sections)                      |
| `\section{Title}`                         | `= Title`                                                         |
| `\begin{frame}\frametitle{Title}`         | `== Title`; content follows, no `\end{frame}`                     |
| `\framesubtitle{Sub}`                     | `#slide(subtitle: [Sub])[..]` directly after `== Title`           |
| `\begin{frame}[t]`                        | `#slide(align: top)[..]`                                          |
| `[fragile]` & `\verb\|x\|`                | `` `x` ``; nothing is fragile                                     |
| `\pause`                                  | `#pause`                                                          |
| `\only<2>{..}`, `\uncover<2->{..}`        | `#only(2)[..]`, `#uncover("2-")[..]`                              |
| `\begin{columns}`                         | `#slide(composer: (1fr, 1fr))[left][right]`                       |
| `\vfill`                                  | `#v(1fr)`                                                         |
| `{\small ..}`                             | `#text(size: sizes.small)[..]`                                    |
| `\emp[SciRed]{x}`, `\col{x}`              | `#emp(color: colors.sci-red)[x]`, `#col[x]`                       |
| `\becomes`, `\becomes*`, `\bang`          | `#becomes`, `#becomes-rev`, `#bang`                               |
| `\begin{definition}[Title]`               | `#definition(title: [Title])[..]`; likewise `example`, `theorem`, `lemma`, `corollary`, `proof`, `note`, `alert-block` |
| `\cite{key}`                              | `@key`                                                            |
| `\backmatter`                             | `#show: backmatter`                                               |
| references frame with `\nocite{*}`        | `#bibliography-slide(bibliography("references.bib", full: true))` |
| TikZ                                      | `#cetz-canvas(..)`, `#fletcher-diagram(..)` (overlay-aware)       |

Math is written between `$..$` as before, but uses [Typst syntax](https://typst.app/docs/reference/math/)
(e.g. `$sum_(i=1)^n a_i / 2$`).

## Disclaimer

Currently the template is set up with my personal details, and the colors and logo of
Stellenbosch University. This project is in no way endorsed by or affiliated with Stellenbosch
University, and I make no claim that any of the branding is correctly applied.
