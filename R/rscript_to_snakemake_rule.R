#' Build a Snakemake rule
#'
#' Convenience helper for writing snakemake rule from its components
#'
#' @param script Path to the script to be executed
#' @param rule_name Optional explicit rule name. Defaults to the script filename without extension.
#' @param input,output Named lists mapping ponting to input and output files
#' @param params Named list of parameter identifiers. Each entry prints as a
#'   reference to the corresponding `config[["rule"]][["param"]]`.
#'
#' @return A single character string containing the formatted rule.
#' @export
#'
#' @examples
#' build_rule(
#'   script = "analysis.R",
#'   input = list(data = "data/input.csv"),
#'   output = list(report = "results/report.html"),
#'   params = list(threshold = 0.05)
#' )
build_rule <- function(
    script,
  rule_name = NULL,
  input = NULL,
  output = NULL,
  params = NULL
) {
  rule_name <- rule_name %||% script |> fs::path_file() |> fs::path_ext_remove()
  rule_fmt <- glue::glue("rule {rule_name}:")

  input_fmt <- if (!is.null(input)) {
    glue::glue('input: {names(input)} = "{input}"') |> glue::glue_collapse(sep = ", ")
  }

  output_fmt <- if (!is.null(output)) {
    glue::glue('output: {names(output)} = "{output}"') |> glue::glue_collapse(sep = ", ")
  }

  params_fmt <- if (!is.null(params)) {
    glue::glue('params: {names(params)} = config["{rule_name}"]["{names(params)}"]') |> glue::glue_collapse(sep = ", ")
  }

  glue::glue_collapse(c(rule_fmt, input_fmt, params_fmt, output_fmt), sep = "\n\t")
}

#' Write a Snakemake rule to disk
#'
#' Persists the character string returned by [build_snakemake_rule()] into a
#' Snakefile. Directories along `path` are created if they do not exist.
#'
#' @param rule Character scalar containing the rule definition.
#' @param path File path that should store the rule.
#' @param append Logical; append to an existing file (`TRUE`, default) or
#'   overwrite it (`FALSE`). Currently `append` is ignored and the file is
#'   overwritten.
#'
#' @return Invisibly returns `path`.
#' @export
#'
#' @examples
#' tmp <- tempfile()
#' rule <- build_snakemake_rule(
#'   script = "analysis.R",
#'   input = list(data = "data/input.csv")
#' )
#' write_rule(rule, tmp)
write_rule <- function(rule, path, append = TRUE) {
  stopifnot("`rule` is not character" = is.character(rule))
  fs::dir_create(fs::path_dir(path))
  write(x = rule, file = path)
  invisible(path)
}

write_config <- function(params, config_path = "config/config.yaml") {
  stopifnot("`params` is not a list" = is.list(params))
  stopifnot("`params` is not a named list" = rlang::is_named(params))

  if (fs::file_exists(config_path)) {
    x <- yaml::read_yaml(config_path)
  } else {
    fs::path_dir(config_path) |> fs::dir_create()
    x <- list()
  }
  x <- modifyList(x, params)
  yaml::write_yaml(x = x, file = config_path)
}
