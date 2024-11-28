#### Preamble ####
# Purpose: Tests the structure and validity of simulated portfolios acquired from
          # a list of companies on the S&P500
# Author: Onon Burentuvshin
# Date: 20 November 2024
# Contact: onon.burentuvshin@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)

analysis_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("analysis_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####

# Check if the dataset has 100 rows
if (nrow(analysis_data) == 100) {
  message("Test Passed: The dataset has 151 rows.")
} else {
  stop("Test Failed: The dataset does not have 151 rows.")
}

# Check if the dataset has 3 columns
if (ncol(analysis_data) == 3) {
  message("Test Passed: The dataset has 3 columns.")
} else {
  stop("Test Failed: The dataset does not have 3 columns.")
}

# Check if all values in the 'Portfolio' column are unique
if (n_distinct(analysis_data$Portfolio) == nrow(analysis_data)) {
  message("Test Passed: All values in 'Portfolio' are unique.")
} else {
  stop("Test Failed: The 'Portfolio' column contains duplicate values.")
}


# Check if there are any missing values in the data set
if (all(!is.na(analysis_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if there are no empty strings in columns
if (all(analysis_data$Portfolio != "" & analysis_data$Correlation_Coefficient != "" & analysis_data$Percent_Returns != "")) {
  message("Test Passed: There are no empty strings in 'division', 'state', or 'party'.")
} else {
  stop("Test Failed: There are empty strings in one or more columns.")
}
