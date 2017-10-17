--Built by: Grace Brockwell, Avery Cederstrand, Haley Miller
--Build Redwood DM
IF NOT EXISTS(SELECT * FROM sys.databases
				WHERE name = N'RedwoodDM')
	CREATE DATABASE RedwoodDM
GO
USE RedwoodDM
--
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name= N'FactContacts'
	)
	DROP TABLE FactContacts;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name= N'DimProperty'
	)
	DROP TABLE DimProperty;

--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name= N'DimAgent'
	)
	DROP TABLE DimAgent;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name= N'DimListing'
	)
	DROP TABLE DimListing;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name= N'DimDate'
	)
	DROP TABLE DimDate;
--
CREATE TABLE DimDate
	(	Date_SK INT PRIMARY KEY, 
		Date DATETIME,
		FullDate CHAR(10),-- Date in MM-dd-yyyy format
		DayOfMonth INT, -- Field will hold day number of Month
		DayName VARCHAR(9), -- Contains name of the day, Sunday, Monday 
		DayOfWeek INT,-- First Day Sunday=1 and Saturday=7
		DayOfWeekInMonth INT, -- 1st Monday or 2nd Monday in Month
		DayOfWeekInYear INT,
		DayOfQuarter INT,
		DayOfYear INT,
		WeekOfMonth INT,-- Week Number of Month 
		WeekOfQuarter INT, -- Week Number of the Quarter
		WeekOfYear INT,-- Week Number of the Year
		Month INT, -- Number of the Month 1 to 12{}
		MonthName VARCHAR(9),-- January, February etc
		MonthOfQuarter INT,-- Month Number belongs to Quarter
		Quarter CHAR(2),
		QuarterName VARCHAR(9),-- First,Second..
		Year INT,-- Year value of Date stored in Row
		YearName CHAR(7), -- CY 2015,CY 2016
		MonthYear CHAR(10), -- Jan-2016,Feb-2016
		MMYYYY INT,
		FirstDayOfMonth DATE,
		LastDayOfMonth DATE,
		FirstDayOfQuarter DATE,
		LastDayOfQuarter DATE,
		FirstDayOfYear DATE,
		LastDayOfYear DATE,
		IsHoliday BIT,-- Flag 1=National Holiday, 0-No National Holiday
		IsWeekday BIT,-- 0=Week End ,1=Week Day
		Holiday VARCHAR(50),--Name of Holiday in US
		Season VARCHAR(10)--Name of Season
	);
--
CREATE TABLE DimListing
	(	Listing_SK INT IDENTITY(1,1) CONSTRAINT pk_SKListing PRIMARY KEY,
		Listing_AK	 INT,
		BeginListDate  DATETIME,
		EndListDate    DATETIME,
		AskingPrice    MONEY
	);
--
CREATE TABLE DimAgent
	(   Agent_SK INT IDENTITY(1,1) CONSTRAINT pk_SKAgent PRIMARY KEY,
		AgentID	INT,
		FirstName	NVARCHAR(30) CONSTRAINT nn_agents_fname NOT NULL,
		LastName	NVARCHAR(30) CONSTRAINT nn_agents_lname NOT NULL,
		HireDate	DATETIME NOT NULL,
		BirthDate	DATETIME NOT NULL,
		Gender		NCHAR(1),
		LicenseDate   DATETIME
	);
--
CREATE TABLE DimProperty
	(   Property_SK INT IDENTITY (1,1) CONSTRAINT pk_SKProperty PRIMARY KEY,
		Property_AK INT,
		City	     NVARCHAR(30) NOT NULL,
		State	     NVARCHAR(20) NOT NULL,
		Zipcode     NVARCHAR(20) NOT NULL,
		Bedrooms    INT,
		Bathrooms   INT,
		SqFt	     INT,
		YearBuilt   NUMERIC(4)
	);
--
CREATE TABLE FactContacts
	(Agent_SK	INT CONSTRAINT FK_agentSK REFERENCES DimAgent(Agent_SK),
	Property_SK INT CONSTRAINT FK_propertySK REFERENCES DimProperty(Property_SK),
	Listing_SK	INT CONSTRAINT FK_ListingSK REFERENCES DimListing(Listing_SK),
	Contact_Date INT CONSTRAINT FK_ContDateSK REFERENCES DimDate(Date_SK),
	Contact_Reason NVARCHAR(15)
	CONSTRAINT pk_FactContact PRIMARY KEY (Agent_SK, Property_SK, Listing_SK, Contact_Date)
	);