#' Recursively compact a list
#'
#' Apply `purrr::compact()` recursively to drop `NULL` or empty list elements from a list.
#'
#' @param x A list, possibly containing nested lists.
#'
#' @return A list with `NULL` or empty list elements removed.
#' @keywords internal
recurse_compact <- function(x) {
  if (is.list(x)) {
    purrr::compact(purrr::map(x, recurse_compact))
  } else {
    x
  }
}

#' Recursively flatten a list
#'
#' Apply `purrr::list_flatten()` recursively to reduce the depth of a list as much as possible.
#'
#' @param x A list, possibly containing nested lists.
#'
#' @return A list with flattened hierarchy.
recurse_flatten <- function(x) {
  if (is.list(x)) {
    purrr::list_flatten(purrr::map(x, recurse_flatten))
  } else {
    x
  }
}

#' Find a function call by its name in an expression
#'
#' Recursively walks a language object (the output of `parse()`, or
#' `expression()`) and collects the calls whose function name matches
#' `fn_name`.
#'
#' @param x A single expression, call, or other language object to be searched.
#' @param fn_name A string giving the function name to be found.
#'
#' @return A list of calls matching `fn_name`. Returns an empty list if no matches are found.

#' @examples
#' expr <- parse(text = "mean(rnorm(5)) + sd(rnorm(5))")[[1]]
#' find_fn_call(expr, fn_name = "mean")
#' @export
find_fn_call <- function(x, fn_name) {
  if (rlang::is_syntactic_literal(x)) {
    msg <- paste(as.character(x), "is constant")
    print(msg)
    res <- NULL
  } else if (is.symbol(x)) {
    msg <- paste(as.character(x), "is symbol")
    print(msg)
    res <- NULL
  } else if (is.call(x)) {
    msg <- paste(rlang::expr_text(x), "is call")
    print(msg)
    if (rlang::is_call(x, name = fn_name)) {
      cond_call <- x
    } else {
      cond_call <- NULL
    }

    # Collect results from recursive calls
    res <- c(
      list(cond_call),
      purrr::map(
        .x = seq_along(x),
        \(i) find_fn_call(x = x[[i]], fn_name = fn_name)
      )
    )
  } else if (is.pairlist(x)) {
    msg <- paste(as.character(x), "is pairlist")
    print(msg)
    res <- NULL
  } else {
    ot <- typeof(x)
    msg <- paste(ot, "(unknown type)")
    print(msg)
    res <- NULL
  }

  res |> recurse_compact() |> recurse_flatten()
}

#' Find matching calls in multiple expressions
#'
#' A wrapper around [find_fn_call()] that accepts a list of language
#' objects (such as the result of `as.list(parse(script.R))`).
#'
#' @param x A list of expressions or calls to search.
#' @param fn_name A string giving the function name to locate.
#'
#' @return A list in which each element contains the calls from the corresponding
#'   element of `x` that match `fn_name`.
#' @examples
#' exprs <- as.list(parse(text = c("foo()", "bar(mean(x))")))
#' find_fn_calls(exprs, fn_name = "mean")
#' @export
find_fn_calls <- function(x, fn_name) {
  if (!is.list(x)) {
    stop("x must be a list of expression(s)", call. = FALSE)
  }
  # recurse_compact(purrr::map(x, \(x) find_fn_call(x, fn_name = fn_name)))
  purrr::map(x, \(x) find_fn_call(x, fn_name = fn_name)) |>
    recurse_compact() |>
    recurse_flatten()
}
