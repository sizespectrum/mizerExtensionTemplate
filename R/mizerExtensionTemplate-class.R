#' mizerExtensionTemplate marker classes
#'
#' S4 marker subclasses of [MizerParams] and [MizerSim] that enable S3
#' dispatch for extension-specific methods defined in this package.
#'
#' These classes add no new slots. All extension-specific data lives in
#' `other_params(params)$mizerExtensionTemplate` and in the component
#' parameters of the "plankton" component (see [setComponent()]).
#'
#' Objects of class `mizerExtensionTemplate` are created by
#' [newExtensionTemplateParams()]. Objects of class
#' `mizerExtensionTemplateSim` are returned automatically by [project()]
#' when called on a `mizerExtensionTemplate` params object.
#'
#' @name mizerExtensionTemplate-class
NULL

#' @export
setClass("mizerExtensionTemplate", contains = "MizerParams")

#' @export
setClass("mizerExtensionTemplateSim", contains = "MizerSim")
