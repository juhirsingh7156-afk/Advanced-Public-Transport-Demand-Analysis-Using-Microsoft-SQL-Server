
CREATE OR ALTER VIEW analytics.vw_ManagementDashboard
AS
SELECT
    R.RouteCode,
    R.RouteName,
    R.Origin,
    R.Destination,

    SUM(F.PassengerCount) AS TotalPassengers,
    SUM(F.FareRevenue) AS TotalRevenue,

    SUM(F.ScheduledTrips) AS ScheduledTrips,
    SUM(F.CompletedTrips) AS CompletedTrips,

    CAST(
        100.0 * SUM(F.CompletedTrips)
        / NULLIF(SUM(F.ScheduledTrips),0)
        AS DECIMAL(10,2)
    ) AS CompletionPercentage,

    CAST(
        100.0 * SUM(F.PassengerCount)
        / NULLIF(
            SUM(F.CompletedTrips) *
            MAX(V.VehicleCapacity),
            0
        )
        AS DECIMAL(10,2)
    ) AS OccupancyPercentage,

    CAST(
        AVG(F.AverageDelayMinutes)
        AS DECIMAL(10,2)
    ) AS AverageDelay

FROM dbo.TripOperations F
JOIN dbo.Routes R
    ON F.RouteID = R.RouteID
JOIN dbo.Vehicles V
    ON F.VehicleID = V.VehicleID

GROUP BY
    R.RouteCode,
    R.RouteName,
    R.Origin,
    R.Destination;
GO

SELECT *
FROM analytics.vw_ManagementDashboard
ORDER BY TotalPassengers DESC;
GO
