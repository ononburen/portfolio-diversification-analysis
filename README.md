# Exploring the Impact of Diversification and Market Volatility on Portfolio Performance: An Empirical Analysis of Simulated Portfolios in Two Periods of Market Stress

## Overview

This repository contains an analysis of the relationship between portfolio diversification, market volatility, and portfolio performance. Using simulated portfolio data derived from S&P 500 companies, this study evaluates the dynamics between market volatilit, portfolio diversification, and portfolio performance. Linear regression models are employed to assess these effects alongside an exploration of heterogeneous effects of different portfolio returns. 


## File Structure

The repo is structured as:

-   `data/01-company_basket` contains the basket of 50 companies generated from the data scraped from Wikipedia.
-   `data/02-raw_data` contains the raw daily price data as obtained from Yahoo Finance using the `quantmod` package.
-   `data/03-constructed_portfolios` contains 1,000 simulated portfolios consisting of the company tickers acquired from 01-company_basket. 
-   `data/04-analysis_data` contains cleaned annual returns data for individual stocks and aggregated portfolios for two years, resulting in four files.
-   `models` contains fitted models and results from our Linear Regression Model. 
-   `scripts` contains the R scripts used to simulate, download and clean data.
-   `other` contains sketches and a complete documentation of LLM usage.
-   `paper` contains the files used to generate the paper, which includes the Quarto document, references file, and a pdf of the paper.

## Execution Instructions

To reproduce the data from this repo, please download the ZIP file and execute the scripts in order. The scripts are numbered and indexed such that it would reproduce our data when executed in the order it was intendedd.

## Statement on LLM usage

The data acquisition, cleaning, figure generating, and model scipts were written and generated with the help of ChatGPT. Moreover, ChatGPT was used to read and interpret certain sections in the paper for feedback and review. The entire history of the usage is documented in `others/llms/usage.txt`.







