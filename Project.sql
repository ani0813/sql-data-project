USE MASTER
DROP DATABASE IF EXISTS Orders_RELATIONAL_DB
GO

CREATE DATABASE Orders_RELATIONAL_DB
GO

-- drop tables
USE Orders_RELATIONAL_DB;
DROP TABLE IF EXISTS dbo.OrderDetails;
DROP TABLE IF EXISTS dbo.Products;
DROP TABLE IF EXISTS dbo.Orders;
DROP TABLE IF EXISTS dbo.EmployeeTerritories;
DROP TABLE IF EXISTS dbo.Territories;
DROP TABLE IF EXISTS dbo.Employees;
DROP TABLE IF EXISTS dbo.Shippers;
DROP TABLE IF EXISTS dbo.Customers;
DROP TABLE IF EXISTS dbo.Suppliers;
DROP TABLE IF EXISTS dbo.Categories;
DROP TABLE IF EXISTS dbo.Region;
GO

-- create tables
CREATE TABLE dbo.Region (
	RegionID INT  PRIMARY KEY,
	RegionDescription NCHAR (50) NOT NULL
);

CREATE TABLE dbo.Categories (
	CategoryID INT PRIMARY KEY,
	CategoryName NVARCHAR(15) NOT NULL,
    [Description] VARCHAR(MAX) NULL,
    Picture image NULL
);

CREATE TABLE dbo.Suppliers (
    SupplierID INT PRIMARY KEY,
	CompanyName NVARCHAR(40) NOT NULL,
	ContactName NVARCHAR(30) NULL,
	ContactTitle NVARCHAR(30) NULL,
	[Address] NVARCHAR(60) NULL,
	City NVARCHAR(15) NULL,
	Region NVARCHAR(15) NULL,
	PostalCode NVARCHAR(10) NULL,
	Country NVARCHAR(15) NULL,
	Phone NVARCHAR(24) NULL,
	Fax NVARCHAR(24) NULL,
	HomePage VARCHAR(MAX) NULL
);

CREATE TABLE dbo.Customers (
	CustomerID NCHAR(5) PRIMARY KEY,
	CompanyName NVARCHAR(40) NOT NULL,
	ContactName NVARCHAR(30) NULL,
	ContactTitle NVARCHAR(30) NULL,
	[Address] VARCHAR(60) NULL,
	City NVARCHAR(15) NULL,
	Region NVARCHAR(15) NULL,
	PostalCode NVARCHAR(10) NULL,
	Country NVARCHAR(15) NULL,
	Phone NVARCHAR(24) NULL,
	Fax NVARCHAR(24) NULL
);

CREATE TABLE dbo.Shippers(
    ShipperID INT PRIMARY KEY,
	CompanyName NVARCHAR(40) NOT NULL,
	Phone NVARCHAR(24) NULL
);

CREATE TABLE dbo.Employees (
	EmployeeID INT PRIMARY KEY,
	LastName NVARCHAR(20) NOT NULL,
	FirstName NVARCHAR(10) NOT NULL,
	Title NVARCHAR(30) NULL,
	TitleOfCourtesy NVARCHAR(25) NULL,
	BirthDate DATETIME NULL,
	HireDate DATETIME NULL,
	[Address] NVARCHAR(60) NULL,
	City NVARCHAR(15) NULL,
	Region NVARCHAR(15) NULL,
	PostalCode NVARCHAR(10) NULL,
	Country NVARCHAR(15) NULL,
	HomePhone NVARCHAR(24) NULL,
	Extension NVARCHAR(4) NULL,
	Photo IMAGE NULL,
	Notes VARCHAR(MAX) NULL,
	ReportsTo INT NULL,
	PhotoPath NVARCHAR(255) NULL,
	/*FOREIGN KEY (ReportsTo) REFERENCES dbo.Employees (EmployeeID) ON DELETE NO ACTION ON UPDATE NO ACTION*/
);

