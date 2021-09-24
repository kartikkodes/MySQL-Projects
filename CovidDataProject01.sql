Select Location , date , total_cases, new_cases , total_deaths, population
from CovidDeaths
order by 1,2;

-- Looking at total Cases vs Total Deaths
Select Location , date , total_cases , total_deaths, (total_deaths / total_cases)*100 as DeathPercentage
from CovidDeaths
where location = 'India'
order by 1,2; 

--Looking at Total Cases vs Population
Select Location , date , Population , total_cases , (total_cases/population)*100 as DeathPercentage
from CovidDeaths
where location = 'India'
order by 1,2; 

--Country with the highest infection rate
select location , population , max(total_cases) as HighestInfectionCount, Max((total_cases / population)*100) as InfectionPercentage
from CovidDeaths
group by location , population
order by InfectionPercentage desc;

-- Country with the highest death count per population
select location , population , max(cast(Total_deaths as int)) as Deaths
from CovidDeaths
where continent is not null
group by location , population
order by Deaths desc;


-- Lets break things down by continent
select location , max(cast(total_deaths as int)) as TotalDeathCount 
from CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc ;


-- Showing the continents with the highest death count by population
select location ,population ,  max(cast(total_deaths as int)) as DeathCount
from CovidDeaths 
where continent is null
group by location , population
order by DeathCount desc;

-- GLOBAL NUMBERS

select date, sum(new_cases) as Total_New_Cases , sum(cast(new_deaths as int)) as Total_New_Deaths , (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from CovidDeaths
where continent is not null
group by date
order by 1,2;

--Total numbers
select sum(new_cases) as Total_New_Cases , sum(cast(new_deaths as int)) as Total_New_Deaths , (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from CovidDeaths
where continent is not null
--group by date
order by 1,2;

--Vaccination

select * 
from CovidDeaths dea
join CovidVaccination vac
on dea.location = vac.location and dea.date = vac.date

--Looking at total population vs vaccination

select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations
from CovidDeaths dea
join CovidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;


-- USE CTE

with popVsvac (continent , location , date , population, new_vaccination , RollingPeopleVaccinated)
as
(
select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations
, Sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)

select * from popVsvac ;

-- Temp Table
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations
, Sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

Select * , (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated;


-- Creating View
create view PPV as 
select date, sum(new_cases) as Total_New_Cases , sum(cast(new_deaths as int)) as Total_New_Deaths , (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from CovidDeaths
where continent is not null
group by date;

select * from PPV;