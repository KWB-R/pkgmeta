#' Write codemeta
#'
#' @param codemeta codemeta object (as retrieved by create_codemeta()),
#' default: create_pkg_codemeta())
#' @param file path where to save codemeta.json (default: file.path(getwd(),
#' "codemetar.json"))
#' @param dbg should debug messages be printed? (default: TRUE)
#' @return writes "codemeta.json"
#' @importFrom jsonlite write_json
#' @importFrom kwb.utils catAndRun
#' @export
write_pkg_codemeta_json <- function(
    codemeta = create_pkg_codemeta(),
    file = file.path(getwd(), "codemetar.json"),
    dbg = TRUE
)
{
  kwb.utils::catAndRun(
    sprintf("Writting codemeta to '%s'", file),
    dbg = dbg,
    expr = jsonlite::write_json(
      codemeta, file,
      useBytes = TRUE,
      pretty = TRUE,
      auto_unbox = TRUE
    )
  )
}
