#' Extract wildcard name from `expand()` calls.
#'
#' Parses a set of script files, finds the first wildcard argument that appears
#' inside an `expand()` call, and returns its name. Missing files trigger a
#' warning and are ignored; empty or wildcard-free files return `character()`.
#'
#' @param files Character vector of paths to scripts that may contain
#'   `expand()` calls.
#'
#' @return Character vector of length 0 (no wildcard) or 1 (first wildcard
#'   name detected).
#' @export
#'
#' @examples
#' \dontrun{
#' extract_expand_wildcard(c("workflow/Snakefile", "workflow/rules/compute_mean.smk"))
#' }
get_wildcard <- function(
  files = c("workflow/Snakefile", Sys.glob("workflow/rules/*.smk"))
) {
  file_check <- fs::file_exists(files)
  if (!any(file_check)) {
    stop("Provided `files` do not exist")
  }
  if (!all(file_check)) {
    warning("Following file do not exist: ", files[!file_check])
    # warning("Following file do not exist: ")
  }

  valid_files <- files[file_check]
  lines <- purrr::map(valid_files, readLines) |> purrr::list_c()
  if (!length(lines)) {
    warning("Provided `files` are empty. Returning empty character")
    return(character())
  }

  matches <- stringr::str_match(
    string = lines,
    pattern = "expand\\(.*,\\s*(?<wildcard>.*?)\\s*="
  )[, "wildcard"]

  wildcards <- unique(matches[!is.na(matches)])

  if (!length(wildcards)) {
    warning("No wildcard found. Returning empty character")
    return(character())
  }
  if (length(wildcards) > 1) {
    warning("Found more than one wildcard. Returning the first one")
    return(wildcards[1])
  }

  return(wildcards)
}


#' Reads all project metadata files from the config/ directory.
#'
#' @return A list of tibbles, one for each .csv file found.
read_project_meta <- function() {
  possible_meta <- Sys.glob("config/*.csv")
  stopifnot("no meta file found in config/" = length(possible_meta) >= 1)

  meta <- purrr::map(possible_meta, \(x) {
    readr::read_csv(x, show_col_types = FALSE)
  })
  meta
}

#' Find which path tokens are variable.
#'
#' @param path_string A single character string for the path.
#' @param meta The list of metadata tibbles.
#' @return A character vector of matching tokens.
get_variable_path_token <- function(path_string, meta) {
  stopifnot(is.character(path_string), length(path_string) == 1)
  stopifnot(is.list(meta))

  tokens <- stringr::str_split(path_string, "[/.]")[[1]]
  tokens <- tokens[nzchar(tokens)]

  if (length(tokens) == 0) {
    return(character(0))
  }

  all_meta_values <- unique(unlist(meta))
  matching_tokens <- intersect(tokens, all_meta_values)

  return(matching_tokens)
}

#' Replaces matching tokens in a path string.
#'
#' @param path_string A single character string for the path.
#' @param pattern A character vector of tokens to replace.
#' @param replacement The single string to use as a replacement.
#' @return The path string with tokens replaced.
expand_path <- function(path_string, pattern, replacement) {
  stopifnot(is.character(path_string), length(path_string) == 1)

  # str_replace_all handles pattern = character(0) perfectly:
  # it does nothing and returns the original path_string.
  stringr::str_replace_all(path_string, pattern, replacement)
}

#' Generalize path based on project metadata.
#'
#' This function takes a vector of file paths and checks them against
#' the project's metadata. If a path contains a token found in the
#' metadata (e.g., "sample_1"), it replaces that token with the
#' project's wildcard (e.g., "{sample}"). If no token matches, the
#' path is returned unchanged.
#'
#' @param path_strings A character vector of file paths to process.
#' @param meta The pre-loaded metadata (from `read_project_meta()`).
#' @param wildcard_name The project's wildcard (from `extract_expand_wildcard()`).
#'
#' @return A character vector of processed paths.
#' @return A character vector of processed paths.
generalize_path <- function(
  path_string,
  meta = read_project_meta(),
  wildcard = get_wildcard()
) {
  wildcard_fmt <- paste0("{", wildcard, "}")

  processed_paths <- purrr::map_chr(
    path_string,
    ~ {
      variable_path_token <- get_variable_path_token(.x, meta)
      if (length(variable_path_token) == 0) {
        .x
      } else {
        stringr::str_replace(.x, variable_path_token, wildcard_fmt)
      }
    }
  )

  return(processed_paths)
}
