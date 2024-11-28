#### Preamble ####
# Purpose: Cleans the raw data produced by 02-download_data.R
# Author: Onon Burentuvshin
# Date: 27 November 2024
# Contact: onon.burentuvshin@mail.utoronto.ca
# License: MIT
# Pre-requisites: Make sure to have saved stock data from your basket.


#### Workspace setup ####
library(tidyverse)
library(readr)
library(dplyr)

#### Clean data ####
stock_prices <- read_csv("data/01-raw_data/raw_data.csv")

# We want to first annualize stock return data from 2017 and 2020.
# These will be saved in separate files for organization.
# Check data structure
head(stock_prices)

# Function to calculate annual returns for a specific year
calculate_annual_returns <- function(data, year) {
  # Filter for the first and last dates of the year
  start_prices <- data %>%
    filter(format(Date, "%Y") == year) %>%
    slice_min(Date)
  
  end_prices <- data %>%
    filter(format(Date, "%Y") == year) %>%
    slice_max(Date)
  
  # Calculate annual returns.
  returns <- (end_prices[-1] - start_prices[-1]) / start_prices[-1]
  
  # Create a data frame with results
  return_df <- data.frame(
    Ticker = colnames(returns),
    Annual_Return = as.numeric(returns)
  )
  
  return_df$Year <- year  # Add year column
  return(return_df)
}

# Calculate returns for 2017 and 2020
returns_2017 <- calculate_annual_returns(stock_prices, 2017)
returns_2020 <- calculate_annual_returns(stock_prices, 2020)

# These analysis data will be used in conjunction with portfolios.csv created
# from 09-porfolio_generration.R script to generate the model data that 
# was idealized in our sketches and simulated data.

# So, we load our simulated portfolio data
portfolios <- read_csv("data/04-constructed_portfolios/portfolios.csv")

# Merge portfolio data with 2017 returns
portfolio_returns_2017 <- portfolios %>%
  left_join(returns_2017, by = c("Stock" = "Ticker")) %>%
  mutate(Weighted_Return = Weight * Annual_Return)

# Repeat for 2020
portfolio_returns_2020 <- portfolios %>%
  left_join(returns_2020, by = c("Stock" = "Ticker")) %>%
  mutate(Weighted_Return = Weight * Annual_Return)

# Calculate HHI for 2017 portfolios
portfolio_hhi_2017 <- portfolios %>%
  group_by(Portfolio_ID) %>%
  summarize(HHI = sum(Weight^2))

# Repeat for 2020 portfolios
portfolio_hhi_2020 <- portfolios %>%
  group_by(Portfolio_ID) %>%
  summarize(HHI = sum(Weight^2))

# Calculate HHI for 2017 portfolios
portfolio_hhi_2017 <- portfolios %>%
  group_by(Portfolio_ID) %>%
  summarize(HHI = sum(Weight^2))

# Repeat for 2020 portfolios
portfolio_hhi_2020 <- portfolios %>%
  group_by(Portfolio_ID) %>%
  summarize(HHI = sum(Weight^2))

# Aggregate weighted returns for 2017
final_portfolio_2017 <- portfolio_returns_2017 %>%
  group_by(Portfolio_ID) %>%
  summarize(
    Portfolio_Return = sum(Weighted_Return, na.rm = TRUE)
  ) %>%
  left_join(portfolio_hhi_2017, by = "Portfolio_ID")

# Repeat for 2020
final_portfolio_2020 <- portfolio_returns_2020 %>%
  group_by(Portfolio_ID) %>%
  summarize(
    Portfolio_Return = sum(Weighted_Return, na.rm = TRUE)
  ) %>%
  left_join(portfolio_hhi_2020, by = "Portfolio_ID")


#### Save data ####

write_csv(returns_2017, "data/02-analysis_data/annual_returns_2017.csv")
write_csv(returns_2020, "data/02-analysis_data/annual_returns_2020.csv")
write_csv(final_portfolio_2017, "data/02-analysis_data/final_portfolio_2017.csv")
write_csv(final_portfolio_2020, "data/02-analysis_data/final_portfolio_2020.csv")