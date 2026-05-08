# mizerExtensionTemplate marker classes

S4 marker subclasses of
[MizerParams](https://sizespectrum.org/mizer/reference/MizerParams.html)
and [MizerSim](https://sizespectrum.org/mizer/reference/MizerSim.html)
that enable S3 dispatch for extension-specific methods defined in this
package.

## Details

These classes add no new slots. All extension-specific data lives in
`other_params(params)$mizerExtensionTemplate` and in the component
parameters of the "plankton" component (see
[`setComponent()`](https://sizespectrum.org/mizer/reference/setComponent.html)).

Objects of class `mizerExtensionTemplate` are created by
[`newExtensionTemplateParams()`](https://sizespectrum.org/mizerExtensionTemplate/reference/newExtensionTemplateParams.md).
Objects of class `mizerExtensionTemplateSim` are returned automatically
by [`project()`](https://sizespectrum.org/mizer/reference/project.html)
when called on a `mizerExtensionTemplate` params object.
