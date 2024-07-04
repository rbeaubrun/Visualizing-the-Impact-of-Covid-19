SELECT * FROM 
covid_deaths
WHERE continent IS NOT NULL
ORDER BY iso_code, continent

SELECT * FROM
covid_vaccinations

SELECT location,date,total_cases,new_cases, total_deaths, population
FROM covid_deaths
ORDER BY location, date

-- Total Cases vs Total Deaths 
	
-- Shows the likelihood of dying if you contract COVID in your country
SELECT location,covid_deaths.date,total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM covid_deaths
WHERE location = 'Haiti'
ORDER BY location, covid_deaths.date

-- Total Cases vs. Population
-- Shows what percentage of population got Covid 
SELECT location,covid_deaths.date, population, total_cases,(total_cases/population)*100 
	AS PercentPopulationInfected
FROM covid_deaths
--WHERE location = 'Haiti'
ORDER BY location, covid_deaths.date

-- Countries with Highest Infection Rate compared to Population

SELECT location, population, max(total_cases) AS HighestInfectionCount,
	max(total_cases/population)*100 AS 
	PercentPopulationInfected
FROM covid_deaths
--WHERE location = 'Haiti'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

--File Restore and Backup
	
REINDEX TABLE covid_deaths

CREATE DATABASE mynewdatabase;
psql -U 
	
	postgres -d mynewdatabase -f /path/to/backup_file.sql


-- Showing Countries with Highest Death Count per Population

--View by Country
	
SELECT location, 
max(total_deaths) AS TotalDeathCount
FROM covid_deaths
--WHERE location = 'Haiti'
WHERE continent IS NOT NULL
GROUP BY location
HAVING max(total_deaths) > 0
ORDER BY TotalDeathCount DESC

-- Continents with Highest Death Count

-- View by Continent

SELECT continent, 
	max(total_deaths) AS TotalDeathCount
FROM covid_deaths
--WHERE location = 'Haiti'
WHERE continent IS NOT NULL
GROUP BY continent
HAVING max(total_deaths) > 0
ORDER BY TotalDeathCount DESC

-- Global Numbers

SELECT 
    covid_deaths.date,
	SUM(total_cases) AS total_cases,
    SUM(new_cases) AS total_new_cases, 
    SUM(total_deaths) AS total_deaths, 
    (SUM(total_deaths)/SUM(total_cases))*100 AS DeathPercentage
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY 
    covid_deaths.date 
HAVING sum(new_cases) > 0
ORDER BY 
    covid_deaths.date

--Global Cases and Death Totals
	
SELECT 
	SUM(total_cases) AS total_cases,
    SUM(new_cases) AS total_new_cases, 
    SUM(total_deaths) AS total_deaths, 
    (SUM(total_deaths)/SUM(total_cases))*100 AS DeathPercentage
FROM covid_deaths
WHERE continent IS NOT NULL
--GROUP BY covid_deaths.date 
HAVING sum(new_cases) > 0

--Join

--Trouble shooting - fields not populating in child table, so I created a copy
	
ALTER TABLE covid_vaccinations2
ALTER COLUMN date TYPE DATE USING date::DATE

CREATE TABLE new_covid_vaccinations AS
SELECT * FROM covid_vaccinations;

SELECT * FROM new_covid_vaccinations

ALTER TABLE new_covid_vaccinations
ALTER COLUMN date TYPE DATE USING date::DATE

-- Troubleshooting Complete 

-- Total Populations vs Vaccinations
	
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location 
	ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM covid_deaths AS dea
JOIN new_covid_vaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND vac.new_vaccinations > 0 
ORDER BY dea.location, dea.date

--CTE

WITH PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location 
	ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM covid_deaths AS dea
JOIN new_covid_vaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND vac.new_vaccinations > 0 
--ORDER BY dea.location, dea.date
)
SELECT *,(RollingPeopleVaccinated/population)*100 As RollingVaccinationsvsPopulation
FROM PopvsVac

--Temp Table 

DROP TABLE IF EXSTS PercentPopulationVaccinated
CREATE TABLE PercentPopulationVaccinated
( 
Continent varchar(255),
Location varchar (255),
Date date,
Population numeric, 
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)	
INSERT INTO	PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location 
	ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM covid_deaths AS dea
JOIN new_covid_vaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND vac.new_vaccinations > 0
ORDER BY dea.location, dea.date

SELECT *,(RollingPeopleVaccinated/population)*100 As RollingVaccinationsvsPopulation
FROM PercentPopulationVaccinated

-- Creating View to Store Data for Later Visualizations

CREATE VIEW PercentPopulationVaccinated1 AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location 
	ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM covid_deaths AS dea
JOIN new_covid_vaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND vac.new_vaccinations > 0
--ORDER BY dea.location, dea.date

SELECT *
FROM PercentPopulationVaccinated1;


--Exploration End 