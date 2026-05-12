-- 03_business_question_queries.sql
-- Hive queries used to answer business questions

-- Business Question 1:
-- Total number of crimes per borough in each month from 2018 to 2021

CREATE TABLE bus_question1 AS
SELECT
    cr.Borough_Code,
    cr.Borough_Name,
    SUBSTR(cr.Year_Month, 1, 7) AS Year_Month,
    SUM(cr.No_of_Crimes) AS Total_Crimes
FROM
    crime_record cr
WHERE
    SUBSTR(cr.Year_Month, 1, 4) BETWEEN '2018' AND '2021'
GROUP BY
    cr.Borough_Code,
    cr.Borough_Name,
    SUBSTR(cr.Year_Month, 1, 7)
ORDER BY
    cr.Borough_Code,
    SUBSTR(cr.Year_Month, 1, 7);


-- Business Question 2:
-- Average unemployment rate among ethnic minority UK nationals across boroughs
-- with highest theft-from-person incidents from 2011 to 2021

CREATE TABLE bus_question2 AS
WITH ranked_boroughs AS (
    SELECT
        cr.Borough_Code,
        SUBSTR(cr.Year_Month, 1, 4) AS Year,
        SUM(cr.No_of_Crimes) AS Total_Theft_From_Person,
        ROW_NUMBER() OVER (
            PARTITION BY SUBSTR(cr.Year_Month, 1, 4)
            ORDER BY SUM(cr.No_of_Crimes) DESC
        ) AS row_num
    FROM
        crime_record cr
    WHERE
        cr.Crime_Type = 'Theft from Person'
        AND SUBSTR(cr.Year_Month, 1, 4) BETWEEN '2011' AND '2021'
    GROUP BY
        cr.Borough_Code,
        SUBSTR(cr.Year_Month, 1, 4)
)
SELECT
    rb.Year,
    db.Borough_Name,
    rb.Total_Theft_From_Person,
    ROUND(AVG(ud.Unemployment_rate_aged_16_ethnic_minority_UK_national), 1)
        AS Avg_Unemployment_Rate_Ethnic_Minorities
FROM
    ranked_boroughs rb
JOIN
    dim_borough db
    ON rb.Borough_Code = db.boroughId
JOIN
    unemployment_data ud
    ON db.Borough_Name = ud.Borough_Name
    AND rb.Year = ud.Year
WHERE
    rb.row_num <= 20
GROUP BY
    rb.Year,
    db.Borough_Name,
    rb.Total_Theft_From_Person
ORDER BY
    rb.Year,
    rb.Total_Theft_From_Person DESC;


-- Business Question 3:
-- GLA constituencies linked to boroughs with highest crime rates from 2019 to 2021

CREATE TABLE bus_question3 AS
WITH ranked_crime_data AS (
    SELECT
        g.Borough_Name,
        SUBSTR(cr.Year_Month, 1, 4) AS Year,
        SUM(cr.No_of_Crimes) AS Total_Crimes,
        ROW_NUMBER() OVER (
            PARTITION BY SUBSTR(cr.Year_Month, 1, 4)
            ORDER BY SUM(cr.No_of_Crimes) DESC
        ) AS row_num
    FROM
        crime_record cr
    JOIN
        dim_borough g
        ON cr.Borough_Code = g.boroughId
    WHERE
        SUBSTR(cr.Year_Month, 1, 4) BETWEEN '2019' AND '2021'
    GROUP BY
        g.Borough_Name,
        SUBSTR(cr.Year_Month, 1, 4)
)
SELECT DISTINCT
    acd.Year,
    acd.Borough_Name,
    acd.Total_Crimes,
    gd.GLA_Constituency
FROM
    ranked_crime_data acd
JOIN
    geographic_data gd
    ON acd.Borough_Name = gd.Borough_Name
WHERE
    acd.row_num <= 20
ORDER BY
    acd.Year,
    acd.Total_Crimes DESC;


-- Business Question 4:
-- Most prevalent crime types in each quarterly month from 2018 to 2020
-- with average unemployment rate among white UK nationals

