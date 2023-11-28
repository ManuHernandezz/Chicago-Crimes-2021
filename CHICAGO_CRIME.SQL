--How many total crimes were reported in 2021?
SELECT COUNT (*)
FROM chicago_crimes_2021

--What is the count of Homicides, Battery and Assaults reported?
SELECT crime_type, COUNT(crime_type) AS Crime_Count
FROM chicago_crimes_2021
WHERE crime_type IN ('homicide', 'battery', 'assault')
GROUP BY crime_type
ORDER BY Crime_Count DESC

--Create a  table that joins data from all three tables
DROP TABLE If EXISTS chicago_crime;
CREATE TABLE chicago_crime AS
	SELECT
	cr.extracted_date AS crime_date,
	cr.crime_type,
	cr.crime_description,
	cr.crime_location,
	cr.city_block AS street_name,
	ca.name AS community_name,
	ca.population,
	ca.area_sq_mi,
	ca.density,
	cr.arrest,
	cr.domestic,
	--ct.temp_high,
	--ct.temp_low,
	--ct.precipitation,
	cr.latitude,
	cr.longitude
FROM chicago_crimes_2021 AS cr
JOIN chicago_areas AS ca
ON cr.community_id = ca.community_area_id
JOIN chicago_temps_2021 AS ct
ON cr.crime_date = ct.date

--What are the top ten communities that had the most crimes reported?
--We will also add the current population to see if area density is also a factor.
SELECT community_name AS 'community', population, density, COUNT (*) AS 'reported_crimes'
FROM chicago_crime
GROUP BY community_name, population, density
ORDER BY reported_crimes DESC
LIMIT 10

--What are the top ten communities that had the least amount of crimes reported?
--We will also add the current population to see if area density is also a factor
SELECT community_name AS 'community', population, density, COUNT(*) AS 'reported_crimes'
FROM chicago_crime
GROUP BY community_name, population, density
ORDER BY reported_crimes ASC
LIMIT 10

--What month had the most crimes reported?
--Primero creo una colummna nueva en mi tabla donde luego extraigo los meses segun el numero de meses
ALTER TABLE chicago_crime ADD COLUMN month_name TEXT;

UPDATE chicago_crime
SET month_name = CASE
                    WHEN SUBSTR(crime_date, 1, 2) = '1/' THEN 'January'
                    WHEN SUBSTR(crime_date, 1, 2) = '2/' THEN 'February'
                    WHEN SUBSTR(crime_date, 1, 2) = '3/' THEN 'March'
                    WHEN SUBSTR(crime_date, 1, 2) = '4/' THEN 'April'
                    WHEN SUBSTR(crime_date, 1, 2) = '5/' THEN 'May'
                    WHEN SUBSTR(crime_date, 1, 2) = '6/' THEN 'June'
                    WHEN SUBSTR(crime_date, 1, 2) = '7/' THEN 'July'
                    WHEN SUBSTR(crime_date, 1, 2) = '8/' THEN 'August'
                    WHEN SUBSTR(crime_date, 1, 2) = '9/' THEN 'September'
                    WHEN SUBSTR(crime_date, 1, 2) = '10' THEN 'October'
                    WHEN SUBSTR(crime_date, 1, 2) = '11' THEN 'November'
                    WHEN SUBSTR(crime_date, 1, 2) = '12' THEN 'December'
                    ELSE 'Unknown'
                  END;


SELECT month_name, COUNT(month_name) AS Crimes_by_month
FROM chicago_crime
GROUP BY month_name
ORDER BY Crimes_by_month DESC

--Agrego una columna donde diga el mes en la tabla de temps
ALTER TABLE chicago_temps_2021 ADD COLUMN month_name TEXT;

UPDATE chicago_temps_2021
SET month_name = CASE
                    WHEN SUBSTR(crime_date, 1, 2) = '1/' THEN 'January'
                    WHEN SUBSTR(crime_date, 1, 2) = '2/' THEN 'February'
                    WHEN SUBSTR(crime_date, 1, 2) = '3/' THEN 'March'
                    WHEN SUBSTR(crime_date, 1, 2) = '4/' THEN 'April'
                    WHEN SUBSTR(crime_date, 1, 2) = '5/' THEN 'May'
                    WHEN SUBSTR(crime_date, 1, 2) = '6/' THEN 'June'
                    WHEN SUBSTR(crime_date, 1, 2) = '7/' THEN 'July'
                    WHEN SUBSTR(crime_date, 1, 2) = '8/' THEN 'August'
                    WHEN SUBSTR(crime_date, 1, 2) = '9/' THEN 'September'
                    WHEN SUBSTR(crime_date, 1, 2) = '10' THEN 'October'
                    WHEN SUBSTR(crime_date, 1, 2) = '11' THEN 'November'
                    WHEN SUBSTR(crime_date, 1, 2) = '12' THEN 'December'
                    ELSE 'Unknown'
                  END;
				  
--What month had the most homicides and what was the average temperature?
--luego de intentarlo bastante, decidi hacer dos subconsultas y unirlas todas en una sola
SELECT a.month_name,
       a.homicide_count,
       b.avg_high_temp
FROM (
    SELECT month_name, 
           COUNT(crime_type) AS homicide_count
    FROM chicago_crime
    WHERE crime_type = 'homicide'
    GROUP BY month_name
) AS a
JOIN (
    SELECT cr.month_name, 
           ROUND(AVG(t.temp_high)) AS avg_high_temp
    FROM chicago_crime AS cr
    JOIN chicago_temps_2021 AS t
    ON cr.month_name = t.month_name
    WHERE cr.crime_type = 'homicide'
    GROUP BY cr.month_name
) AS b
ON a.month_name = b.month_name
ORDER BY homicide_count DESC;			  

--What are the top ten city streets that have had the most reported crimes?
SELECT street_name, COUNT(*) AS count_crimes
FROM chicago_crime
GROUP BY street_name
ORDER BY count_crimes DESC
LIMIT 10

--What are the top ten city streets that have had the most homicides including ties?
SELECT street_name, COUNT(crime_type) AS count_crimes
FROM chicago_crime
where crime_type = 'homicide'
GROUP BY street_name
ORDER BY count_crimes DESC
LIMIT 10

--What are the top ten city streets that have had the most burglaries?
SELECT street_name, COUNT(crime_type) AS count_crimes
FROM chicago_crime
WHERE crime_type = 'burglary'
GROUP BY street_name
ORDER BY count_crimes DESC
LIMIT 10

--What is the number and types of reported crimes on Michigan Ave (The Rodeo Drive of the Midwest)?
SELECT crime_type, COUNT (*) AS crime_count
FROM chicago_crime
WHERE street_name LIKE '%michigan ave%'
GROUP BY crime_type
ORDER BY crime_count DESC

--What are the top 5 least reported crime, how many arrests were made?
SELECT crime_type, COUNT(*) AS crime_count, 
	SUM (CASE WHEN arrest =  'TRUE' THEN 1
	ELSE 0
	END) AS 'Arrest_count'
	ROUND(100 * (arre
FROM chicago_crime
GROUP BY crime_type
ORDER BY crime_count ASC
LIMIT 5
