

SET ANSI_NULLS ON
GO

-- SECTION TO DROP EXTERNAL TABLES 

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('[prd].[CityDimensions]') )
    DROP  TABLE [prd].[CityDimensions]
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('[prd].[CustomerDimensions]') )
    DROP  TABLE [prd].[CustomerDimensions]
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('[prd].[DateDimensions]') )
    DROP  TABLE [prd].[DateDimensions]
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('[prd].[EmployeeDimensions]') )
    DROP  TABLE [prd].[EmployeeDimensions]
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('[prd].[MovementsFact]') )
    DROP  TABLE [prd].[MovementsFact]
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('[prd].[OrdersFact]') )
    DROP  TABLE [prd].[OrdersFact]
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('[prd].[PaymentMethodDimension]') )
    DROP  TABLE [prd].[PaymentMethodDimension]
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('[prd].[PurchasesFact]') )
    DROP  TABLE [prd].[PurchasesFact]
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('[prd].[SalesFact]') )
    DROP  TABLE [prd].[SalesFact]
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('[prd].[StockItemDimensions]') )
    DROP  TABLE [prd].[StockItemDimensions]
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('[prd].[StockItemHoldingFacts]') )
    DROP  TABLE [prd].[StockItemHoldingFacts]
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('[prd].[SupplierDimensions]') )
    DROP  TABLE [prd].[SupplierDimensions]
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('[prd].[TransactionTypeDimensions]') )
    DROP  TABLE [prd].[TransactionTypeDimensions]
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('[prd].[TransactionsFact]') )
    DROP  TABLE [prd].[TransactionsFact]
GO

IF EXISTS (SELECT name FROM sys.schemas WHERE name = N'prd')
   BEGIN
      PRINT 'Dropping the prd schema'
      DROP SCHEMA [prd]
END
GO
PRINT 'Creating the prd schema'
GO
CREATE SCHEMA [prd]
GO


PRINT 'CREATE City Dimensions'
GO
CREATE TABLE [prd].[CityDimensions]
WITH
(
    DISTRIBUTION = REPLICATE
,   CLUSTERED COLUMNSTORE INDEX
)
AS SELECT c.CityID AS [WWI City ID],
       c.CityName AS [City],
       sp.StateProvinceName AS [State Province],
       co.CountryName AS [Country],
	   co.Continent as [Continent],
       sp.SalesTerritory AS [Sales Territory],
	   co.Region AS [Region],
	   co.Subregion AS [Subregion],
	   COALESCE(c.LatestRecordedPopulation, 0) AS [Latest Recorded Population],
	   c.ValidFrom AS [Valid From],
	   c.ValidTo AS [Valid To]
FROM  [stg].[Application_Cities] AS c
INNER JOIN [stg].[Application_StateProvinces] AS sp
ON c.StateProvinceID = sp.StateProvinceID
INNER JOIN [stg].[Application_Countries] AS co
ON sp.CountryID = co.CountryID
OPTION (LABEL = 'CTAS : [CityDimensions]')


PRINT 'CREATE  [CustomerDimensions]'
GO
CREATE TABLE [prd].[CustomerDimensions]
WITH
(
    DISTRIBUTION = REPLICATE
,   CLUSTERED COLUMNSTORE INDEX
)
AS SELECT c.CustomerID AS [WWI Customer ID],
       c.CustomerName AS [Customer],
	   bt.CustomerName AS [Bill To Customer],
	   cc.CustomerCategoryName AS [Category],
       bg.BuyingGroupName AS [Buying Group],
	   p.FullName AS [Primary Contact],
	   c.DeliveryPostalCode AS [Postal Code],
       c.ValidFrom AS [Valid From],
	   c.ValidTo AS [Valid To]
FROM [stg].[Sales_Customers] AS c
INNER JOIN [stg].[Sales_BuyingGroups] AS bg
ON c.BuyingGroupID = bg.BuyingGroupID
INNER JOIN [stg].[Sales_CustomerCategories] AS cc
ON c.CustomerCategoryID = cc.CustomerCategoryID
INNER JOIN [stg].[Sales_Customers] AS bt
ON c.BillToCustomerID = bt.CustomerID
INNER JOIN [stg].[Application_People] AS p
ON c.PrimaryContactPersonID = p.PersonID
OPTION (LABEL = 'CTAS : [CustomerDimensions]')


PRINT 'CREATE  [[DateDimensions]]'
GO
CREATE TABLE [prd].[DateDimensions]
WITH
(
    DISTRIBUTION = REPLICATE
,   CLUSTERED COLUMNSTORE INDEX
)
AS SELECT * FROM [stg].[DateDimensions]
OPTION (LABEL = 'CTAS : [DateDimensions]')


