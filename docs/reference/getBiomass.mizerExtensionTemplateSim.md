# Get biomass time series including the plankton component

Extends
[`mizer::getBiomass()`](https://sizespectrum.org/mizer/reference/getBiomass.html)
for `mizerExtensionTemplateSim` objects to append a plankton biomass
column to the time × species matrix returned by the base method.

## Usage

``` r
# S3 method for class 'mizerExtensionTemplateSim'
getBiomass(object, ...)
```

## Arguments

- object:

  A `mizerExtensionTemplateSim` sim object.

- ...:

  Passed to the next method in the dispatch chain.

## Value

An `ArrayTimeBySpecies` matrix (time × species + Plankton) with
biomasses in grams.
