-- 01_create_hive_tables.sql
-- Hive table creation for crime, unemployment, and geographic analysis

CREATE TABLE crime_data (
    Borough_Name STRING,
    Borough_Code STRING,
    LSOA_Code STRING,
    LSOA_Name STRING,
    Year_Month STRING,
    Arson INT,
    Criminal_Damage INT,
    Burglary_Business_and_Community INT,
    Domestic_Burglary INT,
    Drug_Trafficking INT,
    Possession_of_Drugs INT,
    Handling_Stolen_Goods INT,
    Making_Supplying_or_Possessing_Articles_for_use_i INT,
    Obscene_Publications INT,
    Other_Forgery INT,
    Other_Notifiable_Offences INT,
    Perverting_Course_of_Justice INT,
    Possession_of_False_Documents INT,
    Threat_or_Possession_With_Intent_to_Commit_Crimina INT,
    Possession_of_Article_with_Blade_or_Point INT,
    Possession_of_Firearms_Offences INT,
    Other_Offences_Against_the_State_or_Public_Order INT,
    Public_Fear_Alarm_or_Distress INT,
    Racially_or_Religiously_Aggravated_Public_Fear_Al INT,
    Robbery_of_Personal_Property INT,
    Bicycle_Theft INT,
    Other_Theft INT,
    Theft_from_Person INT,
    Interfering_with_a_Motor_Vehicle INT,
    Theft_from_a_Motor_Vehicle INT,
    Theft_or_Taking_of_a_Motor_Vehicle INT,
    Violence_with_Injury INT,
    Violence_without_Injury INT,
    Absconding_from_Lawful_Custody INT,
    Dangerous_Driving INT,
    Fraud_or_Forgery_Associated_with_Driver_Records INT,
    Going_Equipped_for_Stealing INT,
    Profitting_From_or_Concealing_Proceeds_of_Crime INT,
    Possession_of_Firearm_with_Intent INT,
    Possession_of_Other_Weapon INT,
    Violent_Disorder INT,
    Robbery_of_Business_Property INT,
    Shoplifting INT,
    Aggravated_Vehicle_Taking INT,
    Homicide INT,
    Disclosure_Obstruction_False_or_Misleading_State INT,
    Perjury INT,
    Soliciting_for_Prostitution INT,
    Exploitation_of_Prostitution INT,
    Forgery_or_Use_of_Drug_Prescription INT,
    Bail_Offences INT,
    Other_Firearm_Offences INT,
    Bigamy INT,
    Wildlife_Crime INT,
    Offender_Management_Act INT,
    Other_Knife_Offences INT,
    Concealing_an_Infant_Death_Close_to_Birth INT,
    Aiding_Suicide INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

CREATE TABLE crime_record (
    Borough_Code STRING,
    Borough_Name STRING,
    Crime_Type STRING,
    Year_Month STRING,
    No_of_Crimes INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA INPATH '/user/maria_dev/tutorials/Clean_primary_data1.csv'
OVERWRITE INTO TABLE crime_record;

CREATE TABLE unemployment_data (
    Borough_Code STRING,
    Borough_Name STRING,
    Quarter_Month INT,
    Year INT,
    Unemployment_rate_aged_16_white_UK_national FLOAT,
    Unemployment_rate_aged_16_white_not_UK_national FLOAT,
    Unemployment_rate_aged_16_ethnic_minority_UK_national FLOAT,
    Unemployment_rate_aged_16_ethnic_minority_not_UK_national FLOAT,
    Unemployment_rate_aged_16_64 FLOAT,
    Unemployment_rate_aged_16 FLOAT,
    Unemployment_rate_ethnic_minority FLOAT,
    Ethnic_minority_aged_16_64_who_are_economically_inactive FLOAT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;
