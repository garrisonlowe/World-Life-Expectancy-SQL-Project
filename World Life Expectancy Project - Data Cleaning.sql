-- Active: 1712538144975@@localhost@3306@world_life_expectancy


-- Checking for duplicates using country name and year.
SELECT  country
       ,year
       ,CONCAT(country,year)
       ,COUNT(CONCAT(country,year)) AS duplicateCount
FROM worldlifexpectancy
GROUP BY  country
         ,year
         ,CONCAT(country,year)
HAVING duplicateCount > 1
;


-- Getting the row ID's for the duplicate rows.
SELECT  *
FROM
(
	SELECT  row_id
	       ,CONCAT(country,year)
	       ,ROW_NUMBER() OVER(PARTITION BY CONCAT(country,year) ORDER BY  CONCAT(country,year)) AS row_num
	FROM worldlifexpectancy
) AS row_table
WHERE row_num > 1
;




-- Deleting duplicates from the table.
DELETE FROM worldlifexpectancy
WHERE Row_ID IN 
( 
    SELECT Row_ID 
    FROM ( SELECT row_id, 
           CONCAT(country, year), 
           ROW_NUMBER() OVER(PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) AS row_num 
           FROM worldlifexpectancy  
        ) AS row_table 
    WHERE row_num > 1 
)
;

-- Standardizing data for blank values.
SELECT *
FROM worldlifexpectancy
WHERE Status = '';


-- Checking status values to make sure there is only 2 options.
SELECT DISTINCT Status
FROM worldlifexpectancy
WHERE Status <> '';

-- Finding all developing countries.
SELECT DISTINCT Country
FROM worldlifexpectancy
WHERE Status = 'Developing';


-- Updating table to set status to 'Developing' for all devloping countries that are missing status data
UPDATE worldlifexpectancy
SET Status = 'Developing' 
WHERE Country IN (
    SELECT DISTINCT(Country) 
    FROM worldlifexpectancy 
    WHERE Status = 'Developing'
);

-- Self-Join because I couldnt use the table name in the FROM clause twice.
UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
ON t1.Country = t2.Country
SET t1.Status = "Developing"
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

-- Checking for developed countries
SELECT DISTINCT Country
FROM worldlifexpectancy
WHERE Status = 'Developed';

-- Setting blank Status' for developed countries just as I did for Devloping
UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
ON t1.Country = t2.Country
SET t1.Status = "Developed"
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

-- Checking for NULL values
SELECT *
FROM worldlifexpectancy
WHERE `Status` = NULL;


-- Cleaning begins for next column: Life Expectancy
SELECT  `Country`
       ,`Year`
       ,`Lifeexpectancy`
FROM worldlifexpectancy
WHERE `Lifeexpectancy` = '';


-- Thought Process; to fill in the blanks for this column, we're going to take an average of the next year and the previous year.
-- Self Join to offset the years by -1 and +1 and find the average, rounded to 1 decimal.
SELECT  t1.`Country`
       ,t1.`Year`
       ,t1.`Lifeexpectancy`
       ,t2.`Country`
       ,t2.`Year`
       ,t2.`Lifeexpectancy`
       ,t3.`Country`
       ,t3.`Year`
       ,t3.`Lifeexpectancy`
       ,ROUND((t2.`Lifeexpectancy` + t3.`Lifeexpectancy`)/2, 1) AS blank_avg
FROM worldlifexpectancy t1
JOIN worldlifexpectancy t2
ON t1.`Country` = t2.`Country` AND t1.`Year` = t2.`Year`-1
JOIN worldlifexpectancy t3
ON t1.`Country` = t3.`Country` AND t1.`Year` = t3.`Year`+1
WHERE t1.`Lifeexpectancy` = ''
;

-- Updating table with new calculation to fill in missing data.
UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
ON t1.`Country` = t2.`Country` AND t1.`Year` = t2.`Year`-1
JOIN worldlifexpectancy t3
ON t1.`Country` = t3.`Country` AND t1.`Year` = t3.`Year`+1
SET t1.`Lifeexpectancy` = ROUND((t2.`Lifeexpectancy` + t3.`Lifeexpectancy`)/2, 1)
WHERE t1.`Lifeexpectancy` = ''
;









