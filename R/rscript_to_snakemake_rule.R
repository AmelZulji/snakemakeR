write_snakemake_rule <- function(rule_name = NULL, script, input, output, params) {
  rule_name <- rule_name %||% script |> fs::path_file() |> fs::path_ext_remove()
  input_fmt <- glue::glue_collapse(glue::glue('{names(input)} = "{input}"') ,sep = ", ")
  output_fmt <- glue::glue_collapse(glue::glue('{names(output)} = "{output}"') ,sep = ", ")

  glue::glue(
    "
    rule {rule_name}:
      input: {input_fmt}
      output: {output_fmt}
    "
    , .trim = TRUE
  )
}

