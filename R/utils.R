#' a which function for lists
#'
#' @param list a list
#' @param pred a predicate: a function that takes an element of the list
#'  and outputs a length 1 logical vector
#'
#' @return the indices of the list
#'
which_list <- function(list, pred) {
  which(vapply(list, pred, FUN.VALUE = logical(1), USE.NAMES = FALSE))
}

#' keep the elements of the list which pass a predicate
#'
#' @param list a list
#' @param pred a predicate: a function that takes an element of the list
#'  and outputs a length 1 logical vector
#'
#' @return the reduced list
#'
keep <- function(list, pred) {
  list[which_list(list, pred)]
}

#' is an object a greta distibution node
#'
#' @param x an object
#'
#' @return a length 1 logical vector
#'
is.distribution_node <- function(x) {
  inherits(x, "distribution_node")
}

#' is an object a greta data node
#'
#' @param x an object
#'
#' @return a length 1 logical vector
#'
is.data_node <- function(x) {
  inherits(x, "data_node")
}

#' is an object a greta operation node
#'
#' @param x an object
#'
#' @return a length 1 logical vector
#'
is.operation_node <- function(x) {
  inherits(x, "operation_node")
}

#' is an object a greta model
#'
#' @param x an object
#'
#' @return a length 1 logical vector
#'
is.greta_model <- function(x) {
  inherits(x, "greta_model")
}

#' make a data node
#'
#' @param value an R vector
#'
#' @return a greta data node
#'
make_data_node <- function(value) {
  node <- get_node(as.greta_array(value))
  node
}

#' get the target node of a greta disitbution node
#'
#' @param dist_node a greta distribution node
#'
#' @return a greta variable node
#'
target <- function(dist_node) {
  children <- dist_node$children
  children[which_list(children, function(x) !is.null(x$distribution))][[1]]
}

#' Do two nodes share a name?
#'
#' @param node1 a greta node
#' @param node2 a greta node
#'
#' @return logical vector of length 1
#'
same_name <- function(node1, node2){
  node1$unique_name == node2$unique_name
}

#' What index are nodes in the dag
#'
#' @param node a greta node
#' @param dag a greta dag
#'
#' @return a numeric vector
#'
index <- function(node, dag) {
  which_list(dag$node_list, function(x) same_name(x, node))
}

#' Get the name of distribution the distibution node follows
#'
#' @param dist_node a greta distibution node
#'
#' @return the name of dist
#'
dist_name <- function(dist_node) {
  stopifnot(is.distribution_node(dist_node))
  dist <- strsplit(class(dist_node)[[1]], "_")[[1]][[1]]
  dist
}

#' Get the names of the nodes in a dag
#'
#' @param dag a greta dag
#'
#' @return the names of the nodes
#'
node_names <- function(dag) {
  vapply(dag$node_list, function(x) x$unique_name,
         FUN.VALUE = character(1), USE.NAMES = FALSE)
}

#' Get the likelihood nodes of a greta dag
#'
#' @param dag a greta dag
#'
#' @return a list of nodes
#'
#' @details likelihood nodes are those that are data yet also have a distibution
#'
likelihood_nodes <- function(dag) {
  pred <- function(x) is.data_node(x) && !is.null(x$distribution)
  keep(dag$node_list, pred)
}

#' Get the distibution nodes of a greta dag
#'
#' @param dag a greta dag
#'
#' @return a list of greta nodes
#'
distribution_nodes <- function(dag) {
  keep(dag$node_list, function(x) is.distribution_node(x))
}

#' Get the operation nodes of a greta dag
#'
#' @param dag a greta dag
#'
#' @return a list of greta nodes
#'
operation_nodes <- function(dag) {
  keep(dag$node_list, function(x) is.operation_node(x))
}

#' Update a certain 'field' of all nodes in a dag based on the prescence of
#' a new node
#'
#' @param new_node a greta node which has been construted to replace an
#'   existing node
#' @param dag a greta dag
#' @param field a character string representing a slot in the node class
#'
#' @return the updated node_list
#'
update_field <- function(new_node, dag, field) {
  node_list <- dag$node_list
  for (i in 1:length(node_list)) {
     node <- node_list[[i]]
     if (length(node[[field]]) > 0) {
       for (j in 1:length(node[[field]])) {
         param <- node[[field]][[j]]
         if (same_name(param, new_node)) {
           dag$node_list[[i]][[field]][[j]] <- new_node
         }
       }
     }
  }

  dag

}

#' Check if we can sample from a given distribution node
#'
#' @param dist_node a greta distribution node
#'
#' @return a logical vector of length 1
#'
can_sample <- function(dist_node) {
  stopifnot(is.distribution_node(dist_node))
  # Should change this to use is.data_node
  all(unlist(lapply(dist_node$parameters, function(x) !is.na(x$value()))))
}

#' Check if we can run a given operation node
#'
#' @param dist_node a greta operation node
#'
#' @return a logical vector of length 1
#'
can_run <- function(op_node) {
  stopifnot(is.operation_node(op_node))
  # Should change this to use is.data_node
  all(unlist(lapply(op_node$children, function(x) !is.na(x$value()))))
}



