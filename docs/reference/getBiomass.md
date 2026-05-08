# Get biomass including the plankton component

Extends
[`mizer::getBiomass()`](https://sizespectrum.org/mizer/reference/getBiomass.html)
for `mizerExtensionTemplate` objects to append the plankton component
biomass to the standard species biomasses.

## Usage

``` r
# S3 method for class 'mizerExtensionTemplate'
getBiomass(object, ...)
```

## Arguments

- object:

  A `mizerExtensionTemplate` params object.

- ...:

  Passed to the next method in the dispatch chain.

## Value

A named numeric vector of biomasses (g) with an extra "Plankton" entry.

## Details

Because
[`plotBiomass()`](https://sizespectrum.org/mizer/reference/plotBiomass.html)
calls `getBiomass()` internally, this single override is enough to make
biomass plots include the plankton without any further changes.
