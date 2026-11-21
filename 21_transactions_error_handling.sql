
USE AdvancedTransportDB;
GO

/* Demonstrate a transaction with rollback */

BEGIN TRY

    BEGIN TRANSACTION;

    UPDATE dbo.Routes
    SET BaseFare = BaseFare + 5
    WHERE RouteID = 1;

    /* Validate the change */

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Routes
        WHERE RouteID = 1
          AND BaseFare < 0
    )
    BEGIN
        THROW 50010, 'Invalid fare detected.', 1;
    END;

    COMMIT TRANSACTION;

    PRINT 'Transaction completed successfully.';

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_LINE() AS ErrorLine;

END CATCH;
GO
