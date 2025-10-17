#' Paste Snakemake S4 snippet into an RStudio script
#'
#' Inserts the output of [create_sm_s4()] at the current cursor position in the
#' active RStudio source editor.
#'
#' @return Invisibly returns the inserted snippet as a character vector.
#' @export
#' @seealso [create_sm_s4()]
#'
#' @examples
#' if (rstudioapi::isAvailable()) {
#'   paste_sm_s4_code()
#' }
paste_sm_s4_code <- function() {
  if (!rstudioapi::isAvailable()) {
    stop(
      "rstudioapi is not available. Run this function from within RStudio.",
      call. = FALSE
    )
  }

  snippet <- create_sm_s4()
  rstudioapi::insertText(text = snippet)
  invisible(snippet)
}
