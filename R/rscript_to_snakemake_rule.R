#' Build a Snakemake rule
#'
#' Convenience helper for writing a Snakemake rule from its components. The
#' function performs light validation (e.g. named lists for `input`/`output`) and
#' produces a character scalar that can be written directly to a `.smk` file via
#' [write_rule()].
#'
#' @param rule_name Explicit rule name. Defaults to the `script` file name without extension.
#' @param input,output Named lists pointing to input and output files to be declared in the rule body.
#' @param params Named list describing the parameter keys that should be read from `config`. The actual values are retrieved via [write_config()].
#' @param script Path to the script that implements the rule's logic. Stored in the resulting rule via `script:`.
#'
#' @return A single character string containing the formatted rule.
#' @seealso [write_rule()], [write_config()], and [rscript_to_rule()].
#' @examples
#' \dontrun{
#' build_rule(
#'   script = "workflow/scripts/compute_mean.R",
#'   input = list(raw = "data/sample_1.csv"),
#'   output = list(result = "results/sample_1.csv"),
#'   params = list(na_rm = TRUE)
#' )
#' }
#' @export
build_rule <- function(
  output,
  script,
  rule_name = NULL,
  input = NULL,
  params = NULL
) {
  stopifnot("script doesnt exists" = fs::file_exists(script))

  rule_name <- rule_name %||% script |> fs::path_file() |> fs::path_ext_remove()
  rule_name_fmt <- glue::glue("rule {rule_name}:")

  input_fmt <- if (!is.null(input)) {
    stopifnot(
      "input is not named list" = is.list(input) && !is.null(names(input))
    )

    out <-
      glue::glue('{names(input)} = "{input}"') |>
      glue::glue_collapse(sep = ", ")

    glue::glue("input: {out}")
  }

  output_fmt <- if (!is.null(output)) {
    stopifnot(
      "output is not named list" = is.list(output) && !is.null(names(output))
    )

    out <-
      glue::glue('{names(output)} = "{output}"') |>
      glue::glue_collapse(sep = ", ")

    glue::glue("output: {out}")
  }

  params_fmt <- if (!is.null(params)) {
    stopifnot(
      "params is not named list" = is.list(params) && !is.null(names(params))
    )

    params <- stats::setNames(
      params,
      nm = gsub(pattern = "\\.", replacement = "_", x = names(params))
    )

    out <-
      glue::glue(
        '{names(params)} = config["{rule_name}"]["{names(params)}"]'
      ) |>
      glue::glue_collapse(sep = ", ")

    glue::glue("params: {out}")
  }

  script_rel_path <- fs::path_rel(script, start = "workflow/rules/")
  script_fmt <- if (!is.null(script)) {
    glue::glue(
      'script: "{script_rel_path}"'
    ) |>
      glue::glue_collapse(sep = ", ")
  }

  glue::glue_collapse(
    c(rule_name_fmt, input_fmt, params_fmt, output_fmt, script_fmt),
    sep = "\n\t"
  )
}

#' Build a Snakemake rule
#'
#' Convenience helper for writing a Snakemake rule from its components. The
#' function performs light validation (e.g. named lists for `input`/`output`) and
#' produces a character scalar that can be written directly to a `.smk` file via
#' [write_rule()].
#'
#' @param rule_name Explicit rule name. Defaults to the `script` file name without extension.
#' @param input,output Named lists pointing to input and output files to be declared in the rule body.
#' @param params Named list describing the parameter keys that should be read from `config`. The actual values are retrieved via [write_config()].
#' @param script Path to the script that implements the rule's logic. Stored in the resulting rule via `script:`.
#'
#' @return A single character string containing the formatted rule.
#' @seealso [write_rule()], [write_config()], and [rscript_to_rule()].
#' @examples
#' \dontrun{
#' build_rule(
#'   script = "workflow/scripts/compute_mean.R",
#'   input = list(raw = "data/sample_1.csv"),
#'   output = list(result = "results/sample_1.csv"),
#'   params = list(na_rm = TRUE)
#' )
#' }
#' @export
build_rule2 <- function(
  output,
  script,
  rule_name = NULL,
  input = NULL,
  params = NULL
) {
  stopifnot("script doesnt exists" = fs::file_exists(script))

  rule_name <- rule_name %||% script |> fs::path_file() |> fs::path_ext_remove()
  rule_name_fmt <- glue::glue("rule {rule_name}:")

  input_fmt <- if (!is.null(input)) {
    stopifnot(
      "input is not named list" = is.list(input) && !is.null(names(input))
    )
    input <- purrr::map(input, generalize_path)
    out <-
      glue::glue('{names(input)} = "{input}"') |>
      glue::glue_collapse(sep = ", ")

    glue::glue("input: {out}")
  }

  output_fmt <- if (!is.null(output)) {
    stopifnot(
      "output is not named list" = is.list(output) && !is.null(names(output))
    )
    output <- purrr::map(output, generalize_path)
    out <-
      glue::glue('{names(output)} = "{output}"') |>
      glue::glue_collapse(sep = ", ")

    glue::glue("output: {out}")
  }

  params_fmt <- if (!is.null(params)) {
    stopifnot(
      "params is not named list" = is.list(params) && !is.null(names(params))
    )

    params <- stats::setNames(
      params,
      nm = gsub(pattern = "\\.", replacement = "_", x = names(params))
    )

    out <-
      glue::glue(
        '{names(params)} = config["{rule_name}"]["{names(params)}"]'
      ) |>
      glue::glue_collapse(sep = ", ")

    glue::glue("params: {out}")
  }

  script_rel_path <- fs::path_rel(script, start = "workflow/rules/")
  script_fmt <- if (!is.null(script)) {
    glue::glue(
      'script: "{script_rel_path}"'
    ) |>
      glue::glue_collapse(sep = ", ")
  }

  glue::glue_collapse(
    c(rule_name_fmt, input_fmt, params_fmt, output_fmt, script_fmt),
    sep = "\n\t"
  )
}


