SET ANSI_NULLS ON
GO



-- SECTION TO DROP Staging TABLES 
IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Application_Cities') )
    DROP  TABLE stg.Application_Cities
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Application_Countries') )
    DROP  TABLE stg.Application_Countries
GO


IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Application_DeliveryMethods') )
    DROP  TABLE stg.Application_DeliveryMethods
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Application_PaymentMethods') )
    DROP  TABLE stg.Application_PaymentMethods
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Application_People') )
    DROP  TABLE stg.Application_People
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Application_StateProvinces') )
    DROP  TABLE stg.Application_StateProvinces
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Application_TransactionTypes') )
    DROP  TABLE stg.Application_TransactionTypes
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('[stg].[DateDimensions]') )
    DROP  TABLE [stg].[DateDimensions]
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Purchasing_PurchaseOrderLines') )
    DROP  TABLE stg.Purchasing_PurchaseOrderLines
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Purchasing_PurchaseOrders') )
    DROP  TABLE stg.Purchasing_PurchaseOrders
GO


IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Purchasing_SupplierCategories') )
    DROP  TABLE stg.Purchasing_SupplierCategories
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Purchasing_Suppliers') )
    DROP  TABLE stg.Purchasing_Suppliers
GO

--SupplierTransactions

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Purchasing_SupplierTransactions') )
    DROP  TABLE stg.Purchasing_SupplierTransactions
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Sales_BuyingGroups') )
    DROP  TABLE stg.Sales_BuyingGroups
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Sales_CustomerCategories') )
    DROP  TABLE stg.Sales_CustomerCategories
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Sales_Customers') )
    DROP  TABLE stg.Sales_Customers
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Sales_CustomerTransactions') )
    DROP  TABLE stg.Sales_CustomerTransactions
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Sales_InvoiceLines') )
    DROP  TABLE stg.Sales_InvoiceLines
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Sales_Invoices') )
    DROP  TABLE stg.Sales_Invoices
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Sales_OrderLines') )
    DROP  TABLE stg.Sales_OrderLines
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Sales_Orders') )
    DROP  TABLE stg.Sales_Orders
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Sales_SpecialDeals') )
    DROP  TABLE stg.Sales_SpecialDeals
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Warehouse_ColdRoomTemperatures') )
    DROP  TABLE stg.Warehouse_ColdRoomTemperatures
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Warehouse_Colors') )
    DROP  TABLE stg.Warehouse_Colors
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Warehouse_PackageTypes') )
    DROP  TABLE stg.Warehouse_PackageTypes
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Warehouse_StockGroups') )
    DROP  TABLE stg.Warehouse_StockGroups
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Warehouse_StockItemHoldings') )
    DROP  TABLE stg.Warehouse_StockItemHoldings
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Warehouse_StockItems') )
    DROP  TABLE stg.Warehouse_StockItems
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Warehouse_StockItemStockGroups') )
    DROP  TABLE stg.Warehouse_StockItemStockGroups
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Warehouse_StockItemTransactions') )
    DROP  TABLE stg.Warehouse_StockItemTransactions
GO

IF EXISTS ( SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('stg.Warehouse_VehicleTemperatures') )
    DROP  TABLE stg.Warehouse_VehicleTemperatures
GO


IF EXISTS (SELECT name FROM sys.schemas WHERE name = N'stg')
   BEGIN
      PRINT 'Dropping the stg schema'
      DROP SCHEMA [stg]
END
GO
PRINT 'Creating the stg schema'
GO
CREATE SCHEMA [stg]
GO


PRINT 'CREATING [Application_Cities]'
GO


--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Application_Cities]
(
	[CityID] [int] NOT NULL,
	[CityName] [nvarchar](50) NOT NULL,
	[StateProvinceID] [int] NOT NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Application_Cities]'
GO

INSERT INTO [stg].[Application_Cities]
SELECT  
	[CityID] ,
	[CityName] ,
	[StateProvinceID],
	[LatestRecordedPopulation],
	[LastEditedBy],
	[ValidFrom],
	[ValidTo] 
FROM [ext].[Application_Cities];
GO

PRINT 'CREATING [Application_Countries]'
GO

CREATE  TABLE [stg].[Application_Countries]
(
	[CountryID] [int] NOT NULL,
	[CountryName] [nvarchar](60) NOT NULL,
	[FormalName] [nvarchar](60) NOT NULL,
	[IsoAlpha3Code] [nvarchar](3) NULL,
	[IsoNumericCode] [int] NULL,
	[CountryType] [nvarchar](20) NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[Continent] [nvarchar](30) NOT NULL,
	[Region] [nvarchar](30) NOT NULL,
	[Subregion] [nvarchar](30) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL ,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Application_Countries]'
GO

INSERT INTO [stg].[Application_Countries]
SELECT
	[CountryID], 
	[CountryName] ,
	[FormalName],
	[IsoAlpha3Code],
	[IsoNumericCode],
	[CountryType],
	[LatestRecordedPopulation],
	[Continent],
	[Region],
	[Subregion],
	[LastEditedBy],
	[ValidFrom],
	[ValidTo]
FROM [ext].[Application_Countries];

