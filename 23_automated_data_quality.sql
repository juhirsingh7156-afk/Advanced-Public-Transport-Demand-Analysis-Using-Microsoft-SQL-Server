
CREATE OR ALTER PROCEDURE analytics.sp_DataQualityReport
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        'Total Records' AS QualityCheck,
        COUNT_BIG(*) AS IssueCount
    FROM dbo.TripOperations

    UNION ALL

    SELECT
        'Missing Passenger Count',
        COUNT_BIG(*)
    FROM dbo.TripOperations
    WHERE PassengerCount IS NULL

    UNION ALL

    SELECT
        'Invalid Trip Counts',
        COUNT_BIG(*)
    FROM dbo.TripOperations
    WHERE CompletedTrips > ScheduledTrips

    UNION ALL

    SELECT
        'Missing Revenue',
        COUNT_BIG(*)
    FROM dbo.TripOperations
    WHERE FareRevenue IS NULL

    UNION ALL

    SELECT
        'Invalid Delay',
        COUNT_BIG(*)
    FROM dbo.TripOperations
    WHERE AverageDelayMinutes < 0;
END;
GO

EXEC analytics.sp_DataQualityReport;
GO
