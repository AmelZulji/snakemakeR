#' Paste snippet for a Snakemake S4 object
#'
#' Generate the Snakemake S4 snippet via [build_snakemake_s4_snippet()] and
#' insert it at the cursor location inside the active RStudio source document.
#' You can control how many placeholder entries are produced for each slot by
#' passing the same arguments supported by the builder.
#'
#' @inheritParams build_snakemake_s4_snippet
#'
#' @return Invisibly returns the inserted snippet as a [`glue::glue`] string.
#' @export
#' @seealso [build_snakemake_s4_snippet()]
#'
#' @examples
#' if (rstudioapi::isAvailable()) {
#'   insert_snakemake_s4_snippet(n_input = 3)
#' }
insert_snakemake_s4_snippet <- function(n_input = 2L, n_output = 1L, n_param = 1L) {
  if (!rstudioapi::isAvailable()) {
    stop(
      "rstudioapi is not available. Run this function from within RStudio.",
      call. = FALSE
    )
  }

  snippet <- build_snakemake_s4_snippet(
    n_input = n_input,
    n_output = n_output,
    n_param = n_param
  )
  rstudioapi::insertText(text = snippet)
  invisible(snippet)
}
