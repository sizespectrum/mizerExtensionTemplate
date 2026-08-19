#' Plankton encounter contribution
#'
#' Computes the extra encounter rate that fish experience by feeding on the
#' plankton component. This function is registered as the `encounter_fun` of
#' the "plankton" component in [newExtensionTemplateParams()] and is called
#' automatically by [mizer::getEncounter()] at each time step.
#'
#' The implementation is taken directly from the detritus example in
#' `vignette("guide-extend-mizer", package = "mizer")`. It treats the plankton
#' spectrum as the resource (`n_pp`) in a standard mizer encounter calculation,
#' after first removing the plankton's own encounter hook from the temporary
#' params copy to avoid double-counting.
#'
#' @param params A MizerParams object.
#' @param n Species abundance matrix (species × size).
#' @param n_pp Resource abundance vector (full size grid).
#' @param n_other Named list of other component states, including the current
#'   plankton spectrum under `n_other[["plankton"]]`.
#' @param component Name of this component (`"plankton"`).
#' @param ... Additional arguments (ignored).
#'
#' @return A numeric matrix (species × size) of extra encounter rates due to
#'   plankton.
#' @export
planktonEncounter <- function(params, n, n_pp, n_other, component, ...) {
    params2 <- params
    params2@other_encounter[[component]] <- NULL
    mizerEncounter(params2,
                          n      = n,
                          n_pp   = n_other[[component]],
                          n_other = n_other,
                          ...)
}

#' Plankton dynamics
#'
#' Updates the plankton component spectrum at each time step. This function is
#' registered as the `dynamics_fun` of the "plankton" component in
#' [newExtensionTemplateParams()] and is called automatically by [project()].
#'
#' The plankton grows towards a size-specific carrying capacity at a fixed rate
#' and is simultaneously depleted by predation. The update is the analytical
#' solution of the linear ODE:
#'
#' \deqn{dP/dt = r(K - P) - m \cdot P = rK - (r + m)P}
#'
#' where `r` is the growth rate, `K` is the carrying capacity, and `m` is the
#' predation mortality on the plankton spectrum at each size bin.
#'
#' This implementation follows the detritus example in
#' `vignette("guide-extend-mizer", package = "mizer")`.
#'
#' @param params A MizerParams object.
#' @param n_other Named list of current component states. The plankton
#'   spectrum is available as `n_other[["plankton"]]`.
#' @param rates A named list of rates as returned by [mizer::getRates()].
#'   Used to compute predation mortality on the plankton spectrum via
#'   `rates$pred_rate`.
#' @param dt Length of the current time step (years).
#' @param component Name of this component (`"plankton"`).
#' @param ... Additional arguments (ignored).
#'
#' @return Updated plankton abundance vector (full size grid).
#' @export
planktonDynamics <- function(params, n_other, rates, dt, component, ...) {
    plankton <- n_other[[component]]
    p        <- params@other_params[[component]]

    # Predation mortality rate on each plankton size bin.
    # species_params$interaction_resource scales how much each species feeds on
    # the shared resource spectrum; we use it as a proxy for plankton feeding
    # because the plankton is presented to fish as an extra resource.
    interaction <- params@species_params$interaction_resource
    pred_mort   <- as.vector(interaction %*% rates$pred_rate)

    # Analytical solution to avoid numerical instability at large dt:
    # P(t+dt) = target - (target - P(t)) * exp(-(r + m) * dt)
    target <- p$rate * p$capacity / (p$rate + pred_mort)
    target - (target - plankton) * exp(-(p$rate + pred_mort) * dt)
}

#' Plankton level
#'
#' The plankton abundance as a fraction of its carrying capacity, at each size
#' on the full size grid. A value of 1 means the plankton is at capacity, 0 that
#' it has been grazed away. Sizes at which the capacity is itself zero give
#' `NaN`, exactly as [mizer::resource_level()] does; the plotting functions drop
#' them, but use `na.rm = TRUE` if you summarise the values yourself.
#'
#' ## Why this function declares a `type`
#'
#' This is the template's example of returning a **classed array** rather than a
#' bare vector, and of telling mizer what kind of quantity the values are. The
#' array constructors — [mizer::ArrayResourceBySize()],
#' [mizer::ArraySpeciesBySize()], [mizer::ArrayTimeBySpecies()] and friends —
#' take a `type` argument with three possible values:
#'
#' \describe{
#'   \item{`"value"`}{A rate or an amount. The default.}
#'   \item{`"density"`}{An amount per gram of body weight. Plotting one against
#'     a length axis (`size_axis = "l"`) multiplies by the `dw/dl` Jacobian,
#'     because a density per gram is not a density per centimetre.}
#'   \item{`"proportion"`}{A fraction. Plotted on a linear y axis showing the
#'     whole of the interval from 0 to 1, so the value can be read against the
#'     scale it belongs to.}
#' }
#'
#' A plankton level is a fraction, so it declares `type = "proportion"` and
#' `plot(planktonLevel(params))` gets the right axis without the caller asking
#' for it. Had we returned a bare vector, or omitted `type`, we would have got a
#' log axis fitted to the data — right for a spectrum, wrong for a fraction.
#'
#' Declare `type` for every array your extension returns. If you leave it out,
#' mizer falls back to guessing from `value_name` and `units` (an array called
#' `"Number density"` or carrying units of `"1/g"` is taken to be a density),
#' which is there for backwards compatibility and is easy to fall foul of.
#'
#' @param params A MizerParams object with a "plankton" component, as returned
#'   by [newExtensionTemplateParams()].
#'
#' @return An [mizer::ArrayResourceBySize()] of the plankton level at each size.
#' @seealso [mizer::resource_level()], the mizer function this one mirrors.
#' @export
planktonLevel <- function(params) {
    capacity <- params@other_params[["plankton"]]$capacity
    ArrayResourceBySize(params@initial_n_other$plankton / capacity,
                        value_name = "Plankton level", units = "",
                        type = "proportion", params = params)
}
