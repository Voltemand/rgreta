#' rgreta: simple simulation of greta models
#' @name rgreta
#'
#' @description rgreta easily sample statistical models written in greta
#'
#' @import greta
#'
NULL

.onLoad <- function(libname, pkgname) {
  attach(greta::.internals$greta_arrays["as.greta_array"])
  attach(greta::.internals$greta_arrays["get_node"])
}
