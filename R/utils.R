find_fn_row <- function(pd, fn_name) {
  fun_rows <- pd[pd$token == "SYMBOL_FUNCTION_CALL" & pd$text == fn_name, ]
  if (!nrow(fun_rows)) {
    stop("No function call to '", fn_name, "' found.", call. = FALSE)
  }

  # Use the last occurrence in the file
  ord <- order(fun_rows$line1, fun_rows$col1)
  fun_row <- fun_rows[utils::tail(ord, 1L), ]

  head_expr_id <- fun_row$parent
  call_expr_id <- pd$parent[pd$id == head_expr_id]

  pd[pd$id == call_expr_id, ]
}

#' Inline-expand an expression into literal R code inside the current RStudio document
#'
#' `expand_inline()` evaluates the expression passed to it and replaces the
#' corresponding `expand_inline(...)` call in the current RStudio document with
#' a literal R representation of the value (via `dput()`). This allows you to
#' “freeze” dynamic expressions—such as `Sys.glob()` calls—directly into your
#' script or package source file.
#'
#' The function locates the `expand_inline()` call in the source using
#' `getParseData()`, identifies the full call expression, evaluates the
#' argument in the caller's environment, and then rewrites the source code
#' in-place using `rstudioapi::modifyRange()`.
#'
#' @param expr An expression to be evaluated and inlined. This is captured and
#'   evaluated in the calling environment.
#'
#' @returns Invisibly returns the evaluated value of `expr`. The function is
#'   used for its side effect of modifying the active RStudio document.
#'
#' @export
expand_inline <- function(expr) {
  if (!rstudioapi::isAvailable()) {
    stop("expand_inline() needs RStudio (rstudioapi).", call. = FALSE)
  }

  ctx <- rstudioapi::getActiveDocumentContext()
  contents <- ctx$contents

  parsed <- parse(text = contents, keep.source = TRUE)
  pd <- utils::getParseData(parsed)

  # find the expr node for expand_inline(...)
  call_row <- find_fn_row(pd, "expand_inline")

  # build range: col2 is inclusive in pd, but exclusive in document_range
  rng <- rstudioapi::document_range(
    c(call_row$line1, call_row$col1),
    c(call_row$line2, call_row$col2 + 1L)
  )

  # evaluate the input expr in the caller's environment
  value <- eval(substitute(expr), envir = parent.frame())

  # literal R code for the value
  literal <- paste(deparse(dput(value)), collapse = "")

  # replace expand_inline(...) with the literal code
  rstudioapi::modifyRange(rng, literal, id = ctx$id)

  invisible(value)
}
