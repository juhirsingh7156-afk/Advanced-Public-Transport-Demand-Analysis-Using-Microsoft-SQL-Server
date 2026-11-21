
CREATE TABLE audit.RouteChangeLog
(
    AuditID BIGINT IDENTITY(1,1) PRIMARY KEY,
    RouteID INT,
    OldFare DECIMAL(10,2),
    NewFare DECIMAL(10,2),
    ChangedAt DATETIME2 DEFAULT SYSDATETIME(),
    ChangedBy SYSNAME DEFAULT SUSER_SNAME()
);
GO

CREATE OR ALTER TRIGGER dbo.trg_RouteFareAudit
ON dbo.Routes
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO audit.RouteChangeLog
    (
        RouteID,
        OldFare,
        NewFare
    )
    SELECT
        D.RouteID,
        D.BaseFare,
        I.BaseFare
    FROM deleted D
    JOIN inserted I
        ON D.RouteID = I.RouteID
    WHERE D.BaseFare <> I.BaseFare;
END;
GO

/* Test trigger */

UPDATE dbo.Routes
SET BaseFare = BaseFare + 2
WHERE RouteID = 1;

SELECT *
FROM audit.RouteChangeLog
ORDER BY AuditID DESC;
GO
