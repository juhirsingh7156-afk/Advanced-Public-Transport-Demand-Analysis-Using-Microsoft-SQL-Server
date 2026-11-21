
USE AdvancedTransportDB;
GO

CREATE TABLE dbo.Routes
(
    RouteID INT IDENTITY(1,1) PRIMARY KEY,
    RouteCode VARCHAR(20) NOT NULL UNIQUE,
    RouteName VARCHAR(100) NOT NULL,
    Origin VARCHAR(100) NOT NULL,
    Destination VARCHAR(100) NOT NULL,
    VehicleCapacity INT NOT NULL,
    BaseFare DECIMAL(10,2) NOT NULL,
    RouteStatus VARCHAR(20) DEFAULT 'Active',

    CONSTRAINT CK_Route_Capacity
        CHECK (VehicleCapacity > 0),

    CONSTRAINT CK_Route_Fare
        CHECK (BaseFare >= 0),

    CONSTRAINT CK_Route_Status
        CHECK (RouteStatus IN ('Active','Inactive'))
);
GO

CREATE TABLE dbo.DimDate
(
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL UNIQUE,
    DayName VARCHAR(15),
    WeekNumber INT,
    MonthNumber INT,
    MonthName VARCHAR(15),
    QuarterNumber INT,
    YearNumber INT,
    IsWeekend BIT
);
GO

CREATE TABLE dbo.Vehicles
(
    VehicleID INT IDENTITY(1,1) PRIMARY KEY,
    VehicleNumber VARCHAR(30) NOT NULL UNIQUE,
    VehicleType VARCHAR(50),
    VehicleCapacity INT NOT NULL,
    VehicleStatus VARCHAR(20) DEFAULT 'Active',

    CONSTRAINT CK_Vehicle_Capacity
        CHECK (VehicleCapacity > 0),

    CONSTRAINT CK_Vehicle_Status
        CHECK (VehicleStatus IN
        ('Active','Maintenance','Inactive'))
);
GO

CREATE TABLE dbo.TimePeriods
(
    PeriodID INT PRIMARY KEY,
    PeriodName VARCHAR(30) UNIQUE,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL
);
GO

CREATE TABLE dbo.TripOperations
(
    TripID BIGINT IDENTITY(1,1) PRIMARY KEY,
    SourceTripID VARCHAR(50) NOT NULL UNIQUE,
    DateKey INT NOT NULL,
    RouteID INT NOT NULL,
    VehicleID INT NOT NULL,
    PeriodID INT NOT NULL,

    ScheduledTrips INT NOT NULL,
    CompletedTrips INT NOT NULL,
    PassengerCount INT NOT NULL,

    AverageDelayMinutes DECIMAL(8,2),
    FareRevenue DECIMAL(12,2),

    CONSTRAINT FK_Trip_Date
        FOREIGN KEY (DateKey)
        REFERENCES dbo.DimDate(DateKey),

    CONSTRAINT FK_Trip_Route
        FOREIGN KEY (RouteID)
        REFERENCES dbo.Routes(RouteID),

    CONSTRAINT FK_Trip_Vehicle
        FOREIGN KEY (VehicleID)
        REFERENCES dbo.Vehicles(VehicleID),

    CONSTRAINT FK_Trip_Period
        FOREIGN KEY (PeriodID)
        REFERENCES dbo.TimePeriods(PeriodID),

    CONSTRAINT CK_Trip_Counts
        CHECK (
            ScheduledTrips >= 0
            AND CompletedTrips >= 0
            AND CompletedTrips <= ScheduledTrips
            AND PassengerCount >= 0
        ),

    CONSTRAINT CK_Trip_Delay
        CHECK (AverageDelayMinutes >= 0),

    CONSTRAINT CK_Trip_Revenue
        CHECK (FareRevenue >= 0)
);
GO

/* Staging table: intentionally no business constraints */

CREATE TABLE staging.RawTripData
(
    RawID BIGINT IDENTITY(1,1) PRIMARY KEY,
    SourceTripID VARCHAR(50),
    TravelDate DATE,
    RouteCode VARCHAR(20),
    VehicleNumber VARCHAR(30),
    PeriodID INT,
    ScheduledTrips INT,
    CompletedTrips INT,
    PassengerCount INT,
    AverageDelayMinutes DECIMAL(8,2),
    FareRevenue DECIMAL(12,2),
    LoadDate DATETIME2 DEFAULT SYSDATETIME()
);
GO
