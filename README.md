# final-project

## Introduction

This project is divided into three main parts: 
1.project_1.R
2.project_2.R
3.project_3.R

## File Descriptions

### project_1.R

This script is used for cleaning raw data, including handling missing values, transforming data types, and filtering out unwanted entries.

It takes a CSV file named `data.csv` as input, performs cleaning operations, and saves the cleaned data to a new file `data_clean.csv`.

Method
  - Data import using `read_csv`.
  - Data filtering and transformation with `dplyr` functions like `filter` and `mutate`.
  - Output cleaned data using `write_csv`.

### project_2.R

This script performs statistical analysis on the cleaned data, including generating summary statistics and creating visualizations.

It reads the cleaned data from `data_clean.csv`, performs various analyses, and saves the results and plots.

Method
  - Data visualization using `ggplot2`.
  - Summarizing data statistics.
  - Saving plots with `ggsave`.

### project_3.R

This script is used for building and evaluating a predictive model using the cleaned data.

It reads the cleaned data, splits it into training and test sets, trains a model, makes predictions, and evaluates the model performance. The results are saved in `model_performance.csv`.

Method
  - Data partitioning using `caret` functions.
  - Model training with `train`.
  - Model performance evaluation.

## How to Run

Ensure you have R and RStudio installed. You will also need to install the following packages if they are not already installed:
   ```R
   install.packages(c("dplyr", "readr", "ggplot2", "caret"))
