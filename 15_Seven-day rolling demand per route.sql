
WITH DailyRouteDemand AS
(
    SELECT
        F.RouteID,
        D.FullDate,
        SUM(F.PassengerCount) AS DailyPassengers
    FROM dbo.TripOperations F
    JOIN dbo.DimDate D
        ON F.DateKey = D.DateKey
    GROUP BY F.RouteID,D.FullDate
)
SELECT
    R.RouteName,
    D.FullDate,
    D.DailyPassengers,

    AVG(CAST(D.DailyPassengers AS DECIMAL(18,2)))
    OVER (
        PARTITION BY D.RouteID
        ORDER BY D.FullDate
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS SevenDayAverage

FROM DailyRouteDemand D
JOIN dbo.Routes R
    ON D.RouteID = R.RouteID
ORDER BY R.RouteName,D.FullDate;
GO
