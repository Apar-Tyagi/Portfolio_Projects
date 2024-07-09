Select *
from PortfolioProject..CovidDeaths
order by 3,4;

--Select *
--from PortfolioProject..CovidVaccinations
--order by 3,4;

-- Data that we are going to use
select Location,date,total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

-- Total Cases vs Total Deaths (Death Percentage)
select Location,date,total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float)*100) as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%ecua%'
order by 1,2

-- Total Cases vs Population
select Location,date, population, total_cases, (total_cases/population)*100 as InfectedPercentage
from PortfolioProject..CovidDeaths
order by InfectedPercentage desc

--Highest Infection Rate compared to population
SELECT Location, population, MAX(cast(total_cases as int)) AS HighestInfectionCount, MAX(cast(total_cases/population as float))*100 AS InfectedPercentage
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY InfectedPercentage desc
 
-- Countries with the highest Death Count per Population
SELECT Location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

-- Countries with highest Death Count per Population grouped by Continent 
SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc;


-- Global Numbers
select SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(New_cases)*100 as death_percentage
from PortfolioProject..CovidDeaths
--where location like '%ecua%'
where continent is not null
--group by date
order by 1,2


-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations))
over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
     and dea.date = vac.date
where dea.continent is not null
order by 2,3;


-- use CTE

with PopvsVac(Continent, Location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations))
over(partition by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
     and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)


select * , (RollingPeopleVaccinated/population)*100
from PopvsVac


--Temp Table

drop table if exists #percent_population_vaccinated
Create Table #percent_population_vaccinated(
continent nvarchar(255), 
Location nvarchar(255), 
date datetime, 
population numeric, 
new_vaccinations numeric, 
RollingPeopleVaccinated numeric)

insert into #percent_population_vaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations))
over(partition by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
     and dea.date = vac.date
--where dea.continent is not null
select * , (RollingPeopleVaccinated/population)*100
from #percent_population_vaccinated


-- creating view to store data for later visualizations

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations))
over(partition by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
     and dea.date = vac.date
where dea.continent is not null
	 --order 2,3

drop view PercentPopulationVaccinated

select * from PercentPopulationVaccinated;