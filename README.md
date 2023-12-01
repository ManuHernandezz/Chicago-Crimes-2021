
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
| :---        |    :----:   |
|austin|	|96557	|13504.48|11341|
|near north side	|105481	|38496.72|8126|
|south shore	|53971	|18420.14|7272|
|near west side	|67881	|11929.88|6743|
|north lawndale	|34794	|10839.25|6161|
|auburn gresham	|44878	|11903.98|5873|
|humboldt park	|54165	|15045.83|	|5767|
|greater grand crossing	|31471|8865.07|	|5545|
|west town	|87781	|19166.16|5486|
|loop|	42298	|25635.15|5446|






