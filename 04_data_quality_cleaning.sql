
USE AdvancedTransportDB;
GO

/* Duplicate source records */

SELECT
    SourceTripID,
    COUNT(*) AS DuplicateCount
FROM staging.RawTripData
GROUP BY SourceTripID
HAVING COUNT(*) > 1;
GO

/* Missing critical values */

SELECT *
FROM staging.RawTripData
WHERE SourceTripID IS NULL
   OR TravelDate IS NULL
   OR RouteCode IS NULL
   OR VehicleNumber IS NULL;
GO

/* Invalid passenger counts */

SELECT *
FROM staging.RawTripData
WHERE PassengerCount < 0
   OR ScheduledTrips < 0
   OR CompletedTrips < 0
   OR CompletedTrips > ScheduledTrips;
GO

/* Invalid revenue and delay */

SELECT *
FROM staging.RawTripData
WHERE FareRevenue < 0
   OR AverageDelayMinutes < 0;
GO

/* Unknown route references */

SELECT S.*
FROM staging.RawTripData S
LEFT JOIN dbo.Routes R
    ON S.RouteCode = R.RouteCode
WHERE R.RouteID IS NULL;
GO

/* Unknown vehicles */

SELECT S.*
FROM staging.RawTripData S
LEFT JOIN dbo.Vehicles V
    ON S.VehicleNumber = V.VehicleNumber
WHERE V.VehicleID IS NULL;
GO
