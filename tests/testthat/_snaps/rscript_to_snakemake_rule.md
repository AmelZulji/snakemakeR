# build_rule() produces properly formated rule

    Code
      build_rule(output = list(out1 = "out.csv"), script = "workflow/scripts/compute_mean.R",
      input = list(in1 = "input1.csv"), params = list(narm = TRUE))
    Output
      rule compute_mean:
      	input: in1 = "input1.csv"
      	params: narm = config["compute_mean"]["narm"]
      	output: out1 = "out.csv"
      	script: "../scripts/compute_mean.R"

# build_rule() properly chains input, output and params when they more 1 one arg is present

    Code
      build_rule(output = list(out1 = "out.csv"), script = "workflow/scripts/compute_mean.R",
      input = list(in1 = "input1.csv", in2 = "input2.csv"), params = list(narm = TRUE,
        mean = 10))
    Output
      rule compute_mean:
      	input: in1 = "input1.csv", in2 = "input2.csv"
      	params: narm = config["compute_mean"]["narm"], mean = config["compute_mean"]["mean"]
      	output: out1 = "out.csv"
      	script: "../scripts/compute_mean.R"

# build_rule() handles rule_name argument properly

    Code
      build_rule(output = list(out1 = "out.csv"), script = "workflow/scripts/compute_mean.R",
      input = list(in1 = "input1.csv", in2 = "input2.csv"), params = list(narm = TRUE,
        mean = 10), rule_name = "test_rule")
    Output
      rule test_rule:
      	input: in1 = "input1.csv", in2 = "input2.csv"
      	params: narm = config["test_rule"]["narm"], mean = config["test_rule"]["mean"]
      	output: out1 = "out.csv"
      	script: "../scripts/compute_mean.R"

