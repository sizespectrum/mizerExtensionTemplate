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

Note that the classes are **not** defined statically with `setClass()`.
Instead mizer creates them when the package is loaded:
[`.onLoad()`](https://sizespectrum.org/mizerExtensionTemplate/reference/dot-onLoad.md)
calls
[`mizer::registerExtension()`](https://sizespectrum.org/mizer/reference/registerExtension.html),
which recognises this package as a dispatching extension from the S3
methods it registers for its marker class (for example
[`projectEncounter.mizerExtensionTemplate()`](https://sizespectrum.org/mizerExtensionTemplate/reference/projectEncounter.mizerExtensionTemplate.md))
and inserts the class at the correct place in the S4 hierarchy relative
to any other extension packages loaded in the same session. This is what
lets independently developed extensions be chained in either load order.
Defining the class statically as `contains = "MizerParams"` would
instead fix it as a direct sibling of every other extension and, because
the class would then be sealed, prevent mizer from re-parenting it into
the chain.
