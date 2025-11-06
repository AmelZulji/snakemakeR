exp <- quote(
  if (interactive()) {
  setClass(
    "Snakemake",
    slots = list(
      input = "list",
      output = "list",
      params = "list"
    )
  )

  snakemake <- new(
    Class = "Snakemake",
    input = list(
      input1 = "inst/extdata/sample_data.csv",
      input2 = "inst/extdata/sample_data1.csv"
    ),
    output = list(
      output1 = "/tmp/RtmpNRaF51/testc714465c068d8.csv"
    ),
    params = list(
      na.rm = TRUE
    )
  )
}
)

library(rlang)

out <- find_fn_call(x = exp, fn_name = "new")
out

is_expression(out[[1]])
is_call(out[[1]])

out1 <- call_args(out[[1]])
out1

out1 <- out1[-1]
library(purrr)

out1 |> map(\(x) unlist(x,recursive = T))

expr(rscript_to_snakemake_rule(rule_name = "test", !!!out1)) |> eval()
