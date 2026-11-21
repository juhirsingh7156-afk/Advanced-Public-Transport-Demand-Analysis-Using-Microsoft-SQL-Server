
WITH RouteDemand AS
(
    SELECT
        R.RouteName,
        SUM(F.PassengerCount) AS TotalPassengers
    FROM dbo.TripOperations F
    JOIN dbo.Routes R
        ON F.RouteID = R.RouteID
    GROUP BY R.RouteName
),
RouteSegments AS
(
    SELECT *,
        NTILE(4) OVER (
            ORDER BY TotalPassengers DESC
        ) AS DemandQuartile
    FROM RouteDemand
)
SELECT
    RouteName,
    TotalPassengers,
    DemandQuartile,

    CASE DemandQuartile
        WHEN 1 THEN 'Highest Demand'
        WHEN 2 THEN 'High Demand'
        WHEN 3 THEN 'Moderate Demand'
        WHEN 4 THEN 'Lowest Demand'
    END AS DemandCategory

FROM RouteSegments
ORDER BY DemandQuartile;
GO
