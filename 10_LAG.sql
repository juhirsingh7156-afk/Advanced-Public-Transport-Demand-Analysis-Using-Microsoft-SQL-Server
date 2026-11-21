
WITH DailyDemand AS
(
    SELECT
        D.FullDate,
        SUM(F.PassengerCount) AS TotalPassengers
    FROM dbo.TripOperations F
    JOIN dbo.DimDate D
        ON F.DateKey = D.DateKey
    GROUP BY D.FullDate
),
PreviousDemand AS
(
    SELECT
        FullDate,
        TotalPassengers,
        LAG(TotalPassengers) OVER (
            ORDER BY FullDate
        ) AS PreviousDayPassengers
    FROM DailyDemand
)
SELECT
    FullDate,
    TotalPassengers,
    PreviousDayPassengers,
    TotalPassengers - PreviousDayPassengers
        AS DemandDifference,

    CAST(
        100.0 * (TotalPassengers - PreviousDayPassengers)
        / NULLIF(PreviousDayPassengers,0)
        AS DECIMAL(10,2)
    ) AS DailyGrowthPercentage

FROM PreviousDemand
ORDER BY FullDate;
GO
