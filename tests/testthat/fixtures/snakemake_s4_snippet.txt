setClass(
  "Snakemake",
  slots = list(
    input = "list",
    output = "list",
    params = "list"
  )
)

snakemake <- new(
  "Snakemake",
  input = list(
    input1 = ""
  ),
  output = list(
    output1 = ""
  ),
  params = list(
    param1 = ""
  )
)
