
CREATE OR ALTER PROCEDURE analytics.sp_LoadValidTrips
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        ;WITH ValidRecords AS
        (
            SELECT
                S.*,
                ROW_NUMBER() OVER (
                    PARTITION BY S.SourceTripID
                    ORDER BY S.RawID
                ) AS RN
            FROM staging.RawTripData S
            WHERE S.SourceTripID IS NOT NULL
              AND S.TravelDate IS NOT NULL
              AND S.RouteCode IS NOT NULL
              AND S.VehicleNumber IS NOT NULL
              AND S.ScheduledTrips >= 0
              AND S.CompletedTrips >= 0
              AND S.CompletedTrips <= S.ScheduledTrips
              AND S.PassengerCount >= 0
              AND S.AverageDelayMinutes >= 0
              AND S.FareRevenue >= 0
        )
        INSERT INTO dbo.TripOperations
        (
            SourceTripID,
            DateKey,
            RouteID,
            VehicleID,
            PeriodID,
            ScheduledTrips,
            CompletedTrips,
            PassengerCount,
            AverageDelayMinutes,
            FareRevenue
        )
        SELECT
            S.SourceTripID,
            CONVERT(INT, CONVERT(CHAR(8), S.TravelDate, 112)),
            R.RouteID,
            V.VehicleID,
            S.PeriodID,
            S.ScheduledTrips,
            S.CompletedTrips,
            S.PassengerCount,
            S.AverageDelayMinutes,
            S.FareRevenue
        FROM ValidRecords S
        JOIN dbo.Routes R
            ON S.RouteCode = R.RouteCode
        JOIN dbo.Vehicles V
            ON S.VehicleNumber = V.VehicleNumber
        JOIN dbo.DimDate D
            ON D.FullDate = S.TravelDate
        JOIN dbo.TimePeriods T
            ON T.PeriodID = S.PeriodID
        WHERE S.RN = 1
          AND NOT EXISTS
          (
              SELECT 1
              FROM dbo.TripOperations E
              WHERE E.SourceTripID = S.SourceTripID
          );

        COMMIT TRANSACTION;

        SELECT 'Data load completed successfully' AS Status;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

EXEC analytics.sp_LoadValidTrips;
GO