PRINT 'CREATING [Application_DeliveryMethods]'
GO

CREATE TABLE stg.Application_DeliveryMethods
(
	[DeliveryMethodID] [int] NOT NULL,
	[DeliveryMethodName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO


PRINT 'INSERTING [Application_DeliveryMethods]'
GO
INSERT INTO stg.Application_DeliveryMethods
SELECT 
	[DeliveryMethodID] ,
	[DeliveryMethodName],
	[LastEditedBy],
	[ValidFrom],
	[ValidTo]
FROM ext.Application_DeliveryMethods


PRINT 'CREATING [Application_PaymentMethods]'
GO

CREATE TABLE stg.Application_PaymentMethods
(
	[PaymentMethodID] [int] NOT NULL,
	[PaymentMethodName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Application_PaymentMethods]'
GO
INSERT INTO stg.Application_PaymentMethods
SELECT
	[PaymentMethodID] ,
	[PaymentMethodName] ,
	[LastEditedBy] ,
	[ValidFrom] ,
	[ValidTo]
FROM ext.Application_PaymentMethods


PRINT 'CREATING [Application_People]'
GO

CREATE TABLE stg.Application_People
(
	[PersonID] [int] NOT NULL,
	[FullName] [nvarchar](50) NOT NULL,
	[PreferredName] [nvarchar](50) NOT NULL,
	[SearchName] [nvarchar](101) NOT NULL,
	[IsPermittedToLogon] [bit] NOT NULL,
	[LogonName] [nvarchar](50) NULL,
	[IsExternalLogonProvider] [bit] NOT NULL,
	[IsSystemUser] [bit] NOT NULL,
	[IsEmployee] [bit] NOT NULL,
	[IsSalesperson] [bit] NOT NULL,
	[UserPreferences] [nvarchar](4000) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[FaxNumber] [nvarchar](20) NULL,
	[EmailAddress] [nvarchar](256) NULL,
	[CustomFields] [nvarchar](4000) NULL,
	[OtherLanguages] [nvarchar](4000) NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Application_People]'
GO
INSERT INTO stg.Application_People
SELECT
	[PersonID],
	[FullName],
	[PreferredName],
	[SearchName],
	[IsPermittedToLogon],
	[LogonName],
	[IsExternalLogonProvider],
	[IsSystemUser],
	[IsEmployee],
	[IsSalesperson],
	[UserPreferences],
	[PhoneNumber],
	[FaxNumber],
	[EmailAddress] ,
	[CustomFields],
	[OtherLanguages] ,
	[LastEditedBy],
	[ValidFrom],
	[ValidTo]
FROM ext.Application_People


PRINT 'CREATING [Application_StateProvinces]'
GO
CREATE  TABLE stg.Application_StateProvinces(
	[StateProvinceID] [int] NOT NULL,
	[StateProvinceCode] [nvarchar](5) NOT NULL,
	[StateProvinceName] [nvarchar](50) NOT NULL,
	[CountryID] [int] NOT NULL,
	[SalesTerritory] [nvarchar](50) NOT NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7)  NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Application_StateProvinces]'
GO
INSERT INTO stg.Application_StateProvinces

SELECT
	[StateProvinceID] ,
	[StateProvinceCode],
	[StateProvinceName] ,
	[CountryID] ,
	[SalesTerritory] ,
	[LatestRecordedPopulation],
	[LastEditedBy] ,
	[ValidFrom],
	[ValidTo]
FROM ext.Application_StateProvinces

PRINT 'CREATING [Application_TransactionTypes]'
GO


CREATE  TABLE [stg].[Application_TransactionTypes](
	[TransactionTypeID] [int] NOT NULL,
	[TransactionTypeName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7)  NOT NULL,
	[ValidTo] [datetime2](7)
	)
WITH (HEAP);
GO

PRINT 'INSERTING [Application_SystemParameters]'
GO
INSERT INTO stg.[Application_TransactionTypes]

SELECT
	[TransactionTypeID] ,
	[TransactionTypeName] ,
	[LastEditedBy],
	[ValidFrom] ,
	[ValidTo] 
FROM ext.[Application_TransactionTypes]

PRINT 'CREATING [stg].[DateDimensions]'
GO

CREATE  TABLE [stg].[DateDimensions]
(	
	[Date] [datetime2](7) NOT NULL,
	[DateKey] int NOT NULL,
	[Day Number] int NOT NULL,
	[Day] int NOT NULL,
	[Day of Year] int NOT NULL,
	[Day of Year Number] int NOT NULL,
	[Day of Week] [nvarchar](10) NOT NULL,
	[Day of Week Number] int NOT NULL,
	[Week of Year] int NOT NULL,
	[Month] [nvarchar](10) NOT NULL,
	[Short Month] [nvarchar](10) NOT NULL,
	[Quarter] [nvarchar](10) NOT NULL,
	[Half of Year] [nvarchar](10) NOT NULL,
	[Beginning of Month] [nvarchar](10) NOT NULL,
	[Beginning of Quarter] [nvarchar](10) NOT NULL,
	[Beginning of Half of Year] [nvarchar](10) NOT NULL,
	[Beginning of Year] [nvarchar](10) NOT NULL,
	[Beginning of Month Label] [nvarchar](40) NOT NULL,
	[Beginning of Month Label Short] [nvarchar](40) NOT NULL,
	[Beginning of Quarter Label] [nvarchar](40) NOT NULL,
	[Beginning of Quarter Label Short] [nvarchar](40) NOT NULL,
	[Beginning of Half Year Label] [nvarchar](40) NOT NULL,	
	[Beginning of Half Year Label Short] [nvarchar](40) NOT NULL,
	[Beginning of Year Label] [nvarchar](40) NOT NULL,
	[Beginning of Year Label Short] [nvarchar](40) NOT NULL,
	[Calendar Day Label] [nvarchar](40) NOT NULL,
	[Calendar Day Label Short] [nvarchar](40) NOT NULL,
	[Calendar Week Number] int NOT NULL,
	[Calendar Week Label] [nvarchar](40) NOT NULL,
	[Calendar Month Number] int NOT NULL,
	[Calendar Month Label] [nvarchar](40) NOT NULL,
	[Calendar Month Year Label] [nvarchar](40) NOT NULL,
	[Calendar Quarter Number] int NOT NULL,
	[Calendar Quarter Label] [nvarchar](40) NOT NULL,
	[Calendar Quarter Year Label] [nvarchar](40) NOT NULL,
	[Calendar Half of Year Number] int NOT NULL,
	[Calendar Half of Year Label] [nvarchar](40) NOT NULL,
	[Calendar Year Half of Year Label] [nvarchar](40) NOT NULL,
	[Calendar Year] int,
	[Calendar Year Label] [nvarchar](40) NOT NULL, 
	[Fiscal Month Number] int NOT NULL,
	[Fiscal Month Label] [nvarchar](40) NOT NULL,
	[Fiscal Quarter Number] int NOT NULL,
	[Fiscal Quarter Label] [nvarchar](40) NOT NULL,
	[Fiscal Half of Year Number] int NOT NULL,
	[Fiscal Half of Year Label] [nvarchar](40) NOT NULL,
	[Fiscal Year] int,
	[Fiscal Year Label] [nvarchar](40) NOT NULL,
	[Date Key] int,
	[Year Week Key] int,
	[Year Month Key] int,
	[Year Quarter Key] int,
	[Year Half of Year Key] int,
	[Year Key] int,
	[Fiscal Year Month Key] int,
	[Beginning of Month Key] int,
	[Beginning of Quarter Key] int,
	[Beginning of Half of Year Key] int,
	[Beginning of Year Key] int,
	[Fiscal Year Quarter Key] int,
	[Fiscal Year Half of Year Key] int,
	[ISO Week Number] int NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [stg].[DateDimensions]'
GO

INSERT INTO [stg].[DateDimensions] 
SELECT * FROM [ext].[DateDimensions]
GO

PRINT 'CREATING [Purchasing_PurchaseOrderLines]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Purchasing_PurchaseOrderLines]
(
	[PurchaseOrderLineID] [int] NOT NULL,
	[PurchaseOrderID] [int] NOT NULL,
	[StockItemID] [int] NOT NULL,
	[OrderedOuters] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[ReceivedOuters] [int] NOT NULL,
	[PackageTypeID] [int] NOT NULL,
	[ExpectedUnitPricePerOuter] [decimal](18, 2) NULL,
	[LastReceiptDate] [date] NULL,
	[IsOrderLineFinalized] [bit] NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Purchasing_PurchaseOrderLines]'
GO

INSERT INTO  [stg].[Purchasing_PurchaseOrderLines] 
SELECT 
	[PurchaseOrderLineID],
	[PurchaseOrderID],
	[StockItemID] ,
	[OrderedOuters] ,
	[Description],
	[ReceivedOuters] ,
	[PackageTypeID],
	[ExpectedUnitPricePerOuter],
	[LastReceiptDate] ,
	[IsOrderLineFinalized],
	[LastEditedBy] ,
	[LastEditedWhen] 
FROM [ext].[Purchasing_PurchaseOrderLines]



PRINT 'CREATING [Purchasing_PurchaseOrders]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Purchasing_PurchaseOrders]
(
	[PurchaseOrderID] [int] NOT NULL,
	[SupplierID] [int] NOT NULL,
	[OrderDate] [date] NOT NULL,
	[DeliveryMethodID] [int] NOT NULL,
	[ContactPersonID] [int] NOT NULL,
	[ExpectedDeliveryDate] [date] NULL,
	[SupplierReference] [nvarchar](20) NULL,
	[IsOrderFinalized] [bit] NOT NULL,
	[Comments] [nvarchar](4000) NULL,
	[InternalComments] [nvarchar](4000) NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Purchasing_PurchaseOrders]'
GO

INSERT INTO  [stg].[Purchasing_PurchaseOrders] 
SELECT
	[PurchaseOrderID] ,
	[SupplierID] ,
	[OrderDate],
	[DeliveryMethodID],
	[ContactPersonID],
	[ExpectedDeliveryDate],
	[SupplierReference],
	[IsOrderFinalized] ,
	[Comments] ,
	[InternalComments] ,
	[LastEditedBy] ,
	[LastEditedWhen]
FROM [ext].[Purchasing_PurchaseOrders]


PRINT 'CREATING [Purchasing_SupplierCategories]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Purchasing_SupplierCategories]
(
	[SupplierCategoryID] [int] NOT NULL,
	[SupplierCategoryName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Purchasing_SupplierCategories]'
GO

INSERT INTO  [stg].Purchasing_SupplierCategories 
SELECT

	[SupplierCategoryID],
	[SupplierCategoryName],
	[LastEditedBy] ,
	[ValidFrom],
	[ValidTo]
FROM ext.Purchasing_SupplierCategories


PRINT 'CREATING [Purchasing_Suppliers]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Purchasing_Suppliers]
(
	[SupplierID] [int] NOT NULL,
	[SupplierName] [nvarchar](100) NOT NULL,
	[SupplierCategoryID] [int] NOT NULL,
	[PrimaryContactPersonID] [int] NOT NULL,
	[AlternateContactPersonID] [int] NOT NULL,
	[DeliveryMethodID] [int] NULL,
	[DeliveryCityID] [int] NOT NULL,
	[PostalCityID] [int] NOT NULL,
	[SupplierReference] [nvarchar](20) NULL,
	[BankAccountName] [nvarchar](50) NULL,
	[BankAccountBranch] [nvarchar](50) NULL,
	[BankAccountCode] [nvarchar](20) NULL,
	[BankAccountNumber] [nvarchar](20)  NULL,
	[BankInternationalCode] [nvarchar](20) NULL,
	[PaymentDays] [int] NOT NULL,
	[InternalComments] [nvarchar](4000) NULL,
	[PhoneNumber] [nvarchar](20) NOT NULL,
	[FaxNumber] [nvarchar](20) NOT NULL,
	[WebsiteURL] [nvarchar](256) NOT NULL,
	[DeliveryAddressLine1] [nvarchar](60) NOT NULL,
	[DeliveryAddressLine2] [nvarchar](60) NULL,
	[DeliveryPostalCode] [nvarchar](10) NOT NULL,
	[DeliveryLocation] [varbinary](8000) NULL,
	[PostalAddressLine1] [nvarchar](60) NOT NULL,
	[PostalAddressLine2] [nvarchar](60) NULL,
	[PostalPostalCode] [nvarchar](10) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7)  NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Purchasing_Suppliers]'
GO

INSERT INTO  [stg].[Purchasing_Suppliers] 
SELECT

	[SupplierID] ,
	[SupplierName],
	[SupplierCategoryID],
	[PrimaryContactPersonID],
	[AlternateContactPersonID],
	[DeliveryMethodID],
	[DeliveryCityID],
	[PostalCityID],
	[SupplierReference],
	[BankAccountName],
	[BankAccountBranch] ,
	[BankAccountCode],
	[BankAccountNumber],
	[BankInternationalCode],
	[PaymentDays],
	[InternalComments],
	[PhoneNumber],
	[FaxNumber] ,
	[WebsiteURL],
	[DeliveryAddressLine1],
	[DeliveryAddressLine2],
	[DeliveryPostalCode],
	[DeliveryLocation] ,
	[PostalAddressLine1],
	[PostalAddressLine2],
	[PostalPostalCode],
	[LastEditedBy],
	[ValidFrom],
	[ValidTo] 
FROM ext.[Purchasing_Suppliers]


PRINT 'CREATING [Purchasing_SupplierTransactions]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Purchasing_SupplierTransactions]
(
	[SupplierTransactionID] [int] NOT NULL,
	[SupplierID] [int] NOT NULL,
	[TransactionTypeID] [int] NOT NULL,
	[PurchaseOrderID] [int] NULL,
	[PaymentMethodID] [int] NULL,
	[SupplierInvoiceNumber] [nvarchar](20) NULL,
	[TransactionDate] [date] NOT NULL,
	[AmountExcludingTax] [decimal](18, 2) NOT NULL,
	[TaxAmount] [decimal](18, 2) NOT NULL,
	[TransactionAmount] [decimal](18, 2) NOT NULL,
	[OutstandingBalance] [decimal](18, 2) NOT NULL,
	[FinalizationDate] [date] NULL,
	[IsFinalized] bit,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Purchasing_SupplierTransactions]'
GO

INSERT INTO  [stg].[Purchasing_SupplierTransactions] 
SELECT

	[SupplierTransactionID],
	[SupplierID] ,
	[TransactionTypeID],
	[PurchaseOrderID],
	[PaymentMethodID],
	[SupplierInvoiceNumber],
	[TransactionDate],
	[AmountExcludingTax],
	[TaxAmount],
	[TransactionAmount],
	[OutstandingBalance],
	[FinalizationDate],
	[IsFinalized],
	[LastEditedBy],
	[LastEditedWhen]

FROM ext.[Purchasing_SupplierTransactions]

PRINT 'CREATING [Sales_BuyingGroups]'
GO

CREATE  TABLE [stg].[Sales_BuyingGroups]
(
	[BuyingGroupID] [int] NOT NULL,
	[BuyingGroupName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Purchasing_PurchaseOrderLines]'
GO

INSERT INTO  [stg].[Sales_BuyingGroups] 
SELECT
	[BuyingGroupID] ,
	[BuyingGroupName],
	[LastEditedBy],
	[ValidFrom],
	[ValidTo]
FROM  [ext].[Sales_BuyingGroups] 



PRINT 'CREATING [Sales_CustomerCategories]'
GO

CREATE  TABLE [stg].[Sales_CustomerCategories]
(
	[CustomerCategoryID] [int] NOT NULL,
	[CustomerCategoryName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Sales_CustomerCategories]'
GO

INSERT INTO  [stg].[Sales_CustomerCategories] 
SELECT
	[CustomerCategoryID],
	[CustomerCategoryName],
	[LastEditedBy],
	[ValidFrom],
	[ValidTo]
FROM [ext].[Sales_CustomerCategories] 



PRINT 'CREATING [Sales_Customers]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Sales_Customers]
(
	[CustomerID] [int] NOT NULL,
	[CustomerName] [nvarchar](100) NOT NULL,
	[BillToCustomerID] [int] NOT NULL,
	[CustomerCategoryID] [int] NOT NULL,
	[BuyingGroupID] [int] NULL,
	[PrimaryContactPersonID] [int] NOT NULL,
	[AlternateContactPersonID] [int] NULL,
	[DeliveryMethodID] [int] NOT NULL,
	[DeliveryCityID] [int] NOT NULL,
	[PostalCityID] [int] NOT NULL,
	[CreditLimit] [decimal](18, 2) NULL,
	[AccountOpenedDate] [date] NOT NULL,
	[StandardDiscountPercentage] [decimal](18, 3) NOT NULL,
	[IsStatementSent] [bit] NOT NULL,
	[IsOnCreditHold] [bit] NOT NULL,
	[PaymentDays] [int] NOT NULL,
	[PhoneNumber] [nvarchar](20) NOT NULL,
	[FaxNumber] [nvarchar](20) NOT NULL,
	[DeliveryRun] [nvarchar](5) NULL,
	[RunPosition] [nvarchar](5) NULL,
	[WebsiteURL] [nvarchar](256) NOT NULL,
	[DeliveryAddressLine1] [nvarchar](60) NOT NULL,
	[DeliveryAddressLine2] [nvarchar](60) NULL,
	[DeliveryPostalCode] [nvarchar](10) NOT NULL,
	[DeliveryLocation] varbinary(8000) NULL,
	[PostalAddressLine1] [nvarchar](60) NOT NULL,
	[PostalAddressLine2] [nvarchar](60) NULL,
	[PostalPostalCode] [nvarchar](10) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Sales_Customers]'
GO

INSERT INTO  [stg].[Sales_Customers] 
SELECT
	[CustomerID],
	[CustomerName] ,
	[BillToCustomerID],
	[CustomerCategoryID],
	[BuyingGroupID],
	[PrimaryContactPersonID],
	[AlternateContactPersonID],
	[DeliveryMethodID],
	[DeliveryCityID],
	[PostalCityID],
	[CreditLimit],
	[AccountOpenedDate],
	[StandardDiscountPercentage],
	[IsStatementSent] ,
	[IsOnCreditHold] ,
	[PaymentDays] ,
	[PhoneNumber],
	[FaxNumber],
	[DeliveryRun],
	[RunPosition],
	[WebsiteURL] ,
	[DeliveryAddressLine1],
	[DeliveryAddressLine2],
	[DeliveryPostalCode] ,
	[DeliveryLocation],
	[PostalAddressLine1],
	[PostalAddressLine2],
	[PostalPostalCode],
	[LastEditedBy],
	[ValidFrom],
	[ValidTo]
FROM  [ext].[Sales_Customers] 


PRINT 'CREATING [Sales_CustomerTransactions]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Sales_CustomerTransactions]
(
	[CustomerTransactionID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[TransactionTypeID] [int] NOT NULL,
	[InvoiceID] [int] NULL,
	[PaymentMethodID] [int] NULL,
	[TransactionDate] [date] NOT NULL,
	[AmountExcludingTax] [decimal](18, 2) NOT NULL,
	[TaxAmount] [decimal](18, 2) NOT NULL,
	[TransactionAmount] [decimal](18, 2) NOT NULL,
	[OutstandingBalance] [decimal](18, 2) NOT NULL,
	[FinalizationDate] [date] NULL,
	[IsFinalized]  bit,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Sales_CustomerTransactions]'
GO

INSERT INTO  [stg].[Sales_CustomerTransactions] 
SELECT
	[CustomerTransactionID] ,
	[CustomerID],
	[TransactionTypeID],
	[InvoiceID],
	[PaymentMethodID],
	[TransactionDate],
	[AmountExcludingTax],
	[TaxAmount],
	[TransactionAmount],
	[OutstandingBalance],
	[FinalizationDate],
	[IsFinalized],
	[LastEditedBy],
	[LastEditedWhen]
FROM  [stg].[Sales_CustomerTransactions] 

PRINT 'CREATING [Sales_InvoiceLines]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Sales_InvoiceLines]
(
	[InvoiceLineID] [int] NOT NULL,
	[InvoiceID] [int] NOT NULL,
	[StockItemID] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[PackageTypeID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[TaxRate] [decimal](18, 3) NOT NULL,
	[TaxAmount] [decimal](18, 2) NOT NULL,
	[LineProfit] [decimal](18, 2) NOT NULL,
	[ExtendedPrice] [decimal](18, 2) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Sales_InvoiceLines]'
GO

INSERT INTO  [stg].[Sales_InvoiceLines] 
SELECT
	[InvoiceLineID] ,
	[InvoiceID],
	[StockItemID],
	[Description],
	[PackageTypeID],
	[Quantity] ,
	[UnitPrice],
	[TaxRate] ,
	[TaxAmount],
	[LineProfit],
	[ExtendedPrice],
	[LastEditedBy],
	[LastEditedWhen]
FROM  [ext].[Sales_InvoiceLines] 

PRINT 'CREATING [Sales_InvoiceLines]'
GO
--Sales_Invoices

PRINT 'CREATING [Sales_Invoices]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Sales_Invoices]
(
	[InvoiceID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[BillToCustomerID] [int] NOT NULL,
	[OrderID] [int] NULL,
	[DeliveryMethodID] [int] NOT NULL,
	[ContactPersonID] [int] NOT NULL,
	[AccountsPersonID] [int] NOT NULL,
	[SalespersonPersonID] [int] NOT NULL,
	[PackedByPersonID] [int] NOT NULL,
	[InvoiceDate] [date] NOT NULL,
	[CustomerPurchaseOrderNumber] [nvarchar](20) NULL,
	[IsCreditNote] [bit] NOT NULL,
	[CreditNoteReason] [nvarchar](4000) NULL,
	[Comments] [nvarchar](4000) NULL,
	[DeliveryInstructions] [nvarchar](4000) NULL,
	[InternalComments] [nvarchar](4000) NULL,
	[TotalDryItems] [int] NOT NULL,
	[TotalChillerItems] [int] NOT NULL,
	[DeliveryRun] [nvarchar](5) NULL,
	[RunPosition] [nvarchar](5) NULL,
	[ReturnedDeliveryData] [nvarchar](4000) NULL,
	[ConfirmedDeliveryTime] [datetime2](7)  NULL,
	[ConfirmedReceivedBy]  [nvarchar](4000) NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Sales_Invoices]'
GO

INSERT INTO  [stg].[Sales_Invoices] 
SELECT
	[InvoiceID] ,
	[CustomerID],
	[BillToCustomerID],
	[OrderID] ,
	[DeliveryMethodID],
	[ContactPersonID] ,
	[AccountsPersonID],
	[SalespersonPersonID] ,
	[PackedByPersonID] ,
	[InvoiceDate],
	[CustomerPurchaseOrderNumber] ,
	[IsCreditNote] ,
	[CreditNoteReason] ,
	[Comments],
	[DeliveryInstructions] ,
	[InternalComments] ,
	[TotalDryItems],
	[TotalChillerItems] ,
	[DeliveryRun] ,
	[RunPosition] ,
	[ReturnedDeliveryData] ,
	[ConfirmedDeliveryTime],
	[ConfirmedReceivedBy] ,
	[LastEditedBy] ,
	[LastEditedWhen]
FROM [ext].[Sales_Invoices]



PRINT 'CREATING [Sales_OrderLines]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Sales_OrderLines]
(
	[OrderLineID] [int] NOT NULL,
	[OrderID] [int] NOT NULL,
	[StockItemID] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[PackageTypeID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[TaxRate] [decimal](18, 3) NOT NULL,
	[PickedQuantity] [int] NOT NULL,
	[PickingCompletedWhen] [datetime2](7) NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Sales_OrderLines]'
GO

INSERT INTO  [stg].[Sales_OrderLines]
SELECT
	[OrderLineID],
	[OrderID] ,
	[StockItemID] ,
	[Description] ,
	[PackageTypeID],
	[Quantity] ,
	[UnitPrice],
	[TaxRate],
	[PickedQuantity] ,
	[PickingCompletedWhen],
	[LastEditedBy],
	[LastEditedWhen]
FROM [ext].[Sales_OrderLines]

PRINT 'CREATING [Sales_Orders]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Sales_Orders]
(
	[OrderID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[SalespersonPersonID] [int] NOT NULL,
	[PickedByPersonID] [int] NULL,
	[ContactPersonID] [int] NOT NULL,
	[BackorderOrderID] [int] NULL,
	[OrderDate] [date] NOT NULL,
	[ExpectedDeliveryDate] [date] NOT NULL,
	[CustomerPurchaseOrderNumber] [nvarchar](20) NULL,
	[IsUndersupplyBackordered] [bit] NOT NULL,
	[Comments] [nvarchar](4000) NULL,
	[DeliveryInstructions] [nvarchar](4000) NULL,
	[InternalComments] [nvarchar](4000) NULL,
	[PickingCompletedWhen] [datetime2](7) NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Sales_Orders]'
GO

INSERT INTO  [stg].[Sales_Orders]
SELECT
	[OrderID] ,
	[CustomerID],
	[SalespersonPersonID] ,
	[PickedByPersonID],
	[ContactPersonID] ,
	[BackorderOrderID],
	[OrderDate],
	[ExpectedDeliveryDate],
	[CustomerPurchaseOrderNumber],
	[IsUndersupplyBackordered],
	[Comments] ,
	[DeliveryInstructions],
	[InternalComments],
	[PickingCompletedWhen] ,
	[LastEditedBy],
	[LastEditedWhen] 
FROM [ext].[Sales_Orders]


PRINT 'CREATING [Sales_SpecialDeals]'
GO
CREATE  TABLE [stg].[Sales_SpecialDeals]
(
	[SpecialDealID] [int] NOT NULL,
	[StockItemID] [int] NULL,
	[CustomerID] [int] NULL,
	[BuyingGroupID] [int] NULL,
	[CustomerCategoryID] [int] NULL,
	[StockGroupID] [int] NULL,
	[DealDescription] [nvarchar](30) NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[DiscountAmount] [decimal](18, 2) NULL,
	[DiscountPercentage] [decimal](18, 3) NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Sales_SpecialDeals]'
GO

INSERT INTO  [stg].[Sales_SpecialDeals]
SELECT
	[SpecialDealID] ,
	[StockItemID] ,
	[CustomerID] ,
	[BuyingGroupID],
	[CustomerCategoryID] ,
	[StockGroupID] ,
	[DealDescription] ,
	[StartDate],
	[EndDate] ,
	[DiscountAmount] ,
	[DiscountPercentage] ,
	[UnitPrice] ,
	[LastEditedBy] ,
	[LastEditedWhen]
FROM [ext].[Sales_SpecialDeals]

PRINT 'CREATING [Warehouse_ColdRoomTemperatures]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Warehouse_ColdRoomTemperatures]
(
	[ColdRoomTemperatureID] [bigint]  NOT NULL,
	[ColdRoomSensorNumber] [int] NOT NULL,
	[RecordedWhen] [datetime2](7) NOT NULL,
	[Temperature] [decimal](10, 2) NOT NULL,
	[ValidFrom] [datetime2](7)  NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Warehouse_ColdRoomTemperatures]'
GO

INSERT INTO  [stg].[Warehouse_ColdRoomTemperatures] 
SELECT

	[ColdRoomTemperatureID] ,
	[ColdRoomSensorNumber] ,
	[RecordedWhen] ,
	[Temperature] ,
	[ValidFrom] ,
	[ValidTo] 
FROM [ext].[Warehouse_ColdRoomTemperatures] 

PRINT 'CREATING [Warehouse_Colors]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Warehouse_Colors]
(
	[ColorID] [int] NOT NULL,
	[ColorName] [nvarchar](20) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7)  NOT NULL,
	[ValidTo] [datetime2](7)  NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Warehouse_Colors]'
GO

INSERT INTO  [stg].[Warehouse_Colors] 
SELECT
	[ColorID] ,
	[ColorName],
	[LastEditedBy],
	[ValidFrom],
	[ValidTo]
FROM [ext].[Warehouse_Colors] 


PRINT 'CREATING [Warehouse_PackageTypes]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Warehouse_PackageTypes]
(
	[PackageTypeID] [int] NOT NULL,
	[PackageTypeName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Warehouse_PackageTypes]'
GO

INSERT INTO  [stg].[Warehouse_PackageTypes] 
SELECT
	[PackageTypeID],
	[PackageTypeName],
	[LastEditedBy] ,
	[ValidFrom] ,
	[ValidTo]
FROM [ext].[Warehouse_PackageTypes]

PRINT 'CREATING [Warehouse_StockGroups]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Warehouse_StockGroups]
(
	[StockGroupID] [int] NOT NULL,
	[StockGroupName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Warehouse_StockGroups]'
GO

INSERT INTO  [stg].[Warehouse_StockGroups] 
SELECT
	[StockGroupID],
	[StockGroupName] ,
	[LastEditedBy],
	[ValidFrom] ,
	[ValidTo] 
FROM [ext].[Warehouse_StockGroups]

PRINT 'CREATING [Warehouse_StockItemHoldings]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Warehouse_StockItemHoldings]
(
	[StockItemID] [int] NOT NULL,
	[QuantityOnHand] [int] NOT NULL,
	[BinLocation] [nvarchar](20) NOT NULL,
	[LastStocktakeQuantity] [int] NOT NULL,
	[LastCostPrice] [decimal](18, 2) NOT NULL,
	[ReorderLevel] [int] NOT NULL,
	[TargetStockLevel] [int] NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Warehouse_StockItemHoldings]'
GO

INSERT INTO  [stg].[Warehouse_StockItemHoldings] 
SELECT
	[StockItemID] ,
	[QuantityOnHand],
	[BinLocation] ,
	[LastStocktakeQuantity] ,
	[LastCostPrice] ,
	[ReorderLevel] ,
	[TargetStockLevel] ,
	[LastEditedBy] ,
	[LastEditedWhen] 
FROM [ext].[Warehouse_StockItemHoldings]


PRINT 'CREATING [Warehouse_StockItems]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Warehouse_StockItems]
(
	[StockItemID] [int] NOT NULL,
	[StockItemName] [nvarchar](100) NOT NULL,
	[SupplierID] [int] NOT NULL,
	[ColorID] [int] NULL,
	[UnitPackageID] [int] NOT NULL,
	[OuterPackageID] [int] NOT NULL,
	[Brand] [nvarchar](50) NULL,
	[Size] [nvarchar](20) NULL,
	[LeadTimeDays] [int] NOT NULL,
	[QuantityPerOuter] [int] NOT NULL,
	[IsChillerStock] [bit] NOT NULL,
	[Barcode] [nvarchar](50) NULL,
	[TaxRate] [decimal](18, 3) NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[RecommendedRetailPrice] [decimal](18, 2) NULL,
	[TypicalWeightPerUnit] [decimal](18, 3) NOT NULL,
	[MarketingComments] [nvarchar](4000) NULL,
	[InternalComments] [nvarchar](4000) NULL,
	[Photo] [varbinary](8000) NULL,
	[CustomFields] [nvarchar](4000) NULL,
	[Tags] [nvarchar](4000) NULL,
	[SearchDetails] [nvarchar](4000) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Warehouse_StockItems]'
GO

INSERT INTO  [stg].[Warehouse_StockItems] 
SELECT
	[StockItemID],
	[StockItemName] ,
	[SupplierID],
	[ColorID],
	[UnitPackageID],
	[OuterPackageID] ,
	[Brand],
	[Size] ,
	[LeadTimeDays] ,
	[QuantityPerOuter] ,
	[IsChillerStock],
	[Barcode] ,
	[TaxRate] ,
	[UnitPrice],
	[RecommendedRetailPrice] ,
	[TypicalWeightPerUnit],
	[MarketingComments],
	[InternalComments] ,
	[Photo] ,
	[CustomFields] ,
	[Tags] ,
	[SearchDetails],
	[LastEditedBy],
	[ValidFrom] ,
	[ValidTo] 
FROM [ext].[Warehouse_StockItems]

PRINT 'CREATING [Warehouse_StockItemStockGroups]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Warehouse_StockItemStockGroups]
(
	[StockItemStockGroupID] [int] NOT NULL,
	[StockItemID] [int] NOT NULL,
	[StockGroupID] [int] NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Warehouse_StockItemStockGroups]'
GO

INSERT INTO  [stg].[Warehouse_StockItemStockGroups] 
SELECT
	[StockItemStockGroupID] ,
	[StockItemID] ,
	[StockGroupID],
	[LastEditedBy],
	[LastEditedWhen]
FROM [ext].[Warehouse_StockItemStockGroups]



PRINT 'CREATING [Warehouse_StockItemTransactions]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Warehouse_StockItemTransactions]
(
	[StockItemTransactionID] [int] NOT NULL,
	[StockItemID] [int] NOT NULL,
	[TransactionTypeID] [int] NOT NULL,
	[CustomerID] [int] NULL,
	[InvoiceID] [int] NULL,
	[SupplierID] [int] NULL,
	[PurchaseOrderID] [int] NULL,
	[TransactionOccurredWhen] [datetime2](7) NOT NULL,
	[Quantity] [decimal](18, 3) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Warehouse_StockItemTransactions]'
GO

INSERT INTO  [stg].[Warehouse_StockItemTransactions] 
SELECT
	[StockItemTransactionID] ,
	[StockItemID],
	[TransactionTypeID],
	[CustomerID],
	[InvoiceID] ,
	[SupplierID],
	[PurchaseOrderID] ,
	[TransactionOccurredWhen] ,
	[Quantity],
	[LastEditedBy] ,
	[LastEditedWhen]
FROM [ext].[Warehouse_StockItemTransactions]

PRINT 'CREATING [Warehouse_VehicleTemperatures]'
GO

--CREATE AND DROP SECTION
CREATE  TABLE [stg].[Warehouse_VehicleTemperatures]
(
	[VehicleTemperatureID] [bigint]  NOT NULL,
	[VehicleRegistration] [nvarchar](20)  NOT NULL,
	[ChillerSensorNumber] [int] NOT NULL,
	[RecordedWhen] [datetime2](7) NOT NULL,
	[Temperature] [decimal](10, 2) NOT NULL,
	[FullSensorData] [nvarchar](1000)  NULL,
	[IsCompressed] [bit] NOT NULL,
	[CompressedSensorData] [varbinary](8000) NULL
)
WITH (HEAP);
GO

PRINT 'INSERTING [Warehouse_VehicleTemperatures]'
GO

INSERT INTO  [stg].[Warehouse_VehicleTemperatures] 
SELECT
	[VehicleTemperatureID],
	[VehicleRegistration] ,
	[ChillerSensorNumber] ,
	[RecordedWhen] ,
	[Temperature] ,
	[FullSensorData] ,
	[IsCompressed],
	[CompressedSensorData] 
FROM [ext].[Warehouse_VehicleTemperatures]
