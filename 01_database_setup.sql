
IF DB_ID('AdvancedTransportDB') IS NULL
    CREATE DATABASE AdvancedTransportDB;
GO

USE AdvancedTransportDB;
GO

/* Schema organization */

IF NOT EXISTS (
    SELECT 1 FROM sys.schemas
    WHERE name = 'staging'
)
    EXEC('CREATE SCHEMA staging');

IF NOT EXISTS (
    SELECT 1 FROM sys.schemas
    WHERE name = 'analytics'
)
    EXEC('CREATE SCHEMA analytics');

IF NOT EXISTS (
    SELECT 1 FROM sys.schemas
    WHERE name = 'audit'
)
    EXEC('CREATE SCHEMA audit');
GO
