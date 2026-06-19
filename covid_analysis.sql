-- =============================================
-- PROJECT: COVID-19 Data Exploration
-- AUTHOR: Edibo
-- TOOLS: SQLite / DB Fiddle
-- TOPICS: JOINs, Aggregation, Window Functions,
--         CTEs, Temp Tables
-- =============================================


-- =============================================
-- SECTION 1: CREATE TABLES
-- =============================================

CREATE TABLE covid_deaths (
    iso_code VARCHAR(10),
    continent VARCHAR(30),
    location VARCHAR(50),
    date DATE,
    population BIGINT,
    total_cases INT,
    new_cases INT,
    total_deaths INT,
    new_deaths INT
);

CREATE TABLE covid_vaccinations (
    iso_code VARCHAR(10),
    location VARCHAR(50),
    date DATE,
    new_vaccinations INT,
    total_vaccinations INT
);


-- =============================================
-- SECTION 2: INSERT DATA
-- =============================================

INSERT INTO covid_deaths VALUES
('NGA', 'Africa', 'Nigeria', '2021-01-01', 206139589, 91440, 235, 1300, 5),
('NGA', 'Africa', 'Nigeria', '2021-01-02', 206139589, 91900, 460, 1310, 10),
('NGA', 'Africa', 'Nigeria', '2021-01-03', 206139589, 92500, 600, 1325, 15),
('USA', 'North America', 'United States', '2021-01-01', 331002651, 20500000, 180000, 350000, 2200),
('USA', 'North America', 'United States', '2021-01-02', 331002651, 20700000, 200000, 352500, 2500),
('USA', 'North America', 'United States', '2021-01-03', 331002651, 20950000, 250000, 355000, 2500),
('IND', 'Asia', 'India', '2021-01-01', 1380004385, 10300000, 20000, 149000, 200),
('IND', 'Asia', 'India', '2021-01-02', 1380004385, 10320000, 20000, 149200, 200),
('IND', 'Asia', 'India', '2021-01-03', 1380004385, 10340000, 20000, 149400, 200),
('GBR', 'Europe', 'United Kingdom', '2021-01-01', 67886011, 2500000, 55000, 75000, 800),
('GBR', 'Europe', 'United Kingdom', '2021-01-02', 67886011, 2550000, 50000, 75800, 800),
('GBR', 'Europe', 'United Kingdom', '2021-01-03', 67886011, 2600000, 50000, 76600, 800),
('ZAF', 'Africa', 'South Africa', '2021-01-01', 59308690, 1057161, 11500, 28469, 350),
('ZAF', 'Africa', 'South Africa', '2021-01-02', 59308690, 1073887, 16726, 28799, 330),
('ZAF', 'Africa', 'South Africa', '2021-01-03', 59308690, 1100748, 26861, 29286, 487);

INSERT INTO covid_vaccinations VALUES
('NGA', 'Nigeria', '2021-01-01', 0, 0),
('NGA', 'Nigeria', '2021-01-02', 0, 0),
('NGA', 'Nigeria', '2021-01-03', 0, 0),
('USA', 'United States', '2021-01-01', 500000, 4500000),
('USA', 'United States', '2021-01-02', 600000, 5100000),
('USA', 'United States', '2021-01-03', 700000, 5800000),
('IND', 'India', '2021-01-01', 0, 0),
('IND', 'India', '2021-01-02', 0, 0),
('IND', 'India', '2021-01-03', 0, 0),
('GBR', 'United Kingdom', '2021-01-01', 200000, 1400000),
('GBR', 'United Kingdom', '2021-01-02', 250000, 1650000),
('GBR', 'United Kingdom', '2021-01-03', 300000, 1950000),
('ZAF', 'South Africa', '2021-01-01', 0, 0),
('ZAF', 'South Africa', '2021-01-02', 0, 0),
('ZAF', 'South Africa', '2021-01-03', 0, 0);


-- =============================================
-- SECTION 3: BASIC EXPLORATION
-- =============================================

-- Q1: Death percentage in Nigeria
SELECT location, date, total_cases, total_deaths,
       (total_deaths * 1.0 / total_cases) * 100 AS death_percentage
FROM covid_deaths
WHERE location = 'Nigeria';

-- Q2: Percentage of population infected per country
SELECT location, date, total_cases, population,
       (total_cases * 1.0 / population) * 100 AS percentage_population_infected
FROM covid_deaths
ORDER BY percentage_population_infected DESC;


-- =============================================
-- SECTION 4: AGGREGATION
-- =============================================

-- Q3: Highest total cases and deaths per country
SELECT location,
       MAX(total_cases) AS max_cases,
       MAX(total_deaths) AS max_deaths
FROM covid_deaths
GROUP BY location;

-- Q4: Total death count per continent
SELECT continent,
       MAX(total_deaths) AS max_deaths
FROM covid_deaths
GROUP BY continent;


-- =============================================
-- SECTION 5: WINDOW FUNCTIONS
-- =============================================

-- Q5: Rolling total of vaccinations per country by date
SELECT covid_deaths.location,
       covid_deaths.date,
       covid_deaths.population,
       covid_vaccinations.new_vaccinations,
       SUM(covid_vaccinations.new_vaccinations) OVER
           (PARTITION BY covid_deaths.location
            ORDER BY covid_deaths.date) AS rolling_vaccinations
FROM covid_deaths
JOIN covid_vaccinations
    ON covid_deaths.iso_code = covid_vaccinations.iso_code
    AND covid_deaths.date = covid_vaccinations.date;


-- =============================================
-- SECTION 6: CTE
-- =============================================

-- Q6: Percentage of population vaccinated using CTE
WITH population_vaccinated AS (
    SELECT covid_deaths.location,
           covid_deaths.date,
           covid_deaths.population,
           covid_vaccinations.new_vaccinations,
           SUM(covid_vaccinations.new_vaccinations) OVER
               (PARTITION BY covid_deaths.location
                ORDER BY covid_deaths.date) AS running_vaccinations
    FROM covid_deaths
    JOIN covid_vaccinations
        ON covid_deaths.iso_code = covid_vaccinations.iso_code
        AND covid_deaths.date = covid_vaccinations.date
)
SELECT location, date, population, running_vaccinations,
       (running_vaccinations * 1.0 / population) * 100 AS percentage_of_population
FROM population_vaccinated;


-- =============================================
-- SECTION 7: TEMP TABLE
-- =============================================

-- Q7: Temp table storing latest cases and deaths per country
CREATE TEMPORARY TABLE latest_cases AS
SELECT location,
       MAX(total_cases) AS max_cases,
       MAX(total_deaths) AS max_deaths
FROM covid_deaths
GROUP BY location;

SELECT * FROM latest_cases;
