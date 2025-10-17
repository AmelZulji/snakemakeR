#' Paste Snakemake S4 snippet into an RStudio script
#'
#' Inserts the output of [build_snakemake_s4_snippet()] at the current cursor position in the
#' active RStudio source editor.
#'
#' @return Invisibly returns the inserted snippet as a character vector.
#' @export
#' @seealso [build_snakemake_s4_snippet()]
#'
#' @examples
#' if (rstudioapi::isAvailable()) {
#'   paste_sm_s4_code()
#' }
insert_snakemake_s4_snippet <- function() {
  if (!rstudioapi::isAvailable()) {
    stop(
      "rstudioapi is not available. Run this function from within RStudio.",
      call. = FALSE
    )
  }

  snippet <- build_snakemake_s4_snippet()
  rstudioapi::insertText(text = snippet)
  invisible(snippet)
}
