SET ANSI_NULLS ON
GO



-- SECTION TO DROP EXTERNAL TABLES 
IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Application_Cities') )
    DROP EXTERNAL TABLE ext.Application_Cities
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Application_Countries') )
    DROP EXTERNAL TABLE ext.Application_Countries
GO


IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Application_DeliveryMethods') )
    DROP EXTERNAL TABLE ext.Application_DeliveryMethods
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Application_PaymentMethods') )
    DROP EXTERNAL TABLE ext.Application_PaymentMethods
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Application_People') )
    DROP EXTERNAL TABLE ext.Application_People
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Application_StateProvinces') )
    DROP EXTERNAL TABLE ext.Application_StateProvinces
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Application_TransactionTypes') )
    DROP EXTERNAL TABLE ext.Application_TransactionTypes
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.DateDimensions') )
    DROP EXTERNAL TABLE ext.DateDimensions
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Purchasing_PurchaseOrderLines') )
    DROP EXTERNAL TABLE ext.Purchasing_PurchaseOrderLines
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Purchasing_PurchaseOrders') )
    DROP EXTERNAL TABLE ext.Purchasing_PurchaseOrders
GO


IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Purchasing_SupplierCategories') )
    DROP EXTERNAL TABLE ext.Purchasing_SupplierCategories
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Purchasing_Suppliers') )
    DROP EXTERNAL TABLE ext.Purchasing_Suppliers
GO

--SupplierTransactions

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Purchasing_SupplierTransactions') )
    DROP EXTERNAL TABLE ext.Purchasing_SupplierTransactions
GO


-- SECTION TO DROP EXTERNAL TABLES 
IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Sales_BuyingGroups') )
    DROP EXTERNAL TABLE ext.Sales_BuyingGroups
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Sales_CustomerCategories') )
    DROP EXTERNAL TABLE ext.Sales_CustomerCategories
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Sales_Customers') )
    DROP EXTERNAL TABLE ext.Sales_Customers
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Sales_CustomerTransactions') )
    DROP EXTERNAL TABLE ext.Sales_CustomerTransactions
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Sales_InvoiceLines') )
    DROP EXTERNAL TABLE ext.Sales_InvoiceLines
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Sales_Invoices') )
    DROP EXTERNAL TABLE ext.Sales_Invoices
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Sales_OrderLines') )
    DROP EXTERNAL TABLE ext.Sales_OrderLines
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Sales_Orders') )
    DROP EXTERNAL TABLE ext.Sales_Orders
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Sales_SpecialDeals') )
    DROP EXTERNAL TABLE ext.Sales_SpecialDeals
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Warehouse_ColdRoomTemperatures') )
    DROP EXTERNAL TABLE ext.Warehouse_ColdRoomTemperatures
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Warehouse_Colors') )
    DROP EXTERNAL TABLE ext.Warehouse_Colors
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Warehouse_PackageTypes') )
    DROP EXTERNAL TABLE ext.Warehouse_PackageTypes
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Warehouse_StockGroups') )
    DROP EXTERNAL TABLE ext.Warehouse_StockGroups
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Warehouse_StockItemHoldings') )
    DROP EXTERNAL TABLE ext.Warehouse_StockItemHoldings
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Warehouse_StockItems') )
    DROP EXTERNAL TABLE ext.Warehouse_StockItems
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Warehouse_StockItemStockGroups') )
    DROP EXTERNAL TABLE ext.Warehouse_StockItemStockGroups
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Warehouse_StockItemTransactions') )
    DROP EXTERNAL TABLE ext.Warehouse_StockItemTransactions
GO

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('ext.Warehouse_VehicleTemperatures') )
    DROP EXTERNAL TABLE ext.Warehouse_VehicleTemperatures
GO


IF EXISTS (SELECT name FROM sys.schemas WHERE name = N'ext')
   BEGIN
      PRINT 'Dropping the ext schema'
      DROP SCHEMA [ext]
END
GO
PRINT 'Creating the ext schema'
GO
CREATE SCHEMA [ext]
GO


