library(purrr)
library(rlang)
library(devtools)

exp <- parse("inst/extdata/sample_script.R") |> as.list()
exp

out <- find_fn_calls(x = exp, fn_name = "create_snakemake_object")
out

is_expression(out[[1]])
is_call(out[[1]])

out1 <- call_args(out[[1]])

rule <- expr(build_rule(rule_name = "test", !!!out1)) |> eval()
write_rule(rule = rule, path = "workflow/rules/test.smk")
expr(write_config(rule_name = "yey_rule", params = !!!out1["params"])) |> eval()


out <- find_fn_calls(x = exp, fn_name = "create_snakemake_object")
out1 <- call_args(call = out[[1]])
out1


out <- find_fn_calls(x = exp, fn_name = "create_snakemake_object") |>
  _[[1]] |>
  call_args()


list(test = 1:10, test2 = 20:21) |> _[[1]]
