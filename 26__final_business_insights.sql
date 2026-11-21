
SELECT
    COUNT(DISTINCT F.RouteID) AS TotalRoutes,

    COUNT(DISTINCT F.VehicleID) AS VehiclesUsed,

    SUM(F.PassengerCount) AS TotalPassengers,

    SUM(F.FareRevenue) AS TotalRevenue,

    SUM(F.ScheduledTrips) AS ScheduledTrips,

    SUM(F.CompletedTrips) AS CompletedTrips,

    CAST(
        100.0 * SUM(F.CompletedTrips)
        / NULLIF(SUM(F.ScheduledTrips),0)
        AS DECIMAL(10,2)
    ) AS CompletionRate,

    CAST(
        AVG(F.AverageDelayMinutes)
        AS DECIMAL(10,2)
    ) AS AverageDelay,

    CAST(
        SUM(F.FareRevenue)
        / NULLIF(SUM(F.PassengerCount),0)
        AS DECIMAL(10,2)
    ) AS RevenuePerPassenger

FROM dbo.TripOperations F;
GO

/* Top 5 routes by passenger demand */

SELECT TOP 5
    R.RouteName,
    SUM(F.PassengerCount) AS TotalPassengers
FROM dbo.TripOperations F
JOIN dbo.Routes R
    ON F.RouteID = R.RouteID
GROUP BY R.RouteName
ORDER BY TotalPassengers DESC;
GO

/* Top 5 routes by revenue */

SELECT TOP 5
    R.RouteName,
    SUM(F.FareRevenue) AS TotalRevenue
FROM dbo.TripOperations F
JOIN dbo.Routes R
    ON F.RouteID = R.RouteID
GROUP BY R.RouteName
ORDER BY TotalRevenue DESC;
GO

/* Busiest time periods */

SELECT TOP 4
    T.PeriodName,
    SUM(F.PassengerCount) AS TotalPassengers
FROM dbo.TripOperations F
JOIN dbo.TimePeriods T
    ON F.PeriodID = T.PeriodID
GROUP BY T.PeriodName
ORDER BY TotalPassengers DESC;
GO

/* Lowest completion rate routes */

SELECT
    R.RouteName,
    SUM(F.ScheduledTrips) AS ScheduledTrips,
    SUM(F.CompletedTrips) AS CompletedTrips,

    CAST(
        100.0 * SUM(F.CompletedTrips)
        / NULLIF(SUM(F.ScheduledTrips),0)
        AS DECIMAL(10,2)
    ) AS CompletionRate

FROM dbo.TripOperations F
JOIN dbo.Routes R
    ON F.RouteID = R.RouteID
GROUP BY R.RouteName
ORDER BY CompletionRate ASC;
GO
