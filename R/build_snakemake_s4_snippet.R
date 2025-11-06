#' Generate snippet for a Snakemake S4 object
#'
#' Build a formatted snippet for a minimal Snakemake S4 class definition and
#' instance. You can control how many placeholder entries are generated for the
#' `input`, `output`, and `params` slots.
#'
#' @param n_input,n_output,n_param Single non-negative integers indicating how
#'   many placeholder items to generate for each slot.
#'
#' @return A [`glue::glue`] string containing the formatted snippet.
#' @export
#' @seealso [insert_snakemake_s4_snippet()]
#'
#' @examples
#' build_snakemake_s4_snippet(n_input = 2, n_output = 2, n_param = 1)
build_snakemake_s4_snippet <- function(n_input = 1, n_output = 1, n_param = 1) {
  # Generate the string for each list item.
  inputs <- glue::glue('input{seq_len(n_input)} = ""')
  outputs <- glue::glue('output{seq_len(n_output)} = ""')
  params <- glue::glue('param{seq_len(n_param)} = ""')

  # Collapse the vectors into single strings with items separated by a comma and newline.
  inputs_str <- glue::glue_collapse(inputs, sep = ",\n")
  outputs_str <- glue::glue_collapse(outputs, sep = ",\n")
  params_str <- glue::glue_collapse(params, sep = ",\n")

  # Use the collapsed strings to build the snippet.
  snippet <-
    glue::glue(
    'if (interactive()) {{
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
{inputs_str}
      ),
      output = list(
{outputs_str}
      ),
      params = list(
{params_str}
      )
    )
  }}'
  )

  # Format the snippet
  snippet_fmt <- styler::style_text(text = snippet)

  # Convert the snippet class to glue
  snippet_fmt_glue <- glue::as_glue(snippet_fmt)

  # return the snippet
  return(snippet_fmt_glue)
}
