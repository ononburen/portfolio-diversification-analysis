#### Workspace setup ####
library(tidyverse)
library(dplyr)

# The goal of this script is to artificially generate 1000 random portfolios  
# with  varying stakes in stocks of our 50 company basket. The idea is to create
# portfolios with varying diversification.

# More importantly, our measure for diversification (HHI) NEEDS to be
# evenly distributed to ensure variability in our diversification. Our
# model will be more effective to compare varying levels of diversification.

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
