#' #' Build and append Snakemake config sections
#' #'
#' #' \code{build_config_section()} produces a named list ready to merge into a
#' #' Snakemake YAML config, whereas \code{append_config_section()} handles writing
#' #' that section to disk (creating the config file and directories if needed).
#' #' The legacy \code{append_params_to_config()} helper remains available for
#' #' convenience and simply combines both steps.
#' #'
#' #' @param rule_name Character scalar naming the rule whose parameters are being
#' #'   stored.
#' #' @param params Named list of parameter values.
#' #' @param config_path Path to the YAML config file to update. Defaults to
#' #'   \code{config/config.yaml}.
#' #' @param section Named list produced by \code{build_config_section()}.
#' #'
#' #' @return \code{build_config_section()} returns a named list. The append
#' #'   helpers invisibly return \code{config_path}.
#' #' @name config_section_helpers
#' NULL
#' #' @rdname config_section_helpers
#' #' @export
#' build_config_section <- function(rule_name, params = list()) {
#'   stopifnot(
#'     !missing(rule_name),
#'     is.character(rule_name),
#'     length(rule_name) == 1L,
#'     nzchar(rule_name)
#'   )
#'
#'   if (!length(params)) {
#'     return(list())
#'   }
#'
#'   stopifnot(is.list(params), !is.null(names(params)))
#'
#'   stats::setNames(params |> eval(), rule_name)
#' }
#'
#' #' @rdname config_section_helpers
#' #' @export
#' append_config_section <- function(
#'   config_path = fs::path("config", "config.yaml"),
#'   section = list()
#' ) {
#'   if (!length(section)) {
#'     return(invisible(config_path))
#'   }
#'
#'   stopifnot(
#'     is.list(section),
#'     length(section) == 1L,
#'     !is.null(names(section)),
#'     nzchar(names(section))
#'   )
#'
#'   rule_name <- names(section)
#'   params <- section[[1]]
#'
#'   fs::dir_create(fs::path_dir(config_path), recurse = TRUE)
#'
#'   config <- list()
#'   if (fs::file_exists(config_path) && fs::file_info(config_path)$size > 0) {
#'     config <- yaml::read_yaml(config_path)
#'     if (is.null(config)) {
#'       config <- list()
#'     }
#'   }
#'
#'   existing <- config[[rule_name]]
#'   if (is.null(existing)) {
#'     existing <- list()
#'   }
#'
#'   config[[rule_name]] <- utils::modifyList(existing, params)
#'   yaml::write_yaml(config, config_path)
#'
#'   invisible(config_path)
#' }
#'
#' #' @rdname config_section_helpers
#' #' @export
#' append_params_to_config <- function(
#'   config_path = fs::path("config", "config.yaml"),
#'   rule_name,
#'   params = list()
#' ) {
#'   section <- build_config_section(rule_name, params)
#'   append_config_section(config_path, section)
#' }
