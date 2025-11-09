test_that("build_rule() produces properly fomrated rule", {
  proj_dir <- mock_snakemake_project(project_dir = "testing")
  on.exit(fs::dir_delete(proj_dir), add = TRUE, after = FALSE)

  wd <- setwd(proj_dir)
  on.exit(setwd(wd), add = TRUE, after = FALSE)

  expect_snapshot(
    build_rule(
      output = list(out1 = "out.csv"),
      script = "workflow/scripts/analysis.R",
      input = list(in1 = "input1.csv"),
      params = list(narm = TRUE)
    )
  )
})

test_that("build_rule() properly chains input, output and params when they more 1 one arg is present", {
  proj_dir <- mock_snakemake_project(project_dir = "testing")
  on.exit(fs::dir_delete(proj_dir), add = TRUE, after = FALSE)

  wd <- setwd(proj_dir)
  on.exit(setwd(wd), add = TRUE, after = FALSE)

  expect_snapshot(
    build_rule(
      output = list(out1 = "out.csv"),
      script = "workflow/scripts/analysis.R",
      input = list(in1 = "input1.csv", in2 = "input2.csv"),
      params = list(narm = TRUE, mean = 10)
    )
  )
})



