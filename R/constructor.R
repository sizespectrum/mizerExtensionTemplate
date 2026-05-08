#' Create a MizerParams object using the extension template
#'
#' This constructor demonstrates all five extension mechanisms available in
#' mizer. Read the inline comments to understand what each block does and how
#' to adapt it for your own extension.
#'
#' ## Extension mechanisms demonstrated
#'
#' 1. **`setExtEncounter()` / `setExtMort()`** — add fixed, species × size
#'    arrays to encounter or mortality without any dynamics.
#' 2. **`project*` S3 method** — seasonal encounter multiplier implemented in
#'    [projectEncounter.mizerExtensionTemplate()], replacing the
#'    `setRateFunction()` approach.
#' 3. **`setComponent()`** — a dynamical plankton component with its own
#'    time-evolution and an encounter contribution. Defined in
#'    `component-functions.R`.
#' 4. **S3 generic overrides** — [getBiomass.mizerExtensionTemplate()] and
#'    [getBiomass.mizerExtensionTemplateSim()] add the plankton biomass to the
#'    standard output.
#'
#' ## Metadata-only vs. dispatching extensions
#'
#' This constructor creates a **dispatching** extension: the returned object
#' has class `"mizerExtensionTemplate"` so that mizer's generic functions
#' dispatch to the S3 methods defined in this package. For a
#' **metadata-only** extension (one that does not override any generic), you
#' would omit the `setClass()` definition in `mizerExtensionTemplate-class.R`
#' and the `coerceToExtensionClass()` call at the end of this function. You
#' still call `params@extensions <- mizer::getRegisteredExtensions()` so the
#' dependency is recorded.
#'
#' @param species_params A data frame of species parameters passed directly to
#'   [mizer::newMultispeciesParams()].
#' @param season_amplitude Amplitude of the sinusoidal seasonal variation in
#'   the encounter rate, as a fraction of the base rate. `0` disables the
#'   effect; the default `0.2` gives ±20 % variation over the year.
#' @param extra_food_coef Coefficient for the allometric extra food source
#'   added via `setExtEncounter()`. Set to `0` to disable.
#' @param background_mort_coef Coefficient for background mortality added via
#'   `setExtMort()`. Set to `0` to disable.
#' @param plankton_rate Intrinsic growth rate of the plankton component
#'   (yr⁻¹). Higher values make the plankton respond faster to depletion.
#' @param ... Additional arguments passed to [mizer::newMultispeciesParams()].
#'
#' @return A `MizerParams` object of class `"mizerExtensionTemplate"`.
#'
#' @seealso [projectEncounter.mizerExtensionTemplate()],
#'   [planktonDynamics()], [getBiomass.mizerExtensionTemplate()]
#' @export
newExtensionTemplateParams <- function(
        species_params,
        season_amplitude    = 0.2,
        extra_food_coef     = 0.1,
        background_mort_coef = 0.05,
        plankton_rate       = 0.5,
        ...) {

    params <- mizer::newMultispeciesParams(species_params, ...)

    # -------------------------------------------------------------------------
    # Mechanism 1: setExtEncounter() and setExtMort()
    #
    # The simplest extension mechanism. Adds fixed species × size arrays
    # directly to the encounter rate or mortality, with no state variable and
    # no dynamics.
    #
    # Here we add an allometric extra food source (scales as w^(3/4)) and a
    # size-dependent background mortality (scales as w^(-1/4)).
    #
    # For a metadata-only extension this might be all you need: set up the
    # extra terms here and record params@extensions below.
    # -------------------------------------------------------------------------
    if (extra_food_coef > 0) {
        extra_food <- outer(
            rep(extra_food_coef, nrow(mizer::species_params(params))),
            mizer::w(params)^(3/4)
        )
        mizer::ext_encounter(params) <- mizer::ext_encounter(params) + extra_food
    }

    if (background_mort_coef > 0) {
        bg_mort <- outer(
            rep(background_mort_coef, nrow(mizer::species_params(params))),
            mizer::w(params)^(-1/4)
        )
        mizer::ext_mort(params) <- mizer::ext_mort(params) + bg_mort
    }

    # -------------------------------------------------------------------------
    # Mechanism 2: parameters used by the project* S3 method
    #
    # Store any parameters that your custom project* methods need in
    # other_params(params). Using a named sub-list scoped to your package
    # avoids collision with parameters from other extensions.
    #
    # The projectEncounter.mizerExtensionTemplate() method (rate-methods.R)
    # reads season_amplitude from here.
    # -------------------------------------------------------------------------
    mizer::other_params(params)$mizerExtensionTemplate <- list(
        season_amplitude = season_amplitude
    )

    # -------------------------------------------------------------------------
    # Mechanism 3: setComponent()
    #
    # Adds a dynamical "plankton" component — an extra resource spectrum stored
    # as a vector on the full size grid. It has its own time-evolution
    # (planktonDynamics) and contributes to the fish encounter rate
    # (planktonEncounter). Both functions are defined in component-functions.R.
    #
    # component_params stores everything the dynamics and encounter functions
    # need. It is accessible inside those functions via
    # params@other_params[["plankton"]].
    # -------------------------------------------------------------------------
    plankton_capacity <- mizer::initialNResource(params) * 0.5
    plankton_params <- list(
        capacity = plankton_capacity,
        rate     = rep(plankton_rate, length(plankton_capacity))
    )
    params <- mizer::setComponent(
        params,
        component      = "plankton",
        initial_value  = plankton_capacity / 2,
        dynamics_fun   = "planktonDynamics",
        encounter_fun  = "planktonEncounter",
        component_params = plankton_params,
        colour         = "forestgreen"
    )

    # -------------------------------------------------------------------------
    # Record the extension chain and promote the object to the S4 marker class.
    #
    # Every constructor in a dispatching extension must end with these two
    # lines, in this order:
    #
    #   params@extensions <- mizer::getRegisteredExtensions()
    #   params <- mizer::coerceToExtensionClass(params)
    #
    # getRegisteredExtensions() returns the chain that all loaded .onLoad
    # hooks have built up. Storing it in params stamps the object with a
    # bill of materials so mizer can warn if a required package is missing
    # when the object is later loaded from disk.
    #
    # coerceToExtensionClass() promotes params from plain MizerParams to
    # mizerExtensionTemplate so that S3 dispatch finds the methods defined in
    # this package. This step cannot be replaced with class(params) <- ...,
    # because MizerParams is a formal S4 class.
    #
    # For a metadata-only extension, keep the first line and drop the second.
    # -------------------------------------------------------------------------
    params@extensions <- mizer::getRegisteredExtensions()
    params <- mizer::coerceToExtensionClass(params)
    params
}
