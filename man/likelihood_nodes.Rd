% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{likelihood_nodes}
\alias{likelihood_nodes}
\title{Get the likelihood nodes of a greta dag}
\usage{
likelihood_nodes(dag)
}
\arguments{
\item{dag}{a greta dag}
}
\value{
a list of nodes
}
\description{
Get the likelihood nodes of a greta dag
}
\details{
likelihood nodes are those that are data yet also have a distibution
}
