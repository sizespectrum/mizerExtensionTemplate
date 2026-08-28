# mizerExtensionTemplate

A template R package for building
[mizer](https://sizespectrum.org/mizer/) extension packages. Clone it,
rename it, and replace the placeholder code with your own extension
logic. See [Get
Started](https://sizespectrum.org/mizerExtensionTemplate/articles/mizerExtensionTemplate.md)
for details.

## What this template demonstrates

Every extension mechanism described in the mizer documentation is
illustrated with working, commented code:

| Mechanism | Where | What the template adds |
|----|----|----|
| [`setExtEncounter()`](https://sizespectrum.org/mizer/reference/setExtEncounter.html) | `R/constructor.R` | Allometric extra food source |
| [`setExtMort()`](https://sizespectrum.org/mizer/reference/setExtMort.html) | `R/constructor.R` | Size-dependent background mortality |
| `project*` S3 method | `R/rate-methods.R` | Seasonal encounter multiplier |
| [`setComponent()`](https://sizespectrum.org/mizer/reference/setComponent.html) | `R/constructor.R` + `R/component-functions.R` | Dynamical plankton spectrum |
| `getBiomass` S3 override | `R/generic-methods.R` | Plankton biomass in output |
| Classed arrays with a `type` | `R/component-functions.R` | [`planktonLevel()`](https://sizespectrum.org/mizerExtensionTemplate/reference/planktonLevel.md), a proportion that plots on a 0–1 axis |
| [`signal_info()`](https://sizespectrum.org/mizer/reference/signal_info.html) / [`with_info_level()`](https://sizespectrum.org/mizer/reference/with_info_level.html) | `R/constructor.R` | Reports a choice through mizer’s own `info_level` mechanism |
| Bundled data object | `data/` + `R/data.R` | `example_params` ready to use |

The template also shows both kinds of extension package:

- **Dispatching** (like this template and
  [mizerShelf](https://sizespectrum.org/mizerShelf/)): records an S3
  extension class so mizer’s generic functions dispatch to
  extension-specific methods via
  [`NextMethod()`](https://rdrr.io/r/base/UseMethod.html).
- **Metadata-only** (like
  [mizerStarvation](https://sizespectrum.org/mizerStarvation/)): records
  the extension dependency without overriding any generic. Comments in
  the constructor explain which parts to keep or drop for this case.

## Installation

``` r

# Install from GitHub (requires mizer 3.3.1 or later)
pak::pak("sizespectrum/mizerExtensionTemplate")
```

## Quick start

``` r

library(mizerExtensionTemplate)

# Use the bundled example model (already correctly classed):
getBiomass(example_params)   # includes Plankton

# Or build your own:
params <- newExtensionTemplateParams(NS_species_params)
sim    <- project(params, t_max = 10)
plotBiomass(sim)   # includes a Plankton column
```

## Using this template for your own extension

1.  **Use this repo as a GitHub template** (click “Use this template” on
    GitHub) or copy the files manually.

2.  **Rename** `mizerExtensionTemplate` → your package name throughout:

    - `DESCRIPTION` (Package, Title, Description, URL, BugReports)
    - `R/mizerExtensionTemplate-class.R` — rename the file and the class
      names it documents (there is no class declaration to rename)
    - `R/constructor.R` — rename
      [`newExtensionTemplateParams()`](https://sizespectrum.org/mizerExtensionTemplate/reference/newExtensionTemplateParams.md)
      and update the name and `requirement` passed to
      [`recordExtension()`](https://sizespectrum.org/mizer/reference/recordExtension.html)
    - `R/rate-methods.R` and `R/generic-methods.R` — rename all method
      suffixes
    - `tests/` and `vignettes/` — rename file names and internal
      references

3.  **Decide: metadata-only or dispatching?**  
    For a metadata-only extension, delete
    `R/mizerExtensionTemplate-class.R` and drop the
    [`coerceToExtensionClass()`](https://sizespectrum.org/mizer/reference/coerceToExtensionClass.html)
    call at the end of the constructor. Keep the
    [`recordExtension()`](https://sizespectrum.org/mizer/reference/recordExtension.html)
    call.

4.  **Replace the placeholder extension logic** with your own. Each
    mechanism in `R/constructor.R` is independent — delete the ones you
    don’t need.

5.  **If you ship a bundled data object** in `data/`, create it with
    your setup function and save it normally with
    [`usethis::use_data()`](https://usethis.r-lib.org/reference/use_data.html).
    R preserves its S3 class vector and extension metadata; no `.onLoad`
    hook is needed.

6.  **Regenerate** the namespace and documentation:

    ``` r

    devtools::document()
    devtools::test()
    devtools::check()
    ```

## Background reading

- [Guide: Extending
  mizer](https://sizespectrum.org/mizer/articles/guide-extend-mizer.html)
  — all five extension mechanisms with worked examples.
- [Guide: Creating a mizer extension
  package](https://sizespectrum.org/mizer/articles/guide-create-extension-package.html)
  — the concepts behind S3 extension classes,
  [`NextMethod()`](https://rdrr.io/r/base/UseMethod.html) chaining, and
  composable extensions.
- [Guide: Using mizer extension
  packages](https://sizespectrum.org/mizer/articles/guide-use-extension-packages.html)
  — the user’s perspective on the extension chain.
