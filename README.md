
<img src="https://github.com/ManuHernandezz/Chicago-Crimes-2021/assets/130862652/c8810714-a638-4de3-a859-9a5ee0bde115" width="150" height="150">

# Chicago-Crimes-2021
This SQL project analyzes Chicago's 2021 crime data, covering total crimes, specific types like homicides, community-level trends, and 
correlations with weather. It also examines street-specific crime patterns, offering detailed insights into city-wide safety dynamics.

## 1) How many total crimes were reported in 2021?
    SELECT COUNT (*)
    FROM chicago_crimes_2021

    
 | COUNT      | 
 | :---       | 
 |   202536   | 

## 2) What is the count of Homicides, Battery and Assaults reported?
    SELECT crime_type, COUNT(crime_type) AS Crime_Count
    FROM chicago_crimes_2021
    WHERE crime_type IN ('homicide', 'battery', 'assault')
    GROUP BY crime_type
    ORDER BY Crime_Count DESC


| crime_type      | Crime_Count | 
| :---        |    :----:   |
| battery      | 39988       |
| assault   | 20086        |
|  homicide           |    803         |


## 3) Create a  table that joins data from all three tables

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


## 4) What are the top ten communities that had the most crimes reported? We will also add the current population to see if area density is also a factor.
    SELECT community_name AS 'community', population, density, COUNT (*) AS 'reported_crimes'
    FROM chicago_crime
    GROUP BY community_name, population, density
    ORDER BY reported_crimes DESC
    LIMIT 10

|community	|population	|density	|reported_crimes|
| :---        |    :----:   |    :----:   |    :----:   |
|austin|96557	|13504.48 |11341|
|near north side	|105481	|38496.72|8126|
|south shore	|53971	|18420.14|7272|
|near west side	|67881	|11929.88|6743|
|north lawndale	|34794	|10839.25|6161|
|auburn gresham	|44878	|11903.98|5873|
|humboldt park	|54165	|15045.83|	5767|
|greater grand crossing	|31471|8865.07|	5545|
|west town	|87781	|19166.16|5486|
|loop|	42298	|25635.15|5446|

## 5) What are the top ten communities that had the least amount of crimes reported? We will also add the current population to see if area density is also a factor
	SELECT community_name AS 'community', population, density, COUNT(*) AS 'reported_crimes'
	FROM chicago_crime
	GROUP BY community_name, population, density
	ORDER BY reported_crimes ASC
	LIMIT 10

 |community	|population	|density	|reported_crimes|
 | :---        |    :----:   |    :----:   |    :----:   |
|edison park	|11525	|10199.12	|238|
|burnside	|2527	|4142.62	|321|
|forest glen	|19596	|6123.75	|460|
|mount greenwood	|18628	|6873.8	|492|
|montclare	|14401	|14546.46	|508|
|fuller park	|2567	|3615.49	|541|
|oakland	|6799	|11722.41	|581|
|hegewisch|	10027	|1913.55	|598|
|archer heights|	14196|	7062.69	|653|
|north park|	17559	|6967.86|	679|


## 6)What month had the most crimes reported?
	ALTER TABLE chicago_crime ADD COLUMN month_name TEXT; --First, I create a new column

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

 |month_name	|Crimes_by_month|
 | :---        |    :----:   | 
|October	|19018|
|September	|18987|
|July	|18966|
|June	|18566|
|August	|18255|
|May	|17539|
|November|	16974|
|January|	16038|
|March	|15742|
|April	|15305|
|December|	14258|
|February	|12888|

## 7) I add a column that indicates the month in the temps table
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
## 8) What month had the most homicides and what was the average temperature? (I decided to make two subqueries and join them all into one)

 
|month_name	|homicide_count	|avg_high_temp|
| :---        |    :----:   | :----:   | 
|July	|112	|82.0|
|September	|89	|80.0|
|June	|85	|84.0|
|August	|81	|86.0|
|May	|66	|70.0|
|October	|64	|67.0|
|November	|62	|49.0|
|January	|55	|34.0|
|April	|54	|61.0|
|December	|52	|46.0|
|March	|45	|53.0|
|February	|38	|27.0|

## 9)What are the top ten city streets that have had the most reported crimes?
	SELECT street_name, COUNT(*) AS count_crimes
	FROM chicago_crime
	GROUP BY street_name
	ORDER BY count_crimes DESC
	LIMIT 10
|street_name	|count_crimes|
| :---        |    :----:   | 
|michigan ave	|3257|
|state st	|2858|
|halsted st	|2329|
|ashland ave	|2276|
|clark st	|2036|
|western ave	|1987|
|dr martin luther king jr dr	|1814|
|pulaski rd	|1686|
|kedzie ave	|1606|
|madison st	|1584|

## 10) What are the top ten city streets that have had the most homicides including ties?
	SELECT street_name, COUNT(crime_type) AS count_crimes
	FROM chicago_crime
	where crime_type = 'homicide'
	GROUP BY street_name
	ORDER BY count_crimes DESC
	LIMIT 10

|street_name	|count_crimes|
| :---        |    :----:   | 
|madison st	|14|
|79th st	|14|
|morgan st	|10|
|71st st	|10|
|michigan ave	|9|
|cottage grove ave|	9|
|van buren st|	8|
|state st	|7|
|pulaski rd	|7|
|polk st	|7|




