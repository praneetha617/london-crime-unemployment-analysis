# 03_clean_tertiary_geographic_data.R
# Cleaning tertiary geographic borough dataset

library(dplyr)

tert1 <- read.csv(
  file = "Tert_Data_Dirty.csv",
  header = TRUE,
  sep = ","
)

# Initial data checks
sum(is.na(tert1))
sum(duplicated(tert1))

tert2 <- tert1

# Standardise borough names
tert2$Borough_Name <- gsub("&", "and", tert2$Borough_Name)
tert2$Borough_Name <- gsub("-", " ", tert2$Borough_Name)

# Borough lookup table
borough_lookup <- data.frame(
  Borough_Name = c(
    "Barking and Dagenham", "Barnet", "Bexley", "Brent", "Bromley", "Camden",
    "Croydon", "Ealing", "Enfield", "Greenwich", "Hackney",
    "Hammersmith and Fulham", "Haringey", "Harrow", "Havering", "Hillingdon",
    "Hounslow", "Islington", "Kensington and Chelsea", "Kingston upon Thames",
    "Lambeth", "Lewisham", "Merton", "Newham", "Redbridge",
    "Richmond upon Thames", "Southwark", "Sutton", "Tower Hamlets",
    "Waltham Forest", "Wandsworth", "Westminster"
  ),
  Borough_Code = c(
    "E09000002", "E09000003", "E09000004", "E09000005", "E09000006",
    "E09000007", "E09000008", "E09000009", "E09000010", "E09000011",
    "E09000012", "E09000013", "E09000014", "E09000015", "E09000016",
    "E09000017", "E09000018", "E09000019", "E09000020", "E09000021",
    "E09000022", "E09000023", "E09000024", "E09000025", "E09000026",
    "E09000027", "E09000028", "E09000029", "E09000030", "E09000031",
    "E09000032", "E09000033"
  )
)

tertm <- merge(tert2, borough_lookup, by = "Borough_Name", all.x = TRUE)
tertm <- tertm[, c("Borough_Code", setdiff(names(tertm), "Borough_Code"))]

cleaned_tertiary_data <- tertm %>%
  arrange(Borough_Code, LSOA_Code)

# Data checks
sum(duplicated(cleaned_tertiary_data))
sum(is.na(cleaned_tertiary_data))

write.csv(cleaned_tertiary_data, file = "tertiary_cleaned.csv", row.names = FALSE)
