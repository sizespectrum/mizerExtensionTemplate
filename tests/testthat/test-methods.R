test_that("seasonal encounter varies correctly with time", {
  params <- newExtensionTemplateParams(NS_species_params,
                                      season_amplitude = 0.2,
                                      extra_food_coef = 0,
                                      background_mort_coef = 0)
  # getEncounter returns an ArraySpeciesBySize; convert to plain numeric matrix
  enc_t0   <- as.matrix(getEncounter(params, t = 0))
  enc_t025 <- as.matrix(getEncounter(params, t = 0.25))

  # At t = 0:    sin(2π * 0)    = 0 → multiplier = 1.0
  # At t = 0.25: sin(2π * 0.25) = 1 → multiplier = 1.2
  finite <- is.finite(enc_t0) & is.finite(enc_t025) & enc_t0 > 0
  expect_equal(enc_t025[finite] / enc_t0[finite],
               rep(1.2, sum(finite)),
               tolerance = 1e-10)
})

test_that("encounter is flat when season_amplitude = 0", {
  params <- newExtensionTemplateParams(NS_species_params,
                                      season_amplitude = 0)
  enc_t0   <- as.matrix(getEncounter(params, t = 0))
  enc_t025 <- as.matrix(getEncounter(params, t = 0.25))
  expect_equal(enc_t025, enc_t0)
})

test_that("getBiomass includes Plankton entry for MizerParams", {
  params <- newExtensionTemplateParams(NS_species_params)
  b <- getBiomass(params)
  expect_true("Plankton" %in% names(b))
  expect_gt(b[["Plankton"]], 0)
})

test_that("project() returns a mizerExtensionTemplateSim", {
  params <- newExtensionTemplateParams(NS_species_params)
  sim <- project(params, t_max = 1, t_save = 1)
  expect_s4_class(sim, "mizerExtensionTemplateSim")
  expect_true(methods::is(sim, "MizerSim"))
})

test_that("getBiomass includes Plankton column for MizerSim", {
  params <- newExtensionTemplateParams(NS_species_params)
  sim    <- project(params, t_max = 2, t_save = 1)
  b      <- getBiomass(sim)
  expect_true("Plankton" %in% dimnames(b)[[2]])
  expect_true(all(b[, "Plankton"] > 0))
})

test_that("planktonDynamics preserves non-negativity after projection", {
  params <- newExtensionTemplateParams(NS_species_params)
  sim    <- project(params, t_max = 5, t_save = 1)
  no_t   <- dim(sim@n)[1]
  for (i in seq_len(no_t)) {
    pl <- sim@n_other[i, "plankton"][[1]]
    expect_true(all(pl >= 0))
  }
})

test_that("planktonLevel() declares itself a proportion", {
  params <- newExtensionTemplateParams(NS_species_params)
  lev    <- planktonLevel(params)

  expect_s3_class(lev, "ArrayResourceBySize")
  expect_identical(attr(lev, "type"), "proportion")
  expect_length(lev, length(w_full(params)))
  # The constructor starts the plankton at half its capacity.
  expect_equal(unique(round(as.numeric(lev[is.finite(lev)]), 10)), 0.5)
})

test_that("the declared type gives a proportion the 0-1 y axis", {
  params <- newExtensionTemplateParams(NS_species_params)
  g      <- plot(planktonLevel(params))
  expect_equal(ggplot2::layer_scales(g)$y$get_limits(), c(0, 1))
})

test_that("getBiomass arrays declare themselves plain values", {
  params <- newExtensionTemplateParams(NS_species_params)
  sim    <- project(params, t_max = 2, t_save = 1)
  expect_identical(attr(getBiomass(sim), "type"), "value")
})
