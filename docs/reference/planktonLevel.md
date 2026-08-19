# Plankton level

The plankton abundance as a fraction of its carrying capacity, at each
size on the full size grid. A value of 1 means the plankton is at
capacity, 0 that it has been grazed away. Sizes at which the capacity is
itself zero give `NaN`, exactly as
[`mizer::resource_level()`](https://sizespectrum.org/mizer/reference/setResource.html)
does; the plotting functions drop them, but use `na.rm = TRUE` if you
summarise the values yourself.

## Usage

``` r
planktonLevel(params)
```

## Arguments

- params:

  A MizerParams object with a "plankton" component, as returned by
  [`newExtensionTemplateParams()`](https://sizespectrum.org/mizerExtensionTemplate/reference/newExtensionTemplateParams.md).

## Value

An
[`mizer::ArrayResourceBySize()`](https://sizespectrum.org/mizer/reference/ArrayResourceBySize.html)
of the plankton level at each size.

## Details

### Why this function declares a `type`

This is the template's example of returning a **classed array** rather
than a bare vector, and of telling mizer what kind of quantity the
values are. The array constructors —
[`mizer::ArrayResourceBySize()`](https://sizespectrum.org/mizer/reference/ArrayResourceBySize.html),
[`mizer::ArraySpeciesBySize()`](https://sizespectrum.org/mizer/reference/ArraySpeciesBySize.html),
[`mizer::ArrayTimeBySpecies()`](https://sizespectrum.org/mizer/reference/ArrayTimeBySpecies.html)
and friends — take a `type` argument with three possible values:

- `"value"`:

  A rate or an amount. The default.

- `"density"`:

  An amount per gram of body weight. Plotting one against a length axis
  (`size_axis = "l"`) multiplies by the `dw/dl` Jacobian, because a
  density per gram is not a density per centimetre.

- `"proportion"`:

  A fraction. Plotted on a linear y axis showing the whole of the
  interval from 0 to 1, so the value can be read against the scale it
  belongs to.

A plankton level is a fraction, so it declares `type = "proportion"` and
`plot(planktonLevel(params))` gets the right axis without the caller
asking for it. Had we returned a bare vector, or omitted `type`, we
would have got a log axis fitted to the data — right for a spectrum,
wrong for a fraction.

Declare `type` for every array your extension returns. If you leave it
out, mizer falls back to guessing from `value_name` and `units` (an
array called `"Number density"` or carrying units of `"1/g"` is taken to
be a density), which is there for backwards compatibility and is easy to
fall foul of.

## See also

[`mizer::resource_level()`](https://sizespectrum.org/mizer/reference/setResource.html),
the mizer function this one mirrors.
