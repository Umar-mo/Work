Select *
From Projectcovid..[covid death ]
Where continent is not null
order by 3,4

Select *
From Projectcovid..[covid vaccine ]
order by 3,4

Select Location,date, total_cases, new_cases,total_deaths, population
From Projectcovid..[covid death ]
order by 1,2

-- looking at total cases vs total deaths in Nigeria 

Select Location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
From Projectcovid..[covid death ]
Where location like '%Nigeria%'
order by 1,2

--looking at total cases vs population
--shows % infected

Select Location,date, total_cases, population, (total_cases/population)*100 as percentageinfected
From Projectcovid..[covid death ]
order by 1,2

--looking at countries with highest infection rate compared to population

Select Location, population, MAX(total_cases) as Highestinfectioncount, MAX((total_cases/population))*100 as percentagepopulationinfected
From Projectcovid..[covid death ]
--Where location like '%states%'
Group by location, population
order by  percentagepopulationinfected desc


--looking at countries with highest death count per population

Select Location, MAX(cast(total_deaths as int)) as Totaldeathcount
From Projectcovid..[covid death ]
--Where location like '%states%'
Where continent is not null
Group by location
order by Totaldeathcount desc

--by CONTINENT
Select continent, MAX(cast(total_deaths as int)) as Totaldeathcount
From Projectcovid..[covid death ]
--Where location like '%states%'
Where continent is not null
Group by continent
order by Totaldeathcount desc

--GLOBAL NUMBERS
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage
From Projectcovid..[covid death ]
Where location like '%states%'
and continent is not null
group by date 
order by 1,2


--total population vs vaccination
Select *
From Projectcovid..[covid death ]dea
join Projectcovid..[covid vaccine ]vac
 on dea.location = vac.location
 and dea.date =vac.date

 Select dea.continent, dea.location, dea.population, vac.new_vaccinations
 , SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.date Order by dea.location,dea.Date) as RollingpeopleVaccinated
 --,(RollingpeopleVaccinated/population)*100
From Projectcovid..[covid death ]dea
join Projectcovid..[covid vaccine ]vac
 on dea.location = vac.location
 and dea.date =vac.date
 Where dea.continent is not null
 Order by 2,3

-- --USE CTE

-- with popvsvas (continent, location, date, population, New_vaccinations, RollingpeopleVaccinated)
-- as
-- (
-- Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
-- , SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.date Order by dea.location,dea.Date) as RollingpeopleVaccinated
-- --,(RollingpeopleVaccinated/population)*100
--From Projectcovid..[covid death ]dea
--join Projectcovid..[covid vaccine ]vac
-- on dea.location = vac.location
-- and dea.date =vac.date
-- Where dea.continent is not null
-- ----Order by 2,3
-- )
-- Select *
-- From popvsVac





 --TEMP TABLE

 Create Table #percentpopulationvaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 population numeric,
 new_vaccinations numeric,
 RollingpeopleVaccinated numeric
 )
 

 Insert into #percentpopulationvaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.date Order by dea.location,dea.Date) as RollingpeopleVaccinated
 --,(RollingpeopleVaccinated/population)*100 as percentagevac
From Projectcovid..[covid death ]dea
join Projectcovid..[covid vaccine ]vac
 on dea.location = vac.location
 and dea.date =vac.date
 Where dea.continent is not null
 ----Order by 2,3

 Select*,(RollingpeopleVaccinated/population)*100
 From #percentpopulationvaccinated



