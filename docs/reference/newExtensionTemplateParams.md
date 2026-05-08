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

### Metadata-only vs. dispatching extensions

This constructor creates a **dispatching** extension: the returned
object has class `"mizerExtensionTemplate"` so that mizer's generic
functions dispatch to the S3 methods defined in this package. For a
**metadata-only** extension (one that does not override any generic),
you would omit the `setClass()` definition in
`mizerExtensionTemplate-class.R` and the
[`coerceToExtensionClass()`](https://sizespectrum.org/mizer/reference/coerceToExtensionClass.html)
call at the end of this function. You still call
`params@extensions <- getRegisteredExtensions()` so the dependency is
recorded.

## See also

[`projectEncounter.mizerExtensionTemplate()`](https://sizespectrum.org/mizerExtensionTemplate/reference/projectEncounter.mizerExtensionTemplate.md),
[`planktonDynamics()`](https://sizespectrum.org/mizerExtensionTemplate/reference/planktonDynamics.md),
[`getBiomass.mizerExtensionTemplate()`](https://sizespectrum.org/mizerExtensionTemplate/reference/getBiomass.md)
