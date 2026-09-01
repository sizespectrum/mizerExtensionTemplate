# Changelog

## mizerExtensionTemplate 0.2.0

- Replaced session registration and dynamic S4 marker classes with
  mizer’s simpler S3 extension mechanism. Constructors now use
  [`recordExtension()`](https://sizespectrum.org/mizer/reference/recordExtension.html)
  and
  [`coerceToExtensionClass()`](https://sizespectrum.org/mizer/reference/coerceToExtensionClass.html)
  to record and class each object explicitly.
- Removed the `.onLoad` hook and active binding for bundled data.
  Standard R serialisation now preserves the full extension class
  vector.
