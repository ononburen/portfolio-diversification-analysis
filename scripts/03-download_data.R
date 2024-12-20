#### Preamble ####
# Purpose: Downloads and saves the data from Yahoo Finance
# Author: Onon Burentuvshin
# Date: 27 November 2024
# Contact: onon.burentuvshin@mail.utoronto.ca
# License: MIT
# Pre-requisites: The data we collect will be specific to our portfolio basket.
# Any other information needed? N/A

# We need to install quantmod to read data from Yahoo Finance
options(repos = c(CRAN = "https://cloud.r-project.org"))
install.packages(quantmod)

#### Workspace setup ####
library(quantmod)
library(tidyverse)


#### Download data ####

# We only want historical stock data on companies that are in our 50  
# company basket. This basket was generated by "01-company_basket", which
# should have generated company_basket.csv.

selected_tickers <- read_csv("data/01-company_basket/company_basket.csv")

# Ensure this called the right data frame
head(selected_tickers)

# Yahoo Finance contains historical data that are outside our range of
# interest. So, we want to define a time period.

start_date <- "2010-01-01"
end_date <- "2023-01-01"

# We fetch stock data within our time period and company basket

fetch_stock_data <- function(ticker) {
  tryCatch(
    {
      stock_data <- getSymbols(
        ticker,
        src = "yahoo",
        from = start_date,
        to = end_date,
        auto.assign = FALSE
      )
      stock_data <- Cl(stock_data)  # Extract adjusted closing prices
      colnames(stock_data) <- ticker  # Rename the column
      return(stock_data)
    },
    error = function(e) {
      message(paste("Error fetching data for", ticker))
      return(NULL)
    }
  )
}

# Apply this function for our selected_tickers
stock_prices_list <- lapply(selected_tickers$Ticker, fetch_stock_data)
stock_prices <- do.call(merge, stock_prices_list)

# Ensure you fetched the data properly
head(stock_prices)

# When we run this code, we can see that data on two company tickers 
# failed to be fetched. Maybe these companies went public after 2010 and 
# some data maybe missing. Or, they are not traded anymore. Thus, we can
# remove these three companies from our basket. From the console,
# find out which of these companies failed to be retrieved and remove them as
# such.
problematic_tickers <- c("GEV", "VLTO") # Make sure to inspect console for
                                        # which tickers failed to be fetched.

# Remove problematic tickers from the basket
valid_tickers <- selected_tickers$Ticker[!selected_tickers$Ticker %in% problematic_tickers]

# This means we HAVE TO UPDATE our company basket file. Or else, 
# our portfolio generation is going to have include companies that were
# removed. 
valid_tickers_df <- data.frame(Ticker = valid_tickers)
write_csv(valid_tickers_df, "data/01-company_basket/company_basket.csv")


# Fetch data again with the valid tickers
stock_prices_list <- lapply(valid_tickers, fetch_stock_data)

# Filter for empty or invalid entries
stock_prices_list <- stock_prices_list[!sapply(stock_prices_list, is.null)]

# Combine data into a single data frame
stock_prices <- do.call(merge, stock_prices_list)
stock_prices_df <- as.data.frame(stock_prices)

# Convert rownames (dates) to a column named "Date"
stock_prices_df$Date <- rownames(stock_prices_df)

# Remove row names for organization
rownames(stock_prices_df) <- NULL

#  Reorder columns to place "Date" first
stock_prices_df <- stock_prices_df[, c("Date", setdiff(names(stock_prices_df), "Date"))]


#### Save data ####
 
write_csv(stock_prices_df, "data/02-raw_data/raw_data.csv")

         
