#' mizerExtensionTemplate extension classes
#'
#' S3 extension classes for [MizerParams] and [MizerSim] that enable dispatch
#' to the methods defined in this package.
#'
#' The class names are ordinary entries in the object's S3 class vector. All
#' extension-specific data lives in
#' `other_params(params)$mizerExtensionTemplate` and in the component
#' parameters of the "plankton" component (see [setComponent()]).
#'
#' Objects of class `mizerExtensionTemplate` are created by
#' [newExtensionTemplateParams()]. Objects of class
#' `mizerExtensionTemplateSim` are returned automatically by [project()]
#' when called on a `mizerExtensionTemplate` params object.
#'
#' No class declaration is needed. [newExtensionTemplateParams()] records the
#' extension on the object with [mizer::recordExtension()] and then calls
#' [mizer::coerceToExtensionClass()]. For example, the params class vector is
#' `c("mizerExtensionTemplate", "MizerParams")`; simulations created by
#' [project()] receive
#' `c("mizerExtensionTemplateSim", "MizerSim")` automatically.
#'
#' @name mizerExtensionTemplate-class
#' @keywords internal
NULL
