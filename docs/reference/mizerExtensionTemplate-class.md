# mizerExtensionTemplate extension classes

S3 extension classes for
[MizerParams](https://sizespectrum.org/mizer/reference/MizerParams.html)
and [MizerSim](https://sizespectrum.org/mizer/reference/MizerSim.html)
that enable dispatch to the methods defined in this package.

## Details

The class names are ordinary entries in the object's S3 class vector.
All extension-specific data lives in
`other_params(params)$mizerExtensionTemplate` and in the component
parameters of the "plankton" component (see
[`setComponent()`](https://sizespectrum.org/mizer/reference/setComponent.html)).

Objects of class `mizerExtensionTemplate` are created by
[`newExtensionTemplateParams()`](https://sizespectrum.org/mizerExtensionTemplate/reference/newExtensionTemplateParams.md).
Objects of class `mizerExtensionTemplateSim` are returned automatically
by [`project()`](https://sizespectrum.org/mizer/reference/project.html)
when called on a `mizerExtensionTemplate` params object.

No class declaration is needed.
[`newExtensionTemplateParams()`](https://sizespectrum.org/mizerExtensionTemplate/reference/newExtensionTemplateParams.md)
records the extension on the object with
[`mizer::recordExtension()`](https://sizespectrum.org/mizer/reference/recordExtension.html)
and then calls
[`mizer::coerceToExtensionClass()`](https://sizespectrum.org/mizer/reference/coerceToExtensionClass.html).
For example, the params class vector is
`c("mizerExtensionTemplate", "MizerParams")`; simulations created by
[`project()`](https://sizespectrum.org/mizer/reference/project.html)
receive `c("mizerExtensionTemplateSim", "MizerSim")` automatically.
