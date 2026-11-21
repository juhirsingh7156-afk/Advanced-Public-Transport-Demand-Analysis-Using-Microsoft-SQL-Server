
USE AdvancedTransportDB;
GO

/* Date-based reporting */

CREATE NONCLUSTERED INDEX IX_TripOperations_DateKey
ON dbo.TripOperations(DateKey)
INCLUDE
(
    RouteID,
    VehicleID,
    PassengerCount,
    FareRevenue,
    CompletedTrips
);
GO

/* Route-based reporting */

CREATE NONCLUSTERED INDEX IX_TripOperations_RouteID
ON dbo.TripOperations(RouteID)
INCLUDE
(
    DateKey,
    PassengerCount,
    FareRevenue,
    AverageDelayMinutes
);
GO

/* Period-based reporting */

CREATE NONCLUSTERED INDEX IX_TripOperations_PeriodID
ON dbo.TripOperations(PeriodID)
INCLUDE
(
    PassengerCount,
    CompletedTrips,
    FareRevenue
);
GO

/* Check indexes */

SELECT
    I.name AS IndexName,
    I.type_desc AS IndexType,
    OBJECT_NAME(I.object_id) AS TableName
FROM sys.indexes I
WHERE I.object_id =
    OBJECT_ID('dbo.TripOperations');
GO
