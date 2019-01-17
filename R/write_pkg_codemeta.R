#' Write codemeta
#'
#' @param codemeta codemeta object (as retrieved by create_codemeta()),
#' default: create_pkg_codemeta())
#' @param file path where to save codemeta.json
#' @return writes "codemeta.json"
#' @importFrom jsonlite write_json
#' @export
write_pkg_codemeta <- function(codemeta = create_pkg_codemeta(),
                               file = "codemetar.json") {

  jsonlite::write_json(codemeta, file,
                       useBytes = TRUE,
                       pretty = TRUE,
                       auto_unbox = TRUE)


}
