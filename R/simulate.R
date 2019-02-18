# Need to work on not changing the model

#' Simulate a from a greta model
#'
#' @param m a greta model
#' @param values fixed values of some of parameters of the model
#'
#' @return TBD
#' @export
#'
#' @examples TODO
simulate <- function(m, values = NULL) {

  if (!is.greta_model(m)) {
    stop("m must be a greta model", call. = FALSE)
  }

  # remember some values about the DAG see later note
  old_children_list <- lapply(m$dag$node_list, function(x) x$children)
  old_parameter_list <- lapply(distribution_nodes(m$dag), function(x) x$parameters)

  dag <- m$dag$clone()

  if (!is.null(values)) {

    if (!is.list(values) || is.null(names(m))) {
      stop("values must be a named list", call. = FALSE)
    }

    dag <- insert_parameters(values, dag)

  }

  status <- dag_status(dag)

  while (length(status$likelihoods) > 0) {

    if (length(status$sampleable) > 0) {
      cat("Sampling a distribution node\n")
      dag <- sample_distribution(status$sampleable[[1]], dag)
      status <- dag_status(dag)
      next
    }

    if (length(status$runnable) > 0) {
      cat("Running an operation node\n")
      dag <- run_operation(status$runnable[[1]], dag)
      status <- dag_status(dag)
      next
    }

    # TODO improve this error - possibly with greta source code
    stop("something is wrong with the dag", call. = FALSE)

  }

  out <- as.greta_array(dag$node_list[[1]]$value())

  # Note:
  # This manual copying is due to the fact that clone(deep = TRUE)
  # does not work (at least on my system) as it has problems with the
  # python Graph object
  for (i in 1:length(m$dag$node_list)) {
    m$dag$node_list[[i]]$children <- old_children_list[[i]]
  }

  j <- 1
  for (i in 1:length(m$dag$node_list)) {
    if (is.distribution_node(m$dag$node_list[[i]])) {
       m$dag$node_list[[i]]$parameters <- old_parameter_list[[j]]
       j <- j + 1
    }
  }

  out

}

#' Get the status of the dag
#'
#' @param dag the DAG of the greta model
#'
#' @return A named list
#'
dag_status <- function(dag) {
  status <- list(runnable    = keep(operation_nodes(dag), can_run),
                 sampleable  = keep(distribution_nodes(dag), can_sample),
                 likelihoods = likelihood_nodes(dag))
  status
}
