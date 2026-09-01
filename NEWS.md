# mizerExtensionTemplate 0.2.0

- Replaced session registration and dynamic S4 marker classes with mizer's
  simpler S3 extension mechanism. Constructors now use `recordExtension()` and
  `coerceToExtensionClass()` to record and class each object explicitly.
- Removed the `.onLoad` hook and active binding for bundled data. Standard R
  serialisation now preserves the full extension class vector.
