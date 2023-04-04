Select* 
From PortforlioProject.dbo.CovidDeaths
Order by 3,4

Select location,date,total_cases,new_cases,total_deaths,population
From  PortforlioProject.dbo.CovidDeaths
Where continent is not null
order by 1,2

--total cases vs total deaths
-- Shows the chances of dying if you are infected with covid in your country


Select location,date,population,total_cases,total_deaths,(total_cases/total_deaths)*100 as Total_Deaths_Percentage
From PortforlioProject.dbo.CovidDeaths
Where continent is not null and location ='south africa'
Order by 1,2

--Total cases vs population
--Shows the percentage of people in south africa that have gotten covid

Select location,date,total_cases, Population,(Total_cases/Population)*100 as population_percentage
From PortforlioProject.dbo.CovidDeaths
Where continent is not null and location = 'South africa' 
order by 1,2 desc


--looking at countries with the highest infection rate compared to population

Select location,MAx(total_cases)as Highest_infection_count, Population,MAX((Total_cases/Population))*100 as Percent_population_affected
From PortforlioProject.dbo.CovidDeaths
--Where continent is not null and location = 'South africa' 
Group by location,population
order by Percent_population_affected desc


--shows the country with the highest death count per population

Select location, Max(cast(total_deaths as int))As highestDeathCount
from PortforlioProject.dbo.CovidDeaths
Where continent is not null
Group by location
order by highestDeathCount desc

--Lets break things down by continent

--Showing the continent with the highest death count

Select continent, Max(cast(total_deaths as int))As highestDeathCount
from PortforlioProject.dbo.CovidDeaths
Where continent is not null
Group by continent
order by highestDeathCount desc

--global numbers


Select date,SUM(new_cases) as Total_new_cases,SUM(cast(new_deaths as int)) as Total_new_daths,(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as Total_Deaths_Percentage
From PortforlioProject.dbo.CovidDeaths
Where continent is not null
Group by date
Order by 1,2
 

--JOIN

Select *
From PortforlioProject.dbo.CovidDeaths dea
join PortforlioProject.dbo.CovidDeaths vac
on dea.location = vac.location
and dea.date = vac.date

--looking total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortforlioProject.dbo.CovidDeaths dea
join PortforlioProject.dbo.CovidDeaths vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Order by 1,2,3

--Rolling count

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as RolligPeopleVaccinated
From PortforlioProject.dbo.CovidDeaths dea
join PortforlioProject.dbo.CovidDeaths vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

--Using CTE


with PopvsVac(continent, location, date, population,new_vaccinations,RollingPeapoleVaccinated)

as(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as RolligPeopleVaccinated
From PortforlioProject.dbo.CovidDeaths dea
join PortforlioProject.dbo.CovidDeaths vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
)

Select*,(RollingPeapoleVaccinated/population)*100
From PopvsVac

--TEMP tablecation



create table #PercentPopulationVaccinated
(continent nvarchar(225),
location nvarchar(225),
date datetime,
population numeric,
new_vaccination numeric,
RollingPeapoleVaccinated numeric
)

insert into  #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as RolligPeopleVaccinated
From PortforlioProject.dbo.CovidDeaths dea
join PortforlioProject.dbo.CovidDeaths vac
on dea.location = vac.location
and dea.date = vac.date
--Where dea.continent is not null

Select*,(RollingPeapoleVaccinated/population)*100
From #PercentPopulationVaccinated


--Create view for data Visualizations


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as RolligPeopleVaccinated
From PortforlioProject.dbo.CovidDeaths dea
join PortforlioProject.dbo.CovidDeaths vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null


