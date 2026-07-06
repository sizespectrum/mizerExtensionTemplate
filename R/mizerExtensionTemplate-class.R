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
#' Note that the classes are **not** defined statically with `setClass()`.
#' Instead mizer creates them when the package is loaded: `.onLoad()` calls
#' [mizer::registerExtension()], which recognises this package as a dispatching
#' extension from the S3 methods it registers for its marker class (for example
#' [projectEncounter.mizerExtensionTemplate()]) and inserts the class at the
#' correct place in the S4 hierarchy relative to any other extension packages
#' loaded in the same session. This is what lets independently developed
#' extensions be chained in either load order. Defining the class statically as
#' `contains = "MizerParams"` would instead fix it as a direct sibling of every
#' other extension and, because the class would then be sealed, prevent mizer
#' from re-parenting it into the chain.
#'
#' @name mizerExtensionTemplate-class
#' @keywords internal
NULL
