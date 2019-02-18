context("test-simulate")

test_that("simulate works", {

  library(greta)

  int <- normal(0, 10)
  coef <- normal(0, 10)
  sd <- cauchy(0, 3, truncation = c(0, Inf))
  mu <- int + coef * attitude$complaints
  distribution(attitude$rating) <- normal(mu, sd)
  m <- model(int, coef, sd)

  expect_error(simulate(m), NA)

})
