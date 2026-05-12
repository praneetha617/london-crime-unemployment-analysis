-- 02_create_dimensions.sql
-- Dimension tables for analytical warehouse model

-- Borough dimension
CREATE TABLE dim_borough (
    boroughId STRING,
    Borough_Name STRING
);

INSERT INTO dim_borough
SELECT DISTINCT Borough_Code, Borough_Name
FROM crime_record;

-- Crime type dimension
CREATE TABLE dim_crime_type (
    crimeId INT,
    Crime_Type STRING
);

INSERT INTO dim_crime_type
SELECT
    ROW_NUMBER() OVER () AS crimeId,
    Crime_Type
FROM (
    SELECT DISTINCT Crime_Type
    FROM crime_record
) subquery;

-- Year-month dimension
CREATE TABLE dim_year_month (
    yearMonthId INT,
    Year_Month STRING
);

INSERT INTO dim_year_month (yearMonthId, Year_Month)
SELECT
    ROW_NUMBER() OVER () AS yearMonthId,
    Year_Month
FROM (
    SELECT DISTINCT Year_Month
    FROM crime_record
) subquery;

-- Quarterly year-month dimension
CREATE TABLE dim_quarterly_year_month (
    QuarterlyYearMonthId INT,
    Quarter_Month INT,
    Year INT
);

INSERT INTO dim_quarterly_year_month (
    QuarterlyYearMonthId,
    Quarter_Month,
    Year
)
SELECT
    ROW_NUMBER() OVER () AS QuarterlyYearMonthId,
    Quarter_Month,
    Year
FROM (
    SELECT DISTINCT Quarter_Month, Year
    FROM unemployment_data
) subquery;

-- Ward dimension
CREATE TABLE dim_ward (
    wardId STRING,
    ward_Name STRING
);

INSERT INTO dim_ward
SELECT DISTINCT Ward_Code, Ward_Name
FROM geographic_data;

-- Parliamentary constituency dimension
CREATE TABLE dim_parliamentary (
    parliamentaryId INT,
    Parliamentary_Constituency_Name STRING
);

INSERT INTO dim_parliamentary
SELECT
    ROW_NUMBER() OVER () AS parliamentaryId,
    Parliamentary_Constituency_Name
FROM (
    SELECT DISTINCT Parliamentary_Constituency_Name
    FROM geographic_data
) subquery;

-- GLA constituency dimension
CREATE TABLE dim_glaConstituency (
    glaId INT,
    GLA_Constituency STRING
);

INSERT INTO dim_glaConstituency
SELECT
    ROW_NUMBER() OVER () AS glaId,
    GLA_Constituency
FROM (
    SELECT DISTINCT GLA_Constituency
    FROM geographic_data
) subquery;
