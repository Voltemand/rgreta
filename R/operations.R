# These could/should be written into a wrapper maybe a function factory
# Possibly for all 2 parameter functions

#' Run an add operation
#'
#' @param op_node a greta add operation node
#'
#' @return the value of the operation
#'
run_add <- function(op_node) {
  stopifnot(inherits(op_node, "operation_node"))
  stopifnot(op_node$operation_name == "add")

  # Why can't we use $operation arguments
  # operation arguements don't appear to be ever set
  # are they deprecieted
  # no --- this will be needed for more complex operations
  args <- op_node$children
  # is this neccesary ... yes!,
  stopifnot(length(args) == 2)

  dims <- op_node$dim

  # tempoary guards
  stopifnot(length(dims) == 2)
  stopifnot(dims[[2]] == 1)

  x <- args[[1]]$value()
  y <- args[[2]]$value()

  # how to make sure it's greta::calculate?
  out <- eval(call("calculate", call("+", greta_array(x), greta_array(y))))

  out
}

#' Run an multiply operation
#'
#' @param op_node a greta multiply operation node
#'
#' @return the value of the operation
#'
run_multiply <- function(op_node) {
  stopifnot(inherits(op_node, "operation_node"))
  stopifnot(op_node$operation_name == "multiply")

  # Why can't we use $operation arguments
  # operation arguements don't appear to be ever set
  # are they deprecieted
  # no --- this will be needed for more complex operations
  args <- op_node$children
  # is this neccesary ... yes!,
  stopifnot(length(args) == 2)

  dims <- op_node$dim

  # tempoary guards
  stopifnot(length(dims) == 2)
  stopifnot(dims[[2]] == 1)

  x <- args[[1]]$value()
  y <- args[[2]]$value()

  # how to make sure it's greta::calculate?
  out <- eval(call("calculate", call("*", greta_array(x), greta_array(y))))

  out
}

