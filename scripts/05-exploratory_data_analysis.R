#### Preamble ####
# Purpose: Use analysis data to acquire model data idealized in simulated data.
# Author: Onon Burentuvshin
# Date: 28 November  2024
# Contact: onon.burentuvshin@mail.utoronto.ca
# License: MIT
# Pre-requisites: Acquired clean data from two years of stock performance.


#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
analysis_data <- read_csv("data/analysis_data/analysis_data.csv")

### Model data ####
first_model <-
  stan_glm(
    formula = flying_time ~ length + width,
    data = analysis_data,
    family = gaussian(),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_aux = exponential(rate = 1, autoscale = TRUE),
    seed = 853
  )


#### Save model ####
saveRDS(
  first_model,
  file = "models/first_model.rds"
)


