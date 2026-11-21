
CREATE OR ALTER PROCEDURE analytics.sp_DynamicRouteReport
    @RouteID INT = NULL,
    @PeriodID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SQL NVARCHAR(MAX);

    SET @SQL = N'
        SELECT
            R.RouteName,
            T.PeriodName,
            SUM(F.PassengerCount) AS TotalPassengers,
            SUM(F.FareRevenue) AS TotalRevenue
        FROM dbo.TripOperations F
        JOIN dbo.Routes R
            ON F.RouteID = R.RouteID
        JOIN dbo.TimePeriods T
            ON F.PeriodID = T.PeriodID
        WHERE 1 = 1';

    IF @RouteID IS NOT NULL
        SET @SQL += N' AND F.RouteID = @RouteID';

    IF @PeriodID IS NOT NULL
        SET @SQL += N' AND F.PeriodID = @PeriodID';

    SET @SQL += N'
        GROUP BY R.RouteName,T.PeriodName
        ORDER BY TotalPassengers DESC;';

    EXEC sys.sp_executesql
        @SQL,
        N'@RouteID INT,@PeriodID INT',
        @RouteID = @RouteID,
        @PeriodID = @PeriodID;
END;
GO

/* Test 1: All routes */

EXEC analytics.sp_DynamicRouteReport;

/* Test 2: Specific route */

EXEC analytics.sp_DynamicRouteReport
    @RouteID = 1;

/* Test 3: Specific time period */

EXEC analytics.sp_DynamicRouteReport
    @PeriodID = 2;

/* Test 4: Both filters */

EXEC analytics.sp_DynamicRouteReport
    @RouteID = 1,
    @PeriodID = 2;
GO
