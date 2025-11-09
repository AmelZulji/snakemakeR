is_snakemake_project <- function(path = ".") {
  path <- fs::path_abs(path)

  snakefile <- fs::path(path, c("Snakefile", "workflow/Snakefile"))
  config <- fs::path(path, c("config/config.yaml", "config/config.yml"))

  snakefile_exists <- any(fs::file_exists(snakefile))
  config_exists <- any(fs::file_exists(config))

  if (snakefile_exists && config_exists) {
    TRUE
  } else {
    FALSE
  }
}
