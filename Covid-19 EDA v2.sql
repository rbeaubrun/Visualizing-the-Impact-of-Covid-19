/*
The goal of this analysis is to build a global health analytics dashboard 
potentially showing the correlation between infection and vaccination rates 
components to include:
- countries with top infection
- countries with top vaccination
- vaccination/infection over time 
*/ 

--Data Exploration & Data Cleaning

--------------------------------- Table 1 Covid_Deaths ---------------------------------

--pulling the entire table
SELECT 
	*
FROM
	covid_deaths
LIMIT
	10; --409,715 rows

-- checking for rows with null continent
SELECT 
	*
FROM
	covid_deaths
WHERE
	continent IS NULL; --19,636 rows don't have a continent, will want to drop in eda 

-- checking for rows with null location 
SELECT 
	*
FROM
	covid_deaths
WHERE
	location IS NULL; -- 0 
--'Africa' is listed as a country - will want to harmonize country/continent names in analysis

--Retrieve distinct list of countries/locations
SELECT DISTINCT
	location
FROM
	covid_deaths
ORDER BY
	location ASC; --255 countries 

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

-- Filtering out the non-countries as listed above 
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

--This returns the table with all relevant filters  
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

--Exploring date column
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
	location ASC; --min: 01-05-2020, max: 06-16-2024

-- retrieving all column names
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

--storing covid_deaths table in a temp table 
CREATE TEMPORARY TABLE temp_covid_cases AS
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
	location ASC;--390,079 rows

--pulling the temp table
SELECT
	*
FROM
	temp_covid_cases; --390,079

--------------------------------- Table 2 Covid_Vaccinations ---------------------------------

--pulling covid_vaccinations table 
SELECT 
	*
FROM
	covid_vaccinations; --409,715 rows 

--pulling column names 
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

-- Below are all the columns I'd like to pull
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

-- Unique list of iso_codes
SELECT DISTINCT
	iso_code
FROM
	covid_vaccinations;

-- Unique list of continents
SELECT DISTINCT
	continent
FROM
	covid_vaccinations;-- 6 continents and there are a few nulls

-- filtering out rows with null continent
SELECT DISTINCT
	*
FROM
	covid_vaccinations
WHERE
	continent IS NULL; --19,636 to be filtered out 

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

--updated vaccinations table with filters
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
)
AND
	continent IS NOT NULL
ORDER BY 
	location ASC; --390,079 rows 

--exploring date column 
SELECT min(date)
FROM
	covid_vaccinations;
/*max date: "9/9/2023"
min date: "1/1/2020"*/ 

--converting date to date type
SELECT EXTRACT(YEAR FROM TO_DATE(date, 'MM/DD/YYYY')) AS year_extracted
FROM covid_vaccinations;

-- storing filtered vaccination data into a temp table
CREATE TEMPORARY TABLE temp_covid_vaccinations AS
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
)
AND
	continent IS NOT NULL
ORDER BY 
	location ASC; --390,079

--pulling entire temp table
SELECT
	*
FROM
	temp_covid_vaccinations; --390,079

--------------------------------Exploratory Data Analysis--------------------------------
--pulling entire covid_case data 
SELECT
	*
FROM
	temp_covid_cases; --390,079

-- key metrics by year
SELECT
	EXTRACT(YEAR FROM date) AS case_year,
	SUM(total_tests) AS total_tests,
	SUM(total_cases) AS total_cases,
	SUM(total_deaths) AS total_deaths
FROM
	temp_covid_cases
GROUP BY
	EXTRACT(YEAR FROM date)
ORDER BY
	case_year; --total_tests coming up null for 23-24 need to QC this

--filter for data in 23-24, sorted by mac 
SELECT
	total_tests
FROM
	temp_covid_cases
WHERE
	date >= '01-01-2023'
AND
	total_tests IS NOT NULL; --there is no testing data after 2023 
	
--population by location/country sorted by most populated countries to least
SELECT
	location,
	round(AVG(population)) AS avg_population
FROM
	temp_covid_cases
GROUP BY
	location
ORDER BY
	avg_population DESC; 

--complete vaccinations table 
SELECT
	*
FROM
	temp_covid_vaccinations;--390,079

--updating date column data type in temp table 
ALTER TABLE temp_covid_vaccinations
ALTER COLUMN date SET DATA TYPE DATE USING TO_DATE(date, 'MM/DD/YYYY');

-- key vaccination metrics by year 
SELECT 
	EXTRACT(YEAR FROM date) AS vacc_year,
	SUM(total_vaccinations) AS total_vaccinations,
	SUM(people_vaccinated) AS total_people_vaccinated,
	SUM(people_fully_vaccinated) AS people_fully_vaccinated,
	SUM(total_boosters) AS total_boosters
FROM
	temp_covid_vaccinations
GROUP BY
	EXTRACT(YEAR FROM date)
ORDER BY
	vacc_year;

--JOINING THE TWO TABLES
SELECT
	*
FROM
	temp_covid_vaccinations;

