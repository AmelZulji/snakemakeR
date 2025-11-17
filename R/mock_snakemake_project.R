#' Create a mock Snakemake project structure
#'
#' Helper for tests/examples that need a minimal Snakemake project layout.
#' Creates a minimal snakemake project into `project_dir`.
#'
#' @param project_dir Path to the directory where the mock project should be
#'   created.
#'
#' @return Invisibly returns `project_dir`.
#' @examples
#' \dontrun{
#' demo_dir <- file.path(tempdir(), "snakemake-demo")
#' mock_snakemake_project(demo_dir)
#' list.files(demo_dir, recursive = TRUE)
#' }
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
#' Searches the supplied directory for a `Snakefile` (either at the project
#' root or under `workflow/`) and a configuration file (`config.yaml` or
#' `config.yml` under `config/`). Both must be present for the function to
#' return `TRUE`.
#'
#' @param directory Directory to be checked. Defaults to the current working directory.
#'
#' @return Logical of length one indicating whether required files exist.
#' @examples
#' \dontrun{
#' demo_dir <- mock_snakemake_project(tempfile("snakemake-demo-"))
#' is_snakemake_project(demo_dir)
#' }
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
#' for examples or tests that need a stand-in for the real Snakemake runtime and
#' for interactive development where the Python Snakemake runtime is not
#' available.
#'
#' @param input,output,params Named list of inputs, output and parameters
#'
#' @return An object of class \code{Snakemake} with `input`, `output`, and
#'   `params` slots populated from the provided lists.
#' @examples
#' snakemake <- create_snakemake_object(
#'   input = list(raw = "data/sample.csv"),
#'   output = list(clean = "results/sample_clean.csv"),
#'   params = list(na_rm = TRUE)
#' )
#' snakemake@params$na_rm
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

#' Insert a Snakemake CSO Snippet into the Current RStudio Document
#'
#' This helper function inserts a predefined code snippet that constructs
#' a minimal `create_snakemake_object()` call. It is intended to speed up
#' interactive development when working inside RStudio.
#'
#' The function requires RStudio and uses the `rstudioapi` package to insert
#' text at the current cursor position. If RStudio is not available, it
#' throws an error.
#'
#' @return Invisibly returns the inserted snippet as a character string.
#' @export
#'
#' @examples
#' \dontrun{
#' insert_cso_snippet()
#' }
insert_cso_snippet <- function() {
  if (!rstudioapi::isAvailable()) {
    stop(
      "rstudioapi is not available. Run this function from within RStudio.",
      call. = FALSE
    )
  }

  snippet <- 'if (interactive()) {
  snakemake <- create_snakemake_object(
    input = list(in1 = "data/sti_1.csv"),
    params = list(bar_col = "blue", bar_fill = "green2",nbins = 10),
    output = list(out1 = "results/histogram/sti_1.png")
  )
}

'
  rstudioapi::insertText(text = snippet)
  invisible(snippet)
}
