#' Generate snippet for snakemake S4 object
#'
#' The function is used to produce a snippet for constructing a mock snakemake S4 object. The snippet is properly formated and ready to be pasted in the script. The user then can specify the desired input, output and params.
#'
#' @param n_input The number of input items to generate.
#' @param n_output The number of output items to generate.
#' @param n_param The number of parameter items to generate.
#'
#' @return A string of class glue containing the formatted snippet.
#' @export
#' @seealso [insert_snakemake_s4_snippet()]
#'
#' @examples
#' build_snakemake_s4_snippet(n_input = 2, n_output = 2, n_param = 1)
build_snakemake_s4_snippet <- function(n_input = NULL, n_output = NULL, n_param = NULL) {
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
    'setClass(
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
    )'
  )

  # Format the snippet
  snippet_fmt <- styler::style_text(text = snippet)

  # Convert the snippet class to glue
  snippet_fmt_glue <- glue::as_glue(snippet_fmt)

  # return the snippet
  return(snippet_fmt_glue)
}

