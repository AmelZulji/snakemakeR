#' Generate Snakemake S4 snippet
#'
#' Returns the code skeleton for defining a `Snakemake` S4 class and a
#' corresponding instance. The snippet is ready to paste into an R script.
#'
#' @return A length-one character vector containing the formatted snippet.
#' @export
#' @seealso [paste_sm_s4_code()]
#'
#' @examples
#' cat(create_sm_s4())
create_sm_s4 <- function() {
  template_path <- system.file(
    "templates",
    "snakemake_s4_template.R",
    package = "snakemakeR"
  )

  if (template_path == "") {
    stop(
      "Unable to locate the Snakemake template. Reinstall snakemakeR.",
      call. = FALSE
    )
  }

  paste(readLines(template_path, warn = FALSE), collapse = "\n")
}
