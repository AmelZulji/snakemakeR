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

expr(write_snakemake_rule(rule_name = "test", !!!out1))

x1 <- build_config_section(rule_name = "test", params = out1["params"])
filename <- "test"
con <- file(filename, "w")

yaml::write_yaml(config, con)
close(con)

?yaml::write_yaml()



library(yaml)
x <- list(
  dataset = "schirmer2019",
  samples = c("A1", "A2", "A3"),
  params = list(threshold = 0.2, max_iter = 50)
)

x1

write_yaml(x, "config.yaml")
