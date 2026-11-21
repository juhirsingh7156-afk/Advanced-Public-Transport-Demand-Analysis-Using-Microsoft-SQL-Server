
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

/* Performance test */

SELECT
    F.RouteID,
    SUM(F.PassengerCount) AS TotalPassengers,
    SUM(F.FareRevenue) AS TotalRevenue
FROM dbo.TripOperations F
WHERE F.DateKey BETWEEN 20260101 AND 20260331
GROUP BY F.RouteID;
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
