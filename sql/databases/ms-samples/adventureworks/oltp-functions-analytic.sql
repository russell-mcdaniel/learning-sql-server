use AdventureWorks2019;
GO

-- Analytic Function: Cumulative Distribution, Percentile
--
-- This is based on the same query in the PERCENTILE_CONT documentation:
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/percentile-cont-transact-sql
--
-- The values returned by the sample query are difficult to interpret because the query
-- returns data at a different grain from the input to the aggregate calculations.
--
-- This query is adjusted to return all department history instead of just the current
-- record so that you can see all input used in the calculations.
--
select
	dh.BusinessEntityID																as BusinessEntityID,
	e.LastName																		as LastName,
	e.FirstName																		as FirstName,
	d.Name																			as DepartmentName,
	dh.StartDate																	as DepartmentStart,
	ph.Rate																			as Rate,
	ph.RateChangeDate																as RateStart,
	CUME_DIST() over (partition by d.Name order by ph.Rate)							as CumeDist,
	PERCENTILE_CONT(0.5) within group (order by ph.Rate) over (partition by d.Name)	as MedianCont,
	PERCENTILE_DISC(0.5) within group (order by ph.Rate) over (partition by Name)	as MedianDisc
from
	HumanResources.EmployeePayHistory ph
inner join
	HumanResources.EmployeeDepartmentHistory dh
on
	dh.BusinessEntityID = ph.BusinessEntityID
and
	dh.EndDate is null
inner join
	HumanResources.Department d
on
	d.DepartmentID = dh.DepartmentID
inner join
	HumanResources.vEmployee e
on
	e.BusinessEntityID = ph.BusinessEntityID;
GO

-- Analytic Function: Cumulative Distribution.
select
	edh.Department														as Department,
	edh.LastName														as LastName,
	e.Rate																as Rate,
    cume_dist() over (partition by edh.Department order by e.Rate)		as CumeDist,
    percent_rank() over (partition by edh.Department order by e.Rate)	as PctRank
from
	HumanResources.vEmployeeDepartmentHistory edh
inner join
	HumanResources.EmployeePayHistory e
on
	e.BusinessEntityID = edh.BusinessEntityID  
where
	edh.Department IN (N'Information Services', N'Document Control')   
order by
	edh.Department,
	e.Rate desc;
GO

-- Demonstrate:
-- * Running total using SUM and OVER clause.
-- * Maximum value within a row-controlled window.
select
	sod.SalesOrderID					as SalesOrderID,
	sod.SalesOrderDetailID				as SalesOrderDetailID,
	sod.OrderQty						as OrderQty,
	sum(sod.OrderQty) over (partition by sod.SalesOrderID order by sod.SalesOrderDetailID)
										as OrderQtyRunning,
	max(sod.OrderQty) over (partition by sod.SalesOrderID order by sod.SalesOrderDetailID rows between 1 preceding and 1 following)
										as OrderQtyMaxAdj
from
	Sales.SalesOrderDetail sod
where
	sod.SalesOrderID = 43661
order by
	sod.SalesOrderID, sod.SalesOrderDetailID;
GO

-- Previous quota value using LAG.
select
	BusinessEntityID,
	QuotaDate													as CurrentDate,
	SalesQuota													as CurrentQuota,
	lag(QuotaDate, 1) over (order by QuotaDate)					as PreviousDate,
    lag(SalesQuota, 1) over (order by QuotaDate)				as PreviousQuota,
	SalesQuota - lag(SalesQuota, 1) over (order by QuotaDate)	as Change
from
	Sales.SalesPersonQuotaHistory
where
	BusinessEntityID = 275
--and
--	year(QuotaDate) in ('2013', '2014');
GO

-- First quota for each year using FIRST_VALUE.
select
	BusinessEntityID			as BusinessEntityID,
	year(QuotaDate)				as QuotaYear,
	first_value(SalesQuota) over (partition by BusinessEntityID, year(QuotaDate) order by QuotaDate)
								as FirstQuota
from
	Sales.SalesPersonQuotaHistory
--where
--	BusinessEntityID = 275
order by
	BusinessEntityID,
	year(QuotaDate);
GO

/*
select * from Person.BusinessEntity;
GO

select * from HumanResources.Employee
select * from HumanResources.EmployeeDepartmentHistory
select * from HumanResources.EmployeePayHistory order by BusinessEntityID, RateChangeDate
GO

select * from Sales.SalesPersonQuotaHistory
--where BusinessEntityID = 275
order by BusinessEntityID, QuotaDate;
GO

select schema_name(t.schema_id) as schema_name, t.name as table_name from sys.tables t order by schema_name(t.schema_id), t.name;
GO
*/
