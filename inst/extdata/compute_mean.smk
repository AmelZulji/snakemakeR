rule compute_mean:
	input: input1 = "data/{sample}.csv"
	params: na_rm = config["compute_mean"]["na_rm"]
	output: output1 = "results/{sample}.csv"
	script: "../scripts/compute_mean.R"
