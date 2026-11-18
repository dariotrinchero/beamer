#import "su.typ": *
#show: su-theme.with(
  aspect-ratio: "4-3",
  section-image: image("graphics/sec-bg.pdf"), // optional
  // config-common(handout: true), // toggle to disable overlays
  config-info(
    title: [
      #text(size: sizes.huge, weight: "regular", fill: colors.su-soil)[Seminar Name:]

      #text(size: sizes.Huge)[Title for First Slide \ Spanning Two Lines]
    ],
    short-title: [Title for footer],
    pdf-title: [Title for PDF reader], // optionally override (default: "title – subtitle")
    subtitle: [#col[Stylized] subtitle for first slide],
    author: [Dario Trinchero],
    short-author: [dario.trinchero\@pm.me],
    institution: [Stellenbosch University],
    logo: image("graphics/su-logo.pdf"),
    // date: [October 2020], // optionally override date
  ),
)

//==================================================================================================

#title-slide()

//--------------------------------------------------------------------------------------------------

#outline-slide()

//==================================================================================================

= Introduction

//--------------------------------------------------------------------------------------------------

== High-level overview

#slide(subtitle: [With subtitle!])[
  #note(title: [Nota Bene (Note)])[
    Arrows#becomes logical connectives
  ]

  #v(1fr)
  #definition(title: [Definition])[
    Example definition
  ]

  #v(1fr)
  #example(title: [Example])[
    Example example#becomes-rev remark #bang
  ]
]

//--------------------------------------------------------------------------------------------------

== Continuing

Some text with #emp[emphasis] in #emp(color: colors.sci-red)[multiple colors], as well as more
#col[subtle emphasis] by #col(color: colors.econ-sky-blue)[color alone]. See
#text(size: sizes.small)[`su.typ`] for all defined colors.

#v(1fr)
#theorem(title: [Theorem])[
  Example theorem (see also lemma and corollary)
]
#proof[
  QED
]

//==================================================================================================

#show: backmatter // disable active slide indicator

//--------------------------------------------------------------------------------------------------

#bibliography-slide(bibliography("references.bib", full: true))
