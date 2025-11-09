#' Create a mock Snakemake project structure
#'
#' Helper for tests/examples that need a minimal Snakemake project layout.
#' Creates a temporary directory (if none supplied) with a Snakefile and config
#' file so utilities like \code{is_snakemake_project()} can run against it.
#'
#' @param project_dir Optional directory to populate. Defaults to a new temporary dir.
#' @param snakefile_location Where to place the Snakefile: either
#'   \code{"root"} (default) or \code{"workflow"}.
#' @param include_config Logical; create \code{config/config.yaml}.
#'
#' @return A project_dir to the mock project directory.
#' @export
mock_snakemake_project <- function(
    project_dir = "snakemake_project",
    snakefile_path = "workflow/Snakefile",
    config_path = "config/config.yaml",
    script_path = "workflow/scripts/analysis.R",
    rule_path = "workflow/rules/test.smk"
) {
  file_paths <- fs::path(project_dir, c(snakefile_path, config_path, script_path, rule_path))

  fs::dir_create(fs::path_dir(file_paths), recurse = TRUE)
  fs::file_create(file_paths)

  invisible(project_dir)
}


