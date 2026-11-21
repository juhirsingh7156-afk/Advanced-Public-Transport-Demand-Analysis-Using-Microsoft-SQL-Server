
SELECT
    R.RouteName,
    V.VehicleNumber,
    V.VehicleCapacity,
    SUM(F.PassengerCount) AS TotalPassengers,
    SUM(F.CompletedTrips) AS CompletedTrips,

    SUM(F.CompletedTrips) * V.VehicleCapacity
        AS TotalAvailableCapacity,

    CAST(
        100.0 * SUM(F.PassengerCount)
        / NULLIF(
            SUM(F.CompletedTrips) * V.VehicleCapacity,
            0
        )
        AS DECIMAL(10,2)
    ) AS OccupancyPercentage,

    CASE
        WHEN 100.0 * SUM(F.PassengerCount)
             / NULLIF(
                 SUM(F.CompletedTrips) * V.VehicleCapacity,
                 0
             ) > 100
            THEN 'Capacity Exceeded'
        WHEN 100.0 * SUM(F.PassengerCount)
             / NULLIF(
                 SUM(F.CompletedTrips) * V.VehicleCapacity,
                 0
             ) >= 85
            THEN 'High Utilization'
        ELSE 'Normal Utilization'
    END AS CapacityStatus

FROM dbo.TripOperations F
JOIN dbo.Routes R
    ON F.RouteID = R.RouteID
JOIN dbo.Vehicles V
    ON F.VehicleID = V.VehicleID

GROUP BY
    R.RouteName,
    V.VehicleNumber,
    V.VehicleCapacity

ORDER BY OccupancyPercentage DESC;
GO
