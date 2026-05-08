# Plankton dynamics

Updates the plankton component spectrum at each time step. This function
is registered as the `dynamics_fun` of the "plankton" component in
[`newExtensionTemplateParams()`](https://sizespectrum.org/mizerExtensionTemplate/reference/newExtensionTemplateParams.md)
and is called automatically by
[`project()`](https://sizespectrum.org/mizer/reference/project.html).

## Usage

``` r
planktonDynamics(params, n_other, rates, dt, component, ...)
```

## Arguments

- params:

  A MizerParams object.

- n_other:

  Named list of current component states. The plankton spectrum is
  available as `n_other[["plankton"]]`.

- rates:

  A named list of rates as returned by
  [`mizer::getRates()`](https://sizespectrum.org/mizer/reference/getRates.html).
  Used to compute predation mortality on the plankton spectrum via
  `rates$pred_rate`.

- dt:

  Length of the current time step (years).

- component:

  Name of this component (`"plankton"`).

- ...:

  Additional arguments (ignored).

## Value

Updated plankton abundance vector (full size grid).

## Details

The plankton grows towards a size-specific carrying capacity at a fixed
rate and is simultaneously depleted by predation. The update is the
analytical solution of the linear ODE:

\$\$dP/dt = r(K - P) - m \cdot P = rK - (r + m)P\$\$

where `r` is the growth rate, `K` is the carrying capacity, and `m` is
the predation mortality on the plankton spectrum at each size bin.

This implementation follows the detritus example in
`vignette("extending-mizer", package = "mizer")`.
