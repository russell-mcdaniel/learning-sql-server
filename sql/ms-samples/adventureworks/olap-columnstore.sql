use AdventureWorksDW2019;
GO

select
	d.CalendarYear				as CalendarYear,
	d.CalendarQuarter			as CalendarQuarter,
	s.ProductKey				as ProductKey,
	sum(s.OrderQuantity)		as OrderQuantity
from
	dbo.FactInternetSales s
inner join
	dbo.DimDate d
on
	d.DateKey = s.OrderDateKey
where
	d.CalendarYear = 2012
group by
	d.CalendarYear,
	d.CalendarQuarter,
	s.ProductKey
order by
	d.CalendarYear,
	d.CalendarQuarter,
	s.ProductKey;
GO

--inner join
--	dbo.DimProduct p
--on
--	p.ProductKey = s.ProductKey

--
-- Reconfigure indexes to create clustered columnstore index.
--
-- Guidelines suggest clustered columnstore index for data warehouse
-- queries. The original clustering key on FactInternetSales is on
-- SalesOrderNumber, SalesOrderLineNumber (also the primary key).
--
-- * Recreate PK as nonclustered. Requires handling dependents.
-- * Create clustered columnstore index.

-- dbo.FactInternetSalesReason: Drop the foreign key to dbo.FactInternetSales.
alter table [dbo].[FactInternetSalesReason]
	drop constraint FK_FactInternetSalesReason_FactInternetSales;
GO

-- dbo.FactInternetSales: Recreate the primary key as nonclustered.
alter table [dbo].[FactInternetSales]
	drop constraint [PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber];
GO

-- dbo.FactInternetSales: Create the clustered columnstore index.
create clustered columnstore index [CS_FactInternetSales]
	on [dbo].[FactInternetSales];
GO

alter table [dbo].[FactInternetSales]
	add constraint [PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber]
	primary key nonclustered ([SalesOrderNumber], [SalesOrderLineNumber]);
GO

-- dbo.FactInternetSalesReason: Restore the foreign key to dbo.FactInternetSales.
alter table [dbo].[FactInternetSalesReason]
	add constraint [FK_FactInternetSalesReason_FactInternetSales]
	foreign key ([SalesOrderNumber], [SalesOrderLineNumber])
	references [dbo].[FactInternetSales] ([SalesOrderNumber], [SalesOrderLineNumber]);
GO

--
-- Restore original.
--
-- Need to drop and recreate foreign key from dbo.FactInternetSalesReason. See above.
--
alter table dbo.FactInternetSales
	add constraint PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber
	primary key clustered (SalesOrderNumber, SalesOrderLineNumber);
GO

--
-- Support filter on DimDate.CalendarYear.
--
create nonclustered index [IX_DimDate_CalendarYear]
	on [dbo].[DimDate] ([CalendarYear])
	include ([CalendarQuarter]);
GO

drop index [dbo].[DimDate].[IX_DimDate_CalendarYear];
GO

--
-- Support sample query from documentation (based on original rowstore index).
--
-- Cost W/O:   1.94989
-- Cost With:  1.22090 (changes hash join to merge join between date and sales)
create nonclustered index [IX_FactInternetSales_OrderDateKey]
	on [dbo].[FactInternetSales] ([OrderDateKey])
	include ([ProductKey], [OrderQuantity]);
GO

drop index [dbo].[FactInternetSales].[IX_FactInternetSales_OrderDateKey];
GO

/*
select * from dbo.FactInternetSales;
select * from dbo.DimProduct;
select * from dbo.DimDate;
*/