PRINT 'CREATE  [EmployeeDimensions]'
GO
CREATE TABLE [prd].[EmployeeDimensions]
WITH
(
    DISTRIBUTION = REPLICATE
,   CLUSTERED COLUMNSTORE INDEX
)
AS SELECT p.PersonID AS [WWI Employee ID],
       p.FullName AS [Employee],
	   p.PreferredName AS [Preferred Name],
	   p.IsSalesperson AS [Is Salesperson],
       p.ValidFrom AS [Valid From],
	   p.ValidTo AS [Valid To]
FROM [stg].[Application_People] AS p
WHERE p.IsEmployee <> 0
OPTION (LABEL = 'CTAS : [EmployeeDimensions]')


PRINT 'CREATE  [[MovementsFact]]'
GO
CREATE TABLE [prd].[MovementsFact]
WITH
(
    DISTRIBUTION = HASH([WWI Stock Item Transaction ID])
,   CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT CAST(sit.TransactionOccurredWhen AS date) AS [Date Key],
       sit.StockItemTransactionID AS [WWI Stock Item Transaction ID],
       sit.InvoiceID AS [WWI Invoice ID],
       sit.PurchaseOrderID AS [WWI Purchase Order ID],
       CAST(sit.Quantity AS int) AS Quantity,
       sit.StockItemID AS [WWI Stock Item ID],
       sit.CustomerID AS [WWI Customer ID],
       sit.SupplierID AS [WWI Supplier ID],
       sit.TransactionTypeID AS [WWI Transaction Type ID]
FROM [stg].[Warehouse_StockItemTransactions] AS sit
OPTION (LABEL = 'CTAS : [MovementsFact]')


PRINT 'CREATE  [[OrdersFact]]'
GO
CREATE TABLE [prd].[OrdersFact]
WITH
(
    DISTRIBUTION = HASH([WWI Order ID])
,   CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT 
	c.DeliveryCityID AS [WWI City ID],
	c.CustomerID AS [WWI Customer ID],
	ol.StockItemID AS [WWI Stock Item ID],
	CAST(o.OrderDate AS date) AS [Order Date Key],
	CAST(ol.PickingCompletedWhen AS date) AS [Picked Date Key],
	o.SalespersonPersonID AS [WWI Salesperson ID],
	o.PickedByPersonID AS [WWI Picker ID],
	o.OrderID AS [WWI Order ID],
	o.BackorderOrderID AS [WWI Backorder ID],
	ol.[Description],
	pt.PackageTypeName AS Package,
	ol.Quantity AS Quantity,
	ol.UnitPrice AS [Unit Price],
	ol.TaxRate AS [Tax Rate],
	ROUND(ol.Quantity * ol.UnitPrice, 2) AS [Total Excluding Tax],
	ROUND(ol.Quantity * ol.UnitPrice * ol.TaxRate / 100.0, 2) AS [Tax Amount],
	ROUND(ol.Quantity * ol.UnitPrice, 2) + ROUND(ol.Quantity * ol.UnitPrice * ol.TaxRate / 100.0, 2) AS [Total Including Tax]
FROM [stg].[Sales_Orders] AS o
INNER JOIN [stg].[Sales_OrderLines] AS ol
ON o.OrderID = ol.OrderID
INNER JOIN [stg].[Warehouse_PackageTypes] AS pt
ON ol.PackageTypeID = pt.PackageTypeID
INNER JOIN [stg].[Sales_Customers] AS c
ON c.CustomerID = o.CustomerID
OPTION (LABEL = 'CTAS : [OrdersFact]')


PRINT 'CREATE  [[PaymentMethodDimension]]]'
GO
CREATE TABLE [prd].[PaymentMethodDimension]
WITH
(
    DISTRIBUTION = REPLICATE
,   CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT p.PaymentMethodID,
	   p.PaymentMethodName,
	   p.ValidFrom,
	   p.ValidTo
FROM [stg].[Application_PaymentMethods] AS p
OPTION (LABEL = 'CTAS : [PaymentMethodDimension]')



PRINT 'CREATE  [[PurchasesFact]]]'
GO
CREATE TABLE [prd].[PurchasesFact]
WITH
(
    DISTRIBUTION = HASH([WWI Purchase Order ID])
,   CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT CAST(po.OrderDate AS date) AS [Date Key],
           po.SupplierID AS [WWI Supplier ID],
		   pol.StockItemID AS [WWI Stock Item ID],
           po.PurchaseOrderID AS [WWI Purchase Order ID],
           pol.OrderedOuters AS [Ordered Outers],
           pol.OrderedOuters * si.QuantityPerOuter AS [Ordered Quantity],
           pol.ReceivedOuters AS [Received Outers],
           pt.PackageTypeName AS Package,
           pol.IsOrderLineFinalized AS [Is Order Finalized]
    FROM [stg].[Purchasing_PurchaseOrders] AS po
    INNER JOIN [stg].[Purchasing_PurchaseOrderLines] AS pol
    ON po.PurchaseOrderID = pol.PurchaseOrderID
    INNER JOIN [stg].[Warehouse_StockItems] AS si
    ON pol.StockItemID = si.StockItemID
    INNER JOIN [stg].[Warehouse_PackageTypes] AS pt
    ON pol.PackageTypeID = pt.PackageTypeID
OPTION (LABEL = 'CTAS : [PurchasesFact]')


PRINT 'CREATE  [[SalesFact]]]'
GO
CREATE TABLE [prd].[SalesFact]
WITH
(
    DISTRIBUTION = HASH([WWI Invoice ID])
,   CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT 
       c.DeliveryCityID AS [WWI City ID],
       i.CustomerID AS [WWI Customer ID],
	   i.BillToCustomerID AS [WWI Bill To Customer ID],
	   il.StockItemID AS [WWI Stock Item ID],
	   CAST(i.InvoiceDate AS date) AS [Invoice Date Key],
       CAST(i.ConfirmedDeliveryTime AS date) AS [Delivery Date Key],
	   i.SalespersonPersonID AS [WWI Saleperson ID],
       i.InvoiceID AS [WWI Invoice ID],
       il.[Description],
       pt.PackageTypeName AS Package,
       il.Quantity,
       il.UnitPrice AS [Unit Price],
       il.TaxRate AS [Tax Rate],
       il.ExtendedPrice - il.TaxAmount AS [Total Excluding Tax],
       il.TaxAmount AS [Tax Amount],
       il.LineProfit AS Profit,
       il.ExtendedPrice AS [Total Including Tax],
       CASE WHEN si.IsChillerStock = 0 THEN il.Quantity ELSE 0 END AS [Total Dry Items],
       CASE WHEN si.IsChillerStock <> 0 THEN il.Quantity ELSE 0 END AS [Total Chiller Items]
       
FROM [stg].[Sales_Invoices] AS i
INNER JOIN [stg].[Sales_InvoiceLines] AS il
ON i.InvoiceID = il.InvoiceID
INNER JOIN [stg].[Warehouse_StockItems] AS si
ON il.StockItemID = si.StockItemID
INNER JOIN [stg].[Warehouse_PackageTypes] AS pt
ON il.PackageTypeID = pt.PackageTypeID
INNER JOIN [stg].[Sales_Customers] AS c
ON i.CustomerID = c.CustomerID
INNER JOIN [stg].[Sales_Customers] AS bt
ON i.BillToCustomerID = bt.CustomerID
OPTION (LABEL = 'CTAS : [SalesFact]')


PRINT 'CREATE  [[StockItemDimensions]]]'
GO
CREATE TABLE [prd].[StockItemDimensions]
WITH
(
    DISTRIBUTION = REPLICATE
,   CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT si.StockItemID AS [WWI Stock Item ID],
       si.StockItemName AS [Stock Item],
	   ISNULL(c.ColorName, N'N/A') AS Color,
	   spt.PackageTypeName AS [Selling Package],
       bpt.PackageTypeName AS [Buying Package],
	   ISNULL(si.Brand, N'N/A') AS Brand,
	   ISNULL(si.Size, N'N/A') AS Size,
	   si.LeadTimeDays AS [Lead Time Days],
	   si.QuantityPerOuter AS [Quantity Per Outer],
       si.IsChillerStock AS [Is Chiller Stock],
	   ISNULL(si.Barcode, N'N/A') AS Barcode,
	   si.TaxRate AS [Tax Rate],
	   si.UnitPrice AS [Unit Price],
	   si.RecommendedRetailPrice AS [Recommended Retail Price],
       si.TypicalWeightPerUnit AS [Typical Weight Per Unit],
	   si.Photo AS Photo,
	   si.ValidFrom AS [Valid From],
	   si.ValidTo AS [Valid To]
FROM [stg].[Warehouse_StockItems] si
INNER JOIN [stg].[Warehouse_PackageTypes] AS spt
ON si.UnitPackageID = spt.PackageTypeID
INNER JOIN [stg].[Warehouse_PackageTypes] AS bpt
ON si.OuterPackageID = bpt.PackageTypeID
LEFT OUTER JOIN [stg].[Warehouse_Colors] AS c
ON si.ColorID = c.ColorID
OPTION (LABEL = 'CTAS : [StockItemDimensions]')



PRINT 'CREATE  [[StockItemHoldingFacts]]]'
GO
CREATE TABLE [prd].[StockItemHoldingFacts]
WITH
(
    DISTRIBUTION = HASH([WWI Stock Item ID])
,   CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT 
       sih.StockItemID AS [WWI Stock Item ID],
	   sih.QuantityOnHand AS [Quantity On Hand],
       sih.BinLocation AS [Bin Location],
       sih.LastStocktakeQuantity AS [Last Stocktake Quantity],
       sih.LastCostPrice AS [Last Cost Price],
       sih.ReorderLevel AS [Reorder Level],
       sih.TargetStockLevel AS [Target Stock Level]
FROM [stg].[Warehouse_StockItemHoldings] AS sih
OPTION (LABEL = 'CTAS : [StockItemHoldingFacts]')



PRINT 'CREATE  [[SupplierDimensions]]]'
GO
CREATE TABLE [prd].[SupplierDimensions]
WITH
(
    DISTRIBUTION = REPLICATE
,   CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT s.SupplierID AS [WWI Supplier ID],
       s.SupplierName AS Supplier,
	   sc.SupplierCategoryName AS Category,
	   p.FullName AS [Primary Contact],
	   s.SupplierReference AS [Supplier Reference],
       s.PaymentDays AS [Payment Days],
	   s.DeliveryPostalCode AS [Postal Code],
	   s.ValidFrom AS [Valid From],
	   s.ValidTo AS [Valid To]
FROM [stg].[Purchasing_Suppliers] AS s
INNER JOIN [stg].[Purchasing_SupplierCategories] AS sc
ON s.SupplierCategoryID = sc.SupplierCategoryID
INNER JOIN [stg].[Application_People] AS p
ON s.PrimaryContactPersonID = p.PersonID
OPTION (LABEL = 'CTAS : [SupplierDimensions]')




PRINT 'CREATE  [[TransactionTypeDimensions]]'
GO
CREATE TABLE [prd].[TransactionTypeDimensions]
WITH
(
    DISTRIBUTION = REPLICATE
,   CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT p.TransactionTypeID AS [WWI Transaction Type ID],
       p.TransactionTypeName AS [Transaction Type],
	   p.ValidFrom AS [Valid From],
	   p.ValidTo AS [Valid To]
FROM [stg].[Application_TransactionTypes] AS p
OPTION (LABEL = 'CTAS : [TransactionTypeDimensions]')


PRINT 'CREATE  [[TransactionsFact]]'
GO
CREATE TABLE [prd].[TransactionsFact]
WITH
(
    DISTRIBUTION = HASH([WWI Supplier Transaction ID])
,   CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT CAST(ct.TransactionDate AS date) AS [Date Key],
	   COALESCE(i.CustomerID, ct.CustomerID) AS [WWI Customer ID],
	   ct.CustomerID AS [WWI Bill To Customer ID],
	   CAST(NULL AS int) AS [WWI Supplier ID],
	   ct.TransactionTypeID AS [WWI Transaction Type ID],
	   ct.PaymentMethodID AS [WWI Payment Method ID],
       ct.CustomerTransactionID AS [WWI Customer Transaction ID],
       CAST(NULL AS int) AS [WWI Supplier Transaction ID],
       ct.InvoiceID AS [WWI Invoice ID],
       CAST(NULL AS int) AS [WWI Purchase Order ID],
       CAST(NULL AS nvarchar(20)) AS [Supplier Invoice Number],
       ct.AmountExcludingTax AS [Total Excluding Tax],
       ct.TaxAmount AS [Tax Amount],
       ct.TransactionAmount AS [Total Including Tax],
       ct.OutstandingBalance AS [Outstanding Balance],
       ct.IsFinalized AS [Is Finalized]
FROM [stg].[Sales_CustomerTransactions] AS ct
LEFT OUTER JOIN [stg].[Sales_Invoices] AS i
ON ct.InvoiceID = i.InvoiceID

UNION ALL

SELECT CAST(st.TransactionDate AS date) AS [Date Key],
       CAST(NULL AS int) AS [WWI Customer ID],
	   CAST(NULL AS int) AS [WWI Bill To Customer ID],
	   st.SupplierID AS [WWI Supplier ID],
	   st.TransactionTypeID AS [WWI Transaction Type ID],
	   st.PaymentMethodID AS [WWI Payment Method ID],
       CAST(NULL AS int) AS [WWI Customer Transaction ID],
       st.SupplierTransactionID AS [WWI Supplier Transaction ID],
       CAST(NULL AS int) AS [WWI Invoice ID],
       st.PurchaseOrderID AS [WWI Purchase Order ID],
       st.SupplierInvoiceNumber AS [Supplier Invoice Number],
       st.AmountExcludingTax AS [Total Excluding Tax],
       st.TaxAmount AS [Tax Amount],
       st.TransactionAmount AS [Total Including Tax],
       st.OutstandingBalance AS [Outstanding Balance],
       st.IsFinalized AS [Is Finalized]
FROM [stg].[Purchasing_SupplierTransactions] AS st
OPTION (LABEL = 'CTAS : [TransactionsFact]')