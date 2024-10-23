# US_Household_Income_And_Statistics Project

# Data Cleaning

# 1. Change the incorrect column name alter

ALTER TABLE us_household_income_statistics RENAME COLUMN `ď»żid` TO `id`;


SELECT *
FROM us_project.us_household_income;

SELECT *
FROM us_project.us_household_income_statistics;


# 2. Identyfying duplicates

SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;


SELECT *
FROM(
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM us_project.us_household_income
) duplicates
WHERE row_num > 1
;

# Delete duplicates from the table

DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM(
		SELECT row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		FROM us_project.us_household_income
		) duplicates
	WHERE row_num > 1)
;


SELECT DISTINCT State_Name
FROM us_project.us_household_income
ORDER BY 1;



# 3.Change the State Name to the prorer one

UPDATE  us_project.us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia'
;

UPDATE  us_project.us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama'
;

# 4. Fill the empty field in the City column

SELECT *
FROM us_project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1;

UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

# Clean the Type column 

SELECT Type, COUNT(Type)
FROM us_project.us_household_income
GROUP BY Type
;

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';




# US Household Income Exploratory Data Analysis


SELECT *
FROM us_project.us_household_income
;
SELECT *
FROM us_project.us_household_income_statistics
;

# Find 10 biggest States names by land and by water

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10
;

#Find the biggest avrage income by states

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 10
;

# Higher volume types for different areas

SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
HAVING COUNT(Type) > 100
ORDER BY 4 DESC
LIMIT 20
;

# Highest average income vby the city and state

SELECT u.State_Name, City, ROUND(AVG(Mean),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY ROUND(AVG(Mean),1) DESC
;
    
    
    
    
