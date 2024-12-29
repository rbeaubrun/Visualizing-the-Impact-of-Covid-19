/*
The goal of this analysis is to build a global health analytics dashboard 
potentially showing the correlation between infection and vaccination rates 
components to include:
- countries with top infection
- countries with top vaccination
- vaccination/infection over time 
*/ 

--Data Exploration 

--------------------------------- Table 1 Covid_Deaths ---------------------------------
SELECT 
	*
FROM
	covid_deaths
LIMIT
	10; --409,715 rows

-- This is my query to check for data  mapped to a continent and location 
SELECT 
	*
FROM
	covid_deaths
WHERE
	continent IS NOT NULL
	AND
	location IS NOT NULL; --390,079 ROWS 

/* Queries to examine null locations 
'Africa' is listed as a country - will want to harmonize country/continent names in analysis 
There are no null countries
continue to keep WHERE continent IS NOT NULL throughout queries */

SELECT 
	*
FROM
	covid_deaths
WHERE
	continent IS NULL; --19,636 rows don't have a continent 

SELECT 
	*
FROM
	covid_deaths
WHERE
	location IS NULL;

--Retrieve distince list of countries/locations

SELECT DISTINCT
	location
FROM
	covid_deaths
ORDER BY
	location ASC; --255

/* these locations should be omitted because they are not true countries and will skew analysis
for e.g., if i take max, min, averag pop
"Low income",
"Lower middle income",
"Europe",
"Africa",
"North America",
"Oceania",
"Upper middle income",
"World"*/

-- This query return sthe true list of locations
SELECT DISTINCT
	location
FROM
	covid_deaths
WHERE 
	location NOT IN 
	('Low income',
	'Lower middle income',
	'Europe',
	'Africa',
	'North America',
	'Oceania',
	'Upper middle income',
	'World')
ORDER BY
	location ASC; --247 rows

/* This returns the table with all relevant filters */ 
SELECT
	*
FROM
	covid_deaths
WHERE 
	location NOT IN 
	('Low income',
	'Lower middle income',
	'Europe',
	'Africa',
	'North America',
	'Oceania',
	'Upper middle income',
	'World')
AND
	continent IS NOT NULL
ORDER BY 
	location ASC; --390,079 ROWS 

/*Exploring date column 
min: 01-05-2020
max: 06-16-2024*/ 
SELECT
	location,
	max(date)
FROM
	covid_deaths
WHERE 
	location NOT IN 
	('Low income',
	'Lower middle income',
	'Europe',
	'Africa',
	'North America',
	'Oceania',
	'Upper middle income',
	'World')
AND
	continent IS NOT NULL
GROUP BY
	location
ORDER BY 
	location ASC;

-- narrowing down the columns relevant for this analysis

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'covid_deaths';

-- List of columns 
/*
	"iso_code",
	"continent",
	"location",
	"date",
	"population",
	"total_tests",
	"total_cases",
	"new_cases",
	"total_deaths",
	"new_deaths",
	"total_cases_per_million",
	"new_cases_per_million",
	"total_deaths_per_million",
	"new_deaths_per_million"
*/

SELECT
	"iso_code",
	"continent",
	"location",
	"date",
	"population",
	"total_tests",
	"total_cases",
	"new_cases",
	"total_deaths",
	"new_deaths",
	"total_cases_per_million",
	"new_cases_per_million",
	"total_deaths_per_million",
	"new_deaths_per_million"
FROM
	covid_deaths
WHERE 
	location NOT IN 
	('Low income',
	'Lower middle income',
	'Europe',
	'Africa',
	'North America',
	'Oceania',
	'Upper middle income',
	'World')
AND
	continent IS NOT NULL
ORDER BY 
	location ASC; --390,079 rows i shopuld store this data into a temp table 

--------------------------------- Table 2 Covid_Vaccinations ---------------------------------
SELECT 
	*
FROM
	covid_vaccinations
LIMIT
	10;

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'covid_vaccinations';

--List of covid vaccination columns
/*
"life_expectancy"
"human_development_index"
"tests_per_case"
"age_70_older"
"gdp_per_capita"
"new_people_vaccinated_smoothed_per_hundred"
"population_density"
"median_age"
"aged_65_older"
"extreme_poverty"
"cardiovasc_death_rate"
"diabetes_prevalence"
"female_smokers"
"male_smokers"
"tests_units"
*/	

--Below are all the columns I'd like to pull
SELECT
	"iso_code",
	"continent",
	"location",
	"date",
	"total_tests",
	"new_tests",
	"positive_rate",
	"total_vaccinations",
	"people_vaccinated",
	"people_fully_vaccinated",
	"total_boosters",
	"new_vaccination"
FROM
	covid_vaccinations; --409,715 ROWS

--Exploring iso codes
SELECT DISTINCT
	iso_code
FROM
	covid_vaccinations;

--Exploring the continents
SELECT DISTINCT
	continent
FROM
	covid_vaccinations;-- there are a few nulls

--exploring continents 
SELECT DISTINCT
	continent
FROM
	covid_vaccinations;

-- this will code for rows where continent is null
SELECT DISTINCT
	location
FROM
	covid_vaccinations
WHERE
	continent IS NULL; --i should filter out the below when running code on this table

--to filter out of location
/*
"High income"
"Low income"
"Lower middle income"
"Upper middle income"
"World" */ 

--updated vaccinations table with filter
SELECT
	"iso_code",
	"continent",
	"location",
	"date",
	"total_tests",
	"new_tests",
	"positive_rate",
	"total_vaccinations",
	"people_vaccinated",
	"people_fully_vaccinated",
	"total_boosters",
	"new_vaccination"
FROM
	covid_vaccinations
WHERE location NOT IN (
'High income',
'Low income',
'Lower middle income',
'Upper middle income',
'World'
);

--exploring date column 
SELECT min(date)
FROM
	covid_vaccinations;
/*max date: "9/9/2023"
min date: "1/1/2020"*/ 

--converting date to date type
SELECT EXTRACT(YEAR FROM TO_DATE(date, 'MM/DD/YYYY')) AS year_extracted
FROM covid_vaccinations;


--exploring tests data
--this query shows total tests by county by year
SELECT
	EXTRACT(YEAR FROM TO_DATE(date, 'MM/DD/YYYY')) AS year_extracted,
	location,
	sum(total_tests) AS total_tests
FROM
	covid_vaccinations
WHERE location NOT IN (
	'High income',
	'Low income',
	'Lower middle income',
	'Upper middle income')
GROUP BY
	location,
	EXTRACT(YEAR FROM TO_DATE(date, 'MM/DD/YYYY'))
ORDER BY
	year_extracted,
	total_tests; 

/* leaving off here but a few notes:
- date is varchar here should be date 
- i believe in covid deaths the blanks are 0 here they are null 

Next Steps:
- explore this table
- exploratory analysis on table 1 */ 



--Exploratory Data Analysis 







--Data Cleaning */







-- Data Analysis 