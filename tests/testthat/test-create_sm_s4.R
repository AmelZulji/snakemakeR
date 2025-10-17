test_that("create_sm_s4() returns the packaged template", {
  template_path <- system.file(
    "templates",
    "snakemake_s4_template.R",
    package = "snakemakeR"
  )

  expect_true(
    nzchar(template_path),
    info = "Template file is missing from the installed package."
  )

  expected <- paste(readLines(template_path, warn = FALSE), collapse = "\n")
  expect_equal(create_sm_s4(), expected)
})
