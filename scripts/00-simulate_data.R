#### Preamble ####
# Purpose: Simulates a dataset of Australian electoral divisions, including the 
  #state and party that won each division.
# Author: Rohan Alexander
# Date: 26 September 2024
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)
set.seed(853)


#### Simulate data ####
simulated_data <-
  tibble(
    # Use 1 through to 100 to represent each portfolio
    "Portfolio" = 1:100,
    # Use values between 0 and 1 to represent diversification value
    "Correlation Coefficient" = runif(100, min = 0, max = 1),
    # Use values between 0 and 1000 to signify portfolio returns
    "Percent Returns" =  runif(100, min = 0, max = 100
    )
  )


#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
