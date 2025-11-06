test_that("function call is found", {
  test_expr <- quote(mean(x = 1:10, na.rm = TRUE))
  out <- find_fn_call(x = test_expr, fn_name = "mean")
  expect_equal(out[[1]], test_expr)
})

test_that("namespaced function call is found", {
  test_expr <- quote(base::mean(x = 1:10, na.rm = TRUE))
  out <- find_fn_call(x = test_expr, fn_name = "mean")
  expect_equal(out[[1]], test_expr)
})

test_that("nested function call is found", {
  target_call <- quote(mean(x = 1:11, na.rm = TRUE))
  nested_call <- substitute(sample(x = 1:a, size = 2), list(a = target_call))
  out <- find_fn_call(x = nested_call, fn_name = "mean")
  expect_equal(out[[1]], target_call)
})

test_that("multiple nested function calls are found found", {
  target_call1 <- quote(mean(x = 1:11, na.rm = TRUE))
  target_call2 <- quote(mean(x = 10:22, na.rm = FALSE))
  nested_call <- substitute(
    sample(x = 1:a, size = b, replace = TRUE),
    list(a = target_call1, b = target_call2)
  )
  out <- find_fn_call(x = nested_call, fn_name = "mean")
  expect_equal(length(out), 2)
})

test_that("list of calls can be itereted", {
  target_call1 <- quote(mean(x = 1:11, na.rm = TRUE))
  target_call2 <- quote(mean(x = 10:22, na.rm = FALSE))
  target_call3 <- quote(sample(x = 1:10, size = 2, replace = TRUE))
  target_call4 <- quote(sample(x = 1:10, size = 1, replace = TRUE))
  nested_call1 <- substitute(
    sample(x = 1:a, size = b, replace = TRUE),
    list(a = target_call4, b = target_call4)
  )
  nested_call2 <- substitute(
    sample(x = 1:a, size = b, replace = TRUE),
    list(a = target_call1, b = target_call2)
  )

  list_exp <- rlang::exprs(
    !!target_call1,
    !!target_call2,
    !!target_call3,
    !!target_call4,
    !!nested_call1,
    !!nested_call2
  )

  out <- find_fn_calls(x = list_exp, fn_name = "mean")
  expect_equal(length(out), 4)
})
