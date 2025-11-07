#' Create a mock Snakemake project structure
#'
#' Helper for tests/examples that need a minimal Snakemake project layout.
#' Creates a temporary directory (if none supplied) with a Snakefile and config
#' file so utilities like \code{is_snakemake_project()} can run against it.
#'
#' @param path Optional directory to populate. Defaults to a new temporary dir.
#' @param snakefile_location Where to place the Snakefile: either
#'   \code{"root"} (default) or \code{"workflow"}.
#' @param include_config Logical; create \code{config/config.yaml}.
#'
#' @return A path to the mock project directory.
#' @export
mock_snakemake_project <- function(
    path = fs::path_temp("snakemake_project"),
    snakefile_location = c("root", "workflow"),
    include_config = TRUE) {
  fs::dir_create(path, recurse = TRUE)

  snakefile_location <- match.arg(snakefile_location)

  if (identical(snakefile_location, "root")) {
    fs::file_create(fs::path(path, "Snakefile"))
  }

  if (identical(snakefile_location, "workflow")) {
    workflow_path <- fs::path(path, "workflow")
    fs::dir_create(workflow_path, recurse = TRUE)
    fs::file_create(fs::path(workflow_path, "Snakefile"))
  }

  if (isTRUE(include_config)) {
    config_dir <- fs::path(path, "config")
    fs::dir_create(config_dir, recurse = TRUE)
    fs::file_create(fs::path(config_dir, "config.yaml"))
  }

  path
}
