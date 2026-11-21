
USE AdvancedTransportDB;
GO

/* Generate 120 calendar days */

DECLARE @StartDate DATE = '2026-01-01';

;WITH Calendar AS
(
    SELECT @StartDate AS TravelDate

    UNION ALL

    SELECT DATEADD(DAY,1,TravelDate)
    FROM Calendar
    WHERE TravelDate < DATEADD(DAY,119,@StartDate)
)
INSERT INTO dbo.DimDate
(
    DateKey, FullDate, DayName,
    WeekNumber, MonthNumber, MonthName,
    QuarterNumber, YearNumber, IsWeekend
)
SELECT
    CONVERT(INT,CONVERT(CHAR(8),TravelDate,112)),
    TravelDate,
    DATENAME(WEEKDAY,TravelDate),
    DATEPART(ISO_WEEK,TravelDate),
    MONTH(TravelDate),
    DATENAME(MONTH,TravelDate),
    DATEPART(QUARTER,TravelDate),
    YEAR(TravelDate),
    CASE
        WHEN DATEDIFF(DAY,'19000101',TravelDate)%7 IN (5,6)
        THEN 1 ELSE 0
    END
FROM Calendar
OPTION (MAXRECURSION 0);
GO

/* Generate raw operational data */

;WITH TripSource AS
(
    SELECT
        D.FullDate,
        R.RouteCode,
        V.VehicleNumber,
        T.PeriodID,
        R.VehicleCapacity,
        R.BaseFare,
        ROW_NUMBER() OVER (
            ORDER BY D.FullDate,R.RouteID,T.PeriodID
        ) AS RowNum,
        CASE
            WHEN T.PeriodID IN (2,4) THEN 0.80
            WHEN T.PeriodID = 1 THEN 0.35
            ELSE 0.55
        END AS DemandFactor,
        CASE
            WHEN T.PeriodID IN (2,4) THEN 12
            WHEN T.PeriodID = 1 THEN 6
            ELSE 9
        END AS ScheduledTrips
    FROM dbo.DimDate D
    CROSS JOIN dbo.Routes R
    JOIN dbo.Vehicles V
        ON V.VehicleID = R.RouteID
    CROSS JOIN dbo.TimePeriods T
),
CalculatedTrips AS
(
    SELECT *,
        ScheduledTrips -
        CASE
            WHEN RowNum % 11 = 0 THEN 2
            WHEN RowNum % 7 = 0 THEN 1
            ELSE 0
        END AS CompletedTrips
    FROM TripSource
)
INSERT INTO staging.RawTripData
(
    SourceTripID,
    TravelDate,
    RouteCode,
    VehicleNumber,
    PeriodID,
    ScheduledTrips,
    CompletedTrips,
    PassengerCount,
    AverageDelayMinutes,
    FareRevenue
)
SELECT
    CONCAT('TRIP-',RowNum),
    FullDate,
    RouteCode,
    VehicleNumber,
    PeriodID,
    ScheduledTrips,
    CompletedTrips,

    CAST(ROUND(
        CompletedTrips * VehicleCapacity *
        DemandFactor *
        CASE
            WHEN DATEDIFF(DAY,'19000101',FullDate)%7 IN (5,6)
            THEN 0.85 ELSE 1
        END,
        0
    ) AS INT),

    CAST(3 + RowNum % 15 AS DECIMAL(8,2)),

    CAST(
        ROUND(
            CompletedTrips * VehicleCapacity *
            DemandFactor *
            CASE
                WHEN DATEDIFF(DAY,'19000101',FullDate)%7 IN (5,6)
                THEN 0.85 ELSE 1
            END,
            0
        ) * BaseFare
        AS DECIMAL(12,2)
    )
FROM CalculatedTrips;
GO

SELECT COUNT(*) AS RawRecords
FROM staging.RawTripData;
GO

EXEC analytics.sp_LoadValidTrips;
GO

SELECT COUNT(*) AS LoadedTripRecords
FROM dbo.TripOperations;
GO
