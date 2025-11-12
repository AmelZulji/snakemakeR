
<!-- README.md is generated from README.Rmd. Please edit that file -->

# snakemakeR

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/AmelZulji/snakemakeR/graph/badge.svg)](https://app.codecov.io/gh/AmelZulji/snakemakeR)
<!-- badges: end -->

`snakemakeR` helps R-first analysts capture the small but repetitive
step of drafting a minimal Snakemake S4 scaffold. Instead of copying
code between projects, you can generate a vetted snippet or paste it
directly into the RStudio editor and immediately focus on the parts of
the pipeline that matter.

## Why snakemakeR?

- Works entirely in R, making it easy to slot into existing scripts.
- Keeps the S4 class definition in one helper so fixes stay in sync.
- Provides both textual and RStudio editor helpers, depending on your
  workflow.

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

The snippet below mirrors `inst/extdata/compute_mean.R` and highlights
the minimal structure the parser expects.

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
