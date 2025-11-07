test_that("create_snakemake_object returns the S4 class", {
  snakemake <- create_snakemake_object()
  expect_s4_class(snakemake, "Snakemake")
})

test_that("create_snakemake_object arguments are named input, output, params", {
  arg_names <- names(formals(create_snakemake_object))
  expect_identical(arg_names, c("input", "output", "params"))
})
