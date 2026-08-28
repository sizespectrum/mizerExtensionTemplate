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
#' 5. **`signal_info()` / `with_info_level()`** — reporting a choice made on the
#'    user's behalf through mizer's own mechanism, so that it obeys
#'    `info_level` and the `mizer_info_level` option along with everything else
#'    mizer says. See the block at the end of this function.
#'
#' ## Metadata-only vs. dispatching extensions
#'
#' This constructor creates a **dispatching** extension: the returned object
#' has class `"mizerExtensionTemplate"` so that mizer's generic functions
#' dispatch to the S3 methods defined in this package. No class declaration or
#' load hook is needed. [recordExtension()] adds this extension to the object's
#' own metadata, and [coerceToExtensionClass()] builds the ordinary S3 class
#' vector from that record. For a **metadata-only** extension (one that does
#' not override any generic), omit the `coerceToExtensionClass()` call but keep
#' the `recordExtension()` call so the dependency remains reproducible.
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
#' @param info_level How much [mizer::newMultispeciesParams()] should say about
#'   the defaults it fills in, forwarded unchanged. This template defaults to
#'   `0` only to keep its own examples quiet; your own constructor will usually
#'   want `info_level = default_info_level()`, mizer's exported default, so that
#'   it follows the `mizer_info_level` option as mizer's own constructors do.
#'   Either way, take the argument *explicitly* rather than
#'   hard-coding a value in the call, or a user passing `info_level` would hit
#'   "formal argument \"info_level\" matched by multiple actual arguments".
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
        info_level          = 0,
        ...) {

    # -------------------------------------------------------------------------
    # Mechanism 5: reporting to the user
    #
    # with_info_level() collects the reports raised anywhere inside this
    # function — by mizer's own setters and by our signal_info() call below —
    # and gives them to the user together when the constructor returns.
    #
    # Wrap the whole body. The handlers nest by themselves: if the user called
    # us from inside another function that is already collecting, ours steps
    # aside and lets the outer one report. So you never have to check.
    #
    # Never use message() or warning() for this. They ignore info_level, they
    # are not collected with the other reports, and on the species_params<-()
    # path a message() is swallowed outright.
    # -------------------------------------------------------------------------
    with_info_level(info_level = info_level, {

    params <- newMultispeciesParams(species_params,
                                    info_level = info_level, ...)

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
    # extra terms here and call recordExtension() below.
    # -------------------------------------------------------------------------
    if (extra_food_coef > 0) {
        extra_food <- outer(
            rep(extra_food_coef, nrow(species_params(params))),
            w(params)^(3/4)
        )
        ext_encounter(params) <- ext_encounter(params) + extra_food
    }

    if (background_mort_coef > 0) {
        bg_mort <- outer(
            rep(background_mort_coef, nrow(species_params(params))),
            w(params)^(-1/4)
        )
        ext_mort(params) <- ext_mort(params) + bg_mort
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
    other_params(params)$mizerExtensionTemplate <- list(
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
    plankton_capacity <- initialNResource(params) * 0.5
    # A choice made on the user's behalf, so we say so. `var` names the quantity
    # the report is about, and `level` says how important it is: level 1 survives
    # `info_level = 1`, level 3 is chatter that only the default shows. This is
    # chatter, so level 3.
    #
    # Two further arguments matter when your own report is not routine:
    #   severity = "warning" for something the user asked for that is not
    #     happening — an "info" report is suppressed on the species_params<-()
    #     path and would never be seen there.
    #   unhandled = "show" to report even when nothing is collecting, which is
    #     right when yours may be all the user hears.
    signal_info("plankton_capacity",
                paste("Setting the plankton capacity to half the resource",
                      "capacity."),
                level = 3)
    plankton_params <- list(
        capacity = plankton_capacity,
        rate     = rep(plankton_rate, length(plankton_capacity))
    )
    params <- setComponent(
        params,
        component      = "plankton",
        initial_value  = plankton_capacity / 2,
        dynamics_fun   = "planktonDynamics",
        encounter_fun  = "planktonEncounter",
        component_params = plankton_params,
        colour         = "forestgreen"
    )

    # -------------------------------------------------------------------------
    # Record the extension and set the ordinary S3 class vector.
    #
    # Every constructor in a dispatching extension must end with these two
    # calls, in this order:
    #
    #   params <- recordExtension(params, "mizerExtensionTemplate", ...)
    #   params <- coerceToExtensionClass(params)
    #
    # recordExtension() prepends this extension to the chain already recorded
    # on this particular object. Its requirement lets mizer install the package
    # when a saved model is opened, and its version stamp says which object
    # layout this constructor created. Extensions that merely happen to be
    # loaded are not added.
    #
    # coerceToExtensionClass() reads that recorded chain and sets class(params)
    # to c("mizerExtensionTemplate", "MizerParams"), allowing NextMethod()
    # chains to compose with any extensions already recorded on the object.
    #
    # For a metadata-only extension, keep recordExtension() and drop coercion.
    # -------------------------------------------------------------------------
    params <- recordExtension(
        params,
        "mizerExtensionTemplate",
        version = as.character(
            utils::packageVersion("mizerExtensionTemplate")
        ),
        requirement = "sizespectrum/mizerExtensionTemplate"
    )
    params <- coerceToExtensionClass(params)
    params

    })  # end with_info_level()
}
