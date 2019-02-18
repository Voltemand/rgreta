sample_normal <- function(dist_node) {

  stopifnot(inherits(dist_node, "normal_distribution"))

  params <- dist_node$parameters
  dims <- dist_node$dim

  # tempoary guards
  stopifnot(length(dims) == 2)
  stopifnot(dims[[2]] == 1)

  N <- dims[[1]]
  mu <- params$mean$value()
  sd <- params$sd$value()

  out <- eval(call("rnorm", N, mu, sd))

  out
}

sample_cauchy <- function(dist_node) {

  stopifnot(inherits(dist_node, "cauchy_distribution"))

  params <- dist_node$parameters
  dims <- dist_node$dim

  # tempoary guards
  stopifnot(length(dims) == 2)
  stopifnot(dims[[2]] == 1)

  N <- dims[[1]]
  location <- params$location$value()
  scale <- params$scale$value()

  # is this a half_cauchy?
  if (all(dist_node$truncation == c(0, Inf))) {
     out <- eval(call("rhalfcauchy", N, location, scale))
  } else {
     out <- eval(call("rcauchy", N, location, scale))
  }

  out
}

# need to implement or depend on a better verion of this
rhalfcauchy <- function(n, location = 0, scale = 1) {
  out <- numeric(0)
  while (length(out) < n) {
    X <- rcauchy(1, location = location, scale = scale)
    if (X >= 0) {
      out <- c(out, X)
    } else {
      # do nothing
    }
  }
  out
}
