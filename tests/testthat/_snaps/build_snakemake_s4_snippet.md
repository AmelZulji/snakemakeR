# build_snakemake_s4_snippet() formating works when 1 element is requested

    Code
      build_snakemake_s4_snippet(n_input = 1, n_output = 1, n_param = 1)
    Output
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

# build_snakemake_s4_snippet() formating works when 2 elements input elements are requested

    Code
      build_snakemake_s4_snippet(n_input = 2, n_output = 1, n_param = 1)
    Output
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
          input1 = "",
          input2 = ""
        ),
        output = list(
          output1 = ""
        ),
        params = list(
          param1 = ""
        )
      )