/*es kashxatacneq employee n populate aneluc heto*/
ALTER TABLE Employees
ADD FOREIGN KEY (ReportsTo) REFERENCES dbo.Employees (EmployeeID) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE dbo.Territories(
	TerritoryID NVARCHAR(20) PRIMARY KEY,
	TerritoryDescription NCHAR(50) NOT NULL,
	RegionID INT NOT NULL,
	FOREIGN KEY (RegionID) REFERENCES dbo.Region (RegionID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE dbo.EmployeeTerritories (
	EmployeeID INT NOT NULL,
	TerritoryID NVARCHAR(20) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES dbo.Employees (EmployeeID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (TerritoryID) REFERENCES dbo.Territories (TerritoryID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_empter PRIMARY KEY (EmployeeID,TerritoryID)
);

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
	CustomerID nchar(5) NULL,
	EmployeeID INT NULL,
	OrderDate datetime NULL,
	RequiredDate datetime NULL,
    ShippedDate  datetime  NULL,
    ShipVia INT NULL,
    Freight money NULL,
    ShipName nvarchar(40) NULL,
    ShipAddress NVARCHAR (60) NULL,
	ShipCity NVARCHAR(15) NULL,
    ShipRegion NVARCHAR(15) NULL,
    ShipPostalCode NVARCHAR(10) NULL,
    ShipCountry NVARCHAR(15) NULL,
    FOREIGN KEY (CustomerID ) REFERENCES dbo.Customers (CustomerID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (EmployeeID) REFERENCES dbo.Employees (EmployeeID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ShipVia) REFERENCES dbo.Shippers (ShipperID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
	ProductName NVARCHAR(40) NOT NULL,
	SupplierID INT NULL,
	CategoryID INT NULL,
	QuantityPerUnit NVARCHAR(20) NULL,
	UnitPrice MONEY NULL,
	UnitsInStock SMALLINT NULL,
	UnitsOnOrder SMALLINT NULL,
	ReorderLevel SMALLINT NULL,
	Discontinued BIT  NOT NULL,
	FOREIGN KEY (CategoryID) REFERENCES dbo.Categories (CategoryID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (SupplierID) REFERENCES dbo.Suppliers (SupplierID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE dbo.OrderDetails (
	OrderID INT NOT NULL,
	ProductID INT NOT NULL,
    UnitPrice  money NOT NULL,
    Quantity SMALLINT NOT NULL,
    Discount REAL NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES dbo.Orders (OrderID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES dbo.Products (ProductID) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT PK_OrderDeatils PRIMARY KEY (OrderID,ProductID)
);

/*Checking*/
SELECT * FROM Region;
SELECT* FROM Categories;
SELECT * FROM Suppliers;
SELECT * FROM Customers;
SELECT * FROM Shippers;
SELECT* FROM Employees;
SELECT * FROM Territories;
SELECT * FROM EmployeeTerritories;
SELECT * FROM Orders;
SELECT* FROM Products;
SELECT * FROM OrderDetails;

USE MASTER
DROP DATABASE IF EXISTS Orders_DIMENSIONAL_DW
GO

CREATE DATABASE Orders_DIMENSIONAL_DW
GO

USE Orders_DIMENSIONAL_DW;
DROP TABLE IF EXISTS [dbo].[DimShippers_SCD1];
DROP TABLE IF EXISTS [dbo].[DimEmployees_SCD2];
DROP TABLE IF EXISTS [dbo].[DimProducts_SCD4];
DROP TABLE IF EXISTS [dbo].[DimCustomers_SCD3];
GO

/*CREATING A DESTINATION TABLE DimShippers_SCD1*/
CREATE TABLE [dbo].[DimShippers_SCD1](
 [ShipperID] [int] IDENTITY(1,1) NOT NULL,
 [BusinessKey] [int] NOT NULL,
 [CompanyName] [nvarchar](40) NOT NULL,
 [Phone] [nvarchar](24) NULL
) ;
GO

/*CREATING AN ETL PROCEDURE DimShippers_SCD1_ETL*/
DROP PROCEDURE IF EXISTS dbo.DimShippers_SCD1_ETL
GO
 
CREATE PROCEDURE dbo.DimShippers_SCD1_ETL
AS BEGIN TRY
MERGE Orders_DIMENSIONAL_DW.dbo.DimShippers_SCD1 AS DST -- destination
USING Orders_RELATIONAL_DB.dbo.Shippers AS SRC -- source
ON (SRC.ShipperID = DST.BusinessKey )
WHEN NOT MATCHED THEN -- there are IDs in the source table that are not in the destination table
  INSERT (BusinessKey, CompanyName, Phone)
  VALUES (SRC.ShipperID, SRC.CompanyName, SRC.Phone)
WHEN MATCHED AND (  -- Isnull - a function that return a specified expression  when encountering null values 
	--Isnull(DST.clientname, '') if DST.clientname == NULL then it will return ''
	Isnull(DST.CompanyName, '') <> Isnull(SRC.CompanyName, '') OR
	Isnull(DST.Phone, '') <> Isnull(SRC.Phone, '')) 
	THEN
		UPDATE SET DST.CompanyName = SRC.CompanyName, DST.Phone = SRC.Phone; 
END TRY
BEGIN CATCH
    THROW
END CATCH
GO

--Checking
SELECT * FROM [dbo].[DimShippers_SCD1];
GO
EXEC DimShippers_SCD1_ETL;
GO
SELECT * FROM [dbo].[DimShippers_SCD1];
GO

-- delete part
DELETE [Orders_RELATIONAL_DB].[dbo].[Shippers]
	WHERE CompanyName = 'Speedy Express';
GO
EXEC DimShippers_SCD1_ETL;
GO
SELECT * FROM [dbo].[DimShippers_SCD1];
GO



/*CREATING A DESTINATION TABLE DimEmployees_SCD2*/
CREATE TABLE [dbo].[DimEmployees_SCD2](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[BusinessKey] [int] NOT NULL,
	[LastName] NVARCHAR(20) NOT NULL,
	[FirstName] NVARCHAR(10) NOT NULL,
	[Title] NVARCHAR(30) NULL,
	[TitleOfCourtesy] NVARCHAR(25) NULL,
	[BirthDate] DATETIME NULL,
	[HireDate] DATETIME NULL,
	[Address] NVARCHAR(60) NULL,
	[City] NVARCHAR(15) NULL,
	[Region] NVARCHAR(15) NULL,
	[PostalCode] NVARCHAR(10) NULL,
	[Country] NVARCHAR(15) NULL,
	[HomePhone] NVARCHAR(24) NULL,
	[Extension] NVARCHAR(4) NULL,
	[Photo] IMAGE NULL,
	[Notes] VARCHAR(MAX) NULL,
	[ReportsTo] INT NULL,
	[PhotoPath] NVARCHAR(255) NULL,
	ValidFrom INT NULL,
	ValidTo INT NULL,
	IsCurrent BIT NULL
) ON [PRIMARY]
GO

/*CREATING AN ETL PROCEDURE*/
DROP PROCEDURE IF EXISTS dbo.DimEmployees_SCD2_ETL
GO
 
CREATE PROCEDURE dbo.DimEmployees_SCD2_ETL AS
-- Define the dates used in validity - assume whole 24 hour cycles
DECLARE @Yesterday INT =  --20210412 = 2021 * 10000 + 4 * 100 + 12
(YEAR(DATEADD(dd, - 1, GETDATE())) * 10000)+(MONTH(DATEADD(dd, - 1, GETDATE())) * 100) + DAY(DATEADD(dd, - 1, GETDATE())) 
DECLARE @Today INT = --20210413 = 2021 * 10000 + 4 * 100 + 13
(YEAR(GETDATE()) * 10000)+(MONTH(GETDATE()) * 100) + DAY(GETDATE()) -- Outer insert - the updated records are added to the SCD2 table
INSERT INTO
   dbo.DimEmployees_SCD2 (BusinessKey,LastName,FirstName,Title,TitleOfCourtesy,BirthDate,HireDate,Address,City,Region,PostalCode,Country,HomePhone,Extension,Photo,Notes,ReportsTo,PhotoPath,ValidFrom,IsCurrent) 
   SELECT EmployeeID,LastName,FirstName,Title,TitleOfCourtesy,BirthDate,HireDate,Address,City,Region,PostalCode,Country,HomePhone,Extension,Photo,Notes,ReportsTo,PhotoPath, @Today,1 
   FROM
      (
         -- Merge statement
         MERGE INTO dbo.DimEmployees_SCD2 AS DST 
		 USING [Orders_RELATIONAL_DB].[dbo].[Employees] AS SRC 
         ON (SRC.EmployeeID = DST.BusinessKey) 			
		 -- New records inserted
         WHEN
            NOT MATCHED 
         THEN
            INSERT (BusinessKey,LastName,FirstName,Title,TitleOfCourtesy,BirthDate,HireDate,Address,City,Region,
			PostalCode,Country,HomePhone,Extension,Photo,Notes,ReportsTo,PhotoPath, ValidFrom, IsCurrent) --There is no ValidTo
      VALUES
         (SRC.EmployeeID, SRC.LastName,SRC.FirstName,SRC.Title,SRC.TitleOfCourtesy,SRC.BirthDate,SRC.HireDate,SRC.Address,SRC.City,SRC.Region,SRC.PostalCode,SRC.Country,SRC.HomePhone,SRC.Extension,SRC.Photo,SRC.Notes,SRC.ReportsTo,SRC.PhotoPath, @Today, 1)
         -- Existing records updated if data changes
      WHEN
         MATCHED AND IsCurrent = 1 AND 
         (
            ISNULL(DST.LastName, '') <> ISNULL(SRC.LastName, '') 
            OR ISNULL(DST.FirstName, '') <> ISNULL(SRC.FirstName, '') 
            OR ISNULL(DST.Title, '') <> ISNULL(SRC.Title, '') 
            OR ISNULL(DST.TitleOfCourtesy, '') <> ISNULL(SRC.TitleOfCourtesy, '') 
            OR ISNULL(DST.BirthDate, '') <> ISNULL(SRC.BirthDate, '') 
            OR ISNULL(DST.HireDate, '') <> ISNULL(SRC.HireDate, '') 
            OR ISNULL(DST.Address, '') <> ISNULL(SRC.Address, '')
			OR ISNULL(DST.City, '') <> ISNULL(SRC.City, '') 
            OR ISNULL(DST.Region, '') <> ISNULL(SRC.Region, '') 
            OR ISNULL(DST.PostalCode, '') <> ISNULL(SRC.PostalCode, '')
			OR ISNULL(DST.Country, '') <> ISNULL(SRC.Country, '')
			OR ISNULL(DST.HomePhone, '') <> ISNULL(SRC.HomePhone, '') 
            OR ISNULL(DST.Extension, '') <> ISNULL(SRC.Extension, '') 
			OR ISNULL(DST.Notes, '') <> ISNULL(SRC.Notes, '') 
            OR ISNULL(DST.ReportsTo, '') <> ISNULL(SRC.ReportsTo, '')
			OR ISNULL(DST.PhotoPath, '') <> ISNULL(SRC.PhotoPath, '')
         )
         -- Update statement for a changed dimension record, to flag as no longer active
      THEN
         UPDATE
         SET
            DST.IsCurrent = 0, 
			DST.ValidTo = @Yesterday 
			OUTPUT SRC.EmployeeID, SRC.LastName,SRC.FirstName,SRC.Title,SRC.TitleOfCourtesy,SRC.BirthDate,SRC.HireDate,SRC.Address,SRC.City,SRC.Region,SRC.PostalCode,SRC.Country,SRC.HomePhone,SRC.Extension,SRC.Photo,SRC.Notes,SRC.ReportsTo,SRC.PhotoPath, $Action AS MergeAction 
      )
      AS MRG 
   WHERE
      MRG.MergeAction = 'UPDATE' ;
GO

--Checking
SELECT * FROM [dbo].[DimEmployees_SCD2];
GO
EXEC DimEmployees_SCD2_ETL;
GO
SELECT * FROM [dbo].[DimEmployees_SCD2];
GO

DROP TABLE IF EXISTS [dbo].[DimCustomers_SCD3];


/*CREATING A DESTINATION TABLE DimCustomers_SCD3*/
CREATE TABLE [dbo].[DimCustomers_SCD3](
 [CustomerID] INT identity(1,1)  NOT NULL,
 [BusinessKey] nchar(5) NULL,
 [Address] [varchar](60) NULL, 
 [Address_Prev1] [varchar](60) NULL,
 [Address_Prev1_ValidTo] [varchar] (60) NULL,
 [Address_Prev2] [varchar](60) NULL,
 [Address_Prev2_ValidTo] [varchar] (60) NULL
) 
GO

CREATE PROCEDURE dbo.DimCustomers_SCD3_ETL
AS DECLARE @Yesterday VARCHAR(8) = CAST(YEAR(DATEADD(dd,-1,GETDATE())) AS CHAR(4)) + RIGHT('0' + CAST(MONTH(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2) + RIGHT('0' + CAST(DAY(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2)
 --20210413: string/text/char
MERGE dbo.DimCustomers_SCD3 AS DST
USING [Orders_RELATIONAL_DB].[dbo].[Customers] AS SRC
ON (SRC.CustomerID = DST.BusinessKey)
WHEN NOT MATCHED THEN
INSERT (BusinessKey, Address)
VALUES (SRC.CustomerID, SRC.Address)
WHEN MATCHED  -- there can be only one matched case
AND (DST.Address <> SRC.Address)
THEN 
	UPDATE 
	SET  
		 DST.Address_Prev1 = (CASE WHEN DST.Address <> SRC.Address THEN DST.Address ELSE DST.Address_Prev1 END)
		,DST.Address_Prev1_ValidTo = (CASE WHEN DST.Address <> SRC.Address THEN @Yesterday ELSE DST.Address_Prev1_ValidTo END)
		,DST.Address_Prev2 = (CASE WHEN DST.Address <> SRC.Address THEN DST.Address_Prev1 ELSE DST.Address_Prev2  END)
		,DST.Address_Prev2_ValidTo = (CASE WHEN DST.Address <> SRC.Address THEN DST.Address_Prev1_ValidTo ELSE DST.Address_Prev1_ValidTo  END)
		,DST.Address = SRC.Address;
GO

--Checking
SELECT * FROM [dbo].[DimCustomers_SCD3];
GO
EXEC DimCustomers_SCD3_ETL;
GO
SELECT * FROM [dbo].[DimCustomers_SCD3];
GO


SELECT * FROM [dbo].[DimShippers_SCD1];
SELECT * FROM [dbo].[DimEmployees_SCD2];
SELECT * FROM [dbo].[DimCustomers_SCD3];









