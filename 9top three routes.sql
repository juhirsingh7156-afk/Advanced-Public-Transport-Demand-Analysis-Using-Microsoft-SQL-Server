
WITH RouteDemand AS
(
    SELECT
        R.RouteName,
        T.PeriodName,
        SUM(F.PassengerCount) AS TotalPassengers
    FROM dbo.TripOperations F
    JOIN dbo.Routes R
        ON F.RouteID = R.RouteID
    JOIN dbo.TimePeriods T
        ON F.PeriodID = T.PeriodID
    GROUP BY R.RouteName,T.PeriodName
),
RankedRoutes AS
(
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY PeriodName
            ORDER BY TotalPassengers DESC,RouteName
        ) AS RN
    FROM RouteDemand
)
SELECT *
FROM RankedRoutes
WHERE RN <= 3
ORDER BY PeriodName,RN;
GO
