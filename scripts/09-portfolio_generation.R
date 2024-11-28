#### Workspace setup ####
library(tidyverse)
library(dplyr)

# The goal of this script is to artificially generate 1000 random portfolios  
# with  varying stakes in stocks of our 50 company basket. The idea is to create
# portfolios with varying diversification.

# Read the basket of selected tickers
selected_tickers_df <- read.csv("data/03-company_basket/company_basket.csv")

# Set parameters for portfolio construction
n_portfolios <- 1000  # Number of portfolios
set.seed(42)

# Function to create random portfolios
construct_portfolio <- function(tickers, portfolio_size) {
  sampled_tickers <- sample(tickers, portfolio_size)
  weights <- runif(portfolio_size)
  weights <- weights / sum(weights)  # Normalize weights to sum to 1
  data.frame(Stock = sampled_tickers, Weight = weights)
}

# Construct portfolios with varying levels of diversification
portfolios <- lapply(1:n_portfolios, function(i) {
  portfolio_size <- sample(c(5, 20, 40), 1)  # Randomly choose portfolio size
  construct_portfolio(selected_tickers_df$Ticker, portfolio_size)
})

# Combine portfolios into a single data frame with an identifier
portfolios_df <- bind_rows(portfolios, .id = "Portfolio_ID")

# Check the data strcuture
head(portfolios_df)

### Save file ###
write_csv(portfolios_df, "data/04-constructed_portfolios/portfolios.csv")
