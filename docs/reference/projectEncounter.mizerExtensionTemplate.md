# Seasonal encounter rate for the extension template

Applies a sinusoidal seasonal multiplier on top of the encounter rate
computed by lower extensions and the base mizer calculation.

## Usage

``` r
# S3 method for class 'mizerExtensionTemplate'
projectEncounter(params, n, n_pp, n_other, t = 0, ...)
```

## Arguments

- params:

  A MizerParams object of class `"mizerExtensionTemplate"`.

- n:

  Species abundance matrix (species × size).

- n_pp:

  Resource abundance vector (full size grid).

- n_other:

  Named list of other component states.

- t:

  Current simulation time (years). The seasonal multiplier is
  `1 + amplitude * sin(2π t)`, which peaks at `t = 0.25` and troughs at
  `t = 0.75`.

- ...:

  Additional arguments passed through the dispatch chain.

## Value

A numeric matrix (species × size) of encounter rates, seasonally scaled.

## Details

This method replaces the
[`setRateFunction()`](https://sizespectrum.org/mizer/reference/setRateFunction.html)
approach used in single-user scripts. It participates in the S3 dispatch
chain so that multiple loaded extension packages can each modify the
encounter rate without overwriting one another.

### Why `project*` methods instead of [`setRateFunction()`](https://sizespectrum.org/mizer/reference/setRateFunction.html)

`setRateFunction(params, "Encounter", "myFn")` stores a single function
name per rate. If two extension packages both call it for the same rate,
the second silently overwrites the first. S3 dispatch via `project*`
methods avoids this: each extension defines a method for its own marker
class and calls [`NextMethod()`](https://rdrr.io/r/base/UseMethod.html)
to pass control down the chain.

### Rules for every `project*` method

1.  **Always call
    [`NextMethod()`](https://rdrr.io/r/base/UseMethod.html)** — omitting
    it silently drops all contributions from lower extensions and the
    base mizer calculation.

2.  **Keep the same argument signature** as the generic and include
    `...` so extra arguments pass through to lower methods.

3.  **Do not call
    [`setRateFunction()`](https://sizespectrum.org/mizer/reference/setRateFunction.html)**
    in your constructor for any rate handled by a `project*` method in
    this package.
