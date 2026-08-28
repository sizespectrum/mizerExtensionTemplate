# Example MizerParams object for the extension template

A small three-species `mizerExtensionTemplate` model built from a subset
of the North Sea species parameters bundled with mizer (Sprat, Herring,
Cod). It demonstrates all five extension mechanisms provided by this
template package: an extra encounter term, a seasonal encounter
multiplier, an allometric background mortality, a dynamical plankton
component, and an overridden
[`getBiomass()`](https://sizespectrum.org/mizerExtensionTemplate/reference/getBiomass.md)
generic.

## Usage

``` r
example_params
```

## Format

A
[mizerExtensionTemplate](https://sizespectrum.org/mizerExtensionTemplate/reference/mizerExtensionTemplate-class.md)
object with 3 species and a plankton component.

## Source

Created by `data-raw/example_params.R`.

## Details

The object was created with
[`newExtensionTemplateParams()`](https://sizespectrum.org/mizerExtensionTemplate/reference/newExtensionTemplateParams.md)
and is stored in the package's `data/` directory. R's standard
lazy-loading preserves its S3 class vector and extension metadata, so no
load hook or active binding is needed.

## See also

[`newExtensionTemplateParams()`](https://sizespectrum.org/mizerExtensionTemplate/reference/newExtensionTemplateParams.md)
for the constructor used to build this object,
[`getBiomass.mizerExtensionTemplate()`](https://sizespectrum.org/mizerExtensionTemplate/reference/getBiomass.md)
for the overridden generic,
[mizerExtensionTemplate](https://sizespectrum.org/mizerExtensionTemplate/reference/mizerExtensionTemplate-class.md)
for the S3 extension classes.
