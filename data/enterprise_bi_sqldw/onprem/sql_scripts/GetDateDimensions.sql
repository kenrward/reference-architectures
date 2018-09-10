USE [WideWorldImporters]
GO

/****** Object:  StoredProcedure [dbo].[GetDateDimensions]    Script Date: 3/2/2018 7:08:04 PM ******/
IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[GetDateDimensions]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[GetDateDimensions]
END

/****** Object:  StoredProcedure [dbo].[GetDateDimensions]    Script Date: 3/2/2018 7:08:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetDateDimensions]
AS

DECLARE @StartDate datetime2
DECLARE @EndDate datetime2

SELECT @StartDate = DATEFROMPARTS(DATEPART(year, MIN(a.MinDate)), 1, 1),
       @EndDate = DATEFROMPARTS(DATEPART(year, GETUTCDATE()), 12, 31)
FROM (
    SELECT MIN(OrderDate) AS MinDate FROM Purchasing.PurchaseOrders
    UNION
    SELECT MIN(TransactionDate) AS MinDate FROM Purchasing.SupplierTransactions
    UNION
    SELECT MIN(TransactionDate) AS MinDate FROM Sales.CustomerTransactions
    UNION
    SELECT MIN(InvoiceDate) AS MinDate FROM Sales.Invoices
    UNION
    SELECT MIN(OrderDate) AS MinDate FROM Sales.Orders
    UNION
    SELECT MIN(TransactionOccurredWhen) AS MinDate FROM Warehouse.StockItemTransactions
) a

SELECT [Date] AS [Date],                                                  -- 2013-01-01
       FORMAT([Date], N'yyyyMMdd') AS [DateKey],                          -- 20130101 (to 20131231)
       DATEPART(day, [Date]) AS [Day Number],                             -- 1 (to last day of month)
       DATENAME(day, [Date]) AS [Day],                                    -- 1 (to last day of month)
       DATENAME(dayofyear, [Date]) AS [Day of Year],                      -- 1 (to 365)
       DATEPART(dayofyear, [Date]) AS [Day of Year Number],               -- 1 (to 365)
       DATENAME(weekday, [Date]) AS [Day of Week],                        -- Tuesday
       DATEPART(weekday, [Date]) AS [Day of Week Number],                 -- 3
       DATENAME(week, [Date]) AS [Week of Year],                          -- 1
       DATENAME(month, [Date]) AS [Month],                                -- January
       FORMAT([Date], N'MMM') AS [Short Month],                           -- Jan
       N'Q' + DATENAME(quarter, [Date]) AS [Quarter],                     -- Q1 (to Q4)
       N'H' + CAST([Year Half] AS nvarchar) AS [Half of Year],            -- H1 (or H2)
       [Beginning of Month] AS [Beginning of Month],                      -- 2013-01-01
       [Beginning of Quarter] AS [Beginning of Quarter],                  -- 2013-01-01
       [Beginning of Half of Year] AS [Beginning of Half of Year],        -- 2013-01-01
       [Beginning of Year] AS [Beginning of Year],                        -- 2013-01-01
       FORMAT([Date], N'"Beginning of Month" MMMM-yyyy')
           AS [Beginning of Month Label],
       FORMAT([Date], N'"BOM" MMM-yyyy')
           AS [Beginning of Month Label Short],
       N'Beginning Of Quarter ' + DATENAME(year, [Date]) + N'-Q' +
           DATENAME(quarter, [Date]) AS [Beginning of Quarter Label],
       N'BOQ ' + DATENAME(year, [Date]) + N'-Q' +
           DATENAME(quarter, [Date])
           AS [Beginning of Quarter Label Short],
       FORMAT([Date], N'"Beginning of Half Year" yyyy-\H') +
           CAST([Year Half] AS nvarchar)
           AS [Beginning of Half Year Label],                             -- Beginning of Half Year 2013-H1
       FORMAT([Date], N'"BOH" yyyy-\H') + CAST([Year Half] AS nvarchar)
           AS [Beginning of Half Year Label Short],                       -- BOH 2013-H1
       FORMAT([Date], N'"Beginning of Year" yyyy')
           AS [Beginning of Year Label],                                  -- Beginning of Year 2013
       FORMAT([Date], N'"BOY" yyyy') AS [Beginning of Year Label Short],  -- BOY 2013
       FORMAT([Date], N'MMMM d, yyyy') AS [Calendar Day Label],           -- January 1, 2013
       FORMAT([Date], N'MMM d, yyyy') AS [Calendar Day Label Short],      -- Jan 1, 2013
       DATEPART(week, [Date]) AS [Calendar Week Number],                  -- 1
       FORMAT([Date], N'"CY"yyyy-\W') +
           RIGHT(N'00' + DATENAME(week, [Date]), 2)
           AS [Calendar Week Label],                                      -- CY2013-W1
       DATEPART(month, [Date]) AS [Calendar Month Number],                -- 1 (to 12)
       FORMAT([Date], N'"CY"yyyy-MMM') AS [Calendar Month Label],         -- CY2013-Jan
       FORMAT([Date], N'MMM-yyyy') AS [Calendar Month Year Label],        -- Jan-2013
       DATEPART(quarter, [Date]) AS [Calendar Quarter Number],            -- 1 (to 4)
       FORMAT([Date], N'"CY"yyyy-Q') + DATENAME(quarter, [Date])
           AS [Calendar Quarter Label],                                   -- CY2013-Q1
       N'Q' + DATENAME(quarter, [Date]) + FORMAT([Date], N'-yyyy')
           AS [Calendar Quarter Year Label],                              -- CY2013-Q1
       [Year Half] AS [Calendar Half of Year Number],                     -- 1 (to 2)
       FORMAT([Date], N'"CY"yyyy-\H') + CAST([Year Half] AS nvarchar)
           AS [Calendar Half of Year Label],                              -- CY2013-H1
       N'H' + CAST([Year Half] AS nvarchar) + FORMAT([Date], N'-yyyy')
           AS [Calendar Year Half of Year Label],                         -- H1-2013
       DATEPART(year, [Date]) AS [Calendar Year],                         -- 2013
       FORMAT([Date], N'"CY"yyyy') AS [Calendar Year Label],              -- CY2013
       DATEPART(month, [Fiscal Date]) AS [Fiscal Month Number],           -- 7
       FORMAT([Fiscal Date], N'"FY"yyyy-') + FORMAT([Date], N'MMM')
           AS [Fiscal Month Label],                                       -- FY2013-Jan
       DATEPART(quarter, [Fiscal Date]) AS [Fiscal Quarter Number],       -- 2
       FORMAT([Fiscal Date], N'"FY"yyyy-Q') +
           DATENAME(quarter, [Fiscal Date]) AS [Fiscal Quarter Label],    -- FY2013-Q2
       [Fiscal Year Half] AS [Fiscal Half of Year Number],                -- 1 (to 2)
       FORMAT([Fiscal Date], N'"FY"yyyy-\H') +
           CAST([Fiscal Year Half] AS nvarchar)
           AS [Fiscal Half of Year Label],                                -- FY2013-H2
       DATEPART(year, [Fiscal Date]) AS [Fiscal Year],                    -- 2013
       FORMAT([Fiscal Date], N'"FY"yyyy') AS [Fiscal Year Label],         -- FY2013
       CAST(FORMAT([Date], N'yyyyMMdd') AS int) AS [Date Key],            -- 20130101 (to 20131231)
       CAST(DATENAME(year, [Date]) +
           RIGHT(N'00' + DATENAME(week, [Date]), 2) AS int)
           AS [Year Week Key],                                            -- 201301 (to 201353)
       CAST(FORMAT([Date], N'yyyyMM') AS int) AS [Year Month Key],        -- 201301 (to 201312)
       CAST(DATENAME(year, [Date]) + DATENAME(quarter, [Date]) AS int)
           AS [Year Quarter Key],                                         -- 20131 (to 20134)
       CAST(DATENAME(year, [Date]) + CAST([Year Half] AS nvarchar) AS int)
           AS [Year Half of Year Key],                                    -- 20131 (to 20132)
       DATEPART(year, [Date]) AS [Year Key],                              -- 2013
       CAST(FORMAT([Fiscal Date], N'yyyy') + FORMAT([Date], N'MM') AS int)
           AS [Fiscal Year Month Key],                                    -- 201301 (to 201312)
       CAST(FORMAT([Beginning of Month], N'yyyyMMdd') AS int)
           AS [Beginning of Month Key],                                   -- 20130101
       FORMAT([Beginning of Quarter], N'yyyyMMdd')
           AS [Beginning of Quarter Key],                                 -- 20130101
       FORMAT([Beginning of Half of Year], N'yyyyMMdd')
           AS [Beginning of Half of Year Key],
       CAST(FORMAT([Beginning of Year], N'yyyyMMdd') AS int)
           AS [Beginning of Year Key],                                    -- 20130101
       CAST(FORMAT([Fiscal Date], N'yyyy') +
           DATENAME(quarter, [Fiscal Date]) AS int)
           AS [Fiscal Year Quarter Key],                                  -- 20131
       CAST(FORMAT([Fiscal Date], N'yyyy') +
           CAST([Fiscal Year Half] AS nvarchar) AS int)
           AS [Fiscal Year Half of Year Key],                             -- 20131
       DATEPART(ISO_WEEK, [Date]) AS [ISO Week Number]                    -- 1;
FROM (
    SELECT [Date],
           DATEADD(month, 6, [Date]) AS [Fiscal Date],
           CAST(DATEADD(month, DATEDIFF(month, 0, [Date]), 0) AS date)
               AS [Beginning of Month],
           DATEFROMPARTS(DATEPART(year, [Date]), 1, 1) AS [Beginning of Year],
           DATEFROMPARTS(DATEPART(year, [Date]), ((DATEPART(quarter, [Date]) - 1) * 3) + 1, 1)
               AS [Beginning of Quarter],
           DATEFROMPARTS(DATEPART(year, [Date]), ((DATEPART(month, [Date]) / 7) * 6) + 1, 1)
               AS [Beginning of Half of Year],
           (DATEPART(month, [Date]) / 7) + 1 AS [Year Half],
           (DATEPART(month, DATEADD(month, 6, [Date])) / 7) + 1 AS [Fiscal Year Half]
    FROM (
        SELECT TOP (DATEDIFF(day, @StartDate, @EndDate) + 1)
               DATEADD(day, ROW_NUMBER() OVER (ORDER BY s1.[object_id]) - 1, @StartDate) AS [Date]
        FROM sys.all_objects AS s1
        CROSS JOIN sys.all_objects AS s2
        ORDER BY s1.[object_id]
    ) AS gen_date
) AS gen_dates

GO