CREATE TABLE bus_question4 AS
WITH quarterly_crime_counts AS (
    SELECT
        SUBSTR(cr.Year_Month, 1, 4) AS Year,
        CASE
            WHEN CEIL(CAST(SUBSTR(cr.Year_Month, 6, 2) AS INT) / 3) = 1 THEN 'Jan-Mar'
            WHEN CEIL(CAST(SUBSTR(cr.Year_Month, 6, 2) AS INT) / 3) = 2 THEN 'Apr-Jun'
            WHEN CEIL(CAST(SUBSTR(cr.Year_Month, 6, 2) AS INT) / 3) = 3 THEN 'Jul-Sep'
            WHEN CEIL(CAST(SUBSTR(cr.Year_Month, 6, 2) AS INT) / 3) = 4 THEN 'Oct-Dec'
            ELSE NULL
        END AS Quarterly_Month,
        db.Borough_Name,
        dct.Crime_Type,
        SUM(cr.No_of_Crimes) AS Crime_Count,
        ROW_NUMBER() OVER (
            PARTITION BY
                SUBSTR(cr.Year_Month, 1, 4),
                CEIL(CAST(SUBSTR(cr.Year_Month, 6, 2) AS INT) / 3),
                db.Borough_Name
            ORDER BY SUM(cr.No_of_Crimes) DESC
        ) AS rank
    FROM
        crime_record cr
    JOIN
        dim_borough db
        ON cr.Borough_Code = db.boroughId
    JOIN
        dim_crime_type dct
        ON cr.Crime_Type = dct.Crime_Type
    WHERE
        SUBSTR(cr.Year_Month, 1, 4) BETWEEN '2018' AND '2020'
    GROUP BY
        SUBSTR(cr.Year_Month, 1, 4),
        CEIL(CAST(SUBSTR(cr.Year_Month, 6, 2) AS INT) / 3),
        db.Borough_Name,
        dct.Crime_Type
),
unemployment_rates AS (
    SELECT
        ub.Borough_Name,
        dy.Year,
        CASE
            WHEN dy.Quarter_Month = 1 THEN 'Jan-Mar'
            WHEN dy.Quarter_Month = 2 THEN 'Apr-Jun'
            WHEN dy.Quarter_Month = 3 THEN 'Jul-Sep'
            WHEN dy.Quarter_Month = 4 THEN 'Oct-Dec'
            ELSE NULL
        END AS Quarterly_Month,
        AVG(ub.Unemployment_rate_aged_16_white_UK_national)
            AS Avg_Unemployment_Rate
    FROM
        dim_borough db
    JOIN
        dim_quarterly_year_month dy
        ON db.boroughId = db.boroughId
    JOIN
        unemployment_data ub
        ON db.Borough_Name = ub.Borough_Name
        AND dy.Year = ub.Year
        AND dy.Quarter_Month = ub.Quarter_Month
    WHERE
        dy.Year BETWEEN 2018 AND 2020
    GROUP BY
        ub.Borough_Name,
        dy.Year,
        dy.Quarter_Month
)
SELECT
    qcc.Year,
    qcc.Quarterly_Month,
    qcc.Borough_Name,
    qcc.Crime_Type,
    qcc.Crime_Count,
    ur.Avg_Unemployment_Rate
FROM
    quarterly_crime_counts qcc
JOIN
    unemployment_rates ur
    ON qcc.Borough_Name = ur.Borough_Name
    AND qcc.Year = ur.Year
    AND qcc.Quarterly_Month = ur.Quarterly_Month
WHERE
    qcc.rank = 1;


-- Business Question 5:
-- Highest occurring crime types in each borough from 2011 to 2021

CREATE TABLE bus_question5 AS
WITH ranked_crimes AS (
    SELECT
        SUBSTR(dym.Year_Month, 1, 4) AS Year,
        db.Borough_Name AS Borough_Name,
        dct.Crime_Type AS Crime_Type,
        SUM(cr.No_of_Crimes) AS Total_Crimes,
        ROW_NUMBER() OVER (
            PARTITION BY SUBSTR(dym.Year_Month, 1, 4), db.Borough_Name
            ORDER BY SUM(cr.No_of_Crimes) DESC
        ) AS rank
    FROM
        crime_record cr
    JOIN
        dim_borough db
        ON cr.Borough_Code = db.boroughId
    JOIN
        dim_crime_type dct
        ON cr.Crime_Type = dct.Crime_Type
    JOIN
        dim_year_month dym
        ON cr.Year_Month = dym.Year_Month
    WHERE
        SUBSTR(dym.Year_Month, 1, 4) BETWEEN '2011' AND '2021'
    GROUP BY
        SUBSTR(dym.Year_Month, 1, 4),
        db.Borough_Name,
        dct.Crime_Type
)
SELECT
    Year,
    Borough_Name,
    Crime_Type,
    Total_Crimes
FROM
    ranked_crimes
WHERE
    rank = 1
ORDER BY
    Year,
    Total_Crimes DESC;
