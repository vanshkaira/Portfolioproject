SELECT *
FROM [Portfolio project].dbo.CovidDeaths
ORDER BY 1,2

---Total cases vs total death
SELECT location, total_cases, total_deaths, date,population,new_cases,(total_cases/population)*100 as Covidinfected
FROM .dbo.CovidDeaths
WHERE location like '%INDIA%'
ORDER BY 1,2

--countries with high population rate compared to population
SELECT location,MAX(total_cases) as HighestInfectedcount,population,MAX(total_cases/population)*100 as PERCENTAGEPEOPLEINFECTED
FROM [Portfolio project].dbo.CovidDeaths
Group By location,Population
ORDER BY PERCENTAGEPEOPLEINFECTED DESC

--Countries with highest daeth count  per population
Select Location, Max(Cast(total_deaths as int)) as totaldeathcount
From [Portfolio project]. .CovidDeaths
where continent is not null
group by location
order by totaldeathcount desc

--Breaking out according to continent 

Select  location, Max(cast(Total_deaths as int)) as TotaldeathCount
from [Portfolio project].dbo.CovidDeaths
where Continent is null
Group by location
Order by totaldeathcount Desc


--showing the continent with highest death count per population

Select continent, Max(CAST(total_deaths as int)) AS totaldeathcount
from [Portfolio project].dbo.CovidDeaths
where  continent is not null
group by continent
order by totaldeathcount desc


--calculating global numbers

Select  SUM(new_cases) as GlobalCases,SUM(CAST(new_deaths as int))as Globaldeath,SUM(Cast(new_deaths as int ))/SUM(new_cases)* 100 as Deathpercentage
from [Portfolio project].dbo.CovidDeaths
Where continent is not null
Order by 1,2

----Looking for total population vs vaccination
With POPvsvac ( Continent,Location,Date,Population,New_vaccination,Roolingpeoplevaccinated)
as
(
Select dbo.CovidDeaths.continent,dbo.CovidDeaths.location,dbo.CovidDeaths.date,dbo.CovidDeaths.population,
dbo.CovidVaccinations.new_vaccinations
,SUM(CONVERT(int,dbo.CovidVaccinations.new_vaccinations))OVER(Partition BY dbo.coviddeaths.location Order By
 Coviddeaths.location,dbo.coviddeaths.date) as Roolingpeoplevaccinated
from [Portfolio project].dbo.CovidDeaths
Join [Portfolio project].dbo.CovidVaccinations
On .dbo.CovidDeaths.location=.dbo.CovidVaccinations.location
AND .dbo.CovidDeaths.Date=.dbo.CovidVaccinations.Date
Where dbo.CovidDeaths.continent is not null AND dbo.CovidVaccinations.new_vaccinations is not null
)
Select *,(RoolingPeoplevaccinated/Population)*100  as VaccinationPercentage
from POPvsvac


--Temp_table
Drop table if exists #percentageherovaccinated
Create table #percentageherovaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
Rollingpeoplevaccinated numeric,
)

Insert into #percentageherovaccinated
Select dbo.CovidDeaths.continent,dbo.CovidDeaths.location,dbo.CovidDeaths.date,dbo.CovidDeaths.population,
dbo.CovidVaccinations.new_vaccinations
,SUM(CONVERT(int,dbo.CovidVaccinations.new_vaccinations))OVER(Partition BY dbo.coviddeaths.location Order By
 Coviddeaths.location,dbo.coviddeaths.date) as Rollingpeoplevaccinated
from [Portfolio project].dbo.CovidDeaths
Join [Portfolio project].dbo.CovidVaccinations
On .dbo.CovidDeaths.location=.dbo.CovidVaccinations.location
AND .dbo.CovidDeaths.Date=.dbo.CovidVaccinations.Date
Where dbo.CovidDeaths.continent is not null AND dbo.CovidVaccinations.new_vaccinations is not null

Select *,(Rollingpeoplevaccinated/population)*100 
from #percentageherovaccinated

