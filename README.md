
# rgreta

**rgreta** provides support for simple simulation of models defined in
the **greta** modelling language/R package

## Usage

Define a simple example greta model:

``` r
library(greta)

int <- normal(0, 10)
coef <- normal(0, 10)
sd <- cauchy(0, 3, truncation = c(0, Inf))

mu <- int + coef * attitude$complaints

distribution(attitude$rating) <- normal(mu, sd)

m <- model(int, coef, sd)
```

We can then simulate from the model:

``` r
library(rgreta)
simulations <- simulate(m)
```

    ## Sampling a distribution node
    ## Sampling a distribution node
    ## Sampling a distribution node
    ## Running an operation node
    ## Running an operation node
    ## Sampling a distribution node

``` r
head(simulations)
```

    ## greta array (operation)
    ## 
    ##            [,1]
    ## [1,] -193763.22
    ## [2,]  -55621.24
    ## [3,] -177213.77
    ## [4,]  180697.57
    ## [5,]  -19183.71
    ## [6,]   63658.44

Or we can simulate setting parameters to certain values

``` r
simulations <- simulate(m, list(int = 1, coef = 1, sd = 1))
```

    ## Running an operation node
    ## Running an operation node
    ## Sampling a distribution node

``` r
head(simulations)
```

    ## greta array (operation)
    ## 
    ##          [,1]
    ## [1,] 52.95084
    ## [2,] 65.40251
    ## [3,] 70.58232
    ## [4,] 62.36550
    ## [5,] 80.54827
    ## [6,] 54.35152

## Install

``` r
devtools::install_github("Voltemand\rgreta")
```

## TODO

**rgreta** is very much still a work in progress. The current
feature/idea list is:

  - Support for more distibutions and operations - currently rgreta only
    supports the normal and cauchy distributions and addition and
    multiplication operations
  - Seed passing
  - A way to pass simulated data back to models
  - Support for tensorflow probability distibutions samplers
