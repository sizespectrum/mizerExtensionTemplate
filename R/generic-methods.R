# S3 overrides of user-facing mizer generics.
#
# Each method calls NextMethod() first so that lower extensions in the chain
# contribute their modifications before this package adds its own. The base
# mizer method is always at the bottom of the chain.
#
# Register every method in NAMESPACE via the @method + @export roxygen tags.

# getBiomass.mizerExtensionTemplate ----------------------------------------

#' Get biomass including the plankton component
#'
#' Extends [mizer::getBiomass()] for `mizerExtensionTemplate` objects to
#' append the plankton component biomass to the standard species biomasses.
#'
#' Because [plotBiomass()] calls `getBiomass()` internally, this single
#' override is enough to make biomass plots include the plankton without any
#' further changes.
#'
#' @param object A `mizerExtensionTemplate` params object.
#' @param ... Passed to the next method in the dispatch chain.
#'
#' @return A named numeric vector of biomasses (g) with an extra "Plankton"
#'   entry.
#'
#' @method getBiomass mizerExtensionTemplate
#' @export
#' @name getBiomass
getBiomass.mizerExtensionTemplate <- function(object, ...) {
    params <- object
    b      <- NextMethod()

    plankton <- params@initial_n_other$plankton
    if (!is.null(plankton)) {
        plankton_biomass <- sum(plankton * params@dw_full * params@w_full)
        b <- c(b, Plankton = plankton_biomass)
    }
    b
}

# getBiomass.mizerExtensionTemplateSim -------------------------------------

#' Get biomass time series including the plankton component
#'
#' Extends [mizer::getBiomass()] for `mizerExtensionTemplateSim` objects to
#' append a plankton biomass column to the time × species matrix returned by
#' the base method.
#'
#' @param object A `mizerExtensionTemplateSim` sim object.
#' @param ... Passed to the next method in the dispatch chain.
#'
#' @return An `ArraySpeciesByTime` matrix (time × species + Plankton) with
#'   biomasses in grams.
#'
#' @method getBiomass mizerExtensionTemplateSim
#' @export
getBiomass.mizerExtensionTemplateSim <- function(object, ...) {
    sim    <- object
    params <- sim@params

    # unclass() strips the ArraySpeciesByTime wrapper so we can cbind().
    b             <- unclass(NextMethod())
    dimname_names <- names(dimnames(b))

    # sim@n_other is a list array (time × component).  Each cell holds the
    # component state at that time step.  For the vector-valued plankton
    # component, each cell is a numeric vector of length w_full.
    no_t <- nrow(b)
    plankton_biomass <- vapply(seq_len(no_t), function(i) {
        pl <- sim@n_other[i, "plankton"][[1]]
        sum(pl * params@dw_full * params@w_full)
    }, numeric(1))

    b <- cbind(b, Plankton = plankton_biomass)
    names(dimnames(b)) <- dimname_names

    mizer::ArraySpeciesByTime(b, value_name = "Biomass", units = "g",
                              params = params)
}
