-- Active: 1712538144975@@localhost@3306@world_life_expectancy
-- Life Expectancy increase OVER the last 15 years. Excluding 0s for countries without data. 
SELECT  country
       ,MIN(`Lifeexpectancy`)
       ,MAX(`Lifeexpectancy`)
       ,ROUND(MAX(`Lifeexpectancy`) - MIN(`Lifeexpectancy`),1) AS Life_Increase_Over_15_Years
FROM worldlifexpectancy
GROUP BY  `Country`
HAVING MIN(`Lifeexpectancy`) != 0 AND MAX(`Lifeexpectancy`) != 0
ORDER BY Life_Increase_Over_15_Years DESC
;

-- Average World Life Expectancy by year from 2007 - 2022. Excluding 0s for countries without data. 
SELECT  `Year`
       ,ROUND(AVG(`Lifeexpectancy`),2)
FROM worldlifexpectancy
WHERE `Lifeexpectancy` != 0
AND `Lifeexpectancy` != 0
GROUP BY  `Year`
ORDER BY  `Year` DESC
;

-- Correlation BETWEEN Life Expectancy AND GDP. Excluding 0s for countries without data. 
SELECT  `Country`
       ,ROUND(AVG(`Lifeexpectancy`),1) AS Life_Expectancy
       ,ROUND(AVG(`GDP`),1)            AS GDP
FROM worldlifexpectancy
GROUP BY  `Country`
HAVING Life_Expectancy > 0 AND GDP > 0
ORDER BY GDP DESC
;

SELECT  SUM(CASE WHEN `GDP` >= 1500 THEN 1 ELSE 0 END) High_GDP_Count
       ,ROUND(AVG(CASE WHEN `GDP` >= 1500 THEN `Lifeexpectancy` ELSE NULL END),1) High_GDP_Life_Expectancy
       ,SUM(CASE WHEN `GDP` <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count
       ,ROUND(AVG(CASE WHEN `GDP` <= 1500 THEN `Lifeexpectancy` ELSE NULL END),1) Low_GDP_Life_Expectancy
FROM worldlifexpectancy
;

-- Average Life Expectancy for Developing vs. Developed Countries 
SELECT  `Status`
       ,COUNT(DISTINCT `Country`)
       ,ROUND(AVG(`Lifeexpectancy`),1)
FROM worldlifexpectancy
GROUP BY  `Status`
;

-- Correlation BETWEEN life expectancy AND BMI. 
SELECT  `Country`
       ,ROUND(AVG(`Lifeexpectancy`),1) AS Life_Expectancy
       ,ROUND(AVG(`BMI`),1)            AS BMI
FROM worldlifexpectancy
GROUP BY  `Country`
HAVING Life_Expectancy > 0 AND BMI > 0
ORDER BY `BMI` DESC
;

-- Rolling Total of Adult Mortalities by country AND year. 
SELECT  `Country`
       ,`Year`
       ,`Lifeexpectancy`
       ,`AdultMortality`
       ,SUM(`AdultMortality`) OVER(PARTITION BY `Country` ORDER BY  `Year`) AS Rolling_Total
FROM worldlifexpectancy
;

-- Correlation BETWEEN Life Expectancy AND HIV AIDS rates. 
SELECT  `Country`
       ,ROUND(AVG(`Lifeexpectancy`),1) AS Life_Expectancy
       ,AVG(`HIVAIDS`)        AS HIV
FROM worldlifexpectancy
GROUP BY  `Country`
HAVING Life_Expectancy > 0 AND HIV > 0
ORDER BY HIV DESC
;


-- Correlation between life expectancy and measles rates.
SELECT  `Country`
       ,ROUND (AVG(`Lifeexpectancy`),1 ) AS Life_Expectancy
       ,AVG(`Measles`) AS Measles_Avg
FROM worldlifexpectancy
GROUP BY `Country`
HAVING Life_Expectancy <> 0
AND Measles_Avg <> 0
ORDER BY Measles_Avg DESC
;



