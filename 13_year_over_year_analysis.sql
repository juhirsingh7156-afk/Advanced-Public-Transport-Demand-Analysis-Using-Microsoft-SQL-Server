
WITH MonthlyDemand AS
(
    SELECT
        D.YearNumber,
        D.MonthNumber,
        D.MonthName,
        SUM(F.PassengerCount) AS TotalPassengers
    FROM dbo.TripOperations F
    JOIN dbo.DimDate D
        ON F.DateKey = D.DateKey
    GROUP BY
        D.YearNumber,
        D.MonthNumber,
        D.MonthName
),
Comparison AS
(
    SELECT *,
        LAG(TotalPassengers) OVER (
            ORDER BY YearNumber,MonthNumber
        ) AS PreviousMonthPassengers
    FROM MonthlyDemand
)
SELECT
    YearNumber,
    MonthName,
    TotalPassengers,
    PreviousMonthPassengers,

    TotalPassengers - PreviousMonthPassengers
        AS PassengerDifference,

    CAST(
        100.0 * (TotalPassengers - PreviousMonthPassengers)
        / NULLIF(PreviousMonthPassengers,0)
        AS DECIMAL(10,2)
    ) AS MoMGrowthPercentage

FROM Comparison
ORDER BY YearNumber,MonthNumber;
GO
