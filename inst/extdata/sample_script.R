if (interactive()) {
  snakemake <- create_snakemake_object(
    input = list(
      input1 = "inst/extdata/sample_data.csv"
    ),
    output = list(
      output1 = "/tmp/RtmpNRaF51/testc714465c068d8.csv"
    ),
    params = list(
      na.rm = TRUE
    )
  )
}

# Define a function to compute the mean of all numeric columns
calculate_column_means <- function(df, na.rm = TRUE) {
  numeric_columns <- sapply(df, is.numeric)
  sapply(df[numeric_columns], \(x) mean(x, na.rm = na.rm))
}

sample_data <- read.csv(snakemake@input$input1, )
all_means <- calculate_column_means(sample_data, na.rm = snakemake@params$na.rm)
print(all_means)