SELECT
	*
FROM
	temp_covid_cases;


--joining vaccinations with case data omitting duplicate columns 
WITH vaccinations AS (
    SELECT
        "iso_code",
        "continent",
        "location",
        "date",
        "positive_rate",
        "total_vaccinations",
        "people_vaccinated",
        "people_fully_vaccinated",
        "total_boosters",
        "new_vaccination"
    FROM
        temp_covid_vaccinations
)
SELECT
    vacc.iso_code,
    vacc.continent,
    vacc.location,
    vacc.date,
	cas.total_tests,
	cas.total_cases,
    cas.total_deaths,
    vacc.positive_rate,
    vacc.total_vaccinations,
    vacc.people_vaccinated,
    vacc.people_fully_vaccinated,
    vacc.total_boosters,
    vacc.new_vaccination
FROM
    vaccinations AS vacc
JOIN
    temp_covid_cases AS cas
ON
    vacc.continent = cas.continent
    AND vacc.location = cas.location
    AND vacc.date = cas.date
    AND vacc.iso_code = cas.iso_code; --390,079

--storing both tables into a temp table 
CREATE TEMPORARY TABLE global_health AS
WITH vaccinations AS (
    SELECT
        "iso_code",
        "continent",
        "location",
        "date",
        "positive_rate",
        "total_vaccinations",
        "people_vaccinated",
        "people_fully_vaccinated",
        "total_boosters",
        "new_vaccination"
    FROM
        temp_covid_vaccinations
)
SELECT
    vacc.iso_code,
    vacc.continent,
    vacc.location,
    vacc.date,
	cas.total_tests,
	cas.total_cases,
    cas.total_deaths,
    vacc.positive_rate,
    vacc.total_vaccinations,
    vacc.people_vaccinated,
    vacc.people_fully_vaccinated,
    vacc.total_boosters,
    vacc.new_vaccination
FROM
    vaccinations AS vacc
JOIN
    temp_covid_cases AS cas
ON
    vacc.continent = cas.continent
    AND vacc.location = cas.location
    AND vacc.date = cas.date
    AND vacc.iso_code = cas.iso_code; --390,079 rows 

--returning global health
SELECT
	*
FROM
	global_health;--390,079 rows 

-- summarizing key metrics by year and country 
SELECT
	EXTRACT(YEAR FROM date) AS case_year,
	continent,
	SUM(total_vaccinations) AS total_vaccinations,
	SUM(people_vaccinated) AS total_people_vaccinated,
	SUM(people_fully_vaccinated) AS people_fully_vaccinated,
	SUM(total_boosters) AS total_boosters,
	SUM(total_tests) AS total_tests,
	SUM(total_cases) AS total_cases,
	SUM(total_deaths) AS total_deaths
FROM 
	global_health
GROUP BY
	EXTRACT(YEAR FROM date),
	continent
ORDER BY
	case_year,
	continent;

-- summarizing key metrics by year
SELECT
	EXTRACT(YEAR FROM date) AS case_year,
	SUM(total_vaccinations) AS total_vaccinations,
	SUM(people_vaccinated) AS total_people_vaccinated,
	SUM(people_fully_vaccinated) AS people_fully_vaccinated,
	SUM(total_boosters) AS total_boosters,
	SUM(total_tests) AS total_tests,
	SUM(total_cases) AS total_cases,
	SUM(total_deaths) AS total_deaths
FROM 
	global_health
GROUP BY
	EXTRACT(YEAR FROM date)
ORDER BY
	case_year;

--Ranking locations by highest cases per continent in 2020
SELECT
	location AS country,
	SUM(total_cases) AS total_cases,
	RANK() OVER(ORDER BY SUM(total_cases) DESC) AS case_rank,
	SUM(total_vaccinations) AS total_vaccincations,
	RANK() OVER(ORDER BY SUM(total_vaccinations) DESC) AS vacc_rank
FROM
	global_health
WHERE
	EXTRACT(YEAR FROM date) = 2020
	AND total_cases IS NOT NULL
	AND total_vaccinations IS NOT NULL
GROUP BY
	location
ORDER BY
	case_rank ASC; --The US had the highest number of cases and administered the most vaccinations in 2020 

--rolling sum of cases and tests by month in 2020 in the US 
SELECT
	EXTRACT(MONTH FROM date) AS month,
	SUM(total_cases) AS total_cases,
	SUM(SUM(total_cases)) OVER(ORDER BY EXTRACT(MONTH FROM date)) AS rolling_cases,
	SUM(total_tests) AS total_tests,
	SUM(SUM(total_tests)) OVER(ORDER BY EXTRACT(MONTH FROM date)) AS rolling_tests
FROM
	global_health
WHERE
	EXTRACT(YEAR FROM date) = 2020
	AND location = 'United States'
GROUP BY
	EXTRACT(MONTH FROM date)
ORDER BY
	month; -- the rapidness of cases is astonoshing especially between feb and march. the release of tests was aggressive. further visualization will help identify trends 


	