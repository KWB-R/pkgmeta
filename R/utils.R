#' @importFrom kwb.utils catAndRun
cat_and_run <- kwb.utils::catAndRun

# get_github_token -------------------------------------------------------------
get_github_token <- function()
{
  Sys.getenv("GITHUB_PAT")
}

#' @importFrom kwb.utils multiSubstitute
multi_substitute <- kwb.utils::multiSubstitute

#' @importFrom kwb.utils selectColumns
select_columns <- kwb.utils::selectColumns

#' @importFrom kwb.utils selectElements
select_elements <- kwb.utils::selectElements

#' @importFrom kwb.utils stringList
string_list <- kwb.utils::stringList
