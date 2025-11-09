test_that("build_snakemake_s4_snippet() formating works when 1 element is requested", {
  expect_snapshot(build_snakemake_s4_snippet(
    n_input = 1,
    n_output = 1,
    n_param = 1
  ))
})

test_that("build_snakemake_s4_snippet() formating works when 2 elements input elements are requested", {
  expect_snapshot(build_snakemake_s4_snippet(
    n_input = 2,
    n_output = 1,
    n_param = 1
  ))
})
