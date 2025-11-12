if (interactive()) {
  snakemake <- create_snakemake_object(
    input = list(
      input1 = "data/sample_1.csv"
    ),
    output = list(
      output1 = "results/sample_1.csv"
    ),
    params = list(
      na_rm = TRUE
    )
  )
}

library(readr, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)

sample_data <- read_csv(snakemake@input$input1, show_col_types = FALSE)
sample_mean <- sample_data |> summarise(.by = sample_name, mean = mean(var1, na.rm = snakemake@params$na_rm))

write_csv(sample_mean, file = snakemake@output$output1)

