#' mizerExtensionTemplate
#'
#' @import mizer

# .onLoad is called when the package is loaded (via library() or devtools::load_all()).
# Every mizer extension package — metadata-only or dispatching — must call
# registerExtension() here. This prepends the package to the session's
# extension chain, giving it the highest dispatch priority among currently
# loaded extensions.
#
# If the package ships MizerParams or MizerSim objects in data/, those objects
# are delivered by R's lazy-loading mechanism exactly as they were serialised —
# without any class promotion. An active binding fixes this: the coercion runs
# fresh on every access, so the object always reflects the full extension chain
# that is registered at the moment the user touches it. This matters when two
# or more extension packages are loaded together.

.onLoad <- function(libname, pkgname) {
    registerExtension(pkgname,
                      requirement = "sizespectrum/mizerExtensionTemplate")

    # Replace the lazy-loaded example_params binding with an active binding so
    # that every access returns an object coerced to the current extension class.
    if (exists("example_params", envir = asNamespace(pkgname), inherits = FALSE)) {
        ns  <- asNamespace(pkgname)
        raw <- get("example_params", envir = ns)
        makeActiveBinding("example_params",
                          fun = function() mizer::coerceToExtensionClass(raw),
                          env = ns)
    }
}

