
CREATE OR ALTER FUNCTION analytics.fn_RouteOccupancy
(
    @RouteID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Occupancy DECIMAL(10,2);

    SELECT
        @Occupancy =
            CAST(
                100.0 * SUM(F.PassengerCount)
                /
                NULLIF(
                    SUM(F.CompletedTrips) *
                    MAX(V.VehicleCapacity),
                    0
                )
                AS DECIMAL(10,2)
            )
    FROM dbo.TripOperations F
    JOIN dbo.Vehicles V
        ON F.VehicleID = V.VehicleID
    WHERE F.RouteID = @RouteID;

    RETURN @Occupancy;
END;
GO

SELECT
    RouteName,
    analytics.fn_RouteOccupancy(RouteID)
        AS OccupancyPercentage
FROM dbo.Routes;
GO
