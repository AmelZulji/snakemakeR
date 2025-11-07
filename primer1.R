exp <- parse("inst/extdata/sample_script.R") |> as.list()
exp

library(rlang)

out <- find_fn_calls(x = exp, fn_name = "create_snakemake_object")
out

is_expression(out[[1]])
is_call(out[[1]])

out1 <- call_args(out[[1]])
out1

library(purrr)

expr(build_rule(rule_name = "test", !!!out1)) |> eval()

expr(write_config(rule_name = "yey_rule", params =  !!!out1[3])) |> eval()
