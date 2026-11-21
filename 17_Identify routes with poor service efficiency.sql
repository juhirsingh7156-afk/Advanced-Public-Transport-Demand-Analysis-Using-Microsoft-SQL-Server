
SELECT
    R.RouteName,

    SUM(F.ScheduledTrips) AS ScheduledTrips,
    SUM(F.CompletedTrips) AS CompletedTrips,

    SUM(F.ScheduledTrips - F.CompletedTrips)
        AS MissedTrips,

    CAST(
        100.0 * SUM(F.CompletedTrips)
        / NULLIF(SUM(F.ScheduledTrips),0)
        AS DECIMAL(10,2)
    ) AS CompletionRate,

    AVG(F.AverageDelayMinutes) AS AverageDelay,

    CASE
        WHEN
            100.0 * SUM(F.CompletedTrips)
            / NULLIF(SUM(F.ScheduledTrips),0) < 80
            THEN 'Poor Service'
        WHEN AVG(F.AverageDelayMinutes) > 12
            THEN 'High Delay'
        ELSE 'Acceptable'
    END AS ServiceStatus

FROM dbo.TripOperations F
JOIN dbo.Routes R
    ON F.RouteID = R.RouteID

GROUP BY R.RouteName
ORDER BY CompletionRate ASC;
GO
