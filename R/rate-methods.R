#' Seasonal encounter rate for the extension template
#'
#' Applies a sinusoidal seasonal multiplier on top of the encounter rate
#' computed by lower extensions and the base mizer calculation.
#'
#' This method replaces the `setRateFunction()` approach used in single-user
#' scripts. It participates in the S3 dispatch chain so that multiple loaded
#' extension packages can each modify the encounter rate without overwriting
#' one another.
#'
#' ## Why `project*` methods instead of `setRateFunction()`
#'
#' `setRateFunction(params, "Encounter", "myFn")` stores a single function
#' name per rate. If two extension packages both call it for the same rate,
#' the second silently overwrites the first. S3 dispatch via `project*`
#' methods avoids this: each extension defines a method for its own marker
#' class and calls `NextMethod()` to pass control down the chain.
#'
#' ## Rules for every `project*` method
#'
#' 1. **Always call `NextMethod()`** — omitting it silently drops all
#'    contributions from lower extensions and the base mizer calculation.
#' 2. **Keep the same argument signature** as the generic and include `...`
#'    so extra arguments pass through to lower methods.
#' 3. **Do not call `setRateFunction()`** in your constructor for any rate
#'    handled by a `project*` method in this package.
#'
#' @param params A MizerParams object of class `"mizerExtensionTemplate"`.
#' @param n Species abundance matrix (species × size).
#' @param n_pp Resource abundance vector (full size grid).
#' @param n_other Named list of other component states.
#' @param t Current simulation time (years). The seasonal multiplier is
#'   `1 + amplitude * sin(2π t)`, which peaks at `t = 0.25` and troughs at
#'   `t = 0.75`.
#' @param ... Additional arguments passed through the dispatch chain.
#'
#' @return A numeric matrix (species × size) of encounter rates, seasonally
#'   scaled.
#'
#' @method projectEncounter mizerExtensionTemplate
#' @export
projectEncounter.mizerExtensionTemplate <- function(params, n, n_pp, n_other,
                                                     t = 0, ...) {
    # NextMethod() passes control to the next class in the dispatch chain —
    # either a lower extension's projectEncounter method or, at the bottom,
    # projectEncounter.MizerParams (the standard mizer calculation, which
    # includes the plankton encounter contribution from setComponent()).
    enc <- NextMethod()

    amplitude <- other_params(params)$mizerExtensionTemplate$season_amplitude
    if (!is.null(amplitude) && amplitude != 0) {
        enc <- enc * (1 + amplitude * sin(2 * pi * t))
    }
    enc
}
