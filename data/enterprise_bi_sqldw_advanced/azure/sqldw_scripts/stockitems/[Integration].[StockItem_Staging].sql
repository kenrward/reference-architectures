

EXEC [dbo].[CreateTable] 'Integration', 'StockItem_Staging',
N'
  [WWI Stock Item ID] int,
  [Stock Item] nvarchar(100),
  [Color] nvarchar(20),
  [Selling Package] nvarchar(50),
  [Buying Package] nvarchar(50),
  [Brand] nvarchar(50),
  [Size] nvarchar(20),
  [Lead Time Days] int,
  [Quantity Per Outer] int,
  [Is Chiller Stock] bit,
  [Barcode] nvarchar(50),
  [Tax Rate] decimal(18,3),
  [Unit Price] decimal(18,2),
  [Recommended Retail Price] decimal(18,2),
  [Typical Weight Per Unit] decimal(18,3),
  [Photo] varbinary(max) null ,
  [Valid From] datetime2(7),
  [Valid To] datetime2(7)
',
'HEAP'