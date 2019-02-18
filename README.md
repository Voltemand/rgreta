
# rgreta

rgreta provides support for simulating models defined in the greta
package

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

    ##           [,1]
    ## [1,]  987.6828
    ## [2,] 1242.0151
    ## [3,] 1359.4682
    ## [4,] 1222.3871
    ## [5,] 1515.8643
    ## [6,] 1065.9504

Or we can simulate setting parmeters to certain values

``` r
m$dag$node_list
```

    ## $node_e52a14f8
    ## <data_node>
    ##   Inherits from: <node>
    ##   Public:
    ##     .value: 987.682844107461 1242.01513701429 1359.46821706103 1222. ...
    ##     add_child: function (node) 
    ##     add_parent: function (node) 
    ##     child_names: function (recursive = FALSE) 
    ##     children: list
    ##     clone: function (deep = FALSE) 
    ##     define_tf: function (dag) 
    ##     defined: function (dag) 
    ##     description: function () 
    ##     dim: 30 1
    ##     distribution: NULL
    ##     get_unique_name: function () 
    ##     initialize: function (data) 
    ##     parent_names: function () 
    ##     parents: list
    ##     plotting_label: function () 
    ##     register: function (dag) 
    ##     register_family: function (dag) 
    ##     remove_child: function (node) 
    ##     remove_parent: function (node) 
    ##     representations: list
    ##     set_distribution: function (distribution) 
    ##     tf: function (dag) 
    ##     unique_name: node_e52a14f8
    ##     value: function (new_value = NULL, ...)

## Install

``` r
devtools::install_github("Voltemand\rgreta")
```
