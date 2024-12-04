#### Preamble ####
# Purpose: Use analysis data to generate simple summarizations and figures of the data.
          # Replicate graphs and figures.
# Author: Onon Burentuvshin
# Date: 28 November  2024
# Contact: onon.burentuvshin@mail.utoronto.ca
# License: MIT
# Pre-requisites: Acquired clean data from two years of stock performance.


#### Workspace setup ####
library(tidyverse)
library(ggplot2)

#### Read data ####
data1 <- read_parquet("data/04-analysis_data/annual_returns_2017.parquet")
data2 <- read_parquet("data/04-analysis_data/annual_returns_2020.parquet")
data3 <- read_parquet("data/04-analysis_data/final_portfolio_2017.parquet")
data4 <- read_parquet("data/04-analysis_data/final_portfolio_2020.parquet")

### Model data ####

# Density curves for 2017 and 2020
data3$Year <- "2017"
data4$Year <- "2020"
portfolio_data <- bind_rows(data3, data4)

### Plot density of portfolio returns
ggplot(portfolio_data, aes(x = Portfolio_Return, fill = Year)) +
  geom_density(alpha = 0.5) +
  labs(
    title = "Distribution of Portfolio Returns (2017 vs 2020)",
    x = "Portfolio Return",
    y = "Density"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("2017" = "blue", "2020" = "red"))


### Plot heatmap for 2017
ggplot(data3, aes(x = HHI, y = Portfolio_Return)) +
  geom_bin2d(bins = 30) +
  labs(
    title = "Heatmap of HHI and Portfolio Returns (2017)",
    x = "HHI (Diversification)",
    y = "Portfolio Return"
  ) +
  theme_minimal() +
  scale_fill_gradient(low = "lightblue", high = "darkblue")

# Plot heatmap for 2020
ggplot(data4, aes(x = HHI, y = Portfolio_Return)) +
  geom_bin2d(bins = 30) +
  labs(
    title = "Heatmap of HHI and Portfolio Returns (2020)",
    x = "HHI (Diversification)",
    y = "Portfolio Return"
  ) +
  theme_minimal() +
  scale_fill_gradient(low = "lightblue", high = "darkblue")

### Bar Chart of Average Portfolio Returns by HHI Range

# Define HHI ranges
portfolio_data <- portfolio_data %>%
  mutate(
    HHI_Range = case_when(
      HHI <= 0.3 ~ "Low",
      HHI > 0.3 & HHI <= 0.6 ~ "Medium",
      HHI > 0.6 ~ "High"
    )
  )
# Calculate average returns by HHI range and year
avg_returns <- portfolio_data %>%
  group_by(Year, HHI_Range) %>%
  summarize(Average_Return = mean(Portfolio_Return, na.rm = TRUE))

# Plot bar chart
ggplot(avg_returns, aes(x = HHI_Range, y = Average_Return, fill = Year)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Average Portfolio Returns by HHI Range",
    x = "HHI Range",
    y = "Average Portfolio Return"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("2017" = "blue", "2020" = "red"))

## Figure of distribution of HHI level by year
ggplot(portfolio_data, aes(x = Year, y = HHI, fill = Year)) +
  geom_boxplot(alpha = 0.7) +
  labs(
    title = "Distribution of HHI Levels by Year",
    x = "Year",
    y = "HHI (Diversification)"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("2017" = "blue", "2020" = "red")) +
  theme(legend.position = "none")


## Figure of the correlation matrix between companies.
returns_wide <- data1 %>%
  pivot_wider(names_from = Ticker, values_from = Annual_Return)
str(returns_wide)
summary(returns_wide)
colSums(is.na(returns_wide))

