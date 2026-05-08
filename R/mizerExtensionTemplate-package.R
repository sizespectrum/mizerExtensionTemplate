#' mizerExtensionTemplate
#'
#' @import mizer

# .onLoad is called when the package is loaded (via library() or devtools::load_all()).
# Every mizer extension package — metadata-only or dispatching — must call
# registerExtension() here. This prepends the package to the session's
# extension chain, giving it the highest dispatch priority among currently
# loaded extensions.

.onLoad <- function(libname, pkgname) {
    registerExtension(pkgname,
                      requirement = "sizespectrum/mizerExtensionTemplate")
}
