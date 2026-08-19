# Create a MizerParams object using the extension template

This constructor demonstrates all five extension mechanisms available in
mizer. Read the inline comments to understand what each block does and
how to adapt it for your own extension.

## Usage

``` r
newExtensionTemplateParams(
  species_params,
  season_amplitude = 0.2,
  extra_food_coef = 0.1,
  background_mort_coef = 0.05,
  plankton_rate = 0.5,
  info_level = 0,
  ...
)
```

## Arguments

- species_params:

  A data frame of species parameters passed directly to
  [`mizer::newMultispeciesParams()`](https://sizespectrum.org/mizer/reference/newMultispeciesParams.html).

- season_amplitude:

  Amplitude of the sinusoidal seasonal variation in the encounter rate,
  as a fraction of the base rate. `0` disables the effect; the default
  `0.2` gives ±20 % variation over the year.

- extra_food_coef:

  Coefficient for the allometric extra food source added via
  [`setExtEncounter()`](https://sizespectrum.org/mizer/reference/setExtEncounter.html).
  Set to `0` to disable.

- background_mort_coef:

  Coefficient for background mortality added via
  [`setExtMort()`](https://sizespectrum.org/mizer/reference/setExtMort.html).
  Set to `0` to disable.

- plankton_rate:

  Intrinsic growth rate of the plankton component (yr⁻¹). Higher values
  make the plankton respond faster to depletion.

- info_level:

  How much
  [`mizer::newMultispeciesParams()`](https://sizespectrum.org/mizer/reference/newMultispeciesParams.html)
  should say about the defaults it fills in, forwarded unchanged. This
  template defaults to `0` only to keep its own examples quiet; your own
  constructor will usually want `info_level = default_info_level()`,
  mizer's exported default, so that it follows the `mizer_info_level`
  option as mizer's own constructors do. Either way, take the argument
  *explicitly* rather than hard-coding a value in the call, or a user
  passing `info_level` would hit "formal argument \\info_level\\ matched
  by multiple actual arguments".

- ...:

  Additional arguments passed to
  [`mizer::newMultispeciesParams()`](https://sizespectrum.org/mizer/reference/newMultispeciesParams.html).

## Value

A `MizerParams` object of class `"mizerExtensionTemplate"`.

## Details

### Extension mechanisms demonstrated

1.  **[`setExtEncounter()`](https://sizespectrum.org/mizer/reference/setExtEncounter.html)
    /
    [`setExtMort()`](https://sizespectrum.org/mizer/reference/setExtMort.html)**
    — add fixed, species × size arrays to encounter or mortality without
    any dynamics.

2.  **`project*` S3 method** — seasonal encounter multiplier implemented
    in
    [`projectEncounter.mizerExtensionTemplate()`](https://sizespectrum.org/mizerExtensionTemplate/reference/projectEncounter.mizerExtensionTemplate.md),
    replacing the
    [`setRateFunction()`](https://sizespectrum.org/mizer/reference/setRateFunction.html)
    approach.

3.  **[`setComponent()`](https://sizespectrum.org/mizer/reference/setComponent.html)**
    — a dynamical plankton component with its own time-evolution and an
    encounter contribution. Defined in `component-functions.R`.

4.  **S3 generic overrides** —
    [`getBiomass.mizerExtensionTemplate()`](https://sizespectrum.org/mizerExtensionTemplate/reference/getBiomass.md)
    and
    [`getBiomass.mizerExtensionTemplateSim()`](https://sizespectrum.org/mizerExtensionTemplate/reference/getBiomass.mizerExtensionTemplateSim.md)
    add the plankton biomass to the standard output.

5.  **[`signal_info()`](https://sizespectrum.org/mizer/reference/signal_info.html)
    /
    [`with_info_level()`](https://sizespectrum.org/mizer/reference/with_info_level.html)**
    — reporting a choice made on the user's behalf through mizer's own
    mechanism, so that it obeys `info_level` and the `mizer_info_level`
    option along with everything else mizer says. See the block at the
    end of this function.

### Metadata-only vs. dispatching extensions

This constructor creates a **dispatching** extension: the returned
object has class `"mizerExtensionTemplate"` so that mizer's generic
functions dispatch to the S3 methods defined in this package. The marker
class is **not** defined statically with `setClass()`; mizer recognises
this package as a dispatching extension from the S3 methods it registers
(see `mizerExtensionTemplate-class`) and creates the class dynamically
at load time, which is what allows it to be chained with other
extensions. The
[`coerceToExtensionClass()`](https://sizespectrum.org/mizer/reference/coerceToExtensionClass.html)
call at the end of this function then promotes the object to that class.
For a **metadata-only** extension (one that does not override any
generic and so registers no dispatch methods), you would omit the
[`coerceToExtensionClass()`](https://sizespectrum.org/mizer/reference/coerceToExtensionClass.html)
call; you still call `params@extensions <- getRegisteredExtensions()` so
the dependency is recorded.

## See also

[`projectEncounter.mizerExtensionTemplate()`](https://sizespectrum.org/mizerExtensionTemplate/reference/projectEncounter.mizerExtensionTemplate.md),
[`planktonDynamics()`](https://sizespectrum.org/mizerExtensionTemplate/reference/planktonDynamics.md),
[`getBiomass.mizerExtensionTemplate()`](https://sizespectrum.org/mizerExtensionTemplate/reference/getBiomass.md)
