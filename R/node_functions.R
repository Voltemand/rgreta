# Notes:
# The stuff at the end of each function could be rewritten into another
# function. Otherwise there is a LOT of code duplication.

#' Sample a distibution node
#'
#' @param dist_node a greta distibution_node
#' @param dag the dag the node is part of
#'
#' @return an altered dag containing the simulated values as a data_node
#'
sample_distribution <- function(dist_node, dag) {

  # get what type of distibution it is
  dist <- dist_name(dist_node)

  # find the parameters
  # we also get these in sample_ but these are needed for node juggling
  params <- dist_node$parameters

  # get the distibutions target
  target_node <- target(dist_node)
  sample_fun <- paste0("sample_", dist)

  # what envriment here?
  value <- eval(call(sample_fun, dist_node), envir = parent.frame())
  new_node <- make_data_node(value)
  target_i <- index(target_node, dag)

  # make the new node look like the old one
  new_node$unique_name <- target_node$unique_name
  new_node$parents <- keep(target_node$parents, function(x) !is.distribution_node(x))

  inds <- unlist(lapply(c(params, dist_node), index, dag))

  dag$node_list[[target_i]] <- new_node

  # pseudo code - this is wrong for some reason
  dag$adjacency_matrix[ ,inds] <- rep(0, nrow(dag$adjacency_matrix))
  dag$adjacency_matrix <- dag$adjacency_matrix[-inds, ]

  dag <- update_field(new_node, dag, "parameters")
  dag <- update_field(new_node, dag, "children")

  dag$node_list <- dag$node_list[-inds]

  dag
}


#' Run a distibution node
#'
#' @param dist_node a greta operation_node
#' @param dag the dag the node is part of
#'
#' @return an altered dag containing the obtained values as a data_node
#'
run_operation <- function(op_node, dag) {

  # get what type of distibution it is
  op_name <- op_node$operation_name

  # Assumption: all children are arguements
  # not true for more complex operation but will do for now
  args <- op_node$children
  op_fun <- paste0("run_", op_name)

  # what environment here?
  value <- eval(call(op_fun, op_node), envir = parent.frame())
  new_node <- make_data_node(value)

  # in run operation the node we replace is the operation node itself
  # not it's target as in sample_distribution

  target_i <- index(op_node, dag)

  # make the new node look like the old one
  new_node$unique_name <- op_node$unique_name
  new_node$parents <- op_node$parents

  inds <- unlist(lapply(c(args), index, dag))

  dag$node_list[[target_i]] <- new_node

  # pseudo code -
  dag$adjacency_matrix[ ,inds] <- rep(0, nrow(dag$adjacency_matrix))
  dag$adjacency_matrix <- dag$adjacency_matrix[-inds, ]

  #dag$node_list <- update_field(new_node, dag, "arguments")
  dag <- update_field(new_node, dag, "children")
  # need to update params of other distibutions
  dag <- update_field(new_node, dag, "parameters")

  dag$node_list <- dag$node_list[-inds]

  dag

}


#' Insert values of parameters into a DAG
#'
#' @param parameters a names list of parameters and their values
#' @param dag a the parameters are going to be inserted into
#'
#' @return the altered DAG
#'
insert_parameters <- function(parameters, dag) {

  if (!all(names(parameters) %in% names(dag$target_nodes))) {
    stop("Some of the parameter values given do not match those in the dag",
         call. = FALSE)
  }

  for (name in names(parameters)) {

    target_node <- dag$target_nodes[[name]]
    value <- parameters[[name]]

    dist_node <- keep(target_node$parents, is.distribution_node)[[1]]
    params <- dist_node$parameters

    new_node <- make_data_node(value)
    target_i <- index(target_node, dag)

    new_node$unique_name <- target_node$unique_name
    new_node$parents <- keep(target_node$parents, function(x) !is.distribution_node(x))

    inds <- unlist(lapply(c(params, dist_node), index, dag))

    dag$node_list[[target_i]] <- new_node

    dag$adjacency_matrix[ ,inds] <- rep(0, nrow(dag$adjacency_matrix))
    dag$adjacency_matrix <- dag$adjacency_matrix[-inds, ]

    dag <- update_field(new_node, dag, "parameters")
    dag <- update_field(new_node, dag, "children")

    dag$node_list <- dag$node_list[-inds]

  }

  dag

}