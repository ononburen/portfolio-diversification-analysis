#### Preamble ####
# Purpose: Tests the structure and validity of our analysis data
# Author: Onon Burentuvshin
# Date: 28 November 2024
# Contact: onon.burentuvshin@mail.utoronto.ca
# License: MIT
# Pre-requisites: Make sure our previous scripts ran smoothly, generating
                  # four analysis files. 


#### Workspace setup ####
library(tidyverse)
library(testthat)

# Load our four analysis data
data1 <- read_csv("data/04-analysis_data/annual_returns_2017.csv")
data2 <- read_csv("data/04-analysis_data/annual_returns_2020.csv")
data3 <- read_csv("data/04-analysis_data/final_portfolio_2017.csv")
data4 <- read_csv("data/04-analysis_data/final_portfolio_2020.csv")

#### Test data ####
# Our portfolio data should have 1,000 portfolios. Test this is true
test_that("dataset has 1,000 row", {
  expect_equal(nrow(data3), 1000)
})

test_that("dataset has 1,000 row", {
  expect_equal(nrow(data4), 1000)
})

# All our analysis data files should have 3 columns. Test this is true.
test_that("dataset has 3 columns", {
  expect_equal(ncol(data1), 3)
})

test_that("dataset has 3 columns", {
  expect_equal(ncol(data2), 3)
})

test_that("dataset has 3 columns", {
  expect_equal(ncol(data3), 3)
})

test_that("dataset has 3 columns", {
  expect_equal(ncol(data4), 3)
})

# Check if all values in the 'Portfolio_ID' column are unique in our portfolio data
if (n_distinct(data3$Portfolio_ID) == nrow(data3)) {
  message("Test Passed: All values in 'Portfolio_ID' are unique.")
} else {
  stop("Test Failed: The 'Portfolio' column contains duplicate values.")
}

if (n_distinct(data4$Portfolio_ID) == nrow(data4)) {
  message("Test Passed: All values in 'Portfolio_ID' are unique.")
} else {
  stop("Test Failed: The 'Portfolio' column contains duplicate values.")
}


# Test that there are no missing values in the datasets
test_that("no missing values in dataset", {
  expect_true(all(!is.na(data1)))
})

test_that("no missing values in dataset", {
  expect_true(all(!is.na(data2)))
})

test_that("no missing values in dataset", {
  expect_true(all(!is.na(data3)))
})

test_that("no missing values in dataset", {
  expect_true(all(!is.na(data4)))
})
