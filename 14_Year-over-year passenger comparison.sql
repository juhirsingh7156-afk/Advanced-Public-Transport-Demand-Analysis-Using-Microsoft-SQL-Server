
WITH YearlyDemand AS
(
    SELECT
        D.YearNumber,
        SUM(F.PassengerCount) AS TotalPassengers,
        SUM(F.FareRevenue) AS TotalRevenue
    FROM dbo.TripOperations F
    JOIN dbo.DimDate D
        ON F.DateKey = D.DateKey
    GROUP BY D.YearNumber
),
YearComparison AS
(
    SELECT *,
        LAG(TotalPassengers) OVER (
            ORDER BY YearNumber
        ) AS PreviousYearPassengers,

        LAG(TotalRevenue) OVER (
            ORDER BY YearNumber
        ) AS PreviousYearRevenue

    FROM YearlyDemand
)
SELECT
    YearNumber,
    TotalPassengers,
    PreviousYearPassengers,

    CAST(
        100.0 * (TotalPassengers - PreviousYearPassengers)
        / NULLIF(PreviousYearPassengers,0)
        AS DECIMAL(10,2)
    ) AS YoYPassengerGrowth,

    TotalRevenue,
    PreviousYearRevenue

FROM YearComparison
ORDER BY YearNumber;
GO
