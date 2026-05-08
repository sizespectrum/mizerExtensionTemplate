#' Plankton encounter contribution
#'
#' Computes the extra encounter rate that fish experience by feeding on the
#' plankton component. This function is registered as the `encounter_fun` of
#' the "plankton" component in [newExtensionTemplateParams()] and is called
#' automatically by [mizer::getEncounter()] at each time step.
#'
#' The implementation is taken directly from the detritus example in
#' `vignette("extending-mizer", package = "mizer")`. It treats the plankton
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
#' `vignette("extending-mizer", package = "mizer")`.
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
