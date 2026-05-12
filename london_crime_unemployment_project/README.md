# London Crime and Unemployment Big Data Analytics Project

## Project Overview

This project analyses the relationship between crime patterns and unemployment indicators across London boroughs. It combines crime data, unemployment data, and geographic borough information to support data-driven decision-making through ETL, data warehousing, Hive querying, and dashboard visualisation.

The project was developed as a group academic big data project and includes:

- Data extraction and cleaning using R
- Data transformation and preparation for analytical use
- Hive table creation and data warehouse modelling
- Dimension and fact table design
- Business-question-driven SQL analysis
- Dashboard visualisation using Tableau/BI tools

## Business Questions

1. What is the total number of crimes per borough in each month from 2018 to 2021?
2. What is the average unemployment rate among ethnic minority UK nationals across boroughs with the highest theft-from-person incidents from 2011 to 2021?
3. Which GLA constituencies are linked to boroughs with the highest crime rates from 2019 to 2021?
4. What are the most prevalent crime types in each quarterly month from 2018 to 2020, and what is the corresponding average unemployment rate among white UK nationals?
5. What are the highest occurring crime types in each borough from 2011 to 2021?

## Tools and Technologies

- R / RStudio
- dplyr
- tidyr
- stringr
- zoo
- Apache Hive
- HDFS
- Tableau
- Microsoft Teams / Zoom

## Repository Structure

```text
london_crime_unemployment_project/
│
├── scripts/
│   ├── 01_clean_primary_crime_data.R
│   ├── 02_clean_secondary_unemployment_data.R
│   └── 03_clean_tertiary_geographic_data.R
│
├── sql/
│   ├── 01_create_hive_tables.sql
│   ├── 02_create_dimensions.sql
│   └── 03_business_question_queries.sql
│
├── docs/
│   └── project_summary.md
│
├── screenshots/
│   └── add_dashboard_screenshots_here.md
│
└── data/
    └── README.md
```

## Note on Data

Raw datasets are not included in this repository unless permitted by the dataset licence or university submission rules. The scripts expect local CSV files with names such as:

- `Prim_data_dirty.csv`
- `Sec_data_dirty.csv`
- `Tert_Data_Dirty.csv`

## Author Contribution

This repository highlights the technical implementation work for the project, including data cleaning, transformation, Hive modelling, and analytical querying.
