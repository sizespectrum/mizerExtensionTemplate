#' Example MizerParams object for the extension template
#'
#' A small three-species `mizerExtensionTemplate` model built from a subset of
#' the North Sea species parameters bundled with mizer (Sprat, Herring, Cod).
#' It demonstrates all five extension mechanisms provided by this template
#' package: an extra encounter term, a seasonal encounter multiplier, an
#' allometric background mortality, a dynamical plankton component, and an
#' overridden [getBiomass()] generic.
#'
#' The object was created with [newExtensionTemplateParams()] and is stored in
#' the package's `data/` directory. R's standard lazy-loading preserves its S3
#' class vector and extension metadata, so no load hook or active binding is
#' needed.
#'
#' @format A [mizerExtensionTemplate-class] object with 3 species and a
#'   plankton component.
#' @seealso [newExtensionTemplateParams()] for the constructor used to build
#'   this object, [getBiomass.mizerExtensionTemplate()] for the overridden
#'   generic, [mizerExtensionTemplate-class] for the S3 extension classes.
#' @source Created by `data-raw/example_params.R`.
"example_params"
