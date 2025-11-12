#' Create a mock Snakemake project structure
#'
#' Helper for tests/examples that need a minimal Snakemake project layout.
#' Creates a temporary directory (if none supplied) with a Snakefile and config
#' file so utilities like \code{is_snakemake_project()} can run against it.
#'
#' @param project_dir Directory where to write a mock snakemake project. Defaults to `./snakemake_project`.
#' @export
mock_snakemake_project <- function(project_dir = "snakemake_project") {
file_paths <- list(
  snakefile_path = list(
    source = system.file("extdata", c("Snakefile"), package = "snakemakeR"),
    destination = file.path(project_dir, "workflow")
  ),
  config_path = list(
    source = system.file(
      "extdata",
      c("config.yaml", "sample_metadata.csv"),
      package = "snakemakeR"
    ),
    destination = file.path(project_dir, "config")
  ),
  script_path = list(
    source = system.file(
      "extdata",
      c("compute_mean.R"),
      package = "snakemakeR"
    ),
    destination = file.path(project_dir, "workflow/scripts")
  ),
  rule_path = list(
    source = system.file(
      "extdata",
      c("compute_mean.smk"),
      package = "snakemakeR"
    ),
    destination = file.path(project_dir, "workflow/rules")
  ),
  data_path = list(
    source = system.file(
      "extdata",
      c("sample_1.csv", "sample_2.csv", "sample_3.csv"),
      package = "snakemakeR"
    ),
    destination = file.path(project_dir, "data")
  )
)
  # lapply(file_paths, \(x) {
  #   fs::dir_create(x[["destination"]], recurse = TRUE)
  #   fs::file_copy(path = x[["source"]], new_path = x[["destination"]])
  # })

  lapply(file_paths, \(x) {
    fs::dir_create(x[["destination"]], recurse = TRUE)
    # fs::file_copy(path = x[["source"]], new_path = x[["destination"]])
  })

  lapply(file_paths, \(x) {
    # fs::dir_create(x[["destination"]], recurse = TRUE)
    fs::file_copy(path = x[["source"]], new_path = x[["destination"]])
  })


  invisible(project_dir)
}


#' Test if the directory is a snakemake project
#'
#' Searches the directory for the presence of Snakefile in root or in workflow.
#'
#' @param directory directory to be checked
#'
#' @returns logical of length 1
#' @export
is_snakemake_project <- function(directory = ".") {
  path <- fs::path_abs(path)

  snakefile <- fs::path(path, c("Snakefile", "workflow/Snakefile"))
  config <- fs::path(path, c("config/config.yaml", "config/config.yml"))

  snakefile_exists <- any(fs::file_exists(snakefile))
  config_exists <- any(fs::file_exists(config))

  if (snakefile_exists && config_exists) TRUE else FALSE
}

#' Create a demo Snakemake S4 object
#'
#' Helper that ensures the \code{Snakemake} S4 class is defined and returns a
#' ready-to-use instance populated with demo-friendly defaults. This is useful
#' for examples or tests that need a stand-in for the real Snakemake runtime.
#'
#' @param input,output,params Named list of inputs, output and parameters
#'
#' @return An object of class \code{Snakemake}.
#' @export
create_snakemake_object <- function(
  input = list(),
  output = list(),
  params = list()
) {
  class_env <- .GlobalEnv

  class_exists <- methods::isClass("Snakemake") ||
    methods::isClass("Snakemake", where = class_env)

  if (!class_exists) {
    methods::setClass(
      "Snakemake",
      slots = list(
        input = "list",
        output = "list",
        params = "list"
      ),
      where = class_env
    )
  }

  methods::new(
    Class = "Snakemake",
    input = input,
    output = output,
    params = params
  )
}
