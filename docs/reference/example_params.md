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
object (an S4 subclass of
[mizer::MizerParams](https://sizespectrum.org/mizer/reference/MizerParams-class.html))
with 3 species and a plankton component.

## Source

Created by `data-raw/example_params.R`.

## Details

Because the object is stored in the package's `data/` directory it is
lazy-loaded by R. The package's `.onLoad` hook replaces the plain
binding with an active binding so that every access to `example_params`
calls
[`mizer::coerceToExtensionClass()`](https://sizespectrum.org/mizer/reference/coerceToExtensionClass.html)
and returns an object with the correct S4 extension class for the
extension chain that is currently registered in the session.

## See also

[`newExtensionTemplateParams()`](https://sizespectrum.org/mizerExtensionTemplate/reference/newExtensionTemplateParams.md)
for the constructor used to build this object,
[`getBiomass.mizerExtensionTemplate()`](https://sizespectrum.org/mizerExtensionTemplate/reference/getBiomass.md)
for the overridden generic,
[mizerExtensionTemplate](https://sizespectrum.org/mizerExtensionTemplate/reference/mizerExtensionTemplate-class.md)
for the S4 class definition.
