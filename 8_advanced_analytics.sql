
SELECT
    R.RouteCode,
    R.RouteName,
    SUM(F.PassengerCount) AS TotalPassengers,

    DENSE_RANK() OVER (
        ORDER BY SUM(F.PassengerCount) DESC
    ) AS DemandRank

FROM dbo.TripOperations F
JOIN dbo.Routes R
    ON F.RouteID = R.RouteID

GROUP BY R.RouteCode,R.RouteName
ORDER BY DemandRank;
GO
