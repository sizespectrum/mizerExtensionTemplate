#' Example MizerParams object for the extension template
#'
#' A small three-species `mizerExtensionTemplate` model built from a subset of
#' the North Sea species parameters bundled with mizer (Sprat, Herring, Cod).
#' It demonstrates all five extension mechanisms provided by this template
#' package: an extra encounter term, a seasonal encounter multiplier, an
#' allometric background mortality, a dynamical plankton component, and an
#' overridden [getBiomass()] generic.
#'
#' Because the object is stored in the package's `data/` directory it is
#' lazy-loaded by R. The package's `.onLoad` hook replaces the plain binding
#' with an active binding so that every access to `example_params` calls
#' [mizer::coerceToExtensionClass()] and returns an object with the correct
#' S4 extension class for the extension chain that is currently registered in
#' the session.
#'
#' @format A [mizerExtensionTemplate-class] object (an S4 subclass of
#'   [mizer::MizerParams-class]) with 3 species and a plankton component.
#' @seealso [newExtensionTemplateParams()] for the constructor used to build
#'   this object, [getBiomass.mizerExtensionTemplate()] for the overridden
#'   generic, [mizerExtensionTemplate-class] for the S4 class definition.
#' @source Created by `data-raw/example_params.R`.
"example_params"
