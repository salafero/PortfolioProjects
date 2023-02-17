
Select * 
From [Portfolio Project]..CovidDeaths$
where continent is not null
order by 3,4

--Select * 
--From [Portfolio Project]..CovidVaccinations$
--order by 3,4


Select location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths$
order by 1,2

--Looking at Total Cases vs Total Deaths 
--Shows liklihood of dyinf if you contract covid un your country
Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths$
where location like '%states%'
order by 1,2

--Looking at total cases vs pupulations
--Shows what percentage of population got covid 

Select location, date,population,total_cases ,(total_cases/population)*100 as PercentageOfPopulationInfected
From [Portfolio Project]..CovidDeaths$
--where location like '%mexico%'
order by 1,2

--Looking at county with hifhest infection rate compared to populations
Select location,population,MAX(total_cases) as HighersInfectionCount ,MAX(total_cases/population)*100 as PercentagePopulationInfected
From [Portfolio Project]..CovidDeaths$
--where location like '%mexico%'
Group by location,population
order by PercentagePopulationInfected desc

--Showing the countries with highes DEath Count per Populations
Select location,MAX(total_deaths) as TotalDeathCount
From [Portfolio Project]..CovidDeaths$
--where location like '%mexico%'
where continent is not null
Group by location
order by TotalDeathCount desc

-- Let's breaj things down by continent
Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths$
--where location like '%mexico%'
where continent is not null
Group by continent
order by TotalDeathCount desc


Select continent, MAX (cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths$
--where location like '%mexico%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--Showing continents with the highest death count per population
Select continent, MAX (cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths$
--where location like '%mexico%'
where continent is not null
Group by continent
order by TotalDeathCount desc



--Global numbers
Select  SUM(new_cases) as Total_cases,SUM(cast(new_deaths as int))as Total_deaths , SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Avg --total_cases,total_deaths ,(total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths$
--where location like '%mexico%'
where continent is not null
--Group by date
order by 1,2


--Looking total populations vs Vaccinations

Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date ) as Rolling_People_Vaccinated
, (Rolling_People_Vaccinated/population) *100
From [Portfolio Project] ..CovidDeaths$ dea
Join [Portfolio Project] ..CovidVaccinations$ vac
On dea.location = vac.location
where dea.continent is not null
and vac.new_vaccinations is not null
and dea.date=vac.date
order by 1,2,3


-- Use CTE 
with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, Rolling_People_Vaccinated)
as ( 
Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date ) as Rolling_People_Vaccinated
-- (Rolling_People_Vaccinated/population) *100
From [Portfolio Project] ..CovidDeaths$ dea
Join [Portfolio Project] ..CovidVaccinations$ vac
On dea.location = vac.location
where dea.continent is not null
and vac.new_vaccinations is not null
and dea.date=vac.date
--order by 1,2,3
)
Select*, (Rolling_People_Vaccinated/Population)*100
From PopvsVac



--Creating vie to store data for later visualizations

Create View PopvsVac   as
Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date ) as Rolling_People_Vaccinated
-- (Rolling_People_Vaccinated/population) *100
From [Portfolio Project] ..CovidDeaths$ dea
Join [Portfolio Project] ..CovidVaccinations$ vac
On dea.location = vac.location
where dea.continent is not null
and dea.date=vac.date
--order by 1,2,3

Select* 
From PopvsVac