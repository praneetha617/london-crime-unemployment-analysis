# Project Summary

## Background

The project investigates patterns between London crime rates and unemployment-related socio-economic indicators. The analysis focuses on borough-level crime data, unemployment data, and geographic information such as GLA constituencies.

## Data Sources

### Primary Dataset
MPS Borough-level crime dataset covering crime categories across London boroughs.

### Secondary Dataset
Employment and unemployment rate dataset for London boroughs.

### Tertiary Dataset
Geographic borough reference data used to connect boroughs with GLA constituencies and related geography.

## Technical Workflow

1. Imported raw CSV datasets into R.
2. Cleaned and transformed primary crime data.
3. Standardised unemployment quarter values.
4. Cleaned geographic borough names and joined borough codes.
5. Exported cleaned datasets as CSV.
6. Created Hive external/managed tables.
7. Built dimension tables for borough, crime type, year-month, quarter, ward, parliamentary constituency, and GLA constituency.
8. Wrote Hive queries to answer five business questions.
9. Produced dashboard visualisations from the analytical outputs.

## Dashboard Evidence

Add dashboard screenshots in the `/screenshots` folder. Recommended filenames:

- `dashboard_overview.png`
- `crime_by_borough.png`
- `unemployment_crime_comparison.png`
- `quarterly_crime_patterns.png`
