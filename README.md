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


