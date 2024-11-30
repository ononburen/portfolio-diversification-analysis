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
stock_prices <- read_csv("data/02-raw_data/raw_data.csv")

# If data is missing, then we have to omit these values, and rewrite our company
# basket and rerun our script for portfolio generation again.

# First, identify companies yielding N/A results specific to 2017 and 2020.
filtered_data <- stock_prices %>%
  filter(format(Date, "%Y") %in% c("2017", "2020"))

missing_counts <- colSums(is.na(filtered_data[-1]))  
problematic_companies <- names(missing_counts[missing_counts > 10])
print(problematic_companies)

# We need to remove these companies from our company basket and rerun 
# our script for portfolio generation.
selected_tickers_df <- read_csv("data/01-company_basket/company_basket.csv")

# Remove problematic companies
updated_tickers <- selected_tickers_df %>%
  filter(!Ticker %in% problematic_companies)

# Update our file on company baskets for our portfolio generation script.
write_csv(updated_tickers, "data/01-company_basket/company_basket.csv")

### Rerun script for portfolio generation ###

# Read the basket of selected tickers
selected_tickers_df <- read.csv("data/01-company_basket/company_basket.csv")

# Set parameters for portfolio construction and reproducibility
n_portfolios <- 1000  
set.seed(42)

# Function to calculate HHI
calculate_hhi <- function(weights) {
  sum(weights^2)
}

# Function to create random portfolios with controlled HHI distribution
construct_portfolio <- function(tickers, target_hhi) {
  portfolio_size <- sample(c(5, 20, 40), 1)  # Random portfolio size
  sampled_tickers <- sample(tickers, portfolio_size)
  
  # Generate weights to influence HHI
  if (target_hhi < 0.3) {  # Low HHI (high diversification)
    weights <- runif(portfolio_size)
    weights <- weights / sum(weights)
  } else if (target_hhi > 0.7) {  # High HHI (low diversification)
    weights <- c(runif(1, 0.5, 0.9), runif(portfolio_size - 1, 0.01, 0.05))
    weights <- weights / sum(weights)
  } else {  # Moderate HHI
    weights <- runif(portfolio_size, 0.1, 0.3)
    weights <- weights / sum(weights)
  }
  portfolio <- data.frame(
    Stock = sampled_tickers,
    Weight = weights
  )
  portfolio$HHI <- calculate_hhi(weights)
  return(portfolio)
}

# Generate portfolios with varying HHI targets
target_hhis <- runif(n_portfolios, 0.2, 0.8)  # HHI targets between 0.2 and 0.8
portfolios <- lapply(1:n_portfolios, function(i) {
  construct_portfolio(selected_tickers_df$Ticker, target_hhis[i])
})

# Combine portfolios into a single data frame with an identifier
portfolios_df <- bind_rows(portfolios, .id = "Portfolio_ID")

### Save the file ###
write_csv(portfolios_df, "data/03-constructed_portfolios/portfolios.csv")

### END OF SCRIPT FOR PORTFOLIO GENERATION ###



# We want to first annualize stock return data from 2017 and 2020.
# These will be saved in separate files for organization.

# Function to calculate annual returns for a specific year
calculate_annual_returns <- function(data, year) {
  # Filter for the first and last dates of the year
  start_prices <- data %>%
    filter(format(Date, "%Y") == year) %>%
    slice_min(order_by = Date, with_ties = FALSE) 
  
  end_prices <- data %>%
    filter(format(Date, "%Y") == year) %>%
    slice_max(order_by = Date, with_ties = FALSE) 
  
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


# So, we load our simulated and updated portfolio data
portfolios <- read_csv("data/03-constructed_portfolios/portfolios.csv")

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

write_csv(returns_2017, "data/04-analysis_data/annual_returns_2017.csv")
write_csv(returns_2020, "data/04-analysis_data/annual_returns_2020.csv")
write_csv(final_portfolio_2017, "data/04-analysis_data/final_portfolio_2017.csv")
write_csv(final_portfolio_2020, "data/04-analysis_data/final_portfolio_2020.csv")