#import "@preview/touying:0.6.1": *

// Touying (slide) theme
//#import themes.university: *
//#show: university-theme.with(
//  aspect-ratio: "16-9",
//  // align: horizon,
//  // config-common(handout: true),
//  config-common(frozen-counters: (theorem-counter,)),  // freeze theorem counter for animation
//  config-info(
//    title: [Title],
//    subtitle: [Subtitle],
//    author: [Authors],
//    date: datetime.today(),
//    institution: [Institution],
//    logo: emoji.school,
//  ),
//)

#import "su.typ": su-theme, cetz-canvas, fletcher-diagram
#show: su-theme.with(
  //aspect-ratio: "16-9",
)

//==================================================================================================

//#title-slide()

//--------------------------------------------------------------------------------------------------

== Outline <touying:hidden>

#components.adaptive-columns(outline())

//==================================================================================================

= Animation

//--------------------------------------------------------------------------------------------------

== Simple Animation

test #alert[too]

//--------------------------------------------------------------------------------------------------

== First Slide

Hello, Touying!

#pause

Hello, Typst!

//--------------------------------------------------------------------------------------------------

== Second slide

=== Example

=== Example 2

//--------------------------------------------------------------------------------------------------

== Third slide

//==================================================================================================

= Next topic

//--------------------------------------------------------------------------------------------------

== First slide about next topic

So as you can see
