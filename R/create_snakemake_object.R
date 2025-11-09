#' Create a demo Snakemake S4 object
#'
#' Helper that ensures the \code{Snakemake} S4 class is defined and returns a
#' ready-to-use instance populated with demo-friendly defaults. This is useful
#' for examples or tests that need a stand-in for the real Snakemake runtime.
#'
#' @param input Named list of input paths (e.g., \code{list(input1 = "foo.csv")}).
#' @param output Named list of output paths produced by the rule.
#' @param params Named list of parameter values passed to the analysis.
#'
#' @return An object of class \code{Snakemake}.
#' @export
#'
#' @importFrom methods isClass setClass new
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
