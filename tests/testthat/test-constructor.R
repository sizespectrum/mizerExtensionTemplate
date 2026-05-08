test_that("newExtensionTemplateParams() returns the correct S4 class", {
    params <- newExtensionTemplateParams(NS_species_params)
    expect_s4_class(params, "mizerExtensionTemplate")
    expect_true(methods::is(params, "MizerParams"))
})

test_that("extension is recorded in params@extensions", {
    params <- newExtensionTemplateParams(NS_species_params)
    expect_true("mizerExtensionTemplate" %in% names(params@extensions))
})

test_that("plankton component is present and non-negative", {
    params <- newExtensionTemplateParams(NS_species_params)
    plankton <- initialNOther(params)$plankton
    expect_false(is.null(plankton))
    expect_true(all(plankton >= 0))
    expect_equal(length(plankton), length(w_full(params)))
})

test_that("extra food is added to ext_encounter", {
    params_ext <- newExtensionTemplateParams(NS_species_params,
                                             extra_food_coef = 0.1)
    params_none <- newExtensionTemplateParams(NS_species_params,
                                              extra_food_coef = 0)
    expect_true(all(as.matrix(ext_encounter(params_ext)) >=
                    as.matrix(ext_encounter(params_none))))
})

test_that("background mortality is added to ext_mort", {
    params_ext <- newExtensionTemplateParams(NS_species_params,
                                             background_mort_coef = 0.05)
    params_none <- newExtensionTemplateParams(NS_species_params,
                                              background_mort_coef = 0)
    expect_true(all(as.matrix(ext_mort(params_ext)) >=
                    as.matrix(ext_mort(params_none))))
})

test_that("season_amplitude is stored in other_params", {
    params <- newExtensionTemplateParams(NS_species_params,
                                        season_amplitude = 0.3)
    amp <- other_params(params)$mizerExtensionTemplate$season_amplitude
    expect_equal(amp, 0.3)
})
