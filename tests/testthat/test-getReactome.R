library(testthat)
test_that("error message", {
  expect_equal(class(getReactome("human")),"list")
})