#' Write a Snakemake rule
#'
#' Appends the character string returned by [build_rule()] into a
#' `.smk` file. Directories along `rule_path` are created if they do
#' not exist.
#'
#' @param rule Character scalar containing the rule definition.
#' @param rule_path File path to which rule should be written.
#' @param append Logical; append to an existing file (`TRUE`, default) or overwrite it (`FALSE`).
#'
#' @return Invisibly returns `rule_path`.
#' @export
write_rule <- function(rule, rule_path, append = TRUE) {
  stopifnot("`rule` is not character" = is.character(rule))
  fs::dir_create(fs::path_dir(rule_path))
  write(x = rule, file = rule_path, append = append)
  invisible(rule_path)
}

#' Write or update a config entry corresponding to a Snakemake rule
#'
#' Creates (or updates) a YAML configuration file with the parameters required
#' by a specific rule. Missing directories are created automatically and field
#' names are sanitised to keep them valid Python identifiers.
#'
#' @param rule_name Character scalar used as the key in the configuration file.
#' @param params Named list of parameter values associated with `rule_name`.
#' @param config_path File path to the YAML configuration file.
#'
#' @return Invisibly returns `config_path`.
#' @export
#' @examples
#' \dontrun{
#' tmp_cfg <- tempfile(fileext = ".yaml")
#' write_config(
#'   rule_name = "analysis",
#'   params = list(threshold = 0.05),
#'   config_path = tmp_cfg
#' )
#' }

write_config <- function(
  params,
  config_path = "config/config.yaml",
  rule_name = NULL
) {
  stopifnot(
    "`params` is not a named list" = is.list(params) && rlang::is_named(params)
  )

  if (fs::file_exists(config_path) && !fs::is_file_empty(config_path)) {
    x <- yaml::read_yaml(config_path)
  } else {
    fs::path_dir(config_path) |> fs::dir_create()
    x <- list()
  }
  params <- stats::setNames(list(params), rule_name)

  x <- utils::modifyList(x, params)
  x <- lapply(x, \(x) {
    stats::setNames(
      x,
      nm = gsub(pattern = "\\.", replacement = "_", x = names(x))
    )
  }) # make values syntactically python valid

  yaml::write_yaml(x = x, file = config_path)
}

#' Generate snakemake rule from R script.
#'
#' Parses an R script that calls [create_snakemake_object()] and uses the
#' extracted metadata to write both a Snakemake rule file and a config entry.
#' The generated rule is automatically included in `workflow/Snakefile`.
#'
#' @param script Path to the source R script.
#' @param rule_name Optional explicit rule name; defaults to the script filename without extension.
#'
#' @return Invisibly returns `NULL`.
#' @export
rscript_to_rule <- function(script, rule_name = NULL) {
  rule_name <- rule_name %||% script |> fs::path_file() |> fs::path_ext_remove()
  rule_path <- glue::glue("workflow/rules/{rule_name}.smk")
  exp <- parse(script) |> as.list()
  cso_call <- find_fn_calls(x = exp, fn_name = "create_snakemake_object")
  stopifnot(
    "no `create_snakemake_object` calls were found" = length(cso_call) == 1
  )
  out <- cso_call |> _[[1]] |> rlang::call_args()
  rule <- rlang::expr(build_rule2(
    rule_name = rule_name,
    script = script,
    !!!out
  )) |>
    eval()
  write_rule(rule = rule, rule_path = rule_path)
  rlang::expr(write_config(rule_name = rule_name, params = !!!out["params"])) |>
    eval()

  snakefile_include <- glue::glue('include: "rules/{rule_name}.smk"')
  write(snakefile_include, file = "workflow/Snakefile", append = TRUE)
}
