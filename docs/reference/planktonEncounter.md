# Plankton encounter contribution

Computes the extra encounter rate that fish experience by feeding on the
plankton component. This function is registered as the `encounter_fun`
of the "plankton" component in
[`newExtensionTemplateParams()`](https://sizespectrum.org/mizerExtensionTemplate/reference/newExtensionTemplateParams.md)
and is called automatically by
[`mizer::getEncounter()`](https://sizespectrum.org/mizer/reference/getEncounter.html)
at each time step.

## Usage

``` r
planktonEncounter(params, n, n_pp, n_other, component, ...)
```

## Arguments

- params:

  A MizerParams object.

- n:

  Species abundance matrix (species × size).

- n_pp:

  Resource abundance vector (full size grid).

- n_other:

  Named list of other component states, including the current plankton
  spectrum under `n_other[["plankton"]]`.

- component:

  Name of this component (`"plankton"`).

- ...:

  Additional arguments (ignored).

## Value

A numeric matrix (species × size) of extra encounter rates due to
plankton.

## Details

The implementation is taken directly from the detritus example in
`vignette("extending-mizer", package = "mizer")`. It treats the plankton
spectrum as the resource (`n_pp`) in a standard mizer encounter
calculation, after first removing the plankton's own encounter hook from
the temporary params copy to avoid double-counting.
