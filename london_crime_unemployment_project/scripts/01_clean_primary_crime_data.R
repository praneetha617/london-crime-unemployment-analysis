# 01_clean_primary_crime_data.R
# Cleaning and transforming primary London crime dataset

library(tidyr)
library(dplyr)

crime1 <- read.csv(
  file = "Prim_data_dirty.csv",
  header = TRUE,
  sep = ","
)

# Convert monthly crime columns into long format
crime1_long <- pivot_longer(
  crime1,
  cols = starts_with("X20"),
  names_to = "Year",
  values_to = "No_of_Crimes"
)

# Remove leading X from year/month column names
crime1_long$Year <- sub("X", "", crime1_long$Year)

crime_clean <- crime1_long

# Remove unnecessary major category column
crime_clean <- crime_clean[, -which(names(crime_clean) == "Major.Category")]

# Check data quality
sum(is.na(crime_clean))
sum(duplicated(crime_clean))

# Rename and arrange columns
crime_clean <- crime_clean %>%
  rename(Borough_Code = Borough_Name)

crime_clean <- crime_clean[, c("Borough_Name", setdiff(names(crime_clean), "Borough_Name"))]

crime_clean <- crime_clean %>%
  arrange(Year, Borough_Code)

# Convert YYYYMM into YYYY-MM format
crime_clean$Year <- paste(
  substr(crime_clean$Year, 1, 4),
  substr(crime_clean$Year, 5, 6),
  sep = "-"
)

crime_clean <- crime_clean %>%
  rename(Year_Month = Year)

write.csv(crime_clean, file = "Clean_primary_data1.csv", row.names = FALSE)
