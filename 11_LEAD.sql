
WITH DailyDemand AS
(
    SELECT
        D.FullDate,
        SUM(F.PassengerCount) AS TotalPassengers
    FROM dbo.TripOperations F
    JOIN dbo.DimDate D
        ON F.DateKey = D.DateKey
    GROUP BY D.FullDate
)
SELECT
    FullDate,
    TotalPassengers,

    LEAD(TotalPassengers,1) OVER (
        ORDER BY FullDate
    ) AS NextDayPassengers,

    LEAD(TotalPassengers,7) OVER (
        ORDER BY FullDate
    ) AS NextWeekSameDayPassengers

FROM DailyDemand
ORDER BY FullDate;
GO
