#### Workspace setup ####
library(rvest)
library(dplyr)

# We want to select 50 random companies from S&P 500
url <- "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"

# Extract the table
sp500_table <- url %>%
  read_html() %>%
  html_table(fill = TRUE)

# Select the first table and extract ticker symbols
sp500_data <- sp500_table[[1]] %>%
  select(Symbol, Security)  # Keep useful columns

# Extract ticker symbols into a vector
sp500_tickers <- sp500_data$Symbol

# Check to see the data
head(sp500_data)

# Set a seed for reproducibility
set.seed(42)

# Now, we want to randomly select 50 companies from this index
selected_tickers <- sample(sp500_tickers, 50)

print(selected_tickers)

# selected_tickers now contains a basket of 50 companies that we will collect data on.
# However,  selected_tickers is a vector

selected_tickers_df <- data.frame(Ticker = selected_tickers)
write_csv(selected_tickers_df, "data/01-company_basket/company_basket.csv")
