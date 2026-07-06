## code to prepare the `example_params` dataset
##
## Run this script once (e.g. source("data-raw/example_params.R") from the
## package root) whenever you want to regenerate the bundled example object.
## The result is saved to data/example_params.rda and is then lazy-loaded
## by R whenever the package is attached.
##
## Note: the active binding in .onLoad (mizerExtensionTemplate-package.R)
## means that users always receive a properly classed object regardless of
## which other mizer extension packages they have loaded.

library(mizer)
library(mizerExtensionTemplate)

# Use the North Sea species parameters bundled in mizer as a convenient
# starting point, but keep only three species so the object stays small.
sp <- mizer::NS_species_params_gears[c(1, 4, 11), ]  # Sprat, Herring, Cod

example_params <- newExtensionTemplateParams(
    species_params    = sp,
    season_amplitude  = 0.2,
    extra_food_coef   = 0.1,
    background_mort_coef = 0.05,
    plankton_rate     = 0.5,
    no_w              = 20     # small grid for a compact file
)

usethis::use_data(example_params, overwrite = TRUE)
