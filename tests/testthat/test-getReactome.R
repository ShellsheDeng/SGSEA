library(testthat)

test_that("getReactome returns list", {
  # Ensure org.Hs.eg.db is installed before testing
  if (!requireNamespace("org.Hs.eg.db", quietly = TRUE)) {
    BiocManager::install("org.Hs.eg.db", ask = FALSE)
  }

  # Attach the database ONLY for testing (prevents failure in R CMD check)
  suppressMessages(library(org.Hs.eg.db))

  # Run the test
  expect_equal(class(getReactome("human")), "list")
})


