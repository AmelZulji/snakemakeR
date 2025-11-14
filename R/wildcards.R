extract_expand_wildcard2 <- function(files) {
  file_check <- fs::file_exists(files)
  stopifnot("Provided `files` do not exist" = sum(file_check) >= 1)
  if (sum(file_check) < length(files)) {
    warning("Following file(s) do not exist: ", files[!file_check])
  }
  lines <- purrr::map(files[file_check], readLines) |> list_c()
  # stopifnot("files are empty" = length(lines) >= 1)
  wildcards <- stringr::str_match(string = lines, pattern = "expand\\(.*,\\s*(?<wildcard>.*)=")[,"wildcard"] |> unique()

  if (all(is.na(wildcards))) {
    warning("No wildcard found. Returning empty character")
    return(character())
  } else if (length(wildcards[!is.na(wildcards)]) > 1) {
    warning("Found more than one wildcards. Returning the first one")
    return(wildcards[!is.na(wildcards)][1])
  } else {
    return(wildcards)
  }
}
