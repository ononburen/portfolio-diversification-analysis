#### Preamble ####
# Purpose: Generate model results from our linear regression
# Author: Onon Burentuvshin
# Date: 28 November  2024
# Contact: onon.burentuvshin@mail.utoronto.ca
# License: MIT
# Pre-requisites: Acquired clean data from two years of stock performance.


#### Workspace setup ####
library(tidyverse)
library(broom)
library(arrow)
library(lmtest)
library(car)

#### Read data ####
portfolio_2017 <- read_parquet("data/04-analysis_data/final_portfolio_2017.parquet")
portfolio_2020 <- read_parquet("data/04-analysis_data/final_portfolio_2020.parquet")

### Model 1 data ####
portfolio_2017 <- portfolio_2017 %>% mutate(Year = "2017")
portfolio_2020 <- portfolio_2020 %>% mutate(Year = "2020")

# Combine for analysis
combined_portfolio <- bind_rows(portfolio_2017, portfolio_2020)

combined_portfolio <- combined_portfolio %>%
  mutate(Year = as.factor(Year))

regression_model <- lm(
  Portfolio_Return ~ HHI * Year,
  data = combined_portfolio
)

summary(regression_model)



###  Model  2 Data ###
quantile_75 <- quantile(portfolio_data$Portfolio_Return, 0.75, na.rm = TRUE)
quantile_25 <- quantile(portfolio_data$Portfolio_Return, 0.25, na.rm = TRUE)
top_performers <- portfolio_data %>% filter(Portfolio_Return >= quantile_75)
bottom_performers <- portfolio_data %>% filter(Portfolio_Return <= quantile_25)

regression_top <- lm(Portfolio_Return ~ HHI * Year, data = top_performers)
regression_bottom <- lm(Portfolio_Return ~ HHI * Year, data = bottom_performers)

summary(regression_top)
summary(regression_bottom)


# Save the models as a list
model_results <- list(
  top_performers = regression_top,
  bottom_performers = regression_bottom
)


### Model Validation Tests ###
library(car)
library(lmtest)

# Test 1: Linearity
plot(regression_model, 1)

# Test 2: Predictors (x) are Independent & Observed with Negligible Error
dw_test <- durbinWatsonTest(regression_model)
print(dw_test)


  

# Test 3: Residuals have mean value of 0
plot(regression_model, 1)

# Test 4: Residual Errors have Constant Variance
variance_test <- bptest(regression_model)
print(variance_test)

### Save Files ###
saveRDS(regression_model, file = "models/base_regression_model.rds")
saveRDS(model_results, file = "models/model_2_results.rds")
