# 02_clean_secondary_unemployment_data.R
# Cleaning secondary unemployment dataset

library(dplyr)
library(stringr)
library(zoo)

seco1 <- read.csv(
  file = "Sec_data_dirty.csv",
  header = TRUE,
  sep = ","
)

seco2 <- seco1

# Convert quarter labels into numeric quarter values
seco2 <- seco2 %>%
  mutate(Quarter_Month = str_trim(Quarter_Month)) %>%
  mutate(Quarter_Month = case_when(
    Quarter_Month == "Jan-Mar" ~ 1,
    Quarter_Month == "Apr-Jun" ~ 2,
    Quarter_Month == "Jul-Sep" ~ 3,
    Quarter_Month == "Oct-Dec" ~ 4,
    TRUE ~ as.numeric(NA)
  ))

# Replace missing white non-UK national unemployment values with mean
seco3 <- seco2 %>%
  mutate(Unemployment_rate_aged_16_white_not_UK_national = if_else(
    is.na(Unemployment_rate_aged_16_white_not_UK_national),
    mean(Unemployment_rate_aged_16_white_not_UK_national, na.rm = TRUE),
    Unemployment_rate_aged_16_white_not_UK_national
  ))

# Ensure quarter fields are integers
seco4 <- seco3 %>%
  mutate(across(
    starts_with("Quarter"),
    ~ as.integer(gsub("\\D", "", .))
  ))

cleaned_secondary_data <- seco4

# Data quality checks
sum(duplicated(cleaned_secondary_data))
sum(is.na(cleaned_secondary_data))

write.csv(cleaned_secondary_data, file = "Cleaned_Secondary_Data.csv", row.names = FALSE)
