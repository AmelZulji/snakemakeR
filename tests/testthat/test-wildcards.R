test_that("extract_expand_wildcard detects wildcard in mock project", {
  smkproj <- withr::local_tempdir("test")
  mock_snakemake_project(smkproj)
  withr::local_dir(smkproj)
  expect_equal(extract_expand_wildcard(), "sample")
})

test_that("extract_expand_wildcard errors when all files missing", {
  expect_error(
    extract_expand_wildcard(files = c("non_valid_path.smk")),
    "Provided `files` do not exist"
  )
})

test_that("extract_expand_wildcard warns when some files missing", {
  valid_file <- system.file("extdata", "Snakefile", package = "snakemakeR")
  invalid_file <- "invalid_path.R"
  expect_warning(
    extract_expand_wildcard(files = c(valid_file, invalid_file)),
    regexp = "Following file do not exist: "
  )
})


test_that("extract_expand_wildcard warns on empty files", {
  # character() included to create empty file
  path <- withr::local_tempfile(lines = character())
  expect_warning(
    extract_expand_wildcard(files = path),
    regexp = "Provided `files` are empty."
  )
})


test_that("extract_expand_wildcard warns when multiple wildcards found", {
  # character() included to create empty file
  path1 <- withr::local_tempfile(
    lines = c('expand("results/scater_plot/{sample}.png", sample=samples)')
  )
  path2 <- withr::local_tempfile(
    lines = c('expand("results/scater_plot/{sample}.png", sampler=samples)')
  )

  expect_warning(
    extract_expand_wildcard(files = c(path1, path2)),
    regexp = "Found more than one wildcard. Returning the first one"
  )
})


test_that("extract_expand_wildcard warns when no wildcards present", {
  # character() included to create empty file
  path <- withr::local_tempfile(lines = c('some random text'))
  expect_warning(
    extract_expand_wildcard(files = c(path)),
    regexp = "No wildcard found. Returning empty character"
  )
})
