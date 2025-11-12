library(fs)
library(tidyverse)

samples <- paste0("sample_", 1:3) |> set_names()

tibble(sample = samples) |> write_csv(file = "inst/extdata/sample_metadata.csv")

iwalk(samples, \(x,y) {
  df <- data.frame(
    sample_name = y,
    var1 = sample(c(rnorm(n = 5), NA), size = 10, replace = TRUE, prob = c(rep(0.1, 5), 0.5))
)
  write_csv(x = df, file = path("inst/extdata",y,ext = "csv"))
})
