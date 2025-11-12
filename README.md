
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