PRINT 'CREATING [Application_Cities]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Application_Cities]
(
	[CityID] [int] NOT NULL,
	[CityName] [nvarchar](50) NOT NULL,
	[StateProvinceID] [int] NOT NULL,
	[Location] BINARY(8000) NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Application_Cities/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO



PRINT 'CREATING [Application_Countries]'
GO

CREATE EXTERNAL TABLE [ext].[Application_Countries]
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
	[Border] BINARY(8000) NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL ,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Application_Countries/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO


PRINT 'CREATING [Application_DeliveryMethods]'
GO

CREATE EXTERNAL TABLE [ext].[Application_DeliveryMethods]
(
	[DeliveryMethodID] [int] NOT NULL,
	[DeliveryMethodName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Application_DeliveryMethods/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO




PRINT 'CREATING [Application_PaymentMethods]'
GO

CREATE EXTERNAL TABLE [ext].[Application_PaymentMethods]
(
	[PaymentMethodID] [int] NOT NULL,
	[PaymentMethodName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Application_PaymentMethods/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO




--Application_People

PRINT 'CREATING [Application_People]'
GO

CREATE EXTERNAL TABLE [ext].[Application_People]
(
	[PersonID] [int] NOT NULL,
	[FullName] [nvarchar](50) NOT NULL,
	[PreferredName] [nvarchar](50) NOT NULL,
	[SearchName] [nvarchar](101) NOT NULL,
	[IsPermittedToLogon] [bit] NOT NULL,
	[LogonName] [nvarchar](50) NULL,
	[IsExternalLogonProvider] [bit] NOT NULL,
	[HashedPassword] [varbinary](8000) NULL,
	[IsSystemUser] [bit] NOT NULL,
	[IsEmployee] [bit] NOT NULL,
	[IsSalesperson] [bit] NOT NULL,
	[UserPreferences] [nvarchar](4000) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[FaxNumber] [nvarchar](20) NULL,
	[EmailAddress] [nvarchar](256) NULL,
	[Photo] [varbinary](8000) NULL,
	[CustomFields] [nvarchar](4000) NULL,
	[OtherLanguages] [nvarchar](4000) NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Application_People/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO



PRINT 'CREATING [Application_StateProvinces]'
GO
CREATE EXTERNAL TABLE [ext]. [Application_StateProvinces](
	[StateProvinceID] [int] NOT NULL,
	[StateProvinceCode] [nvarchar](5) NOT NULL,
	[StateProvinceName] [nvarchar](50) NOT NULL,
	[CountryID] [int] NOT NULL,
	[SalesTerritory] [nvarchar](50) NOT NULL,
	[Border] varbinary(8000) NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7)  NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Application_StateProvinces/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

PRINT 'CREATING [Application_SystemParameters]'


CREATE EXTERNAL TABLE [ext].[Application_TransactionTypes](
	[TransactionTypeID] [int] NOT NULL,
	[TransactionTypeName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7)  NOT NULL,
	[ValidTo] [datetime2](7)
	)
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Application_TransactionTypes/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO


--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[DateDimensions]
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
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_dbo_GetDateDimensions/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO


PRINT 'CREATING [Purchasing_PurchaseOrderLines]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Purchasing_PurchaseOrderLines]
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
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Purchasing_PurchaseOrderLines/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO


PRINT 'CREATING [Purchasing_PurchaseOrders]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Purchasing_PurchaseOrders]
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
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Purchasing_PurchaseOrders/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

PRINT 'CREATING [Purchasing_SupplierCategories]'
GO


--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Purchasing_SupplierCategories]
(
	[SupplierCategoryID] [int] NOT NULL,
	[SupplierCategoryName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Purchasing_SupplierCategories/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

PRINT 'CREATING [Purchasing_Suppliers]'
GO


--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Purchasing_Suppliers]
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
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Purchasing_Suppliers/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO


PRINT 'CREATING [Purchasing_SupplierTransactions]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Purchasing_SupplierTransactions]
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
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Purchasing_SupplierTransactions/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO


PRINT 'CREATING [Sales_BuyingGroups]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Sales_BuyingGroups]
(
	[BuyingGroupID] [int] NOT NULL,
	[BuyingGroupName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Sales_BuyingGroups/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

PRINT 'CREATING [Sales_CustomerCategories]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Sales_CustomerCategories]
(
	[CustomerCategoryID] [int] NOT NULL,
	[CustomerCategoryName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Sales_CustomerCategories/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

PRINT 'CREATING [Sales_Customers]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Sales_Customers]
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
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Sales_Customers/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO


PRINT 'CREATING [Sales_CustomerTransactions]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Sales_CustomerTransactions]
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
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Sales_CustomerTransactions/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

PRINT 'CREATING [Sales_InvoiceLines]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Sales_InvoiceLines]
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
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Sales_InvoiceLines/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

--Sales_Invoices

PRINT 'CREATING [Sales_Invoices]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Sales_Invoices]
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
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Sales_Invoices/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

PRINT 'CREATING [Sales_OrderLines]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Sales_OrderLines]
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
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Sales_OrderLines/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

PRINT 'CREATING [Sales_Orders]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Sales_Orders]
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
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Sales_Orders/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO


PRINT 'CREATING [Sales_SpecialDeals]'
GO
CREATE EXTERNAL TABLE [ext].[Sales_SpecialDeals]
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
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Sales_SpecialDeals/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO


PRINT 'CREATING [Warehouse_ColdRoomTemperatures]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Warehouse_ColdRoomTemperatures]
(
	[ColdRoomTemperatureID] [bigint]  NOT NULL,
	[ColdRoomSensorNumber] [int] NOT NULL,
	[RecordedWhen] [datetime2](7) NOT NULL,
	[Temperature] [decimal](10, 2) NOT NULL,
	[ValidFrom] [datetime2](7)  NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Warehouse_ColdRoomTemperatures/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

PRINT 'CREATING [Warehouse_Colors]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Warehouse_Colors]
(
	[ColorID] [int] NOT NULL,
	[ColorName] [nvarchar](20) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7)  NOT NULL,
	[ValidTo] [datetime2](7)  NOT NULL
)
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Warehouse_Colors/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

PRINT 'CREATING [Warehouse_PackageTypes]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Warehouse_PackageTypes]
(
	[PackageTypeID] [int] NOT NULL,
	[PackageTypeName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Warehouse_PackageTypes/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

PRINT 'CREATING [Warehouse_StockGroups]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Warehouse_StockGroups]
(
	[StockGroupID] [int] NOT NULL,
	[StockGroupName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Warehouse_StockGroups/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

PRINT 'CREATING [Warehouse_StockItemHoldings]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Warehouse_StockItemHoldings]
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
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Warehouse_StockItemHoldings/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO



PRINT 'CREATING [Warehouse_StockItems]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Warehouse_StockItems]
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
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Warehouse_StockItems/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO


PRINT 'CREATING [Warehouse_StockItemStockGroups]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Warehouse_StockItemStockGroups]
(
	[StockItemStockGroupID] [int] NOT NULL,
	[StockItemID] [int] NOT NULL,
	[StockGroupID] [int] NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL
)
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Warehouse_StockItemStockGroups/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO



PRINT 'CREATING [Warehouse_StockItemTransactions]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Warehouse_StockItemTransactions]
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
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Warehouse_StockItemTransactions/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

PRINT 'CREATING [Warehouse_VehicleTemperatures]'
GO

--CREATE AND DROP SECTION
CREATE EXTERNAL TABLE [ext].[Warehouse_VehicleTemperatures]
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
WITH (DATA_SOURCE = [WAREHOUSEEXTERNALDATASOURCE],LOCATION = N'/WideWorldImporters_Warehouse_VehicleTemperatures/',FILE_FORMAT = [UNCOMPRESSEDCSV],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO

PRINT 'ALL DONE'
--GO
