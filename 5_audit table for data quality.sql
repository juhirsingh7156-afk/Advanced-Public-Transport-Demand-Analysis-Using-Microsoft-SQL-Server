
CREATE TABLE audit.DataQualitysLog
(
    LogID BIGINT IDENTITY(1,1) PRIMARY KEY,
    RawID BIGINT,
    SourceTripID VARCHAR(50),
    IssueType VARCHAR(100),
    IssueDescription VARCHAR(500),
    LoggedAt DATETIME2 DEFAULT SYSDATETIME()
);
GO

/* Log duplicate source records */

;WITH DuplicateRecords AS
(
    SELECT
        RawID,
        SourceTripID,
        ROW_NUMBER() OVER (
            PARTITION BY SourceTripID
            ORDER BY RawID
        ) AS RN
    FROM staging.RawTripData
)
INSERT INTO audit.DataQualityLog
(
    RawID,
    SourceTripID,
    IssueType,
    IssueDescription
)
SELECT
    RawID,
    SourceTripID,
    'DUPLICATE',
    'Repeated source trip identifier'
FROM DuplicateRecords
WHERE RN > 1;
GO

/* Log invalid trip counts */

INSERT INTO audit.DataQualityLog
(
    RawID,
    SourceTripID,
    IssueType,
    IssueDescription
)
SELECT
    RawID,
    SourceTripID,
    'INVALID_TRIP_COUNT',
    'Passenger or trip counts are invalid'
FROM staging.RawTripData
WHERE PassengerCount < 0
   OR ScheduledTrips < 0
   OR CompletedTrips < 0
   OR CompletedTrips > ScheduledTrips;
GO

SELECT *
FROM audit.DataQualityLog
ORDER BY LoggedAt DESC;
GO
