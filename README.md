
<!-- README.md is generated from README.Rmd. Please edit that file -->

# snakemakeR

<!-- badges: start -->

<!-- badges: end -->

`snakemakeR` is workflow package helping to quickly write a snakemake
rule for an R script

## Installation

You can install the development version of snakemakeR from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("AmelZulji/snakemakeR")
```

## Quick start

The package is designed around a short feedback loop:

1.  Develop an R script that includes mock snakemake S4 object generated
    with `create_snakemake_object()`.
2.  Call `rscript_to_rule()` to parse the script, write a rule file to
    `workflow/rules/`, and update `config/config.yaml`.
3.  Include the generated rule from a `Snakefile` (done automatically
    via `include: "rules/<name>.smk"`).

## Function highlights

- `create_snakemake_object()` ensures the `Snakemake` S4 class exists
  and returns a ready-to-use instance for interactive development.
- `build_rule()`, `write_rule()`, and `write_config()` are composable
  helpers if you want to incrementally assemble a rule without parsing a
  script.
- `find_fn_call()` / `find_fn_calls()` power the parser by locating
  calls in a language object; you can reuse them for custom AST
  inspections.

Every exported function comes with examples in the reference
documentation (`?snakemakeR::build_rule`, etc.), so you can copy/paste a
minimal pattern when wiring a new step.
