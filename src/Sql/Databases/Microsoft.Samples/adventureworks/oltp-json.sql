-- ================================================================================
-- Explore basic JSON functionality.
--
-- Ideas for additional exercises:
--
-- * Create attribute on Sales.SalesOrderHeader to store JSON representation.
-- * Create computed columns and indexes plus queries to demonstrate usage.
-- * Create query to modify documents.
-- ================================================================================
USE AdventureWorks2019;
GO

--
-- Get an order and its details as a JSON document.
--
-- To return a nested array, a correlated subquery must be used. Beware
-- of performance when processing large sets of documents. To mitigate,
-- create a temporary table to store intermediate results or divide the
-- process to handle documents in small batches or individually.
--
SELECT
	h.SalesOrderID							AS [OrderID],
	h.SalesOrderNumber						AS [OrderNumber],
	h.OrderDate								AS [OrderDate],
	h.ShipDate								AS [ShipDate],
	h.CustomerID                			AS [Customer.ID],
	p.LastName								AS [Customer.LastName],
	p.FirstName								AS [Customer.FirstName],
	h.SubTotal                  			AS [Amount.SubTotal],
	h.TaxAmt                    			AS [Amount.Tax],
	h.Freight                   			AS [Amount.Freight],
	h.TotalDue                  			AS [Amount.Total],
	(
		SELECT
			d.SalesOrderDetailID			AS [OrderDetailID],
			d.ProductID						AS [ProductID],
			p.Name							AS [ProductName],
			d.OrderQty						AS [Quantity],
			d.UnitPrice						AS [UnitPrice],
			d.UnitPriceDiscount				AS [UnitDiscount],
			d.LineTotal						AS [LineTotal]
		FROM
			Sales.SalesOrderDetail d
		INNER JOIN
			Production.Product p
		ON
			p.ProductID = d.ProductID
		WHERE
			d.SalesOrderID = h.SalesOrderID
		FOR JSON PATH,
			INCLUDE_NULL_VALUES
	)                           			AS [OrderDetails]
FROM
	Sales.SalesOrderHeader h
INNER JOIN
	Sales.Customer c
ON
	c.CustomerID = h.CustomerID
INNER JOIN
	Person.Person p
ON
	p.BusinessEntityID = c.PersonID
WHERE
	h.SalesOrderID = 72415
FOR JSON PATH,
	WITHOUT_ARRAY_WRAPPER,
	INCLUDE_NULL_VALUES;
GO

--
-- Query a JSON document.
--
DECLARE @OrderDocument nvarchar(MAX) =
N'{
    "OrderID": 72415,
    "OrderNumber": "SO72415",
    "OrderDate": "2014-05-07T00:00:00",
    "ShipDate": "2014-05-14T00:00:00",
    "Customer": {
        "ID": 16616,
        "LastName": "Liang",
        "FirstName": "Kelvin"
    },
    "Amount": {
        "SubTotal": 2337.2700,
        "Tax": 186.9816,
        "Freight": 58.4318,
        "Total": 2582.6834
    },
    "OrderDetails": [
        {
            "OrderDetailID": 114718,
            "ProductID": 782,
            "ProductName": "Mountain-200 Black, 38",
            "Quantity": 1,
            "UnitPrice": 2294.9900,
            "UnitDiscount": 0.0000,
            "LineTotal": 2294.990000
        },
        {
            "OrderDetailID": 114719,
            "ProductID": 921,
            "ProductName": "Mountain Tire Tube",
            "Quantity": 1,
            "UnitPrice": 4.9900,
            "UnitDiscount": 0.0000,
            "LineTotal": 4.990000
        },
        {
            "OrderDetailID": 114720,
            "ProductID": 930,
            "ProductName": "HL Mountain Tire",
            "Quantity": 1,
            "UnitPrice": 35.0000,
            "UnitDiscount": 0.0000,
            "LineTotal": 35.000000
        },
        {
            "OrderDetailID": 114721,
            "ProductID": 873,
            "ProductName": "Patch Kit\/8 Patches",
            "Quantity": 1,
            "UnitPrice": 2.2900,
            "UnitDiscount": 0.0000,
            "LineTotal": 2.290000
        }
    ]
}';

-- Check if the text is valid JSON.
IF ISJSON(@OrderDocument) = 1
	PRINT N'The text is a valid JSON document.';
ELSE
	PRINT N'The text is NOT a valid JSON document.';

-- Get the order total and the first line total to demonstrate array access.
SELECT
	-- The source uses the "decimal(38,6)" data type.
	CAST(JSON_VALUE(@OrderDocument, N'$.OrderDetails[0].LineTotal') AS decimal(38,6))	AS LineTotal,
	-- The source uses the "money" data type.
	CAST(JSON_VALUE(@OrderDocument, N'$.Amount.Total') AS money)						AS OrderTotal

-- Get the customer and amount objects and the order lines array as JSON.
SELECT
	JSON_QUERY(@OrderDocument, N'$.Customer')			AS CustomerDetails,
	JSON_QUERY(@OrderDocument, N'$.Amount')				AS Amounts,
	-- JSON path filtering does not appear to be supported.
	--JSON_QUERY(@OrderDocument, N'$.OrderDetails[?(@.LineTotal < 1000)]')	AS OrderDetails;
	JSON_QUERY(@OrderDocument, N'$.OrderDetails')		AS OrderDetails;

-- Return the order details as row data.
SELECT
	d.*
FROM
	OPENJSON(@OrderDocument, N'$.OrderDetails')
		WITH
		(
			OrderDetailID		int				N'$.OrderDetailID',
			ProductID			int				N'$.ProductID',
			ProductName			dbo.Name		N'$.ProductName',
			Quantity			smallint		N'$.Quantity',
			UnitPrice			money			N'$.UnitPrice',
			UnitDiscount		money			N'$.UnitDiscount',
			LineTotal			numeric(38,6)	N'$.LineTotal'
		) d;
GO
